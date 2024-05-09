import 'package:docutrack_main/main.dart';
import 'package:docutrack_main/staff/staff_home.dart';
import 'package:docutrack_main/style.dart';
import 'package:docutrack_main/superadmin/superadmin_homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:docutrack_main/signup_staff.dart';
import 'package:docutrack_main/admin/admin_home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:docutrack_main/email_confirmation.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

// class JwtToken {
//   static UserJwtToken? _instance;
//   String? jwtToken;
//
//   factory JwtToken() {
//     _instance ??= UserJwtToken._();
//     return _instance!;
//   }
//
//   JwtToken._();
//
//   void setUserJwtToken(String newJwtToken) {
//     jwtToken = newJwtToken;
//     print(jwtToken);
//   }
// }

final userJwtTokenProvider = UserJwtToken();

class _SignInState extends State<SignIn> {
  Future<AuthenticatedUser>? _futureAuthenticatedUser;
  final formKey = GlobalKey<FormState>();
  MyappState? appState;
  String? username = "";
  String? password = "";

  bool _showPassword = false;
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;

  signUserState? SignInUserState;
  UserJwtToken? userJwtToken;

  @override
  void initState() {
    super.initState();
    appState = Provider.of<MyappState>(context, listen: false);
    SignInUserState = Provider.of<signUserState>(context, listen: false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            'Sign In',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 65,
                              letterSpacing: 1.5,
                            ),
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
                      decoration: const BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                        child: SingleChildScrollView(
                          child: Form(
                            key: formKey,
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
                                const SizedBox(height: 10),
                                BuildUsername(),
                                const SizedBox(height: 20),
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
                                const SizedBox(height: 10),
                                BuildPassword(),
                                const SizedBox(height: 20),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: BuildForgetUsername()),
                                const SizedBox(height: 20),
                                BuildSigIn(),
                                const SizedBox(height: 50),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    'Don\'t have an account yet?',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: BuildSignUpBtn()),
                                const SizedBox(height: 30),
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
                            'Sign In',
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
                          key: formKey,
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
                              const SizedBox(height: 10),
                              BuildUsername(),
                              const SizedBox(height: 20),
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
                              const SizedBox(height: 10),
                              BuildPassword(),
                              const SizedBox(height: 20),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: BuildForgetUsername()),
                              const SizedBox(height: 20),
                              BuildSigIn(),
                              const SizedBox(height: 50),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  'Don\'t have an account yet?',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: BuildSignUpBtn()
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

  Widget BuildUsername() => TextFormField(
    decoration: InputDecoration(
      labelText: 'Enter your WMSU email',
      labelStyle: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.grey,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      border: OutlineInputBorder(),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: primaryColor
        ),
      ),
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
        return 'Invalid Email!';
      } else {
        return null;
      }
    },
    onSaved: (value) => setState(() => username = value),
  );

  Widget BuildPassword() => TextFormField(
    decoration: InputDecoration(
      labelText: 'Enter your password',
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
    validator: (value) {
      if (value!.isEmpty) {
        return 'Please enter your password.';
      } else {
        return null;
      }
    },
    onSaved: (value) => setState(() => password = value),
  );

  Widget BuildSigIn() => ElevatedButton(
    onPressed: () {
      final isValid = formKey.currentState!.validate();
      FocusScope.of(context).unfocus();

      if (isValid) {
        formKey.currentState!.save();
        _futureAuthenticatedUser = loginUser(context, username!, password!);
        _futureAuthenticatedUser!.then(
              (value) {
            appState?.setToken(value.jwt_token);
            print(appState?.user_Token);
          },
          onError: (e) {
            showErrorMessage("Invalid username or password");
            print(appState?.user_Token);
          },
        );
      }
    },
    child: Text(
      'Login',
      style: GoogleFonts.poppins(
        color: secondaryColor,
        fontSize: 16,
      ),
    ),
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.all(5.0),
      fixedSize: Size(MediaQuery.of(context).size.width, 55),
      primary: primaryColor,
      shape: StadiumBorder(),
    ),
  );

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Error',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'OK',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }




  Widget BuildForgetUsername() => TextButton(
    onPressed: () {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => EmailConfirmation()));
    },
    child: Text(
      'Forgot Password?',
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.black,
      ),
    ),
  );

  Widget BuildSignUpBtn() => TextButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignUp(),
        ),
      );
    },
    child: Text(
      'Sign Up',
      style: GoogleFonts.poppins(
        color: primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
    ),
  );
}

//USER AUTHENTICATION
class AuthenticatedUser {
  final String jwt_token;
  final String role;

  const AuthenticatedUser({required this.jwt_token, required this.role});

  factory AuthenticatedUser.fromJson(Map<String, dynamic> json) {
    return AuthenticatedUser(jwt_token: json['jwt_token'], role: json['role']);
  }
}

class AuthenticatedAdmin {
  final String token;
  final String admin_id;
  final String office_name;
  final String role;
  // final String password;
  // final String confirm_password;

  const AuthenticatedAdmin(
      {required this.token,
        required this.admin_id,
        required this.office_name,
        required this.role});
  factory AuthenticatedAdmin.fromJson(Map<String, dynamic> json) {
    return AuthenticatedAdmin(
      token: json['token'],
      admin_id: json['admin_id'],
      office_name: json['office_name'],
      role: json['role'],
    );
  }
}

Future<AuthenticatedUser> loginUser(
    BuildContext context, String username, String password) async {
  var api_url = dotenv.env['API_URL'];
  final response = await http.post(
    Uri.parse("${api_url}/api/accounts/Signin"),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'username': username,
      'password': password,
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    final authenticatedUser = AuthenticatedUser.fromJson(jsonResponse);
    final appState = Provider.of<MyappState>(context, listen: false);
    appState?.setToken(authenticatedUser.jwt_token);

    if (authenticatedUser.role == 'admin') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AdminHome()),
      );
    } else if (authenticatedUser.role == 'clerk') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => StaffHome()),
      );
    } else if (authenticatedUser.role == 'superadmin') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SuperAdmin_HomePage()),
      );
    }
    return authenticatedUser;
  } else {
    // Handle other status codes if needed
    print('Request failed with status: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Request failed with status: ${response.statusCode}');
  }
}



// Future<void>sendTokentToBackend(String) async{
//   final url = 'https://85e0-2001-4456-181-8900-899e-fa41-50d1-19fa.ngrok-free.app/api/scanner/docu_recieve_record/document_detail=$docuId/user=$userId}';
//
//   final response = await http.get(
//     Uri.parse(url),
//     headers: {
//       'Authorization': 'Bearer $jwtToken', // Include the JWT token in the 'Authorization' header
//     },
//   );
//
//   if (response.statusCode == 200) {
//     // Request was successful
//     // You can process the response from the backend here
//   } else {
//     // Request failed
//     // Handle errors or log the response
//   }
// }
