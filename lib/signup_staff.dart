import 'dart:convert';

import 'package:docutrack_main/style.dart';
import 'package:flutter/material.dart';
import 'package:docutrack_main/sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:docutrack_main/staff/staff_edit_profile.dart';
import 'package:docutrack_main/main.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var api_url = dotenv.env['API_URL'];
  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();
  String? email = "";
  // String? employee_id = "";
  String? password = "";
  String? confirm_password = "";
  TextEditingController _passwordController = TextEditingController();
  String? role = 'clerk';
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;

  UserIdState? userIdState;

  @override
  void initState(){
    super.initState();
    userIdState=Provider.of<UserIdState>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: primaryColor,
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (isMobile(context)) {
              return Stack(
                children: [
                  Positioned(
                    top: 70,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const  EdgeInsets.only(right: 20),
                          child: FittedBox(
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/DocuTrack(White).png',
                                  height: 45,
                                  width: 45,
                                ),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'DocuTrack',
                                      style: GoogleFonts.russoOne(
                                        color: secondaryColor,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                    ),
                                    Text(
                                      'Document Tracking and Management System',
                                      style: GoogleFonts.poppins(
                                        color: secondaryColor,
                                        fontSize: 5.6,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 65,
                              letterSpacing: 1.5,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 270,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                        child: SingleChildScrollView(
                          child: Form(
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
                                SizedBox(height: 10.0),
                                BuildInputEmail(),
                                SizedBox(height: 20.0),
                                Text.rich(
                                  TextSpan(
                                    text: 'Password ',
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
                                SizedBox(height: 10.0),
                                BuildInputPassword(),
                                SizedBox(height: 20.0),
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
                                SizedBox(height: 10.0),
                                BuildConfirmPassword(),
                                SizedBox(height: 50.0),
                                Center(
                                  child: BuildSignUpBtn(),
                                ),
                                SizedBox(height: 50.0),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: BuildSignInBtn(),
                                ),
                                SizedBox(height: 20.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  constraints: const BoxConstraints(maxWidth: 500),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 1.0,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          child: FittedBox(
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/DocuTrack (Red).png',
                                  height: 50,
                                  width: 50,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'DocuTrack',
                                      style: GoogleFonts.russoOne(
                                        color: primaryColor,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                      maxLines: 1,
                                    ),
                                    Text(
                                      'Document Tracking and Management System',
                                      style: GoogleFonts.poppins(
                                        color: primaryColor,
                                        fontSize: 6,
                                        letterSpacing: 0.5,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.poppins(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 65,
                              letterSpacing: 1.5,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(height: 50),
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
                              SizedBox(height: 10.0),
                              BuildInputEmail(),
                              SizedBox(height: 20.0),
                              Text.rich(
                                TextSpan(
                                  text: 'Password ',
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
                              SizedBox(height: 10.0),
                              BuildInputPassword(),
                              SizedBox(height: 20.0),
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
                              SizedBox(height: 10.0),
                              BuildConfirmPassword(),
                              SizedBox(height: 50.0),
                              Center(
                                child: BuildSignUpBtn(),
                              ),
                              SizedBox(height: 50.0),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: BuildSignInBtn(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
      ),
    );
  }
  Widget BuildInputEmail() =>
      TextFormField(
        key: Key('email'),
        decoration: InputDecoration(
          labelText: 'Enter your WMSU email',
          labelStyle: GoogleFonts.poppins(
            fontSize: 15.0,
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
            return 'Please enter a WMSU email.';
          } else if (!value.endsWith('@wmsu.edu.ph')){
            return 'Invalid Email! Only WMSU email is allowed.';
          } else{
            return null;
          }
        },
        onSaved: (value) {email = value;},
      );

  // Widget BuildInputEmployeeID() =>
  //     TextFormField(
  //       key: Key('employee_id'),
  //       decoration: InputDecoration(
  //         labelText: 'Enter your employee ID',
  //         labelStyle: GoogleFonts.poppins(
  //           fontSize: 15,
  //           color: Colors.grey,
  //         ),
  //         contentPadding: EdgeInsets.symmetric(horizontal: 10),
  //         border: OutlineInputBorder(),
  //       ),
  //       validator: (value) {
  //         if (value!.isEmpty) {
  //           return 'Please enter a Employee ID.';
  //         }
  //       },
  //       onSaved: (value) {employee_id = value;},
  //     );

  Widget BuildInputPassword() =>
      TextFormField(
        key: Key('password'),
        decoration: InputDecoration(
          labelText: 'Enter a password',
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
            return 'Please enter a password.';
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

  Widget BuildSignUpBtn() => ElevatedButton(
      onPressed: () {
        if (!_formKey.currentState!.validate()) {

        } else {
          _submitForm().then((value) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => StaffEditProfile()),
                    (route) => false);
          });
        }
      },
      child: Text(
        'Sign Up',
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
      ));

  Widget BuildSignInBtn() => Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(
        'Already have an account?',
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.black,
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignIn(),
            ),
          );
        },
        child: Text(
          'Sign In',
          style: GoogleFonts.poppins(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
    ],
  );


  Future<void> _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }

    try {
      final url = Uri.parse('${api_url}/api/accounts/create_staff');
      final request = http.MultipartRequest('POST', url)
        ..fields['email'] = email!
      // ..fields['employee_id'] = employee_id!
        ..fields['password'] = password!
        ..fields['confirm_password'] = confirm_password!
        ..fields['role'] = role!;

      // print(employee_id);

      final response = await request.send();
      print(response);
      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        final Map<String, dynamic> responseData = json.decode(responseString);
        final String userId = responseData['user_id'].toString();


        userIdState!.setUserId(userId.toString());
        print(userId);

        print('staff account successfully saved!');
      }
    } catch (e) {
      print('error: $e');
    }
    void snackBar(context, String msg) {
      final snackBar = SnackBar(content:
      Text(
          msg,
          style: TextStyle(
            fontSize: 18,
            backgroundColor: Colors.green,
          )
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
