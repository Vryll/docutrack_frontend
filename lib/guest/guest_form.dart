import 'package:docutrack_main/main.dart';
import 'package:flutter/material.dart';
import 'package:docutrack_main/style.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:docutrack_main/guest/guest_qrCode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:docutrack_main/localhost.dart';


class GuestForm extends StatefulWidget {
  const GuestForm({super.key});

  @override
  State<GuestForm> createState() => _GuestFormState();
}

class _GuestFormState extends State<GuestForm> {
  var api_url = dotenv.env['API_URL'];
  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();

  String? email;
  String? role = "guest";
  String? first_name;
  String? middle_name;
  String? last_name;
  // String? employee_id_number;

  GuestDetailState? guestDetailState;



  List<dynamic>? officeList;
  String? guest_admin_office;

  fetchOfficeList() async{
    final response = await http.get(Uri.parse(
        '${api_url}/api/accounts/getOfficeList/all'),
      headers:{'Accept': 'application/json',
        "ngrok-skip-browser-warning": "$localhost_port",

      },
    );
    if(response.statusCode == 200){
      setState(() {
        officeList = json.decode(response.body);
      });
    }
  }

  @override
  void initState(){
    super.initState();
    fetchOfficeList();
    guestDetailState = Provider.of<GuestDetailState>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack (
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
          Positioned(
            top: 70,
            left: 20,
            right: 20,
            child: Column (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/DocuTrack(White).png',
                      height: 45,
                      width: 45,
                    ),
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'DocuTrack',
                          style: GoogleFonts.russoOne(
                            color: secondaryColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                        Text(
                          'Document Tracking and Management System',
                          style: GoogleFonts.poppins(
                            color: secondaryColor,
                            fontSize: 5.6,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ],
                ),
                FittedBox(
                  child: Text(
                    'Guest Form',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned (
            top: 220,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Container (
                margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                child: SingleChildScrollView (
                  child: Form (
                    key: _formKey,
                    child: Column (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //     'Guest Details',
                        //   style: GoogleFonts.poppins(
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 24,
                        //   ),
                        // ),
                        // SizedBox(height: 20),
                        //Forms
                        Row(
                          children: [
                            Text(
                              'WMSU Email',
                              style: GoogleFonts.poppins(
                              ),

                            ),
                            Text(
                              '*',
                              style: GoogleFonts.poppins(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        BuildEmailAddress(),
                        // SizedBox(height: 10),
                        // Row(
                        //   children: [
                        //     Text(
                        //       'Employee ID #',
                        //       style: GoogleFonts.poppins(
                        //           fontWeight: FontWeight.bold
                        //       ),
                        //
                        //     ),
                        //     Text(
                        //       '*',
                        //       style: GoogleFonts.poppins(
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.red,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // BuildEmployeeIDNumber(),
                        SizedBox(height: 20),

                        Row(
                          children: [
                            Text(
                              'First Name',
                              style: GoogleFonts.poppins(

                              ),

                            ),
                            Text(
                              '*',
                              style: GoogleFonts.poppins(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        BuildFirstName(),
                        SizedBox(height: 20),

                        Row(
                          children: [
                            Text(
                              'Middle Name',
                              style: GoogleFonts.poppins(

                              ),

                            ),
                            //
                          ],
                        ),
                        SizedBox(height: 10.0),
                        BuildMiddleName(),
                        SizedBox(height: 20),

                        Row(
                          children: [
                            Text(
                              'Last Name',
                              style: GoogleFonts.poppins(

                              ),

                            ),
                            Text(
                              '*',
                              style: GoogleFonts.poppins(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        BuildLastName(),
                        SizedBox(height: 20),

                        Row(
                          children: [
                            Text(
                              'Office',
                              style: GoogleFonts.poppins(

                              ),

                            ),
                            Text(
                              '*',
                              style: GoogleFonts.poppins(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        buildSelectOffice(),
                        SizedBox(height: 40),
                        Center(
                            child: BuildConfirmBtn()
                        ),
                        SizedBox(height: 50),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  //BUILD WIDGETS
  Widget BuildEmailAddress() =>TextFormField(
    key: Key('email'),
    decoration: InputDecoration(
      labelText: 'Enter your WMSU email',
      labelStyle: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.grey,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: primaryColor
        ),
      ),
    ),
    validator: (value){
      if(value!.isEmpty){
        return "Please enter your WMSU email.";
      }
    },
    //input save function
    onSaved: (value){
      email = value;
    },
  );
  Widget BuildFirstName() =>TextFormField(
    key: Key('first_name'),
    decoration: InputDecoration(
      labelText: 'Enter your first name',
      labelStyle: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.grey,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: primaryColor
        ),
      ),
    ),
    validator: (value){
      if(value!.isEmpty){
        return "Please enter your first name.";
      }
    },
    //input save function
    onSaved: (value){
      first_name = value;
    },
  );

  Widget BuildMiddleName() =>TextFormField(
    key: Key('middle_name'),
    decoration: InputDecoration(
      labelText: 'Enter your middle name',
      labelStyle: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.grey,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: primaryColor
        ),
      ),
    ),
    // validator: (value){
    //   if(value!.isEmpty){
    //     return "Please enter your middle name";
    //   }
    // },
    //input save function
    onSaved: (value){
      middle_name = value;
    },
  );

  Widget BuildLastName() =>TextFormField(
    key: Key('last_name'),
    decoration: InputDecoration(
      labelText: 'Enter your last name',
      labelStyle: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.grey,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: primaryColor
        ),
      ),
    ),
    validator: (value){
      if(value!.isEmpty){
        return "Please enter your last name.";
      }
    },

    onSaved: (value){
      last_name = value;
    },
  );

  // Widget BuildEmployeeIDNumber() =>TextFormField(
  //   key: Key('employee_id_number'),
  //   decoration: InputDecoration(
  //     labelText: 'Enter your Employee Id ',
  //     labelStyle: GoogleFonts.poppins(
  //       fontSize: 15,
  //       color: Colors.grey,
  //     ),
  //     contentPadding: EdgeInsets.symmetric(horizontal: 10),
  //     border: OutlineInputBorder(),
  //   ),
  //   validator: (value){
  //     if(value!.isEmpty){
  //       return "Please enter a first name.";
  //     }
  //   },
  //   //input save function
  //   onSaved: (value){
  //     employee_id_number = value;
  //   },
  // );

  Widget buildSelectOffice() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Choose an office',
        labelStyle: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.grey,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: primaryColor
          ),
        ),
      ),
      items: officeList?.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          child: Text(
            item['office_list'],
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          value: item['office_list'],
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          guest_admin_office = newValue;
        });
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please choose an office.';
        }
        return null;
      },
      onSaved: (value) {
        guest_admin_office = value;
      },
    );
  }

  Widget BuildConfirmBtn() => ElevatedButton(
    onPressed: () {
      _submitForm();
    },
    child: Text(
        'Next',
        style: GoogleFonts.poppins(
            color: secondaryColor,
            fontSize: 15
        )
    ),
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.all(5.0),
      fixedSize: Size(MediaQuery.of(context).size.width, 55),
      primary: primaryColor,
      shape: StadiumBorder(),
    ),
  );

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          // title: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Icon(
          //       Icons.help,
          //       size: 100,
          //       color: primaryColor,
          //     ),
          //     SizedBox(height: 20.0),
          //     Text(
          //       'Are you sure you want to confirm?',
          //       style: GoogleFonts.poppins(
          //
          //         fontSize: 14,
          //       ),
          //     ),
          //     SizedBox(height: 25.0),
          //     Row(
          //       mainAxisAlignment:
          //       MainAxisAlignment.spaceEvenly,
          //       children: [
          //         ElevatedButton(
          //           child: Text('Yes',
          //             style: GoogleFonts.poppins(
          //
          //             ),
          //           ),
          //           onPressed: () {
          //             //add the functionality
          //
          //             //navigator
          //             Navigator.pop(context);
          //             Future.delayed(Duration(milliseconds: 100), () {
          //               showDialog(
          //                 context: context,
          //                 builder: (BuildContext context) {
          //                   return AlertDialog(
          //                     contentPadding: EdgeInsets.zero,
          //                     content: Container(
          //                       width: 350,
          //                       height: 250,
          //                       decoration: ShapeDecoration(
          //                         color: Colors.white,
          //                         shape: RoundedRectangleBorder(
          //                           borderRadius: BorderRadius.circular(5),
          //                         ),
          //                       ),
          //                       child: Column(
          //                         mainAxisAlignment: MainAxisAlignment.center,
          //                         children: [
          //                           Icon(
          //                             Icons.check_circle,
          //                             size: 100,
          //                             color: Colors.green,
          //                           ),
          //                           SizedBox(height: 10.0),
          //                           Text(
          //                             'Submission has been successfully saved!',
          //                             style: GoogleFonts.poppins(
          //                               // fontWeight: FontWeight.bold,
          //                               fontSize: 14,
          //                             ),
          //                           ),
          //                           SizedBox(height: 25.0),
          //                           Row(
          //                             mainAxisAlignment:
          //                             MainAxisAlignment.spaceEvenly,
          //                             children: [
          //                               ElevatedButton(
          //                                 child: Text('OK'),
          //                                 onPressed: () {
          //                                   Navigator.of(context).push(
          //                                       MaterialPageRoute(builder: (context)=>GuestVerification())
          //                                   );
          //                                 },
          //                                 style: ElevatedButton.styleFrom(
          //                                   padding: EdgeInsets.symmetric(
          //                                       horizontal: 50, vertical: 13),
          //                                   textStyle: GoogleFonts.poppins(
          //                                     fontSize: 14,
          //                                     // fontWeight: FontWeight.bold,
          //                                   ),
          //                                   primary: Colors.white,
          //                                   onPrimary: Colors.green,
          //                                   elevation: 3,
          //                                   shadowColor: Colors.transparent,
          //                                   shape: StadiumBorder(side: BorderSide(color: Colors.green, width: 2)),
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   );
          //                 },
          //               );
          //             });
          //           },
          //           style: ElevatedButton.styleFrom(
          //             padding: EdgeInsets.symmetric(
          //                 horizontal: 40, vertical: 13),
          //             textStyle: GoogleFonts.poppins(
          //               fontSize: 14,
          //               fontWeight: FontWeight.bold,
          //             ),
          //             primary: Colors.white,
          //             onPrimary: primaryColor,
          //             elevation: 3,
          //             shadowColor: Colors.transparent,
          //             shape: StadiumBorder(side: BorderSide(color: primaryColor, width: 2)),
          //           ),
          //         ),
          //         ElevatedButton(
          //           child: Text('Cancel'),
          //           onPressed: () {
          //             Navigator.pop(context);
          //           },
          //           style: ElevatedButton.styleFrom(
          //             padding: EdgeInsets.symmetric(
          //                 horizontal: 35, vertical: 13),
          //             textStyle: GoogleFonts.poppins(
          //               fontSize: 14,
          //               // fontWeight: FontWeight.bold,
          //             ),
          //             primary: primaryColor,
          //             onPrimary: Colors.white,
          //             elevation: 3,
          //             shadowColor: Colors.transparent,
          //             shape: StadiumBorder(side: BorderSide(color: primaryColor, width: 2)),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
        );
      },
    );
  }

  //For Backend Functionality
  Future<void> _submitForm() async{
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
    }

    try{
      final url = Uri.parse('${api_url}/api/accounts/create_guest_details');
      final request = http.MultipartRequest('POST', url)
        ..fields['email'] = email!
        ..fields['role'] = role!
      // ..fields['employee_id_number'] = employee_id_number!
        ..fields['first_name'] = first_name!
        ..fields['middle_name'] = middle_name!
        ..fields['last_name'] = last_name!
        ..fields['guest_admin_office'] = guest_admin_office!;

      print(email);
      print(role);
      // print(employee_id_number);
      print(first_name);
      print(middle_name);
      print(last_name);
      print(guest_admin_office);

      final response = await request.send();
      if(response.statusCode == 200){
        final responseString = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseString);
        String successMessage = jsonResponse['success'];
        Map<String, dynamic> guestDetails = jsonResponse['guest_details'];

        String email = guestDetails['email'];
        String role = guestDetails['role'];
        // String employee_id_number = guestDetails['employee_id_number'];
        String first_name = guestDetails['first_name'];
        String middle_name = guestDetails['middle_name'];
        String last_name = guestDetails['last_name'];
        String guest_admin_office = guestDetails['guest_admin_office'];

        guestDetailState!.setGuestDetailState(email, role, first_name, middle_name, last_name, guest_admin_office);

        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => GuestScanQRCode())
        );


        print('guest details successfully saved!');
      }else{
        print('failed to save the guest details');
      }
    }catch(e){
      print('error: $e');
    }
  }
}
