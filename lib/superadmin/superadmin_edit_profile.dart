import 'package:docutrack_main/superadmin/superadmin_my_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/style.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:docutrack_main/main.dart';
import 'package:docutrack_main/custom_widget/custom_superadmin_sideNavBar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class SuperadminProfileDetails{
  int? userId;
  String? email;
  String? superadmin_name;
  String? password;
  String? user_id;

  SuperadminProfileDetails({
    required this.userId,
    required this.email,
    required this.superadmin_name,
    required this.password,
    required this.user_id,
  });
}

class _EditProfileState extends State<EditProfile> {
  var api_url = dotenv.env['API_URL'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;

  XFile? _image;

  SuperadminProfileState? superadminProfileState;
  UserIdState? userIdState;
  MyappState? myAppState;

  int? userId;
  String? email = "";
  String? superadmin_name = "";
  String? password = "";
  String? confirm_password = "";
  String? superadmin_image = "";
  int? user_id;

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ConfirmpasswordController = TextEditingController();

  @override
  void initState(){
    super.initState();
    userIdState = Provider.of<UserIdState>(context, listen: false);
    myAppState = Provider.of<MyappState>(context, listen: false);
    superadminProfileState = Provider.of<SuperadminProfileState>(context, listen: false);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _ConfirmpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile(context) ? AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 65,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: secondaryColor,
          ),
        ),
        centerTitle: true,
      )
          : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isWeb(context) ?
          Container(
            color: primaryColor,
            child: SideNav(),
            width: size300_80(context),
          ) : Container(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: isMobile(context) ? EdgeInsets.symmetric(horizontal: 20, vertical: 30)
                    : EdgeInsets.symmetric(horizontal: 60, vertical: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (MediaQuery.of(context).size.width > 600)
                      Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Edit Profile',
                                style: GoogleFonts.poppins(
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 30),
                    Consumer<SuperadminProfileState>(
                      builder: (context, superadminProfile, _) {
                        return Column(
                          children: [
                            Center(
                              child: buildUploadBtn(context),
                            ),

                            // Container(
                            //   width: 100.0,
                            //   height: 100.0,
                            //   decoration: BoxDecoration(
                            //     shape: BoxShape.circle,
                            //     color: primaryColor,
                            //   ),
                            //   child: Center(
                            //     child: superadminProfile != null && superadminProfile.superadmin_image != null
                            //         ? ClipOval(
                            //       child: Image.network(
                            //         superadminProfile.superadmin_image!,
                            //         width: 100,
                            //         height: 100,
                            //         fit: BoxFit.cover,
                            //         loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? progress) {
                            //           return progress == null
                            //               ? child
                            //               : CircularProgressIndicator(
                            //             value: progress.expectedTotalBytes != null
                            //                 ? progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1)
                            //                 : null,
                            //           );
                            //         },
                            //       ),
                            //     )
                            //         : Icon(
                            //       Icons.person_rounded,
                            //       size: 100.0,
                            //       color: secondaryColor,
                            //     ),
                            //   ),
                            // ),

                            // SizedBox(height: 20),
                            // ElevatedButton(
                            //   onPressed: () {
                            //     _getImage();
                            //   },
                            //   child: Text(
                            //     'Upload Photo',
                            //     style: GoogleFonts.poppins(
                            //       fontSize: 14,
                            //       color: primaryColor,
                            //     ),
                            //   ),
                            //   style: ElevatedButton.styleFrom(
                            //     padding: EdgeInsets.all(10.0),
                            //     fixedSize: Size(120, 40),
                            //     primary: secondaryColor,
                            //     onPrimary: primaryColor,
                            //     shadowColor: Colors.transparent,
                            //     side: BorderSide(color: primaryColor, width: 2),
                            //     shape: StadiumBorder(),
                            //   ),
                            // ),
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                superadminProfile?.superadmin_name ?? 'Name',
                                style: GoogleFonts.poppins(
                                  color: primaryColor,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Center(
                              child: Text(
                                'WMSU Email: ${superadminProfile?.email ?? 'Email'}',
                                style: GoogleFonts.poppins(
                                  color: primaryColor,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              buildemail(),
                              SizedBox(height: 20.0),
                              buildName(),
                              SizedBox(height: 20.0),
                              buildPassword(),
                              SizedBox(height: 20.0),
                              buildConfirmPassword(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: buildSaveButton(context),
                    ),
                    // LayoutBuilder(
                    //     builder: (BuildContext context, BoxConstraints constraints) {
                    //       return Column(
                    //         children: [
                    //           Consumer<SuperadminProfileState>(
                    //             builder: (context, superadminProfile, _) {
                    //               return Column(
                    //                 children: [
                    //                   Center(
                    //                     child: Container(
                    //                       width: 100.0,
                    //                       height: 100.0,
                    //                       decoration: BoxDecoration(
                    //                         shape: BoxShape.circle,
                    //                         color: primaryColor,
                    //                       ),
                    //                       child: Center(
                    //                         child: _image != null
                    //                             ? ClipOval(
                    //                           child: Image.file(
                    //                             File(_image!.path),
                    //                             width: 100, // Set your desired width
                    //                             height: 100, // Set your desired height
                    //                             fit: BoxFit.cover,
                    //                           ),
                    //                         )
                    //                             : superadminProfile != null
                    //                             ? ClipOval(
                    //                           child: Image.network(
                    //                             superadminProfile.superadmin_image!,
                    //                             width: 100,
                    //                             height: 100,
                    //                             fit: BoxFit.cover, // Ensure the image fills the circle
                    //                             loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? progress) {
                    //                               return progress == null
                    //                                   ? child
                    //                                   : CircularProgressIndicator(
                    //                                 value: progress.expectedTotalBytes != null
                    //                                     ? progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1)
                    //                                     : null,
                    //                               );
                    //                             },
                    //                           ),
                    //                         )
                    //                             : Icon(
                    //                           Icons.person, // You can use a placeholder icon or image
                    //                           size: 100,
                    //                           color: Colors.white,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //
                    //                   SizedBox(height: 20),
                    //
                    //                   Center(
                    //                     child: ElevatedButton(
                    //                       onPressed: () {
                    //                         _getImage();
                    //                       },
                    //                       child: Text(
                    //                         'Upload Photo',
                    //                         style: GoogleFonts.poppins(
                    //                           fontSize: 14,
                    //                           fontWeight: FontWeight.bold,
                    //                         ),
                    //                       ),
                    //                       style: ElevatedButton.styleFrom(
                    //                         primary: secondaryColor,
                    //                         onPrimary: primaryColor,
                    //                         elevation: 3,
                    //                         shadowColor: Colors.transparent,
                    //                         side: BorderSide(color: Colors.white, width: 2),
                    //                         shape: StadiumBorder(),
                    //                       ),
                    //                     ),
                    //                   ),
                    //
                    //                   SizedBox(height: 20),
                    //                   Center(
                    //                     child: Text(
                    //                       superadminProfile.superadmin_name ?? '',
                    //                       style: GoogleFonts.poppins(
                    //                         color: primaryColor,
                    //                         fontSize: 20.0,
                    //                         fontWeight: FontWeight.bold,
                    //                       ),
                    //                       textAlign: TextAlign.center,
                    //                     ),
                    //                   ),
                    //                   Center(
                    //                     child: Text(
                    //                       'Email: ${superadminProfile.email ?? ''}',
                    //                       style: GoogleFonts.poppins(
                    //                         color: primaryColor,
                    //                         fontSize: 12.0,
                    //                         fontWeight: FontWeight.bold,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               );
                    //             },
                    //           ),
                    //           Form(
                    //             key: _formKey,
                    //             child: Column(
                    //               children: [
                    //                 SizedBox(height: 30.0),
                    //                 buildemail(),
                    //                 SizedBox(height: 10.0),
                    //                 buildName(),
                    //                 SizedBox(height: 10.0),
                    //                 buildPassword(),
                    //                 SizedBox(height: 10.0),
                    //                 buildConfirmPassword(),
                    //                 SizedBox(height: 80.0),
                    //                 buildSaveButton(context),
                    //               ],
                    //             ),
                    //           )
                    //         ],
                    //       );
                    //     }
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildemail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
        SizedBox(height: 10),
        TextFormField(
          key: Key('email'),
          decoration: InputDecoration(
            labelText: 'Enter your WMSU email',
            labelStyle: GoogleFonts.poppins(
              fontSize: 15,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: primaryColor
                )
            ),
          ),
          enabled: true,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your WMSU email.';
            } else if(!value.endsWith('@wmsu.edu.ph')) {
              return 'Invalid Email!';
            } else {
              return null;
            }
          },
          onSaved: (value){email = value;},
        ),
      ],
    );
  }

  Widget buildName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text.rich(
          TextSpan(
            text: 'Office Name ',
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
        SizedBox(height: 10),
        TextFormField(
          key: Key('superadmin_name'),
          decoration: InputDecoration(
            labelText: 'Enter your office name',
            labelStyle: GoogleFonts.poppins(
              fontSize: 15,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: primaryColor
                )
            ),
          ),
          enabled: true,
          initialValue: '',
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your office name.';
            }
          },
          onSaved: (value){superadmin_name = value;},
        ),
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
        SizedBox(height: 10),
        TextFormField(
          key: Key('password'),
          decoration: InputDecoration(
            labelText: 'Enter your password',
            labelStyle: GoogleFonts.poppins(
              fontSize: 15,
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
          enabled: true,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please re-enter your password.';
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
        ),
      ],
    );
  }
  Widget buildConfirmPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
        SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Re-enter your password',
            labelStyle: GoogleFonts.poppins(
              fontSize: 15,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: primaryColor
                )
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
          enabled: true,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please re-enter your password.';
              // } else if (value != _passwordController.text) {
              //   return 'Passwords do not match.';
            }
            else {
              return null;
            }
          },
          onSaved: (value) {confirm_password = value;},
        ),
      ],
    );
  }

  Widget buildUploadBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _getImage();
      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: _image != null
              ? ClipOval(
            child: Image.network(
              _image!.path,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          )
              : Icon(
            Icons.add_photo_alternate_outlined,
            size: 100.0,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget buildSaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (!_formKey.currentState!.validate()) {
          return;
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Center(
                child: SpinKitThreeBounce(
                  color: secondaryColor,
                  size: 30.0,
                ),
              );
            },
          );
          try{
            await _submitForm();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  content: Container(
                    width: 350,
                    height: 250,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 100,
                            color: Colors.green,
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Account has been successfully updated!',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 25.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => MyProfile()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 13),
                                  textStyle: GoogleFonts.poppins(
                                    fontSize: 14,
                                  ),
                                  primary: Colors.white,
                                  onPrimary: Colors.green,
                                  elevation: 3,
                                  shadowColor: Colors.transparent,
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }catch(e){
            print('error: $e');
            Navigator.pop(context);
          }

        }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(10.0),
        fixedSize: Size(isMobile(context) ? MediaQuery.of(context).size.width : 250, 55),
        primary: primaryColor,
        onPrimary: secondaryColor,
        shadowColor: Colors.transparent,
        shape: StadiumBorder(),
      ),
      child: Text(
        'Save Changes',
        style: GoogleFonts.poppins(
          fontSize: 14,
        ),
      ),
    );
  }

  // void showConfirmationDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(5)),
  //           ),
  //           title: Icon(
  //             Icons.help,
  //             size: 70,
  //             color: primaryColor,
  //           ),
  //           content: Text(
  //             'Are you sure you want to update the admin details?',
  //             style: GoogleFonts.poppins(
  //               fontWeight: FontWeight.bold,
  //               fontSize: 16,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //           actions: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 ElevatedButton(
  //                   onPressed: () async {
  //                     _submitForm();
  //                     showDialog(
  //                       context: context,
  //                       builder: (BuildContext context) {
  //                         return AlertDialog(
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.all(
  //                                 Radius.circular(5)),
  //                           ),
  //                           title: Icon(
  //                             Icons.check_circle,
  //                             size: 70,
  //                             color: Colors.green,
  //                           ),
  //                           content: Text(
  //                             'You have successfully updated the admin details!',
  //                             style: GoogleFonts.poppins(
  //                               fontWeight: FontWeight.bold,
  //                               fontSize: 16,
  //                             ),
  //                             textAlign: TextAlign.center,
  //                           ),
  //                           actions: [
  //                             Align(
  //                               alignment: Alignment.center,
  //                               child: ElevatedButton(
  //                                 onPressed: () async {
  //                                   showDialog(
  //                                     context: context,
  //                                     builder: (BuildContext context) {
  //                                       return Center(
  //                                         child: SpinKitThreeBounce(
  //                                           color: secondaryColor,
  //                                           size: 30.0,
  //                                         ),
  //                                       );
  //                                     },
  //                                   );
  //
  //                                   await Future.delayed(Duration(
  //                                       milliseconds: 1500), () {
  //                                     Navigator.pop(context);
  //                                     // Navigator.pushReplacement(
  //                                     //   context,
  //                                     //   MaterialPageRoute(
  //                                     //     builder: (context) =>
  //                                     //         SuperAdmin_HomePage(),
  //                                     //   ),
  //                                     // );
  //                                   });
  //                                 },
  //                                 child: Text(
  //                                   'OK',
  //                                   style: GoogleFonts.poppins(
  //                                     color: Colors.green,
  //                                   ),
  //                                 ),
  //                                 style: ElevatedButton.styleFrom(
  //                                   padding: EdgeInsets.all(10.0),
  //                                   fixedSize: Size(90, 40),
  //                                   primary: secondaryColor,
  //                                   onPrimary: Colors.green,
  //                                   shadowColor: Colors.transparent,
  //                                   side: BorderSide(color: Colors.green, width: 1),
  //                                   shape: StadiumBorder(),
  //                                 ),
  //                               ),
  //                             ),
  //                             SizedBox(height: 20),
  //                           ],
  //                         );
  //                       },
  //                     );
  //                     await Future.delayed(
  //                         Duration(milliseconds: 2500), () {
  //                       Navigator.pop(context);
  //                       // Navigator.pushReplacement(
  //                       //   context,
  //                       //   MaterialPageRoute(
  //                       //     builder: (context) => SuperAdmin_HomePage(),
  //                       //   ),
  //                       // );
  //                     });
  //                   },
  //                   child: Text(
  //                     'Yes',
  //                     style: GoogleFonts.poppins(
  //                       color: primaryColor,
  //                     ),
  //                   ),
  //                   style: ElevatedButton.styleFrom(
  //                     padding: EdgeInsets.all(10.0),
  //                     fixedSize: Size(90, 40),
  //                     primary: secondaryColor,
  //                     onPrimary: primaryColor,
  //                     shadowColor: Colors.transparent,
  //                     side: BorderSide(color: primaryColor, width: 1),
  //                     shape: StadiumBorder(),
  //                   ),
  //                 ),
  //                 SizedBox(width: 20),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Text(
  //                     'Cancel',
  //                     style: GoogleFonts.poppins(
  //                       color: secondaryColor,
  //                     ),
  //                   ),
  //                   style: ElevatedButton.styleFrom(
  //                     padding: EdgeInsets.all(10.0),
  //                     fixedSize: Size(90, 40),
  //                     primary: primaryColor,
  //                     onPrimary: Colors.white,
  //                     shadowColor: Colors.transparent,
  //                     side: BorderSide(color: primaryColor, width: 2),
  //                     shape: StadiumBorder(),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: 20),
  //           ]
  //       );
  //     },
  //   );
  // }
  // showSuccessDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         content: Container(
  //           width: 300,
  //           height: 150,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Icon(
  //                 Icons.check_circle,
  //                 size: 70,
  //                 color: Colors.green,
  //               ),
  //               SizedBox(height: 10.0),
  //               Text(
  //                 'You have successfully updated the admin details!',
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 16,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //               SizedBox(height: 20.0),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   Navigator.pop(context); // Close the dialog
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
  //                   textStyle: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                   primary: Colors.green,
  //                   shape: StadiumBorder(),
  //                 ),
  //                 child: Text('OK'),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> _getImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _submitForm() async{
    final userId = userIdState!.userId;
    print(userId);

    final isValid = _formKey.currentState!.validate();

    if (isValid){
      _formKey.currentState!.save();

      try{
        List<int> imageBytes = await _image!.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        print(base64Image);
        final url = Uri.parse('${api_url}/api/accounts/edit_superadmin_data/$userId');

        final request = http.MultipartRequest('POST', url)
          ..fields['email'] = email!
          ..fields['superadmin_name'] = superadmin_name!
          ..fields['password'] = password!
          ..files.add(http.MultipartFile.fromString('superadmin_image', base64Image));

        print(email);
        print(superadmin_name);
        print(password);

        final response = await request.send();

        if (response.statusCode == 200){
          print('Superadmin details updated successfully');
        }else{
          print('Update failed with status code: ${response.statusCode}');
        }
      }catch(e){
        print('Error: $e');
      }
    }
  }
}

