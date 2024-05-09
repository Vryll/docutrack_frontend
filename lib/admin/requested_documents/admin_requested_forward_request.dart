import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:docutrack_main/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:docutrack_main/admin/admin_home_page.dart';
import 'package:docutrack_main/custom_widget/custom_side_nav_bar.dart';
import 'package:docutrack_main/style.dart';
import 'package:file_picker/file_picker.dart';
import 'package:docutrack_main/localhost.dart';

class ForwardRequest extends StatefulWidget {
  const ForwardRequest({super.key});

  @override
  State<ForwardRequest> createState() => _ForwardRequestState();
}

class _ForwardRequestState extends State<ForwardRequest> {
  var api_url = dotenv.env['API_URL'];
  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();
  PlatformFile? _selectedFile;
  Uint8List? _fileBytes;
  String? forwarded_subject;
  String? forwarded_requested;
  String? forwarded_docu_request_recipient;
  String? forwarded_date_requested;
  String? forwarded_requested_docu_file;

  bool isSendRequest = false;
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;

  UserOfficeNameState? userOfficeNameState;
  SelectedIncomingRequestedDocuDetails? selectedIncomingRequestedDocuDetails;
  DefaultIncomingRequestDocuState? defaultIncomingRequestDocuState;

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
    selectedIncomingRequestedDocuDetails = Provider.of<SelectedIncomingRequestedDocuDetails>(context, listen: false);
    defaultIncomingRequestDocuState = Provider.of<DefaultIncomingRequestDocuState>(context, listen: false);
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
        allowedExtensions: ['pdf'],
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
          'Forward Request',
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (MediaQuery.of(context).size.width > 600)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: FittedBox(
                                  child: Text(
                                    'Forward Request',
                                    style: GoogleFonts.poppins(
                                      fontSize: 45,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 50),
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
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 1.0,
                            offset: Offset(0, 1),
                          ),
                        ],
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
                            const SizedBox(height: 30),
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
                                text: 'Recipient/s',
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
                                text: 'Date Requested ',
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
                            const SizedBox(height: 30),
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
                            SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: _pickFile,
                              child: FittedBox(
                                child: Text(
                                  'Add another file',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(10.0),
                                minimumSize: Size(110, 25),
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
                      child: Container(
                        constraints: BoxConstraints(maxWidth: isWeb(context) ? 250 : MediaQuery.of(context).size.width),
                        child: Row(
                          children: [
                            Expanded(child: buildSendRequest(context)),
                          ],
                        ),
                      ),
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

  Widget buildInputTopic() {
    return TextFormField(
      key: Key('forwarded_subject'),
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
        forwarded_subject = value;
        print(forwarded_subject);
      },
    );
  }

  Widget buildInputRequestedBy() {
    return TextFormField(
      key: Key('forwarded_requested'),
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

        forwarded_requested = value;
        print(value);
      },
    );
  }

