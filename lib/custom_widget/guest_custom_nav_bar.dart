// import 'package:docutrack_main/staff/staff_archived.dart';
import 'package:docutrack_main/style.dart';
import 'package:flutter/material.dart';
import 'package:docutrack_main/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
// import 'package:docutrack_main/staff/staff_profile.dart';
import 'package:docutrack_main/guest/guest_AboutUs.dart';
// import 'package:marquee_text/marquee_text.dart';

class SideNav extends StatefulWidget {
  const SideNav({Key? key}) : super(key: key);

  @override
  _SideNavState createState() => _SideNavState();
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

class _SideNavState extends State<SideNav> {
  var api_url = dotenv.env['API_URL'];
  String jwtToken = "";
  String selectedItem = '';

  late Timer _timer;



  MyappState? myAppState;
  UserIdState? userIdState;
  ClerkDetailState? clerkDetailState;

  @override
  void initState(){
    super.initState();
    myAppState = Provider.of<MyappState>(context, listen: false);
    userIdState = Provider.of<UserIdState>(context, listen: false);
    clerkDetailState = Provider.of<ClerkDetailState>(context, listen: false);

    // timeredSendTokenToBackend(jwtToken);
    // fetchClerkDetails();

    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      print('Timer is triggered!');
      //  timeredSendTokenToBackend(jwtToken);
      // fetchClerkDetails();
    });
  }

  @override
  void dispose() {

    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Drawer(
        child: Container(
          color: primaryColor,
          child: Column(
            children: [
              DrawerHeader(
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, top: 35.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Guest Mode',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 5.0),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.chevron_left_rounded,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Builder(
                builder: (BuildContext context) {
                  return MyListTile(
                    icon: Icons.lightbulb,
                    title: 'About Us',
                    onTap: () {
                      setState(() {
                        selectedItem = 'About Us';
                      });
                      Navigator.pop(context);


                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => AboutUs())
                      );
                    },
                    isSelected: selectedItem == 'About Us',
                  );

                },
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
  //functionalities
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
//     if (response.statusCode == 200) {
//       // Handle a successful response from the backend
//       final Map<String, dynamic> responseBody = jsonDecode(response.body);
//
//       String email = responseBody["user"]["email"];
//       String first_name = responseBody["user"]["first_name"];
//       String last_name = responseBody["user"]["last_name"];
//       String user_image_profile = responseBody["clerk_data"]["user_image_profile"];
//       String admin_logo = responseBody["clerk_data"]["admin_logo"];
//       String office_name = responseBody["clerk_data"]["office_name"];
//       String staff_positon = responseBody["clerk_data"]["staff_positon"];
//
//       clerkDetailState!.setClerkDetail(email, first_name, last_name, user_image_profile, admin_logo, office_name,staff_positon );
//
//
//       // Use the userId as needed in your Dart code
//       print('Email: $email');
//       print('First Name: $first_name');
//       print('Last Name: $last_name');
//       print('user_image_profile: $user_image_profile');
//       print('admin_logo:$admin_logo');
//       print(office_name);
//       print('staff_positon: $staff_positon');
//     } else {
//       print('Error: ${response.statusCode}');
//     }
//   } catch (error) {
//     print('Error in timeredSendTokenToBackend: $error');
//     // Handle the error as needed
//   }
// }

// Future<void> fetchClerkDetails() async {
//   final userId = userIdState!.userId;
//   print(userId);
//
//   try {
//     final response = await http.get(Uri.parse(
//       '${api_url}/api/accounts/countWorkspaceDocu/clerk_user=$userId',
//     ));
//
//     if (response.statusCode == 200) {
//       Map<String, dynamic> data = json.decode(response.body);
//       String email = data["user"]["email"];
//       String first_name = data["user"]["first_name"];
//       String last_name = data["user"]["last_name"];
//       String user_image_profile = data["clerk_data"]["user_image_profile"];
//
//       clerkDetailState!.setClerkDetail(email, first_name, last_name, user_image_profile);
//
//       print(email);
//       print(first_name);
//       print(last_name);
//       print(user_image_profile);
//     }
//   } catch (e) {
//     print('Error: $e');
//   }
// }


}
class MyListTile extends StatelessWidget{
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  MyListTile({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: isSelected ? secondaryColor : null,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: ListTile(
            leading: Icon(
              icon,
              color: isSelected ? primaryColor : secondaryColor,
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: isSelected ? primaryColor : secondaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
