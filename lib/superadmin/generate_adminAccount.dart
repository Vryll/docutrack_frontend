import 'package:flutter/material.dart';
import 'package:docutrack_main/style.dart';
// import 'package:docutrack_main/custom_widget/staff_custom_nav_bar.dart';
import 'package:docutrack_main/custom_widget/custom_superadmin_sideNavBar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/superadmin/superadmin_homepage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:docutrack_main/localhost.dart';

class Generate_AdminAcc extends StatefulWidget {
  Generate_AdminAcc({Key? key}) : super(key: key);

  @override
  State<Generate_AdminAcc> createState() => _Generate_AdminAccState();
}

class _Generate_AdminAccState extends State<Generate_AdminAcc> {
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ConfirmpasswordController = TextEditingController();
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;


  @override
  void dispose() {
    _passwordController.dispose();
    _ConfirmpasswordController.dispose();
    super.dispose();
  }

  var api_url = dotenv.env['API_URL'];
  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();
  String? email = "";
  // String? admin_id = "";
  List<dynamic>? officeList;
  String? office_name = "";
  String? password = "";
  String? confirm_password = "";
  String? role = 'admin';

  XFile? _image;
  String? base64Image;



  fetchOfficeList() async{
    final response = await http.get(Uri.parse(
        '${api_url}/api/accounts/getOfficeList/all'),
      headers:{
        'Accept': 'application/json',
        "ngrok-skip-browser-warning": "$localhost_port",
      },
    );
    if(response.statusCode == 200){
      setState(() {
        officeList = json.decode(response.body);
      });
    }
  }

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