  Widget buildInputRecipient() {
    return DropdownButtonFormField<String>(
      key: Key('forwarded_docu_request_recipient'),
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
          forwarded_docu_request_recipient = newValue;
        });
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please select a recipient\'s office name.';
        }
        return null;
      },
      onSaved: (value) {
        forwarded_docu_request_recipient = value;
        print(forwarded_docu_request_recipient);
      },
    );
  }

  Widget buildDate() => TextFormField(
    key: Key('forwarded_date_requested'),
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
            forwarded_date_requested = formattedDate;
          });
        }
      });
    },
    controller: TextEditingController(text: forwarded_date_requested),
    decoration: InputDecoration(
      labelText: 'Choose a date',
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
      forwarded_date_requested = value;
      print(forwarded_date_requested);
    },
  );

  Widget buildSendRequest(context) {
    return ElevatedButton(
      onPressed: () {
        if (!_formKey.currentState!.validate()) {

        } else {
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
                          'Are you sure you want to forward request?',
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
                                  ),
                                ),
                                onPressed: () async {
                                  sendForwardUpdateStatus();
                                  _submitForm();
                                  await createForwardRecords();
                                  await UpdateForwardedRequestDocument();

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
                                              borderRadius: BorderRadius
                                                  .circular(5),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              children: [
                                                Icon(
                                                  Icons.check_circle,
                                                  size: 100,
                                                  color: Colors.green,
                                                ),
                                                SizedBox(height: 10.0),
                                                Text(
                                                  'Request has been successfully forwarded!',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 25.0),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: [
                                                    ElevatedButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (
                                                                context) =>
                                                                AdminHome(),
                                                          ),
                                                        );
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                            horizontal: 50,
                                                            vertical: 13),
                                                        textStyle: GoogleFonts
                                                            .poppins(
                                                          fontSize: 14,
                                                        ),
                                                        primary: Colors.white,
                                                        onPrimary: Colors.green,
                                                        elevation: 3,
                                                        shadowColor: Colors
                                                            .transparent,
                                                        shape: StadiumBorder(
                                                          side: BorderSide(
                                                              color: Colors
                                                                  .green,
                                                              width: 2),
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
                                      horizontal: 28, vertical: 13),
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
                                child: FittedBox(
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.poppins(
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 13),
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
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        minimumSize: Size(250, 50),
        primary: primaryColor,
        onPrimary: Colors.white,
        shadowColor: Colors.transparent,
        shape: StadiumBorder(),
      ),
      child: FittedBox(
        child: Text(
          'Send Request',
          style: GoogleFonts.poppins(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid && _selectedFile != null) {
      _formKey.currentState!.save();
    }


    final reqDocuID = selectedIncomingRequestedDocuDetails!.req_docu_id;
    print(reqDocuID);

    try{
      List<int> nonNullableFileBytes = _fileBytes ?? Uint8List(0);
      String base64File = base64Encode(nonNullableFileBytes);

      final url = Uri.parse('${api_url}/api/documents/create_forwarded_request_document/$reqDocuID');
      final request = http.MultipartRequest('POST', url)
        ..fields['requested_document'] = reqDocuID!
        ..fields['forwarded_subject'] = forwarded_subject!
        ..fields['forwarded_requested'] = forwarded_requested!
        ..fields['forwarded_docu_request_recipient'] = forwarded_docu_request_recipient!
        ..fields['forwarded_date_requested'] = forwarded_date_requested!
        ..fields['forwarded_requested_docu_file'] = base64File!
        ..fields['forwarded_requested_docu_file_name'] = _selectedFile!.name;

      final response = await request.send();
      print(response);

      if(response.statusCode == 200){
        print('Forwareded request has been successfully sent!');
      }else{
        final respBody = await response.stream.bytesToString();
        print('Error: ${response.statusCode}, Details: $respBody');
      }
    }catch(e){
      print('Error: $e');
    }
  }

  Future<void>sendForwardUpdateStatus()async{
    final reqDocuID = defaultIncomingRequestDocuState!.docu_request_id;
    print(reqDocuID);

    final status_value = "Forwarded";
    try{
      final response = await http.post(Uri.parse('${api_url}/api/documents/update_forward_status_reqDocu/$reqDocuID'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'status_value': status_value,
        }),
      );

      if(response.statusCode == 201){
        print('status received was successfully sent to backend');
      }
    }catch(e){
      print('Error: $e');
    }
  }

  Future<void>createForwardRecords()async{
    final reqDocuId = defaultIncomingRequestDocuState!.docu_request_id;
    print(reqDocuId);

    try{
      final response = await http.post(Uri.parse('${api_url}/api/documents/create_forwarded_requested_document_records/$reqDocuId'));

      if(response.statusCode == 200){
        print('Forwarded Request Document Records was successfuly created');
      }
    }catch(e){
      print('Error: $e');
    }
  }

  Future<void>UpdateForwardedRequestDocument()async{
    final reqDocuID = defaultIncomingRequestDocuState!.docu_request_id;
    print(reqDocuID);

    final status_value = "Forwarded";

    try{
      final response = await http.post(Uri.parse('${api_url}/api/documents/update_forwarded_request_document/$reqDocuID'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'status_value': status_value,
        }),
      );

      if(response.statusCode == 201){
        print('status received was successfully sent to backend');
      }
    }catch(e){
      print('Error: $e');
    }
  }

}
