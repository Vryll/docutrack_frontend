import 'package:docutrack_main/superadmin/superadmin_edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/style.dart';
import 'package:docutrack_main/custom_widget/custom_superadmin_sideNavBar.dart';
import 'package:docutrack_main/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class SuperadminProfileDetails {
  int? userId;
  String? email;
  String? superadmin_name;
  String? password;
  String? superadmin_image;
  int? user_id;

  SuperadminProfileDetails({
    required this.userId,
    required this.email,
    required this.superadmin_name,
    required this.password,
    required this.superadmin_image,
    required this.user_id,
  });
}

class _MyProfileState extends State<MyProfile> {
  var api_url = dotenv.env['API_URL'];

  SuperadminProfileState? superadminProfileState;
  UserIdState? userIdState;
  MyappState? myAppState;

  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;

  @override
  void initState(){
    super.initState();
    userIdState = Provider.of<UserIdState>(context, listen: false);
    myAppState = Provider.of<MyappState>(context, listen: false);
    superadminProfileState = Provider.of<SuperadminProfileState>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: isMobile(context)
          ? Drawer(
        backgroundColor: primaryColor,
        child: SideNav(),
      )
          : null,
      appBar: isMobile(context) ? AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 65,
        centerTitle: true,
        leading: Row(
          children: [
            Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: Icon(Icons.menu),
                color: secondaryColor,
              ),
            ),
            SizedBox(width: 1), // Adjust the width as needed
          ],
        ),
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
        ),
      ) : null,
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
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (MediaQuery.of(context).size.width > 600)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'My Profile',
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
                    SizedBox(height: 30.0),
                    Consumer<SuperadminProfileState>(
                      builder: (context, superadminProfile, _) {
                        return Column(
                          children: [
                            Center(
                              child: Container(
                                width: 150.0,
                                height: 150.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryColor,
                                ),
                                child: Center(
                                  child: superadminProfile != null && superadminProfile.superadmin_image != null
                                      ? ClipOval(
                                    child: Image.network(
                                      superadminProfile.superadmin_image!,
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? progress) {
                                        return progress == null
                                            ? child
                                            : CircularProgressIndicator(
                                          value: progress.expectedTotalBytes != null
                                              ? progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1)
                                              : null,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        );
                                      },
                                    ),
                                  )
                                      : Icon(
                                    Icons.person_rounded,
                                    size: 150.0,
                                    color: secondaryColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
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
                            SizedBox(height: 40.0),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => EditProfile()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(10.0),
                                  fixedSize: Size(140, 50),
                                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  primary: primaryColor,
                                  onPrimary: secondaryColor,
                                  shadowColor: Colors.transparent,
                                  // side: BorderSide(color: primaryColor, width: 2),
                                  shape: StadiumBorder(),
                                ),
                                child: Text(
                                  'Edit Profile',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
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
  Future<void> sendTokenToBackend(String jwtToken) async {
    final userToken = myAppState!.user_Token;
    final url = '${api_url}/api/scanner/getJwtToken';
    print(url);

    final requestData = {
      'jwt_token': userToken,
    };

    final jsonData = jsonEncode(requestData);
    print(jsonData);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {

        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        final int userId = responseBody['user_id'];

        userIdState!.setUserId(userId.toString());


        print('User ID: $userId');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');

    }
  }
}
