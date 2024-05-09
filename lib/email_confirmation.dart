import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:docutrack_main/main.dart';
import 'package:docutrack_main/style.dart';
import 'package:docutrack_main/forgot_password.dart';

class EmailConfirmation extends StatefulWidget {
  const EmailConfirmation({Key? key}) : super(key: key);

  @override
  State<EmailConfirmation> createState() => _EmailConfirmationState();
}

class _EmailConfirmationState extends State<EmailConfirmation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var api_url = dotenv.env['API_URL'];

  String? email = "";
  ForgetPasswordState? forgetPasswordState;

  @override
  void initState() {
    super.initState();
    forgetPasswordState = Provider.of<ForgetPasswordState>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Image.asset(
                    'assets/DocuTrack (Red).png',
                    height: 60,
                    width: 60,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Forgot Password',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'WMSU Email ',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        buildEmailAddress(),
                        // const SizedBox(height: 350.0),
                        // buildNextBtn(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            buildNextBtn(),
          ],
        ),
      ),
    );
  }

  Widget buildEmailAddress() {
    return TextFormField(
      key: Key('email'),
      decoration: InputDecoration(
        labelText: 'Enter your WMSU email',
        labelStyle: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.grey,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: primaryColor
          ),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your WMSU email.';
        } else if (!value.endsWith('@wmsu.edu.ph')) {
          return 'Only use WMSU email.';
        } else if (value == email) {
          return 'WMSU email do not match with the existing.';
        }  else {
          return null; // No error
        }
      },
      onSaved: (value) {
        setState(() => email = value);
      },
    );
  }

  Widget buildNextBtn() {
    return ElevatedButton(
      onPressed: () async {
        // Navigator.of(context).push(
        //     MaterialPageRoute(builder: (context) => ForgotPassword())
        // );
        if (!_formKey.currentState!.validate()) {

        } else {
          emailConfirmation();
        }
      },
      child: Text(
        'Next',
        style: GoogleFonts.poppins(
          color: secondaryColor,
          fontSize: 15.0,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(5.0),
        fixedSize: Size(MediaQuery.of(context).size.width, 55),
        primary: primaryColor,
        shape: StadiumBorder(),
      ),
    );
  }

  Future<void> emailConfirmation() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return; // Return early if the form is not valid
    }

    _formKey.currentState!.save();

    try {
      final url = Uri.parse('$api_url/api/accounts/forget_password');
      final request = http.MultipartRequest('POST', url)
        ..fields['email'] = email!;

      final response = await request.send();

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(await response.stream.bytesToString());

        final String matchedEmail = responseBody['email'];
        final String message = responseBody['message'];

        // Check if the email matched before updating the state
        if (message == 'Email matched') {
          forgetPasswordState!.setForgetPassword(matchedEmail);

          Navigator.of(context).push(
              MaterialPageRoute(builder: (context)=>ForgotPassword())
          );
          print('Email matched: $matchedEmail');
        } else {
          // Handle the case where the email doesn't exist
          print('Email does not exist');
        }
      } else {
        // Handle non-200 status codes (e.g., 404 Not Found)
        print('Errorss: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      // Print detailed error message and stack trace
      print('Error: $e');
      print('Stack trace:\n$stackTrace');
    }
  }


}

