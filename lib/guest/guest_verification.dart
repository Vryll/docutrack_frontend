import 'package:flutter/material.dart';
import 'package:docutrack_main/style.dart';
import 'package:docutrack_main/guest/staffid_scanner.dart';
import 'package:docutrack_main/guest/staffselfie_cam.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:docutrack_main/custom_widget/guest_custom_nav_bar.dart';
import 'package:docutrack_main/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

class GuestVerification extends StatefulWidget {
  const GuestVerification({super.key});

  @override
  State<GuestVerification> createState() => _GuestVerificationState();
}

class _GuestVerificationState extends State<GuestVerification> {
  var api_url = dotenv.env['API_URL'];

  bool isStep1Completed = false;
  bool isStep2Completed = false;

  void updateStep1Completion(bool value){
    setState(() {
      isStep1Completed = value;
    });
  }

  void updateStep2Completion(bool value){
    setState(() {
      isStep2Completed = value;
    });
  }


  StaffIDImageState? staffIDImageState;
  StaffSelfieImageState? staffSelfieImageState;
  DocumentDetailState? documentDetailState;
  GuestDetailState? guestDetailState;

  @override
  void initState(){
    super.initState();
    guestDetailState = Provider.of<GuestDetailState>(context, listen: false);
    documentDetailState = Provider.of<DocumentDetailState>(context, listen: false);
    staffIDImageState = Provider.of<StaffIDImageState>(context, listen: false);
    staffSelfieImageState = Provider.of<StaffSelfieImageState>(context, listen: false);
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
          'Verification',
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
          // Positioned(
          //   top: 60.0,
          //   left: 15.0,
          //   child: Builder(
          //     builder: (BuildContext context) => IconButton(
          //       onPressed: () {
          //         if (isStep1Completed || isStep2Completed) {
          //           Scaffold.of(context).openDrawer();
          //         } else {
          //           Navigator.pop(context);
          //         }
          //       },
          //       icon: isStep1Completed || isStep2Completed ? Icon(Icons.menu) : Icon(Icons.arrow_back),
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
          // Positioned(
          //   top: 60.0,
          //   right: 15.0,
          //   child: isStep1Completed || isStep2Completed
          //       ? IconButton(
          //     onPressed: () {
          //       // Add your logout functionality here
          //       Navigator.of(context).push(
          //         MaterialPageRoute(builder: (context) => SigningPage())
          //       );
          //     },
          //     icon: Icon(Icons.logout),
          //     color: Colors.white,
          //   )
          //       : Container(),
          // ),
          Positioned(
            top: 30,
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
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 25, right: 25,top: 85.0),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Verify your identity',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Center(
                            child: Text(
                              'Please submit the documents below to process your receipt of confirmation.',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          // SizedBox(height: 40.0),
                          // Column(
                          //   children: <Widget>[
                          //     Center(
                          //       child: Text(
                          //         'Verify your identity',
                          //         style: GoogleFonts.poppins(
                          //           color: Colors.black,
                          //           fontSize: 24,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //     ),
                          //     SizedBox(height: 10.0),
                          //     Center(
                          //       child: Text(
                          //         'Please submit the documents below to process your receipt of confirmation.',
                          //         style: GoogleFonts.poppins(
                          //           color: Colors.black,
                          //           fontSize: 14,
                          //         ),
                          //         textAlign: TextAlign.center,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(height: 50),
                          GestureDetector(
                            onTap: () {
                              Future.delayed(Duration(milliseconds: 200), () {
                                setState(() {

                                });
                              });
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => StaffIdScanner(onComplete: updateStep1Completion))
                              );

                            },
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.grey[200],
                                boxShadow: isStep1Completed
                                    ? [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: Offset(0, 3),
                                  ),
                                ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Icon(
                                      Icons.badge,
                                      size: 45,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15, top: 18),
                                          child: Text(
                                            'Step 1',
                                            style: GoogleFonts.poppins(
                                              fontSize: 9.5,
                                              color: Colors.grey[150],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15),
                                          child: Text(
                                            'Scan your employee ID',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.grey[150],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  isStep1Completed
                                      ? Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Icon(
                                      Icons.check_circle,
                                      size: 25,
                                      color: Colors.green,
                                    ),
                                  )
                                      : Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Icon(
                                      Icons.upload,
                                      size: 25,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => StaffSelfieCam(onComplete: updateStep2Completion))
                              );
                              Future.delayed(Duration(milliseconds: 200), () {
                                setState(() {

                                });
                              });
                            },
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.grey[200],
                                boxShadow: isStep2Completed
                                    ? [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: Offset(0, 3),
                                  ),
                                ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Icon(
                                      Icons.person_rounded,
                                      size: 45,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15, top: 18),
                                          child: Text(
                                            'Step 2',
                                            style: GoogleFonts.poppins(
                                              fontSize: 9.5,
                                              color: Colors.grey[150],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15),
                                          child: Text(
                                            'Take a selfie',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.grey[150],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  isStep2Completed
                                      ? Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Icon(
                                      Icons.check_circle,
                                      size: 25,
                                      color: Colors.green,
                                    ),
                                  )
                                      : Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Icon(
                                      Icons.upload,
                                      size: 25,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 80),
                          Container(
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.only(top: 90.0, bottom: 10.0),
                            child: ElevatedButton(
                              child: Text('Submit'),
                              onPressed: isStep1Completed && isStep2Completed
                                  ? () {
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
                                                'Are you sure you want to submit?',
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
                                                        sendTokenToBackend();

                                                        //navigator
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
                                                                      borderRadius: BorderRadius.circular(5),
                                                                    ),
                                                                  ),
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
                                                                        'Receipt confirmed!',
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
                                                                              Navigator.of(context).push(
                                                                                  MaterialPageRoute(builder: (context)=>SigningPage())
                                                                              );
                                                                            },
                                                                            style: ElevatedButton.styleFrom(
                                                                              padding: EdgeInsets.symmetric(
                                                                                  horizontal: 50, vertical: 13),
                                                                              textStyle: GoogleFonts.poppins(
                                                                                fontSize: 14,
                                                                                // fontWeight: FontWeight.bold,
                                                                              ),
                                                                              primary: Colors.white,
                                                                              onPrimary: Colors.green,
                                                                              elevation: 3,
                                                                              shadowColor: Colors.transparent,
                                                                              shape: StadiumBorder(side: BorderSide(color: Colors.green, width: 2)),
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
                              } : null,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(10.0),
                                fixedSize: Size(MediaQuery.of(context).size.width, 55),
                                textStyle: GoogleFonts.poppins(fontSize: 16),
                                primary: primaryColor,
                                onPrimary: Colors.white,
                                elevation: 3,
                                shadowColor: Colors.transparent,
                                // side: BorderSide(color: Colors.white, width: 2),
                                shape: StadiumBorder(),
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(right: 0),
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: TextButton(
                                    onPressed: () {
                                      _showWhyNeededDialog(context);
                                    },
                                    child: Text(
                                      'Why ist it needed?',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  )
                              )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // drawer: SideNav(),
    );
  }
  Future<void> sendTokenToBackend() async {

    final String? docuId = documentDetailState!.docuId;
    print(docuId);

    final String? email = guestDetailState!.email;
    print(email);

    final employee_id_image = staffIDImageState!.capturedImageBase64;
    print(employee_id_image);

    final user_selfie_image = staffSelfieImageState!.capturedSelfieImagePathBase64Data;
    print(user_selfie_image);

    final url = '${api_url}/api/scanner/guest_docu_recieve_record/document_detail=$docuId';
    print(url);
    final requestData = {
      'email': email ?? '',
      'docuId': docuId ?? '',
      'employee_id_image': employee_id_image,
      'user_selfie_image': user_selfie_image,
    };
    final jsonData = jsonEncode(requestData);

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

  void _showWhyNeededDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Why is it needed?',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 22
            ),
            textAlign: TextAlign.center,

          ),
          content: Text(
            "As part of our commitment to accountability and secure document management, we kindly request your cooperation in scanning your employee ID and taking a selfie. This procedure establishes a clear association between your identity and system transactions, facilitating accountability in the event of discrepancies or issues. Your adherence to this process is greatly appreciated as we strive to maintain the highest standards of security within our system. Thank you for your understanding and collaboration.",
            style: GoogleFonts.poppins(
                fontSize: 13
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: GoogleFonts.poppins(
                  color: primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
