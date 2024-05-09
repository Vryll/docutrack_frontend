import 'package:docutrack_main/staff/staff_archived.dart';
import 'package:docutrack_main/style.dart';
import 'package:flutter/material.dart';
import 'package:docutrack_main/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/staff/staff_home.dart';
import 'dart:async';
import 'package:docutrack_main/staff/staff_profile.dart';
import 'package:docutrack_main/staff/staffAboutUs.dart';
import 'package:docutrack_main/staff/scanned_history.dart';
import 'package:intl/intl.dart';

class SideNav extends StatefulWidget {
  const SideNav({Key? key}) : super(key: key);

  @override
  _SideNavState createState() => _SideNavState();
}

class ClerkDetails{
  int? userId;
  String? email;
  String? first_name;
  String? last_name;
  String? user_image_profile;

  ClerkDetails({
    required this.userId,
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.user_image_profile,
  });
}

class ClerkScannedDocumentDetails {
  final int? docuId;
  final String? docu_title;
  final String? memorandum_number;
  final String? docu_type;
  final String? time_scanned;

  ClerkScannedDocumentDetails({

    required this.docuId,
    required this.docu_title,
    required this.memorandum_number,
    required this.docu_type,
    required this.time_scanned,
  });

  factory ClerkScannedDocumentDetails.fromJson(Map<String, dynamic> json) {
    return ClerkScannedDocumentDetails(
      docuId: json['docuId'] ?? 0,
      docu_title: json['docu_title'] ?? '',
      memorandum_number: json['memorandum_number'] ?? '',
      docu_type: json['docu_type'] ?? '',
      time_scanned: json['time_scanned'] ?? '',
    );
  }



  static List<ClerkScannedDocumentDetails> fromJsonList(List<dynamic> list) {
    return list.map((json) => ClerkScannedDocumentDetails.fromJson(json)).toList();
  }

  @override
  String toString() {
    return 'ClerkScannedDocumentDetails(docuId: $docuId, docu_title: $docu_title, memorandum_number: $memorandum_number, docu_type: $docu_type, time_scanned: $time_scanned)';
  }
}

class _SideNavState extends State<SideNav> {
  var api_url = dotenv.env['API_URL'];
  String jwtToken = "";
  String selectedItem = '';

  late Timer _timer;
  bool dataFetched = false;



  MyappState? myAppState;
  UserIdState? userIdState;
  ClerkDetailState? clerkDetailState;
  ClerkScannedHistoryState? clerkScannedHistoryState;

  @override
  void initState(){
    super.initState();
    myAppState = Provider.of<MyappState>(context, listen: false);
    userIdState = Provider.of<UserIdState>(context, listen: false);
    clerkScannedHistoryState = Provider.of<ClerkScannedHistoryState>(context, listen: false);

    timeredSendTokenToBackend(jwtToken);
    // fetchClerkDetails();

    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      print('Timer is triggered!');

      if (!dataFetched) {
        timeredSendTokenToBackend(jwtToken);
        // fetchClerkDetails();


        dataFetched = true;
      } else {

        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {

    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    clerkDetailState = Provider.of<ClerkDetailState>(context, listen: true);
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
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  sendTokenToBackend(jwtToken);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=> StaffProfile())
                  );
                },
                child: DrawerHeader(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 9),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (clerkDetailState!.user_image_profile != null)

                                ClipOval(
                                  child: Image.network(
                                    clerkDetailState!.user_image_profile.toString(),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              if (clerkDetailState!.user_image_profile == null)

                                Icon(
                                  Icons.person,
                                  color: primaryColor,
                                  size: 40,
                                ),
                              if (clerkDetailState!.user_image_profile == null)

                                CircularProgressIndicator(),
                            ],
                          ),
                        ),



                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, top: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${clerkDetailState!.first_name} ${clerkDetailState!.last_name}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${clerkDetailState!.email}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
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
              ),
              Expanded(
                child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Builder(
                        builder: (BuildContext context) {
                          return MyListTile(
                            icon: Icons.house,
                            title: 'Home',
                            onTap: () {
                              sendTokenToBackend(jwtToken);
                              setState(() {
                                selectedItem = 'Home';
                                Navigator.pop(context);
                              });
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => StaffHome()));
                            },
                            isSelected: selectedItem == 'Home',
                          );
                        },
                      ),
                      Builder(
                        builder: (BuildContext context) {
                          return MyListTile(
                            icon: Icons.history,
                            title: 'Scanned History',
                            onTap: () async {
                              setState(() {
                                selectedItem = 'Scanned History';
                              });
                              await sendTokenToBackend(jwtToken);
                              await fetchUserScannedRecord();
                              Navigator.pop(context);
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context)=> ClerkScannedHistory())
                              );
                            },
                            isSelected: selectedItem == 'Scanned History',
                          );
                        },
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
                    ]
                ),
              ),
              MyListTile(
                icon: Icons.archive,
                title: 'Archived',
                onTap: () {
                  sendTokenToBackend(jwtToken);
                  setState(() {

                  });
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StaffArchived()));
                },
                isSelected: selectedItem == 'Archived',
              ),
              MyListTile(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () {
                  setState(() {

                  });
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SigningPage()));
                },
                isSelected: selectedItem == 'Logout',
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

  Future<void> timeredSendTokenToBackend(String jwtToken) async {
    final userToken = myAppState!.user_Token;
    final url = '${api_url}/api/accounts/getJwtTokenNClerkDetails';
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

        int userId = responseBody["user"]["userId"];
        String email = responseBody["user"]["email"];
        String first_name = responseBody["user"]["first_name"];
        String last_name = responseBody["user"]["last_name"];
        String user_image_profile = responseBody["clerk_data"]["user_image_profile"];
        String admin_logo = responseBody["clerk_data"]["admin_logo"];
        String office_name = responseBody["clerk_data"]["office_name"];
        String staff_positon = responseBody["clerk_data"]["staff_positon"];

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
    } catch (error) {
      print('Error in timeredSendTokenToBackend: $error');

    }
  }

  Future<void> fetchUserScannedRecord() async {
    final userId = userIdState!.userId;
    print(userId);

    try {
      final response = await http.get(Uri.parse('${api_url}/api/scanner/getClerk_scanned_history/userId=$userId'));

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        final  userScannedRecordCount = responseData['count'];
        final userScannedRecordDetail = responseData['data'];

        if (userScannedRecordDetail is List) {
          List<ClerkScannedDocumentDetails> clerkScannedDocumentDetailList =
          userScannedRecordDetail.map((docu) => ClerkScannedDocumentDetails.fromJson(docu)).toList();

          clerkScannedHistoryState!.setClerkScannedHistory(clerkScannedDocumentDetailList);
          clerkScannedHistoryState!.setClerkScannedHistoryCount(userScannedRecordCount);
        } else {
          print('Invalid response data format');
        }
      } else {
        print('HTTP request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('error: $e');
    }
  }



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