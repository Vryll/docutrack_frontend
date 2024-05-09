import 'package:docutrack_main/style.dart';
import 'package:flutter/material.dart';
import 'package:docutrack_main/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/custom_widget/staff_custom_nav_bar.dart';
import 'dart:async';
import 'package:docutrack_main/staff/staff_edit_profile.dart';

class StaffProfile extends StatefulWidget {
  const StaffProfile({Key? key}) : super(key: key);

  @override
  State<StaffProfile> createState() => _StaffProfileState();
}

class ClerkDetails{
  String? email;
  String? first_name;
  String? last_name;
  String? user_image_profile;

  ClerkDetails({
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.user_image_profile,
  });
}

class _StaffProfileState extends State<StaffProfile> {
  var api_url = dotenv.env['API_URL'];

  String jwtToken = "";

  late Timer _timer;
  bool dataFetched = false;

  MyappState? myAppState;
  ClerkDetailState? clerkDetailState;
  UserIdState? userIdState;

  @override
  void initState(){
    super.initState();
    fetchClerkDetailsByTimer();
    myAppState = Provider.of<MyappState>(context, listen: false);
    userIdState = Provider.of<UserIdState>(context, listen: false);
    // fetchClerkDetails();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print('Timer is triggered!');

      if (!dataFetched) {
        fetchClerkDetailsByTimer();
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
    clerkDetailState!.ClerkDetailsCleanup();
    dataFetched = false;
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    clerkDetailState = Provider.of<ClerkDetailState>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      drawer: SideNav(),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 65,
        leading: Row(
          children: [
            Builder(
              builder: (context) => IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu),
                color: secondaryColor,
              ),
            ),
          ],
        ),
        centerTitle: true,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
        ),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          //   icon: const Icon(Icons.arrow_back),
          //   color: secondaryColor,
          // ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: secondaryColor,
        child: Column (
          children: [
            Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(50.0),
                  bottomLeft: Radius.circular(50.0),
                ),
              ),
              padding: EdgeInsets.only(bottom: 30.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(clerkDetailState!.user_image_profile.toString()),
                                radius: 50.0,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Center(
                              child: Text(
                                  '${clerkDetailState!.first_name} ${clerkDetailState!.last_name}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  )
                              ),
                            ),
                            Center(
                              child: Text(
                                clerkDetailState!.email.toString(),
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Center(
                              child: Align(
                                alignment: Alignment(0, -0.5),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context)=> StaffEditProfile())
                                    );                                      },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(10.0),
                                    fixedSize: Size(140, 50),
                                    primary: Colors.white,
                                    onPrimary: primaryColor,
                                    elevation: 3,
                                    shadowColor: Colors.transparent,
                                    // side: BorderSide(color: Colors.white, width: 2),
                                    shape: StadiumBorder(),
                                  ),
                                  child: Text(
                                    'Edit Profile',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              color: secondaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30.0),
                    child: Text(
                      'Office and Position',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          child: ClipOval(
                            child: Image.network(
                              clerkDetailState!.admin_logo.toString(),
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {

                                  return child;
                                } else {

                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                          : null,
                                    ),
                                  );
                                }
                              },
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                          )
                      ),
                      SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            clerkDetailState!.office_name.toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          Text(
                            clerkDetailState!.staff_positon.toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void>fetchClerkDetailsByTimer() async{
    final userId = userIdState!.userId;
    try{
      final response = await http.get(Uri.parse
        ('${api_url}/api/accounts/getClerk_details/$userId')
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        int userId = responseBody["user"]["userId"] ?? 0;
        String email = responseBody["user"]["email"] ?? '';
        String first_name = responseBody["user"]["first_name"] ?? '';
        String last_name = responseBody["user"]["last_name"] ?? '';
        String user_image_profile = responseBody["clerk_data"]["user_image_profile"] ?? '';
        String admin_logo = responseBody["clerk_data"]["admin_logo"] ?? '';
        String office_name = responseBody["clerk_data"]["office_name"] ?? '';
        String staff_positon = responseBody["clerk_data"]["staff_positon"] ?? '';

        clerkDetailState!.setClerkDetail(userId, email, first_name, last_name, user_image_profile,admin_logo,office_name,staff_positon );

        print('Email: $email');
        print('First Name: $first_name');
        print('Last Name: $last_name');
        print('user_image_profile: $user_image_profile');
        print('admin_logo:$admin_logo');
        print(office_name);
        print('staff_positon: $staff_positon');
      } else {
        print('Error: ${response.statusCode}');
      }

    }catch(e){
      print('error: $e');
    }




  }
  // Future<void> timeredSendTokenToBackend(String jwtToken) async {
  //   final userToken = myAppState!.user_Token;
  //   final url = '${api_url}/api/accounts/getJwtTokenNClerkDetails';
  //   print(url);
  //
  //   final requestData = {
  //     'jwt_token': userToken,
  //   };
  //
  //   final jsonData = jsonEncode(requestData);
  //   print(jsonData);
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json', // Specify JSON content type
  //       },
  //       body: jsonData, // Encode the data as JSON
  //     );
  //
  //
  //   } catch (error) {
  //     print('Error in timeredSendTokenToBackend: $error');
  //     // Handle the error as needed
  //   }
  // }
}
