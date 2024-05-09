// import 'package:flutter/material.dart';
// import 'package:docutrack_main/style.dart';
// import 'package:docutrack_main/custom_widget/staff_custom_nav_bar.dart';
// import 'package:docutrack_main/guest/staffid_scanner.dart';
// import 'package:docutrack_main/guest/staffselfie_cam.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:provider/provider.dart';
// import 'package:docutrack_main/main.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:docutrack_main/staff/staff_home.dart';
//
//
// class StaffVerification extends StatefulWidget {
//   const StaffVerification({super.key});
//
//
//   @override
//   State<StaffVerification> createState() => _StaffVerificationState();
// }
//
// class _StaffVerificationState extends State<StaffVerification> {
//   var api_url = dotenv.env['API_URL'];
//
//   bool isStep1Completed = false;
//   bool isStep2Completed = false;
//
//
//   String jwtToken = "";
//
//   StaffIDImageState? staffIDImageState;
//   MyappState? myAppState;
//   ScannedIdQRState? scannedIdQRState;
//   StaffSelfieImageState? staffSelfieImageState;
//
//   @override
//   void initState(){
//     super.initState();
//     scannedIdQRState = Provider.of<ScannedIdQRState>(context, listen: false);
//     myAppState = Provider.of<MyappState>(context, listen: false);
//     staffIDImageState = Provider.of<StaffIDImageState>(context, listen: false);
//     staffSelfieImageState = Provider.of<StaffSelfieImageState>(context, listen: false);
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Stack(
//         children: [
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             bottom: 0.5 * MediaQuery.of(context).size.height,
//             child: Container(
//               color: primaryColor,
//             ),
//           ),
//           Positioned(
//             top: 60.0,
//             left: 15.0,
//             child: Builder(
//               builder: (BuildContext context) => IconButton(
//                 onPressed: () {
//                   if (isStep1Completed || isStep2Completed) {
//                     Scaffold.of(context).openDrawer();
//                   } else {
//                     Navigator.pop(context);
//                   }
//                 },
//                 icon: isStep1Completed || isStep2Completed ? Icon(Icons.menu) : Icon(Icons.arrow_back),
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           Positioned(
//             top: 60.0,
//             right: 15.0,
//             child: isStep1Completed || isStep2Completed
//                 ? IconButton(
//               onPressed: () {
//                 // Add your logout functionality here
//                 // Navigator.of(context).push(
//                 //   MaterialPageRoute(builder: (context) => StaffIdScanner())
//                 // );
//               },
//               icon: Icon(Icons.logout),
//               color: Colors.white,
//             )
//                 : Container(),
//           ),
//           Positioned(
//             top: 70.0,
//             left: 50.0,
//             right: 50.0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(child: Container()),
//                 Expanded(
//                   flex: 2,
//                   child: Text(
//                     'Scan QR',
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.poppins(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 24.0,
//                     ),
//                   ),
//                 ),
//                 Expanded(child: Container()),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 140,
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: const BorderRadius.only(
//                   topRight: Radius.circular(50.0),
//                   topLeft: Radius.circular(50.0),
//                 ),
//               ),
//               child: Column(
//                 children: <Widget>[
//                   SizedBox(height: 40),
//                   Container(
//                     alignment: Alignment.center,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Image.asset(
//                           'assets/wmsu_logo.png',
//                           height: 55,
//                           width: 55,
//                         ),
//                         SizedBox(width: 10.0),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: <Widget>[
//                             Text(
//                               'DocuTrack',
//                               style: GoogleFonts.russoOne(
//                                 color: primaryColor,
//                                 fontWeight: FontWeight.w800,
//                                 fontSize: 30,
//                                 letterSpacing: 1,
//                               ),
//                             ),
//                             Text(
//                               'Document Tracking Management System',
//                               style: GoogleFonts.russoOne(
//                                 color: primaryColor,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 8,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 20.0),
//                     child: Column(
//                       children: <Widget>[
//                         SizedBox(height: 40.0),
//                         Container(
//                           width: 300,
//                           child: Column(
//                             children: <Widget>[
//                               Center(
//                                 child: Text(
//                                   'Verify your identity',
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.black,
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.w800,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 10.0),
//                               Center(
//                                 child: Text(
//                                   'Please submit the documents below to process your receipt of confirmation.',
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.black,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 50),
//                         GestureDetector(
//                           onTap: () {
//                             Future.delayed(Duration(milliseconds: 200), () {
//                               setState(() {
//                                 isStep1Completed = true;
//                               });
//                             });
//                             Navigator.of(context).push(
//                               MaterialPageRoute(builder: (context) => StaffIdScanner())
//                             );
//
//                           },
//                           child: Container(
//                             width: 310,
//                             height: 64,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(4),
//                               color: Colors.grey[200],
//                               boxShadow: isStep1Completed
//                                   ? [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.5),
//                                   spreadRadius: 2,
//                                   blurRadius: 2,
//                                   offset: Offset(0, 3),
//                                 ),
//                               ]
//                                   : null,
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 15),
//                                   child: Icon(
//                                     Icons.badge,
//                                     size: 35,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.only(left: 15, top: 18),
//                                         child: Text(
//                                           'Step 1',
//                                           style: GoogleFonts.poppins(
//                                             fontSize: 10,
//                                             color: Colors.grey[150],
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(left: 15),
//                                         child: Text(
//                                           'Scan your employee ID',
//                                           style: GoogleFonts.poppins(
//                                             fontSize: 16,
//                                             color: Colors.grey[150],
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 isStep1Completed
//                                     ? Padding(
//                                   padding: const EdgeInsets.only(right: 15),
//                                   child: Icon(
//                                     Icons.check_circle,
//                                     size: 20,
//                                     color: Colors.green,
//                                   ),
//                                 )
//                                     : Padding(
//                                   padding: const EdgeInsets.only(right: 15),
//                                   child: Icon(
//                                     Icons.upload,
//                                     size: 20,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(builder: (context) => StaffSelfieCam() )
//                             );
//                             Future.delayed(Duration(milliseconds: 200), () {
//                               setState(() {
//                                 isStep2Completed = true;
//                               });
//                             });
//                           },
//                           child: Container(
//                             width: 310,
//                             height: 64,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(4),
//                               color: Colors.grey[200],
//                               boxShadow: isStep2Completed
//                                   ? [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.5),
//                                   spreadRadius: 2,
//                                   blurRadius: 2,
//                                   offset: Offset(0, 3),
//                                 ),
//                               ]
//                                   : null,
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 15),
//                                   child: Icon(
//                                     Icons.person_rounded,
//                                     size: 35,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.only(left: 15, top: 18),
//                                         child: Text(
//                                           'Step 2',
//                                           style: GoogleFonts.poppins(
//                                             fontSize: 10,
//                                             color: Colors.grey[150],
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(left: 15),
//                                         child: Text(
//                                           'Take a selfie',
//                                           style: GoogleFonts.poppins(
//                                             fontSize: 16,
//                                             color: Colors.grey[150],
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 isStep2Completed
//                                     ? Padding(
//                                   padding: const EdgeInsets.only(right: 15),
//                                   child: Icon(
//                                     Icons.check_circle,
//                                     size: 20,
//                                     color: Colors.green,
//                                   ),
//                                 )
//                                     : Padding(
//                                   padding: const EdgeInsets.only(right: 15),
//                                   child: Icon(
//                                     Icons.upload,
//                                     size: 20,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           alignment: Alignment.bottomCenter,
//                           margin: EdgeInsets.only(top: 100.0, bottom: 10.0),
//                           child: ElevatedButton(
//                             child: Text('Submit'),
//                             onPressed: isStep1Completed && isStep2Completed
//                                 ? () {
//                               showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return AlertDialog(
//                                     contentPadding: EdgeInsets.zero,
//                                     content: Container(
//                                       width: 350,
//                                       height: 250,
//                                       decoration: ShapeDecoration(
//                                         color: Colors.white,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(5),
//                                         ),
//                                       ),
//                                       child: Column(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           Icon(
//                                             Icons.help,
//                                             size: 70,
//                                             color: primaryColor,
//                                           ),
//                                           SizedBox(height: 20.0),
//                                           Text(
//                                             'Are you sure you want to submit?',
//                                             style: GoogleFonts.poppins(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 14,
//                                             ),
//                                           ),
//                                           SizedBox(height: 30.0),
//                                           Row(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.spaceEvenly,
//                                             children: [
//                                               ElevatedButton(
//                                                 child: Text('Yes',
//                                                   style: GoogleFonts.poppins(
//                                                     fontWeight: FontWeight.bold
//                                                   ),
//                                                 ),
//                                                 onPressed: () {
//                                                   //add the functionality
//                                                   sendTokenToBackend(jwtToken);
//
//                                                   //navigator
//                                                   Navigator.pop(context);
//                                                   Future.delayed(Duration(milliseconds: 100), () {
//                                                     showDialog(
//                                                       context: context,
//                                                       builder: (BuildContext context) {
//                                                         return AlertDialog(
//                                                           contentPadding: EdgeInsets.zero,
//                                                           content: Container(
//                                                             width: 300,
//                                                             height: 220,
//                                                             decoration: ShapeDecoration(
//                                                               color: Colors.white,
//                                                               shape: RoundedRectangleBorder(
//                                                                 borderRadius: BorderRadius.circular(5),
//                                                               ),
//                                                             ),
//                                                             child: Column(
//                                                               mainAxisAlignment: MainAxisAlignment.center,
//                                                               children: [
//                                                                 Icon(
//                                                                   Icons.check_circle,
//                                                                   size: 70,
//                                                                   color: Colors.green,
//                                                                 ),
//                                                                 SizedBox(height: 20.0),
//                                                                 Text(
//                                                                   'Submission has been successfully saved!',
//                                                                   style: GoogleFonts.poppins(
//                                                                     fontWeight: FontWeight.bold,
//                                                                     fontSize: 14,
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(height: 30.0),
//                                                                 Row(
//                                                                   mainAxisAlignment:
//                                                                   MainAxisAlignment.spaceEvenly,
//                                                                   children: [
//                                                                     ElevatedButton(
//                                                                       child: Text('OK'),
//                                                                       onPressed: () {
//                                                                         Navigator.of(context).push(
//                                                                           MaterialPageRoute(builder: (context)=>StaffHome())
//                                                                         );
//                                                                       },
//                                                                       style: ElevatedButton.styleFrom(
//                                                                         padding: EdgeInsets.symmetric(
//                                                                             horizontal: 50, vertical: 13),
//                                                                         textStyle: GoogleFonts.poppins(
//                                                                           fontSize: 14,
//                                                                           fontWeight: FontWeight.bold,
//                                                                         ),
//                                                                         primary: Colors.white,
//                                                                         onPrimary: Colors.green,
//                                                                         elevation: 3,
//                                                                         shadowColor: Colors.transparent,
//                                                                         shape: StadiumBorder(side: BorderSide(color: Colors.green, width: 2)),
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         );
//                                                       },
//                                                     );
//                                                   });
//                                                 },
//                                                 style: ElevatedButton.styleFrom(
//                                                   padding: EdgeInsets.symmetric(
//                                                       horizontal: 40, vertical: 13),
//                                                   textStyle: GoogleFonts.poppins(
//                                                     fontSize: 14,
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                   primary: Colors.white,
//                                                   onPrimary: primaryColor,
//                                                   elevation: 3,
//                                                   shadowColor: Colors.transparent,
//                                                   shape: StadiumBorder(side: BorderSide(color: primaryColor, width: 2)),
//                                                 ),
//                                               ),
//                                               ElevatedButton(
//                                                 child: Text('Cancel'),
//                                                 onPressed: () {
//                                                   Navigator.pop(context);
//                                                 },
//                                                 style: ElevatedButton.styleFrom(
//                                                   padding: EdgeInsets.symmetric(
//                                                       horizontal: 35, vertical: 13),
//                                                   textStyle: GoogleFonts.poppins(
//                                                     fontSize: 14,
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                   primary: primaryColor,
//                                                   onPrimary: Colors.white,
//                                                   elevation: 3,
//                                                   shadowColor: Colors.transparent,
//                                                   shape: StadiumBorder(side: BorderSide(color: primaryColor, width: 2)),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             } : null,
//                             style: ElevatedButton.styleFrom(
//                               padding: EdgeInsets.all(10.0),
//                               fixedSize: Size(250, 50),
//                               textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
//                               primary: primaryColor,
//                               onPrimary: Colors.white,
//                               elevation: 3,
//                               shadowColor: Colors.transparent,
//                               side: BorderSide(color: Colors.white, width: 2),
//                               shape: StadiumBorder(),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(right: 0),
//                           child: Align(
//                             alignment: Alignment.bottomCenter,
//                             child: Text(
//                               'Why is it needed?',
//                               style: GoogleFonts.poppins(
//
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       drawer: SideNav(),
//     );
//   }
//   Future<void> sendTokenToBackend(String jwtToken) async {
//
//     final String? docuId = scannedIdQRState!.docuId;
//     print(docuId);
//
//     final userToken = myAppState!.user_Token;
//     print(userToken);
//
//     final employee_id_image = staffIDImageState!.capturedImageBase64;
//     print(employee_id_image);
//
//     final user_selfie_image = staffSelfieImageState!.capturedSelfieImagePathBase64Data;
//     print(user_selfie_image);
//
//     final url = '${api_url}/api/scanner/docu_recieve_record/document_detail=$docuId';
//     print(url);
//     final requestData = {
//       'jwt_token': userToken,
//       'docuId': docuId ?? '',
//       'employee_id_image': employee_id_image,
//       'user_selfie_image': user_selfie_image,
//     };
//     final jsonData = jsonEncode(requestData);
//
//     print(requestData);
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json', // Specify JSON content type
//       },
//       body: jsonData, // Encode the data as JSON
//     );
//
//     if (response.statusCode == 200) {
//       // Handle a successful response from the backend (if needed)
//       final responseBody = jsonDecode(response.body);
//       print('Response: $responseBody');
//     } else {
//       print('Error: ${response.statusCode}');
//     }
//   }
// }
