import 'package:docutrack_main/main.dart';
import 'package:docutrack_main/staff/staff_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:docutrack_main/style.dart';
import 'package:docutrack_main/custom_widget/guest_custom_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/guest/guest_document_details.dart';
import 'package:docutrack_main/guest/guest_verification.dart';

class GuestPageView extends StatefulWidget {
  const GuestPageView({super.key});

  @override
  State<GuestPageView> createState() => _GuestPageViewState();
}

class _GuestPageViewState extends State<GuestPageView> {
  var api_url = dotenv.env['API_URL'];

  final List<Widget> _pages = [
    GuestDocuDetails(),
    // ScanQRTracking(),
  ];
  String jwtToken = "";
  int _currentPageIndex = 0;
  MyappState? myAppState;
  DocumentDetailState? documentDetailState;
  ScannedIdQRState? scannedIdQRState;
  GuestDetailState? guestDetailState;

  @override
  void initState(){
    super.initState();
    documentDetailState = Provider.of<DocumentDetailState>(context, listen: false);
    scannedIdQRState = Provider.of<ScannedIdQRState>(context, listen: false);
    guestDetailState = Provider.of<GuestDetailState>(context, listen: false);
    myAppState = Provider.of<MyappState>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: false,
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
          'Scanned Document',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Swiper(
              loop: false,
              itemCount: _pages.length,
              itemBuilder: (BuildContext context, int index) {
                return _pages[index];
              },
              onIndexChanged: (int index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
            ),
          ),
          // Positioned(
          //   top: 60.0,
          //   left: 15.0,
          //   child: Builder(
          //     builder: (BuildContext context) => IconButton(
          //       onPressed: () {
          //         Scaffold.of(context).openDrawer();
          //       },
          //       icon: Icon(Icons.menu),
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
          // Positioned(
          //   top: 60.0,
          //   right: 15.0,
          //   child: IconButton(
          //     onPressed: () {
          //       // Add your logout functionality here
          //
          //     },
          //
          //     icon: Icon(Icons.logout),
          //     color: Colors.white,
          //   ),
          // ),
          // Positioned(
          //   top: 70.0,
          //   left: 50.0,
          //   right: 50.0,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Expanded(child: Container()),
          //       Expanded(
          //         flex: 2,
          //         child: Text(
          //           'Scan QR',
          //           textAlign: TextAlign.center,
          //           style: GoogleFonts.poppins(
          //             color: Colors.white,
          //             fontWeight: FontWeight.bold,
          //             fontSize: 24.0,
          //           ),
          //         ),
          //       ),
          //       Expanded(child: Container()),
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: List<Widget>.generate(
                //     _pages.length,
                //         (int index) {
                //       return Container(
                //         width: 10.0,
                //         height: 10.0,
                //         margin: EdgeInsets.symmetric(horizontal: 5.0),
                //         decoration: BoxDecoration(
                //           shape: BoxShape.circle,
                //           color: _currentPageIndex == index
                //               ? primaryColor
                //               : Colors.grey.withOpacity(0.5),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Receive',
                          style: GoogleFonts.poppins(
                            // fontWeight: FontWeight.bold
                          ),
                        ),
                        onPressed: () {
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
                                          Icons.help,
                                          size: 100,
                                          color: primaryColor,
                                        ),
                                        SizedBox(height: 20.0),
                                        Text(
                                          'Are you sure you want to receive?',
                                          style: GoogleFonts.poppins(

                                            fontSize: 14,
                                          ),
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
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(builder: (context)=>GuestVerification())
                                                  );
                                                  //PLACE HERE THE BACKEND FUNCTINALITY
                                                  //  sendTokenToBackend(jwtToken);
                                                  //navigator
                                                  // Navigator.pop(context);
                                                  // Future.delayed(Duration(milliseconds: 100), () {
                                                  //   showDialog(
                                                  //     context: context,
                                                  //     builder: (BuildContext context) {
                                                  //       return AlertDialog(
                                                  //         contentPadding: EdgeInsets.zero,
                                                  //         content: Container(
                                                  //           width: 350,
                                                  //           height: 250,
                                                  //           decoration: ShapeDecoration(
                                                  //             color: Colors.white,
                                                  //             shape: RoundedRectangleBorder(
                                                  //               borderRadius: BorderRadius.circular(5),
                                                  //             ),
                                                  //           ),
                                                  //           child: Column(
                                                  //             mainAxisAlignment: MainAxisAlignment.center,
                                                  //             children: [
                                                  //               Icon(
                                                  //                 Icons.check_circle,
                                                  //                 size: 100,
                                                  //                 color: Colors.green,
                                                  //               ),
                                                  //               SizedBox(height: 10.0),
                                                  //               Text(
                                                  //                 'Receipt confirmed!',
                                                  //                 style: GoogleFonts.poppins(
                                                  //                   // fontWeight: FontWeight.bold,
                                                  //                   fontSize: 14,
                                                  //                 ),
                                                  //               ),
                                                  //               SizedBox(height: 25.0),
                                                  //               Row(
                                                  //                 mainAxisAlignment:
                                                  //                 MainAxisAlignment.spaceEvenly,
                                                  //                 children: [
                                                  //                   ElevatedButton(
                                                  //                     child: Text('OK'),
                                                  //                     onPressed: () {
                                                  //                       Navigator.of(context).push(
                                                  //                           MaterialPageRoute(builder: (context)=>SigningPage())
                                                  //                       );
                                                  //                     },
                                                  //                     style: ElevatedButton.styleFrom(
                                                  //                       padding: EdgeInsets.symmetric(
                                                  //                           horizontal: 50, vertical: 13),
                                                  //                       textStyle: GoogleFonts.poppins(
                                                  //                         fontSize: 14,
                                                  //                         // fontWeight: FontWeight.bold,
                                                  //                       ),
                                                  //                       primary: Colors.white,
                                                  //                       onPrimary: Colors.green,
                                                  //                       elevation: 3,
                                                  //                       shadowColor: Colors.transparent,
                                                  //                       shape: StadiumBorder(side: BorderSide(color: Colors.green, width: 2)),
                                                  //                     ),
                                                  //                   ),
                                                  //                 ],
                                                  //               ),
                                                  //             ],
                                                  //           ),
                                                  //         ),
                                                  //       );
                                                  //     },
                                                  //   );
                                                  // });
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
                                                  shape: StadiumBorder(side: BorderSide(color: primaryColor, width: 2)),
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
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(10.0),
                          fixedSize: Size(140, 50),
                          textStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          primary: Colors.transparent,
                          onPrimary: primaryColor,
                          elevation: 3,
                          shadowColor: Colors.transparent,
                          side: BorderSide(color: primaryColor, width: 2),
                          shape: StadiumBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context)=> StaffHome())
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(10.0),
                          fixedSize: Size(140, 50),
                          textStyle: GoogleFonts.poppins(
                            fontSize: 16,),
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
        ],
      ),
    );
  }
  Future<void> sendTokenToBackend(String jwtToken) async {

    final String? docuId = documentDetailState!.docuId;
    print(docuId);

    final userToken = myAppState!.user_Token;
    print(userToken);


    final url = '${api_url}/api/scanner/docu_recieve_record/document_detail=$docuId';
    print(url);
    final requestData = {
      'jwt_token': userToken,
      'docuId': docuId ?? '',
    };
    final jsonData = jsonEncode(requestData);
    print(jsonData);

    print(requestData);
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {

      final responseBody = jsonDecode(response.body);
      print('Response: $responseBody');
    } else {
      print('Error: ${response.statusCode}');
    }
  }


}
