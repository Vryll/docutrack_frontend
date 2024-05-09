import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:docutrack_main/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:docutrack_main/admin/admin_home_page.dart';
import 'package:docutrack_main/custom_widget/custom_side_nav_bar.dart';
import 'package:docutrack_main/style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:docutrack_main/localhost.dart';


class RequestDocu extends StatefulWidget {
  const RequestDocu({super.key});

  @override
  State<RequestDocu> createState() => _RequestDocuState();
}

class _RequestDocuState extends State<RequestDocu> {
  var api_url = dotenv.env['API_URL'];
  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();
  PlatformFile? _selectedFile;
  Uint8List? _fileBytes;

  String? dateReleased;
  String? type;
  String? docu_request_topic;
  String? requested;
  String? docu_request_recipient;
  String? docu_request_deadline;
  String? docu_request_comment;

  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;

  UserOfficeNameState? userOfficeNameState;

  //Dropdown for docuTypes
  List<dynamic>? docuTypes;
  String? docu_type;

  //Dropdown for docuSender&Recipient
  List<dynamic>? officeNames;
  String? office_name;

  @override
  void initState(){
    super.initState();
    userOfficeNameState = Provider.of<UserOfficeNameState>(context, listen: false);
    fetchDocuType();
    fetchDocuSenderNRecipient();
  }

