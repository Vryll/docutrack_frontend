
import 'package:docutrack_main/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/style.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:docutrack_main/main.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class ForgetPasswordDetails {
  final String? email;
  final String? password;

  const ForgetPasswordDetails({
    required this.email,
    required this.password,
  });

  factory ForgetPasswordDetails.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordDetails(
      email: json['email'],
      password: json['password'],
    );
  }
}




class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();
  var api_url = dotenv.env['API_URL'];

  String? email = "";
  String? password = "";
  String? confirm_password = "";

  TextEditingController _passwordController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  ForgetPasswordState? forgetPasswordState;

  @override
  void initState(){
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
                        // Text.rich(
                        //   TextSpan(
                        //     text: 'WMSU Email ',
                        //     style: GoogleFonts.poppins(
                        //       fontSize: 15,
                        //       color: Colors.black,
                        //     ),
                        //     children: [
                        //       TextSpan(
                        //         text: '*',
                        //         style: TextStyle(
                        //           color: Colors.red,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(height: 10.0),
                        // buildEmailAddress(),
                        // const SizedBox(height: 20.0),

                        Text.rich(
                          TextSpan(
                            text: 'New Password ',
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
                        BuildInputPassword(),
                        const SizedBox(height: 20.0),

                        Text.rich(
                          TextSpan(
                            text: 'Confirm Password ',
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
                        BuildConfirmPassword(),
                        // const SizedBox(height: 179.0),
                        // buildSaveBtn(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            buildSaveBtn(),
          ],
        ),
      ),
    );
  }

  // Widget buildEmailAddress() {
  //   return TextFormField(
  //     decoration: InputDecoration(
  //       labelText: 'Enter your email address',
  //       labelStyle: GoogleFonts.poppins(
  //         fontSize: 15,
  //         color: Colors.grey,
  //       ),
  //       contentPadding: EdgeInsets.symmetric(horizontal: 10),
  //       border: OutlineInputBorder(),
  //     ),
  //     validator: (value){
  //       if(value!.isEmpty){
  //         return 'Please enter your email address';
  //       } else if(!value.endsWith('@wmsu.edu.ph')){
  //         return 'Invalid Email!';
  //       } else{
  //         return null;
  //       }
  //     },
  //   ) ;
  // }

  Widget BuildInputPassword() =>
      TextFormField(
        key: Key('password'),
        decoration: InputDecoration(
          labelText: 'Enter your new password',
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
          suffixIcon: IconButton(
            icon: Icon(
              _showPassword ? Icons.visibility : Icons.visibility_off,
              color: _showPassword ? primaryColor : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _showPassword = !_showPassword;
              });
            },
          ),
        ),
        obscureText: !_showPassword,
        controller: _passwordController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your new password.';
          } else if (value!.length < 8) {
            return 'Password should be at least 8 characters long.';
          } else if (!value.contains(RegExp(r'[A-Z]'))) {
            return 'Password should contain at least one uppercase letter.';
          } else if (!value.contains(RegExp(r'[a-z]'))) {
            return 'Password should contain at least one lowercase letter.';
          } else if (!value.contains(RegExp(r'[0-9]'))) {
            return 'Password should contain at least one number.';
          } else {
            return null;
          }
        },
        onSaved: (value) {password = value;},
      );

  Widget BuildConfirmPassword() =>
      TextFormField(
        key: Key('confirm_password'),
        decoration: InputDecoration(
          labelText: 'Re-enter your password',
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
          suffixIcon: IconButton(
            icon: Icon(
              _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
              color: _showConfirmPassword ? primaryColor : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _showConfirmPassword = !_showConfirmPassword;
              });
            },
          ),
        ),
        obscureText: !_showConfirmPassword,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please re-enter your password.';
          } else if (value != _passwordController.text) {
            return 'Passwords do not match.';
          } else if (value!.length < 8) {
            return 'Password should be at least 8 characters long.';
          } else if (!value.contains(RegExp(r'[A-Z]'))) {
            return 'Password should contain at least one uppercase letter.';
          } else if (!value.contains(RegExp(r'[a-z]'))) {
            return 'Password should contain at least one lowercase letter.';
          } else if (!value.contains(RegExp(r'[0-9]'))) {
            return 'Password should contain at least one number.';
          } else {
            return null;
          }
        },
        onSaved: (value) {confirm_password = value;},
      );


  Widget buildSaveBtn() {
    return ElevatedButton(
      onPressed: () {
        if (!_formKey.currentState!.validate()) {}
        else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                title: Icon(
                  Icons.help,
                  size: 70,
                  color: primaryColor,
                ),
                content: Text(
                  'Are you sure you want to save changes?',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          _updateForm();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5)),
                                ),
                                title: Icon(
                                  Icons.check_circle,
                                  size: 70,
                                  color: Colors.green,
                                ),
                                content: Text(
                                  'Password has been successfully saved!',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                actions: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SignIn(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'OK',
                                        style: GoogleFonts.poppins(
                                          color: Colors.green,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(10.0),
                                        fixedSize: Size(90, 40),
                                        primary: secondaryColor,
                                        onPrimary: Colors.green,
                                        shadowColor: Colors.transparent,
                                        side: BorderSide(color: Colors.green, width: 1),
                                        shape: StadiumBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              );
                            },
                          );
                          // await Future.delayed(
                          //     Duration(milliseconds: 2500), () {
                          //
                          //   Navigator.pop(context);
                          //   Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => SignIn(),
                          //     ),
                          //   );
                          // });
                        },
                        child: Text(
                          'Yes',
                          style: GoogleFonts.poppins(
                            color: primaryColor,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(10.0),
                          fixedSize: Size(90, 40),
                          primary: secondaryColor,
                          onPrimary: primaryColor,
                          shadowColor: Colors.transparent,
                          side: BorderSide(color: primaryColor, width: 1),
                          shape: StadiumBorder(),
                        ),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            color: secondaryColor,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(10.0),
                          fixedSize: Size(90, 40),
                          primary: primaryColor,
                          onPrimary: Colors.white,
                          shadowColor: Colors.transparent,
                          side: BorderSide(color: primaryColor, width: 2),
                          shape: StadiumBorder(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              );
            },
          );
        }
      },
      child: Text(
        'Save changes',
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

  //BACKEND FUNCTIONALITY
  Future<void>_updateForm() async{
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
    }

    final email = forgetPasswordState!.email;

    try{
      final url = Uri.parse('${api_url}/api/accounts/update_password/$email');
      final request = http.MultipartRequest('POST', url)
        ..fields['password'] = password!
        ..fields['confirm_password'] = confirm_password!;

      final response = await request.send();

      print(password);

      if(response.statusCode == 200){
        print('password was successfulyy updated');
      }
      else {
        // Print detailed error response
        final responseError = await response.stream.bytesToString();
        print('Failed to update password. Status code: ${response.statusCode}, Error: $responseError');
      }
    }catch(e){
      print('error: $e');
    }
  }


}