  @override
  void initState(){
    super.initState();
    fetchOfficeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile(context) ? AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 65,
        title: Text(
          'Create an admin account',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
        ),
        iconTheme: IconThemeData(
          color: secondaryColor,
        ),
        centerTitle: true,
      )
          : null,
      drawer: isMobile(context)
          ? Drawer(
        backgroundColor: primaryColor,
        child: SideNav(),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (MediaQuery.of(context).size.width > 600)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Create an admin account',
                              style: GoogleFonts.poppins(
                                fontSize: 45,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
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
                    if (MediaQuery.of(context).size.width > 600)
                      const SizedBox(height: 30),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                  alignment: Alignment.center,
                                  child: buildUploadBtn(context)
                              ),
                              const SizedBox(height: 30),
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
                              BuildEmailForm(),
                              // SizedBox(height: 20),
                              // Row(
                              //   children: [
                              //     Text(
                              //       'Admin ID',
                              //       style: GoogleFonts.poppins(
                              //         fontWeight: FontWeight.bold,
                              //         letterSpacing: 1,
                              //       ),
                              //     ),
                              //     Text(
                              //       '*',
                              //       style: GoogleFonts.poppins(
                              //           fontWeight: FontWeight.bold,
                              //           color: Colors.red
                              //       ),
                              //     )
                              //   ],
                              // ),
                              // SizedBox(height: 5),
                              // BuildAdminIDForm(),
                              const SizedBox(height: 20),
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
                              const SizedBox(height: 10),
                              BuildOffceNameForm(),
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
                              BuildPasswordForm(),
                              const SizedBox(height: 20),
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
                              BuildConfirmPasswordForm(),
                            ],
                          ),
                        )
                    ),
                    SizedBox(height: isWeb(context) ? 40 : 30),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: BuildSaveBtn(),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget BuildEmailForm() => TextFormField(
    key: Key('email'),
    decoration: InputDecoration(
      labelText: 'Enter a WMSU email',
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
    validator: (String? value){
      if(value == null || value.isEmpty){
        return 'Please enter a WMSU email.';
      } else if(!value.endsWith('@wmsu.edu.ph')){
        return 'Invalid Email!';
      } else {
        return null;
      }
    },
    onSaved: (value){email = value;},
  );



  // Widget BuildAdminIDForm() => TextFormField(
  //   key: Key('admin_id'),
  //   decoration: InputDecoration(
  //     labelText: 'Enter admin ID',
  //     contentPadding: EdgeInsets.symmetric(horizontal: 10),
  //     border: OutlineInputBorder(),
  //   ),
  //   validator: (String? value){
  //     if(value == null || value.isEmpty){
  //       return 'Please enter some text';
  //     }
  //     return null;
  // },
  //   onSaved: (value){admin_id = value;},
  // );

  Widget BuildOffceNameForm() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Choose an office',
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
      ),
      items: officeList?.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          child: Text(item['office_list'],
            /// UPDATED (12-03-23) FONTSIZE CHANGED
            style: GoogleFonts.poppins(
                fontSize: 12
            ),
          ),
          value: item['office_list'],
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          office_name = newValue;
        });
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please choose an office.';
        }
        return null;
      },
      onSaved: (value) {
        office_name = value;
      },
    );
  }

  // Widget BuildOffceNameForm() => TextFormField(
  //   key: Key('office_name'),
  //   decoration: InputDecoration(
  //     labelText: 'Enter office name',
  //     contentPadding: EdgeInsets.symmetric(horizontal: 10),
  //     border: OutlineInputBorder(),
  //   ),
  //   validator: (String? value){
  //     if(value == null || value.isEmpty){
  //       return 'Please enter some text';
  //     }
  //     return null;
  //   },
  //   onSaved: (value){office_name = value;},
  // );

  Widget BuildPasswordForm() => TextFormField(
    key: Key('password'),
    decoration: InputDecoration(
      labelText: 'Enter a password',
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
    validator: (value){
      if(value!.isEmpty){
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
    // onSaved: (value) => setState(() =>password = value),
    obscureText: !_showPassword,
    enabled: true,
    onSaved: (value){password = value;},
  );

  Widget BuildConfirmPasswordForm() => TextFormField(
    decoration: InputDecoration(
      labelText: 'Re-enter password',
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
    validator: (value){
      if(value!.isEmpty){
        return 'Please re-enter password.';
        // } else if (value != _passwordController.text) {
        //   return 'Passwords do not match.';
        // } else if (value!.length < 8) {
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
    // onSaved: (value) => setState(() =>password = value),
    obscureText: !_showConfirmPassword,
    enabled: true,
    onSaved: (value){confirm_password = value;},
  );

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

  Widget BuildSaveBtn() => ElevatedButton(
    onPressed: () async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: 350,
                height: 270,
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
                        Icons.help,
                        size: 100,
                        color: primaryColor,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Are you sure you want to create this account?',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 25.0),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: Text('Yes',
                                style: GoogleFonts.poppins(

                                ),
                              ),
                              onPressed: () async {
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
                                await _submitForm();

                                Navigator.pop(context);
                                Future.delayed(Duration(milliseconds: 100), () {
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
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  5),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                size: 100,
                                                color: Colors.green,
                                              ),
                                              SizedBox(height: 10.0),
                                              Text(
                                                'Admin account created successfully!',
                                                style: GoogleFonts.poppins(
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              SizedBox(height: 25.0),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  ElevatedButton(
                                                    child: Text('OK'),
                                                    onPressed: () {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SuperAdmin_HomePage(),
                                                        ),
                                                      );
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                          horizontal: 50,
                                                          vertical: 13),
                                                      textStyle: GoogleFonts
                                                          .poppins(
                                                        fontSize: 14,
                                                        // fontWeight: FontWeight.bold,
                                                      ),
                                                      primary: Colors.white,
                                                      onPrimary: Colors.green,
                                                      elevation: 3,
                                                      shadowColor: Colors
                                                          .transparent,
                                                      shape: StadiumBorder(
                                                          side: BorderSide(
                                                              color: Colors
                                                                  .green,
                                                              width: 2)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 13),
                                textStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                primary: Colors.white,
                                onPrimary: primaryColor,
                                elevation: 3,
                                shadowColor: Colors.transparent,
                                shape: StadiumBorder(side: BorderSide(
                                    color: primaryColor, width: 2)),
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: ElevatedButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 13),
                                textStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  // fontWeight: FontWeight.bold,
                                ),
                                primary: primaryColor,
                                onPrimary: Colors.white,
                                elevation: 3,
                                shadowColor: Colors.transparent,
                                shape: StadiumBorder(),
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
        //   showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return AlertDialog(
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.all(Radius.circular(0)),
        //         ),
        //         title: Icon(
        //           Icons.help,
        //           size: 70,
        //           color: primaryColor,
        //         ),
        //         content: Text(
        //           'Are you sure you want to add this account?',
        //           style: GoogleFonts.poppins(
        //             fontWeight: FontWeight.bold,
        //             fontSize: 16,
        //           ),
        //           textAlign: TextAlign.center,
        //         ),
        //         actions: [
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               ElevatedButton(
        //                 onPressed: () async {
        //                   await _submitForm();
        //                   showDialog(
        //                     context: context,
        //                     builder: (BuildContext context) {
        //                       return AlertDialog(
        //                         shape: RoundedRectangleBorder(
        //                           borderRadius: BorderRadius.all(
        //                               Radius.circular(5)),
        //                         ),
        //                         title: Icon(
        //                           Icons.check_circle,
        //                           size: 70,
        //                           color: Colors.green,
        //                         ),
        //                         content: Text(
        //                           'Account has been successfully added!',
        //                           style: GoogleFonts.poppins(
        //                             fontWeight: FontWeight.bold,
        //                             fontSize: 16,
        //                           ),
        //                           textAlign: TextAlign.center,
        //                         ),
        //                         actions: [
        //                           Align(
        //                             alignment: Alignment.center,
        //                             child: ElevatedButton(
        //                               onPressed: () async {
        //                                 showDialog(
        //                                   context: context,
        //                                   builder: (BuildContext context) {
        //                                     return Center(
        //                                       child: SpinKitThreeBounce(
        //                                         color: secondaryColor,
        //                                         size: 30.0,
        //                                       ),
        //                                     );
        //                                   },
        //                                 );
        //
        //                                 await Future.delayed(Duration(
        //                                     milliseconds: 1500), () {
        //                                   Navigator.pop(context);
        //                                   Navigator.pushReplacement(
        //                                     context,
        //                                     MaterialPageRoute(
        //                                       builder: (context) =>
        //                                           SuperAdmin_HomePage(),
        //                                     ),
        //                                   );
        //                                 });
        //                               },
        //                               child: Text(
        //                                 'OK',
        //                                 style: GoogleFonts.poppins(
        //                                   color: Colors.green,
        //                                 ),
        //                               ),
        //                               style: ElevatedButton.styleFrom(
        //                                 padding: EdgeInsets.all(10.0),
        //                                 fixedSize: Size(90, 40),
        //                                 primary: secondaryColor,
        //                                 onPrimary: Colors.green,
        //                                 shadowColor: Colors.transparent,
        //                                 side: BorderSide(color: Colors.green, width: 1),
        //                                 shape: StadiumBorder(),
        //                               ),
        //                             ),
        //                           ),
        //                           SizedBox(height: 20),
        //                         ],
        //                       );
        //                     },
        //                   );
        //                   await Future.delayed(
        //                       Duration(milliseconds: 2500), () {
        //                     Navigator.pop(context);
        //                     Navigator.pushReplacement(
        //                       context,
        //                       MaterialPageRoute(
        //                         builder: (context) => SuperAdmin_HomePage(),
        //                       ),
        //                     );
        //                   });
        //                 },
        //                 child: Text(
        //                   'Yes',
        //                   style: GoogleFonts.poppins(
        //                     color: primaryColor,
        //                   ),
        //                 ),
        //                 style: ElevatedButton.styleFrom(
        //                   padding: EdgeInsets.all(10.0),
        //                   fixedSize: Size(90, 40),
        //                   primary: secondaryColor,
        //                   onPrimary: primaryColor,
        //                   shadowColor: Colors.transparent,
        //                   side: BorderSide(color: primaryColor, width: 1),
        //                   shape: StadiumBorder(),
        //                 ),
        //               ),
        //               SizedBox(width: 20),
        //               ElevatedButton(
        //                 onPressed: () {
        //                   Navigator.of(context).pop();
        //                 },
        //                 child: Text(
        //                   'Cancel',
        //                   style: GoogleFonts.poppins(
        //                     color: secondaryColor,
        //                   ),
        //                 ),
        //                 style: ElevatedButton.styleFrom(
        //                   padding: EdgeInsets.all(10.0),
        //                   fixedSize: Size(90, 40),
        //                   primary: primaryColor,
        //                   onPrimary: Colors.white,
        //                   shadowColor: Colors.transparent,
        //                   side: BorderSide(color: primaryColor, width: 2),
        //                   shape: StadiumBorder(),
        //                 ),
        //               ),
        //             ],
        //           ),
        //           SizedBox(height: 20),
        //         ],
        //       );
        //     },
        //   );
        // }
      }
    },
    child: Text(
      'Add account',
      style: GoogleFonts.poppins(
        fontSize: 16,
      ),
    ),
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.all(10.0),
      fixedSize: Size(isMobile(context) ? MediaQuery.of(context).size.width : 250, 55),
      primary: primaryColor,
      onPrimary: Colors.white,
      shadowColor: Colors.transparent,
      // side: BorderSide(color: primaryColor, width: 2),
      shape: StadiumBorder(),
    ),
  );


  Future<void> _submitForm() async{
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }

    try{
      List<int> imageBytes = await _image!.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      final url = Uri.parse('${api_url}/api/accounts/create_admin');
      final request = http.MultipartRequest('POST', url)
        ..fields['email'] = email!
      // ..fields['admin_id'] = admin_id!
        ..fields['office_name'] = office_name!
        ..fields['password'] = password!
        ..fields['confirm_password'] = confirm_password!
        ..fields['role'] = role!
        ..files.add(await http.MultipartFile.fromString(
            'admin_logo', base64Image));

      final response = await request.send();
      print(response);
      print(email);
      // print(admin_id);
      print(office_name);
      print(password);
      print(_image);

      if(response.statusCode ==200){
        print('admin account is successfully saved!');
      }
    }catch (e) {
      print('error: $e');
    }
  }
  void snackBar(context, String msg){
    final snackBar = SnackBar(content: Text(
      msg,
      style: TextStyle(
        fontSize: 18,
        backgroundColor: Colors.green,
      ),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}

