import 'package:docutrack_main/admin/admin_my_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/style.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:docutrack_main/main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:docutrack_main/custom_widget/custom_side_nav_bar.dart';
import 'package:docutrack_main/localhost.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class AdminProDetails{
  String? email;
  String? password;
  String? admin_logo;
  String? admin_id;
  String? office_name;
  int? user_id;

  AdminProDetails({
    required this.email,
    required this.password,
    required this.admin_logo,
    required this.admin_id,
    required this.office_name,
    required this.user_id,
  });
}



class _EditProfileState extends State<EditProfile> {
  var api_url = dotenv.env['API_URL'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isMobile(BuildContext context) =>
      MediaQuery
          .of(context)
          .size
          .width <= 600;

  bool isWeb(BuildContext context) =>
      MediaQuery
          .of(context)
          .size
          .width > 600;

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ConfirmpasswordController = TextEditingController();

  XFile? _image;

  AdminProfileState? adminProfileState;
  UserIdState? userIdState;
  MyappState? myAppState;

  String jwtToken = "";

  String? password;
  String? confirm_password;
  String? admin_logo;
  String? admin_overview;


  @override
  void dispose() {
    _passwordController.dispose();
    _ConfirmpasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    adminProfileState = Provider.of<AdminProfileState>(context, listen: false);
    userIdState = Provider.of<UserIdState>(context, listen: false);
    myAppState = Provider.of<MyappState>(context, listen: false);
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
            fontSize: 24,
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
                padding: EdgeInsets.symmetric(
                    horizontal: isWeb(context) ? 40 : 20,
                    vertical: isWeb(context) ? 40 : 30),
                child: LayoutBuilder(
                    builder: (BuildContext context,
                        BoxConstraints constraints) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (MediaQuery
                              .of(context)
                              .size
                              .width > 600)
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
                          if (MediaQuery
                              .of(context)
                              .size
                              .width > 600)
                            const SizedBox(height: 30),
                          Consumer<AdminProfileState>(
                            builder: (context, adminProfile, _) {
                              return Column(
                                children: [
                                  Center(
                                    child: buildUploadBtn(context),
                                  ),
                                  SizedBox(height: 20),

                                  const SizedBox(height: 20),
                                  Text(
                                    adminProfile.office_name ?? '',
                                    style: GoogleFonts.poppins(
                                      color: primaryColor,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      text: 'WMSU Email: ',
                                      style: GoogleFonts.poppins(
                                        color: primaryColor,
                                        fontSize: 12.0,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '${adminProfile.email ?? ''}',
                                          style: GoogleFonts.poppins(
                                            color: primaryColor,
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration
                                                .underline,
                                            decorationColor: primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 30.0),
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 15),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    buildPassword(),

                                    const SizedBox(height: 20.0),
                                    buildConfirmPassword(),

                                    const SizedBox(height: 20.0),
                                    buildOverview(),

                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 50.0),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: buildSaveButton(context
                              )
                          ),
                          const SizedBox(height: 20.0),
                        ],
                      );
                    }
                ),
              ),
            ),
          ),
        ],
      ),
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
          enabled: true,
          validator: (value) {
            if (value!.length < 8) {
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
          onSaved: (value) {
            password = value;
          },

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
          enabled: true,

          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 14,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please re-enter your password.';
            } else if (value != _passwordController.text) {
              return 'Passwords do not match.';
            } else {
              return null;
            }
          },
          onSaved: (value) {
            confirm_password = value;
          },
        ),
      ],
    );
  }

  Widget buildOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Overview ',
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
        TextFormField(
          minLines: 2,
          maxLines: 10,
          keyboardType: TextInputType.multiline,
          key: Key('admin_overview'),
          decoration: InputDecoration(
            hintText: 'Enter overview',
            hintStyle: GoogleFonts.poppins(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
              fontSize: 12,
            ),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[280],
            contentPadding: EdgeInsets.only(
                top: 10.0, bottom: 150.0, left: 10.0, right: 10.0),
          ),
          enabled: true,

          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 14,
          ),
          validator: (value) {
            // if (value!.isEmpty) {
            //   return 'Please enter some text.';
            // }
          },
          onSaved: (value) {
            admin_overview = value;
          },
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
      onPressed: () async{

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
        fixedSize: Size(isMobile(context) ? MediaQuery
            .of(context)
            .size
            .width : 250, 50),
        primary: primaryColor,
        onPrimary: secondaryColor,
        shadowColor: Colors.transparent,
        side: BorderSide(color: primaryColor, width: 2),
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


  Future<void> _getImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery);
      setState(() {
        _image = image;
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _submitForm() async {
    final userId = userIdState!.userId;
    print(userId);
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();

      try {
        final url = Uri.parse('$api_url/api/accounts/edit_admin_Details/$userId');

        final request = http.MultipartRequest('POST', url);

        if (_image != null) {

          List<int> imageBytes = await _image!.readAsBytes();
          String base64Image = base64Encode(imageBytes);
          request.fields['admin_logo'] = base64Image;
        }

        if (password != null) {

          request.fields['password'] = password!;
        }

        if (admin_overview != null) {

          request.fields['admin_overview'] = admin_overview!;
        }

        final response = await request.send();

        if (response.statusCode == 200) {
          print('Admin details updated successfully');

        } else {
          print('Update failed with status code: ${response.statusCode}');

        }
      } catch (e) {
        print('Error: $e');

      }
    }
  }

}
