import 'package:docutrack_main/main.dart';
import 'package:docutrack_main/staff/staff_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:docutrack_main/style.dart';
import 'package:docutrack_main/staff/document_details.dart';
import 'package:docutrack_main/custom_widget/staff_custom_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';



class StaffPageView extends StatefulWidget {
  const StaffPageView({super.key});

  @override
  State<StaffPageView> createState() => _StaffPageViewState();
}

class _StaffPageViewState extends State<StaffPageView> {
  var api_url = dotenv.env['API_URL'];

  final List<Widget> _pages = [
    DocuDetails(),
    // ScanQRTracking(),
  ];

  String jwtToken = "";
  String statusValue = "";
  int _currentPageIndex = 0;
  ScannedIdQRState? scannedIdQRState;
  MyappState? myAppState;
  DocumentDetailState? documentDetailState;


  @override
  void initState(){
    super.initState();
    scannedIdQRState = Provider.of<ScannedIdQRState>(context, listen: false);
    myAppState = Provider.of<MyappState>(context, listen: false);
    documentDetailState = Provider.of<DocumentDetailState>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: false,
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
          'Scan QR',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
        ),
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
          Container(
            margin: EdgeInsets.only(bottom: 30.0),
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
                SizedBox(height: 30.0),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          child: Text('Receive',
                            style: GoogleFonts.poppins(
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
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 25.0),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  child: FittedBox(
                                                    child: Text('Yes',
                                                      style: GoogleFonts.poppins(

                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    //PLACE HERE THE BACKEND FUNCTINALITY
                                                    sendTokenToBackend(jwtToken, statusValue);

                                                    Navigator.pop(context);
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
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 20.0),                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Icon(
                                                                      Icons.check_circle,
                                                                      size: 100,
                                                                      color: Colors.green,
                                                                    ),
                                                                    SizedBox(height: 10.0),
                                                                    Text(
                                                                      'Submission has been successfully saved!',
                                                                      style: GoogleFonts.poppins(
                                                                        // fontWeight: FontWeight.bold,
                                                                        fontSize: 14,
                                                                      ),
                                                                      textAlign: TextAlign.center,
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
                                                                                MaterialPageRoute(builder: (context)=>StaffHome())
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
                                                  child: FittedBox(child: Text('Cancel',
                                                    maxLines: 1,
                                                  ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 33, vertical: 13),
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
                            // side: BorderSide(color: primaryColor, width: 2),
                            shape: StadiumBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: SideNav(),
    );
  }
  // Future<void> sendTokenToBackend(String jwtToken) async {
  //
  //   final String? docuId = documentDetailState!.docuId;
  //   print(docuId);
  //
  //   final userToken = myAppState!.user_Token;
  //   print(userToken);
  //
  //
  //   final url = '${api_url}/api/scanner/docu_recieve_record/document_detail=$docuId';
  //   print(url);
  //   final requestData = {
  //     'jwt_token': userToken,
  //     'docuId': docuId ?? '',
  //   };
  //   final jsonData = jsonEncode(requestData);
  //   print(jsonData);
  //
  //   print(requestData);
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: {
  //       'Content-Type': 'application/json', // Specify JSON content type
  //     },
  //     body: jsonData, // Encode the data as JSON
  //   );
  //
  //   if (response.statusCode == 200) {
  //     // Handle a successful response from the backend (if needed)
  //     final responseBody = jsonDecode(response.body);
  //     print('Response: $responseBody');
  //   } else {
  //     print('Error: ${response.statusCode}');
  //   }
  // }

  Future<void> sendTokenToBackend(String jwtToken, String statusValue) async {
    final String? docuId = documentDetailState!.docuId;
    print(docuId);

    final userToken = myAppState!.user_Token;
    print(userToken);

    final statusValue = "Received";

    final url = '${api_url}/api/scanner/docu_recieve_record/document_detail=$docuId';
    print(url);
    final requestData = {
      'jwt_token': userToken,
      'docuId': docuId ?? '',
      'status_value': statusValue,
    };
    final jsonData = jsonEncode(requestData);
    print(jsonData);

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      print('successfully received!');
      print('Response: $responseBody');
    } else {
      print('Error: ${response.statusCode}');
    }
  }







// }
// Future<void>saverecord()async{
//   if (docuId != null && docuId.isNotEmpty){
//     final apiUrl =
//         'https://your-api-url-here.com/docu_recieve_record/document_detail=$docuId';
//
//     try {
//       final response = await http.post(Uri.parse(apiUrl));
//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         final message = responseData['message'];
//         print('Response message: $message');
//         // Handle the response as needed
//       } else {
//         print('Failed to create Recieve_Record. Status code: ${response.statusCode}');
//         // Handle the error
//       }
//     } catch (error) {
//       print('Error: $error');
//       // Handle the error
//     }
//   }
// }
}