  //fetching data of document type from the database
  fetchDocuType() async {
    final response = await http.get(Uri.parse(
        '${api_url}/api/documents/getDocuTypes'),
      headers:{
        'Accept': 'application/json',
        "ngrok-skip-browser-warning": "$localhost_port",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        docuTypes = json.decode(response.body);
      });
    }
  }

  //fetching data of document sender and recipient from the database
  fetchDocuSenderNRecipient() async {
    final response = await http.get(Uri.parse(
        '${api_url}/api/documents/getDocumentSender'),
      headers:{
      'Accept': 'application/json',
      "ngrok-skip-browser-warning": "$localhost_port",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        officeNames = json.decode(response.body);
      });
    }
  }

  String getStoredOfficeName() {
    return userOfficeNameState?.getStoredOfficeName() ?? "";
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['docx'],
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _selectedFile = result.files.first;
          _fileBytes = result.files.single.bytes;
          print(_selectedFile);

        });
      }
    } catch (e) {
      print('error picking file: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile(context)
          ? AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          'Request for Approval',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: secondaryColor,
        ),
      ) : null,
      drawer: isMobile(context)
          ? Drawer(
        backgroundColor: primaryColor,
        child: SideNav(),
      ) : null,
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
                padding: isMobile(context) ? EdgeInsets.symmetric(horizontal: 20, vertical: 30)
                    : EdgeInsets.symmetric(horizontal: 60, vertical: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: FittedBox(
                              child: Text(
                                'Request for Approval',
                                style: GoogleFonts.poppins(
                                  fontSize: 45.0,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                                maxLines: 1,
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Document Information',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // const SizedBox(height: 30),
                            // Text.rich(
                            //   TextSpan(
                            //     text: 'Document Type ',
                            //     style: GoogleFonts.poppins(
                            //       fontSize: 15,
                            //       color: Colors.black,
                            //     ),
                            //     children: [
                            //       TextSpan(
                            //         text: '*',
                            //         style: TextStyle(
                            //           color: Colors.red,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // const SizedBox(height: 10),
                            // buildInputDocumentType(),
                            const SizedBox(height: 20),
                            Text.rich(
                              TextSpan(
                                text: 'Subject ',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            buildInputTopic(),
                            const SizedBox(height: 20),
                            Text.rich(
                              TextSpan(
                                text: 'Requested by ',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            buildInputRequestedBy(),
                            const SizedBox(height: 20),
                            Text.rich(
                              TextSpan(
                                text: 'Recipient',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            buildInputRecipient(),
                            const SizedBox(height: 20),
                            Text.rich(
                              TextSpan(
                                text: 'Date Requested',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            buildDate(),
                            const SizedBox(height: 20),
                            if (_selectedFile != null)
                              SizedBox(height: 30),
                            if (_selectedFile != null)
                              Row(
                                children: [
                                  Icon(
                                    Icons.attach_file,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10.0),
                                  Expanded(
                                    child: Text(
                                      _selectedFile?.name ?? '',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: _pickFile,
                              child: Text(
                                'Choose a file',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(10.0),
                                minimumSize: Size(120, 25),
                                primary: secondaryColor,
                                onPrimary: primaryColor,
                                shadowColor: secondaryColor,
                                side: BorderSide(color: primaryColor!, width: 2),
                                shape: StadiumBorder(),
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(0),
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: buildSend(context),
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
  // Widget buildInputDocumentType() {
  //   return DropdownButtonFormField<String>(
  //     key: Key('type'),
  //     decoration: InputDecoration(
  //       labelText: 'Choose a document type',
  //       labelStyle: GoogleFonts.poppins(
  //         fontSize: 15,
  //         color: Colors.grey,
  //       ),
  //       contentPadding: EdgeInsets.symmetric(horizontal: 10),
  //       border: OutlineInputBorder(),
  //     ),
  //     items: docuTypes?.map<DropdownMenuItem<String>>((item) {
  //       return DropdownMenuItem<String>(
  //         child: Text(
  //           item['docu_type'],
  //           style: GoogleFonts.poppins(
  //               fontSize: 14
  //           ),
  //         ),
  //         value: item['docu_type'],
  //       );
  //     }).toList(),
  //     onChanged: (String? newValue) {
  //       setState(() {
  //         type = newValue;
  //       });
  //     },
  //     validator: (String? value) {
  //       if (value == null || value.isEmpty) {
  //         return 'Please choose a document type.';
  //       }
  //       return null;
  //     },
  //     onSaved: (value) {
  //       type = value;
  //       print(type);
  //     },
  //   );
  // }

  Widget buildInputTopic() {
    return TextFormField(
      key: Key('docu_request_topic'),
      decoration: InputDecoration(
        labelText: 'Enter a subject',
        labelStyle: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.grey,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a subject.';
        }
        return null;
      },
      onSaved: (value) {
        docu_request_topic = value;
        print(docu_request_topic);
      },
    );
  }

  Widget buildInputRequestedBy() {
    return TextFormField(
      key: Key('requested'),
      decoration: InputDecoration(
        // labelText: getStoredOfficeName(),
        // labelStyle: GoogleFonts.poppins(
        //   fontSize: 15,
        //   color: Colors.grey,
        // ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(),
      ),
      enabled: false,
      initialValue: getStoredOfficeName(),
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.grey,
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text.';
        }
        return null;
      },
      onSaved: (value) {

        print(value);
      },
    );
  }

  Widget buildInputRecipient() {
    return DropdownButtonFormField<String>(
      key: Key('docu_request_recipient'),
      decoration: InputDecoration(
        labelText: 'Choose recipient\'s office name',
        labelStyle: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.grey,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(),
      ),
      items: officeNames?.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          child: Text(item['office_name'],
            style: GoogleFonts.poppins(
                fontSize: 14
            ),
          ),
          value: item['office_name'],
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          docu_request_recipient = newValue;
        });
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please select a recipient\'s office name.';
        }
        return null;
      },
      onSaved: (value) {
        docu_request_recipient = value;
        print(docu_request_recipient);
      },
    );
  }

  Widget buildDate() => TextFormField(
    key: Key('date_released'),
    onTap: () {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              datePickerTheme: DatePickerTheme.of(context).copyWith(
                shape: Border(),
              ),
              colorScheme: ColorScheme.light(
                primary: primaryColor,
              ),
            ),
            child: child!,
          );
        },
      ).then((selectedDate) {
        if (selectedDate != null) {
          // Handle the selected date
          String formattedDate = DateFormat('MM-dd-yyyy').format(selectedDate);
          setState(() {
            dateReleased = formattedDate;
          });
        }
      });
    },
    controller: TextEditingController(text: dateReleased),
    decoration: InputDecoration(
      labelText: 'Enter a date requested',
      labelStyle: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.grey,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10.00),
      suffixIcon: Icon(
        Icons.calendar_today,
        color: Colors.black,
        size: 20,
      ),
      border: OutlineInputBorder(),
    ),
    validator: (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please choose a date.';
      } DateTime selectedDate = DateFormat('MM-dd-yyyy').parse(value);
      DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
      if (selectedDate.isBefore(yesterday)) {
        return 'Invalid Date.';
      } return null;
    },
    onSaved: (value) {
      docu_request_deadline = value;
      print(docu_request_deadline);
    },
  );

  // Widget buildComment() {
  //   return TextFormField(
  //     key: Key('docu_request_comment'),
  //     minLines: 2,
  //     maxLines: 10,
  //     keyboardType: TextInputType.multiline,
  //     decoration: InputDecoration(
  //       border: InputBorder.none,
  //       filled: true,
  //       fillColor: Colors.grey[200],
  //       contentPadding: EdgeInsets.only(top: 10.0, bottom: 200.0, left: 10.0, right: 10.0),
  //     ),
  //     enabled: true,
  //     initialValue: '',
  //     style: GoogleFonts.poppins(
  //       color: Colors.black,
  //       fontSize: 14,
  //     ),
  //     onSaved: (value) {
  //       docu_request_comment = value;
  //       print(docu_request_comment);
  //     },
  //   );
  // }

  Widget buildSend(context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() == true) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                content: Container(
                  width: 350,
                  height: 270,
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
                          'Are you sure you want to send request?',
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
                                onPressed: () async {
                                  _submitForm();
                                  Navigator.pop(context);
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
                                                Icons.check_circle,
                                                size: 100,
                                                color: Colors.green,
                                              ),
                                              SizedBox(height: 10.0),
                                              Text(
                                                'Request has been successfully sent!',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 25.0),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  ElevatedButton(
                                                    child: Text('OK'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => AdminHome()),
                                                      );
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 50, vertical: 13),
                                                      textStyle: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                      ),
                                                      primary: Colors.white,
                                                      onPrimary: Colors.green,
                                                      elevation: 3,
                                                      shadowColor: Colors.transparent,
                                                      shape: StadiumBorder(
                                                        side: BorderSide(
                                                            color: Colors.green, width: 2),
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
                                  shape: StadiumBorder(side: BorderSide(
                                      color: primaryColor, width: 2)),
                                ),
                              ),
                            ),
                            SizedBox(width: 15,),
                            Expanded(
                              child: ElevatedButton(
                                child: FittedBox(child: Text('Cancel',
                                  maxLines: 1,
                                )),
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
        }

      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(10.0),
        fixedSize: Size(isMobile(context) ? MediaQuery.of(context).size.width : 250, 50),
        primary: primaryColor,
        onPrimary: Colors.white,
        shadowColor: Colors.transparent,
        side: BorderSide(color: primaryColor, width: 2),
        shape: StadiumBorder(),
      ),
      child: Text(
        'Send Request',
        style: GoogleFonts.poppins(
          fontSize: 16,
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid && _selectedFile != null) {
      _formKey.currentState!.save();
    }
    try {
      List<int> nonNullableFileBytes = _fileBytes ?? Uint8List(0);
      String base64File = base64Encode(nonNullableFileBytes);
      print(base64File);
      final url = Uri.parse('${api_url}/api/documents/create_request_document');
      final request = http.MultipartRequest('POST', url)
        ..fields['docu_request_topic'] = docu_request_topic!
        ..fields['requested'] = getStoredOfficeName()
        ..fields['docu_request_recipient'] = docu_request_recipient!
        ..fields['docu_request_deadline'] = docu_request_deadline!
        ..fields['docu_request_file'] = base64File!
        ..fields['docu_request_file_name'] = _selectedFile!.name;

      final response = await request.send();
      print(response);
      if (response.statusCode == 200) {

        print('Request has been successfully sent!');
      }
    } catch (e) {
      print('error: $e');
    }
  }
}
