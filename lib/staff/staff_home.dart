import 'package:docutrack_main/style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/custom_widget/staff_custom_nav_bar.dart';
import 'package:docutrack_main/staff/qrcode_scanner.dart';
import 'package:docutrack_main/staff/worksSpace_Page.dart';
import 'package:docutrack_main/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StaffHome extends StatefulWidget {
  const StaffHome({super.key});

  @override
  State<StaffHome> createState() => _StaffHomeState();
}



class _StaffHomeState extends State<StaffHome> {
  var api_url = dotenv.env['API_URL'];

  String jwtToken = "";

  MyappState? myAppState;
  UserIdState? userIdState;
  // WorkspaceDocuDetailState? workspaceDocuDetailState;
  // DocumentCountForWorkspace? documentCountForWorkspace;


  @override
  void initState(){
    super.initState();
    myAppState = Provider.of<MyappState>(context, listen: false);
    userIdState = Provider.of<UserIdState>(context, listen: false);
    // workspaceDocuDetailState = Provider.of<WorkspaceDocuDetailState>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu),
            color: secondaryColor,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: primaryColor,
            ),
          ),

          Center(
            child: Container(
              margin: EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    'assets/DocuTrack(White).png',
                    height: 90,
                    width: 90,
                  ),
                  Text(
                    'DocuTrack',
                    style: GoogleFonts.russoOne(
                      color: secondaryColor,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  Text(
                    'Document Tracking and Management System',
                    style: GoogleFonts.poppins(
                      color: secondaryColor,
                      fontSize: 9.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 250,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(50.0),
                  topLeft: Radius.circular(50.0),
                ),
              ),
              child: Padding (
                padding: EdgeInsets.only(top: 50.0),
                child: SingleChildScrollView (
                  child: Column (
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 30.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'What to do?',
                              style: GoogleFonts.poppins(
                                color: primaryColor,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => ScanQRCode())
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    fixedSize: Size(140, 110),
                                    backgroundColor: primaryColor,
                                  ),
                                  child: Text(
                                      'Scan QR',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      )
                                  ),
                                ),
                                SizedBox(width: 30.0),
                                ElevatedButton(
                                  onPressed: () async{
                                    await sendTokenToBackend(jwtToken);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context)=>Workspace())
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    fixedSize: Size(140, 110),
                                    backgroundColor: primaryColor,
                                  ),
                                  child: Text(
                                      'Workspace',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      )
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),


                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: SideNav(),
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


