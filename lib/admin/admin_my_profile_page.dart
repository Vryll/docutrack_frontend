import 'package:docutrack_main/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/style.dart';
import 'package:docutrack_main/custom_widget/custom_side_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:docutrack_main/admin/admin_edit_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:docutrack_main/localhost.dart';


class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}
class AdminProfDetails{
  String? email;
  String? password;
  String? admin_logo;
  String? admin_overview;
  String? admin_id;
  String? office_name;
  int? user_id;

  AdminProfDetails({
    required this.email,
    required this.password,
    required this.admin_logo,
    required this.admin_overview,
    required this.admin_id,
    required this.office_name,
    required this.user_id,
  });
}

class AdminProfileDetails {
  String? email;
  String? password;
  String? admin_logo;
  String? admin_overview;
  String? admin_id;
  String? office_name;
  int? user_id;

  AdminProfileDetails({
    required this.email,
    required this.password,
    required this.admin_logo,
    required this.admin_overview,
    required this.admin_id,
    required this.office_name,
    required this.user_id,
  });

  factory AdminProfileDetails.fromJson(Map<String, dynamic> json) {
    return AdminProfileDetails(
      email: json['user']['email'],
      password: json['user']['password'],
      admin_logo: json['admin_data']['admin_logo'],
      admin_overview: json['admin_data']['admin_overview'],
      admin_id: json['admin_data']['admin_id'],
      office_name: json['admin_data']['office_name'],
      user_id: json['admin_data']['user_id'],
    );
  }
}

class _MyProfileState extends State<MyProfile> {
  var api_url = dotenv.env['API_URL'];
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;


  AdminProfileState? adminProfileState;
  MyappState? myAppState;
  UserIdState? userIdState;

  late Timer _timer;
  bool dataFetched = false;


  @override
  void initState() {
    super.initState();
    myAppState = Provider.of<MyappState>(context, listen: false);
    userIdState = Provider.of<UserIdState>(context, listen: false);
    // fetchAdminDetails();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print('Timer is triggered!');

      if (!dataFetched) {
        fetchAdminDetails();
        // fetchClerkDetails();


        dataFetched = true;
      } else {

        _timer.cancel();
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
    dataFetched = false;
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    adminProfileState = Provider.of<AdminProfileState>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile(context) ? AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 65,
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            fontSize: 24,
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
                padding: EdgeInsets.symmetric(horizontal: isWeb(context) ? 40 : 20, vertical: isWeb(context) ? 40 : 30),
                child: Column (
                  children: [
                    if (MediaQuery.of(context).size.width > 600)
                      Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'My Profile',
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
                    if (MediaQuery.of(context).size.width > 600)
                      const SizedBox(height: 30),
                    Consumer<AdminProfileState>(
                      builder: (context, adminProfile, _) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 150.0,
                              height: 150.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                              ),
                              child: Center(
                                child: adminProfile.admin_logo != null
                                    ? ClipOval(
                                  child: Image.network(
                                    adminProfile.admin_logo!,
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
                                      decoration: TextDecoration.underline,
                                      decorationColor: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () async{
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfile(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(10.0),
                                  fixedSize: Size(130, 45),
                                  primary: primaryColor,
                                  onPrimary: secondaryColor,
                                  shadowColor: Colors.transparent,
                                  shape: StadiumBorder(),
                                ),
                                child: Text(
                                  'Edit Profile',
                                  style: GoogleFonts.poppins(
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 50.0),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(20),
                              constraints: const BoxConstraints(maxHeight: 250),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  adminProfile.admin_overview?.isNotEmpty == true
                                      ? adminProfile.admin_overview!
                                      : "No overview",
                                  style: GoogleFonts.poppins(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            )
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
  Future<AdminProfileDetails> fetchAdminDetails() async {
    try {
      final userId = userIdState!.userId;
      print(userId);

      final response = await http.get(Uri.parse('$api_url/api/accounts/getAdminDetails/$userId'),
        headers:{'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",
        },
      );
      print(response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData);

        final email = responseData['user']['email'] ?? '';
        final password = responseData['user']['password'] ?? '';
        final admin_logo = responseData['admin_data']['admin_logo'] ?? '';
        final admin_overview = responseData['admin_data']['admin_overview'] ?? '';
        final admin_id = responseData['admin_data']['admin_id'] ?? '';
        final office_name = responseData['admin_data']['office_name'] ?? '';
        final user_id = responseData['admin_data']['user_id'] ?? '';

        final adminProfileDetails = AdminProfileDetails(
          email: email,
          password: password,
          admin_logo: admin_logo,
          admin_overview: admin_overview,
          admin_id: admin_id,
          office_name: office_name,
          user_id: user_id,
        );

        print(adminProfileDetails);


        adminProfileState!.setAdminProfileDetails(
          email,
          password,
          admin_logo,
          admin_overview,
          admin_id,
          office_name,
          user_id,
        );

        return adminProfileDetails;
      } else {
        throw Exception('Failed to fetch admin details');
      }
    } catch (error) {

      print('Error fetching admin details: $error');
      throw error;
    }
  }
}

