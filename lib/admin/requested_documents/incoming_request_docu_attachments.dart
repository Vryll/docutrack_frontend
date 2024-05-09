import 'package:flutter/material.dart';
import 'package:docutrack_main/custom_widget/custom_side_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:docutrack_main/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/style.dart';
import 'package:docutrack_main/admin/requested_documents/admin_requested_forward_request.dart';
import 'package:docutrack_main/admin/requested_documents/incoming_request_document_tracking.dart';
import 'package:docutrack_main/admin/requested_documents/incoming_requested_docu_preview.dart';
import 'package:docutrack_main/localhost.dart';

class IncomingDocuAttachments extends StatefulWidget {
  const IncomingDocuAttachments({super.key});

  @override
  State<IncomingDocuAttachments> createState() => _IncomingDocuAttachmentsState();
}

class ForwardedRequestDocuDetails{
  String? forwarded_subject;
  String? forwarded_requested;
  String? forwarded_docu_request_recipient;
  String? forwarded_date_requested;
  String? forwarded_requested_docu_file;

  ForwardedRequestDocuDetails({
    required this.forwarded_subject,
    required this.forwarded_requested,
    required this.forwarded_docu_request_recipient,
    required this.forwarded_date_requested,
    required this.forwarded_requested_docu_file,
  });
}

class _IncomingDocuAttachmentsState extends State<IncomingDocuAttachments> {
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;

  var api_url = dotenv.env['API_URL'];

  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();

  String? docu_request_comment = "";

  MyappState? myAppState;
  UserIdState? userIdState;
  UserOfficeNameState? userOfficeNameState;
  ForwardedRequestDocumentDetails? forwardedRequestedDocumentDetails;
  SelectedForwardedRequestedDocuFile? selectedForwardedRequestedDocuFile;
  DefaultIncomingRequestDocuState? defaultIncomingRequestDocuState;
  SelectedDefaultRequestDocuState? selectedDefaultRequestDocuState;

  String jwtToken = "";

  @override
  void initState(){
    super.initState();
    myAppState = Provider.of<MyappState>(context, listen: false);
    userIdState = Provider.of<UserIdState>(context, listen: false);
    userOfficeNameState = Provider.of<UserOfficeNameState>(context, listen: false);
    forwardedRequestedDocumentDetails = Provider.of<ForwardedRequestDocumentDetails>(context, listen: false);
    selectedForwardedRequestedDocuFile = Provider.of<SelectedForwardedRequestedDocuFile>(context, listen: false);
    defaultIncomingRequestDocuState = Provider.of<DefaultIncomingRequestDocuState>(context, listen: false);
    selectedDefaultRequestDocuState = Provider.of<SelectedDefaultRequestDocuState>(context, listen: false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile(context) ? AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 65,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Document Attachments',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: secondaryColor,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(
          color: secondaryColor,
        ),
        centerTitle: true,
      )
          : null,
      drawer: isMobile(context)
          ? Drawer(
        backgroundColor: primaryColor,
        child: SideNav(),
      )
          : null,
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
            child: Padding(
              padding: isMobile(context) ? EdgeInsets.symmetric(horizontal: 20, vertical: 30)
                  : EdgeInsets.symmetric(horizontal: 60, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (MediaQuery.of(context).size.width > 600)
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: FittedBox(
                              child: Text(
                                'Document Attachments',
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
                        SizedBox(width: 90),
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
                    SizedBox(height: 30),
                  // SizedBox(height: 20),

                  Consumer<ForwardedRequestDocumentDetails>(
                    builder: (context, forwardedRequestedDocumentDetails, child) {
                      return Expanded(
                        child: ListView(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: ListView.builder(
                                itemCount: forwardedRequestedDocumentDetails.forwardedRequestedDocumentFileList.length,
                                itemBuilder: (context, index) {

                                  ListForwardedRequestedDocumentFile forwardedDocuDetail = forwardedRequestedDocumentDetails.forwardedRequestedDocumentFileList[index];

                                  return GestureDetector(
                                    onTap: () async{

                                      try {
                                        int? forwarded_reqDocuID = forwardedDocuDetail!.forwarded_requested_docu_id;

                                        final response = await http.get(
                                            Uri.parse('${api_url}/api/documents/getForwarded_requested_document/$forwarded_reqDocuID'),
                                          headers:{'Accept': 'application/json',
                                            "ngrok-skip-browser-warning": "$localhost_port",
                                          },
                                        );

                                        if (response.statusCode == 200) {
                                          final responseData = json.decode(response.body);


                                          String forwardedRequestedDocuFileUrl = responseData['forwarded_requested_docu_file']['forwarded_requested_docu_file'];

                                          selectedForwardedRequestedDocuFile!.setSelectedForwardedRequestedDocuFile(forwardedRequestedDocuFileUrl);

                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context)=>Requested_Incoming_Preview())
                                          );

                                          print(forwardedRequestedDocuFileUrl);
                                        }
                                      } catch (e) {
                                        print('Error: $e');
                                      }
                                    },
                                    child: ListTile(
                                      title: Text(
                                        forwardedDocuDetail.forwarded_subject ?? 'No Subject',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                        forwardedDocuDetail.forwarded_requested ?? 'Unknown Sender',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: Text(
                                        forwardedDocuDetail.forwarded_date_requested ?? 'Unknown Date',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Consumer<DefaultIncomingRequestDocuState>(
                    builder: (context, defaultIncomingRequestDocuState, child) {
                      return Expanded(
                        child: ListView(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                try {
                                  int? reqDocuID = defaultIncomingRequestDocuState!.docu_request_id;

                                  final response = await http.get(
                                      Uri.parse('${api_url}/api/documents/getRequested_document/$reqDocuID'),
                                    headers:{'Accept': 'application/json',
                                      "ngrok-skip-browser-warning": "$localhost_port",
                                    },
                                  );

                                  if (response.statusCode == 200) {
                                    final responseData = json.decode(response.body);


                                    String defaultRequestedDocuFileUrl = responseData['requested_docu_file']['docu_request_file'];

                                    selectedDefaultRequestDocuState!.setSelectedDefaultRequestDocu(defaultRequestedDocuFileUrl);

                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context)=>Requested_Incoming_Preview())
                                    );

                                    print(defaultRequestedDocuFileUrl);
                                  }
                                } catch (e) {
                                  print('Error: $e');
                                }
                              },
                              child: ListTile(
                                title: Text(
                                  defaultIncomingRequestDocuState.docu_request_topic ?? 'No Subject',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  defaultIncomingRequestDocuState.requested ?? 'Unknown Sender',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Text(
                                  defaultIncomingRequestDocuState.docu_request_deadline ?? 'Unknown Date',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 500),
                      child: Row(
                        children: [
                          Expanded(child: buildReceiveBtn()),
                          SizedBox(width: 15),
                          Expanded(child: buildForwardBtn()),
                          SizedBox(width: 15),
                          Expanded(child: buildReturnBtn()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget buildReceiveBtn() => ElevatedButton(
    onPressed: () {
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
                              ),
                            ),
                            onPressed: () async {
                              receiveFunction();
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
                                            'Request has been successfully received!',
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
                                                child: Text(
                                                  'OK',
                                                  style: GoogleFonts.poppins(),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 13),
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
                              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 13),
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
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
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
    child: FittedBox(
      child: Text(
        'Receive',
        style: GoogleFonts.poppins(
          color: secondaryColor,
          fontSize: 15,
        ),
      ),
    ),
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      minimumSize: Size(250, 50),
      primary: primaryColor,
      onPrimary: secondaryColor,
      shadowColor: Colors.transparent,
      //  side: BorderSide(color: primaryColor, width: 2),
      shape: StadiumBorder(),
    ),
  );

  Widget buildForwardBtn() => ElevatedButton(
    onPressed: () async {
      await sendTokenToBackendFetchOfficeName(jwtToken);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ForwardRequest(),
        ),
      );
    },
    child: FittedBox(
      child: Text(
        'Forward',
        style: GoogleFonts.poppins(
          color: secondaryColor,
          fontSize: 15,
        ),
      ),
    ),
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      minimumSize: Size(250, 50),
      primary: primaryColor,
      onPrimary: secondaryColor,
      shadowColor: Colors.transparent,
      //  side: BorderSide(color: primaryColor, width: 2),
      shape: StadiumBorder(),
    ),
  );

  Widget buildReturnBtn() => ElevatedButton(
    onPressed: () async{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: 350,
              height: 280,
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
                    SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        minLines: 2,
                        maxLines: 10,
                        keyboardType: TextInputType.multiline,
                        // key: Key('admin_overview'),
                        decoration: InputDecoration(
                          hintText: 'Enter comment',
                          hintStyle: GoogleFonts.poppins(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey[280],
                          contentPadding: EdgeInsets.only(
                              top: 10.0, bottom: 120.0, left: 10.0, right: 10.0),
                        ),
                        enabled: true,
                        onSaved: (value) {
                          docu_request_comment = value;
                          print(docu_request_comment);
                        },
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        
                      ),
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
                              _submitForm();

                              Navigator.pop(context);
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
                                              'Are you sure you want to return?',
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
                                                      ///BACKEND FUNCTIONALITY INSERT

                                                      sendReturnUpdateStatus();
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
                                                                    'Request has been successfully returned!',
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
                                                                        child: Text(
                                                                          'OK',
                                                                          style: GoogleFonts.poppins(),
                                                                        ),
                                                                        onPressed: () {
                                                                          Navigator.pop(context);
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 13),
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
                                                      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 13),
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
                                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
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
                              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 13),
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
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
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
    child: FittedBox(
      child: Text(
        'Return',
        style: GoogleFonts.poppins(
          color: primaryColor,
          fontSize: 15,
        ),
      ),
    ),
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      minimumSize: Size(250, 50),
      primary: secondaryColor,
      onPrimary: primaryColor,
      shadowColor: Colors.transparent,
      side: BorderSide(color: primaryColor, width: 2),
      shape: StadiumBorder(),
    ),
  );

  Future<void> sendTokenToBackendFetchOfficeName(String jwtToken) async {
    final userToken = myAppState!.user_Token;
    final url = '${api_url}/api/documents/getJwtTokenNOfficeName';
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
          "ngrok-skip-browser-warning": "$localhost_port",
        },
        body: jsonData,
      );
      if (response.statusCode == 200) {

        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print(responseBody);

        final String requestOfficeName = responseBody['requested'];

        userOfficeNameState!.setUserOfficeName(requestOfficeName);


        print('Requested Office Name: $requestOfficeName');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');

    }
  }

  Future<void>receiveFunction()async{
    final reqDocuID = defaultIncomingRequestDocuState!.docu_request_id;
    print(reqDocuID);

    final status_value = "Received";
    try{
      final response = await http.post(Uri.parse('${api_url}/api/documents/update_forwarded_request_receive_status/$reqDocuID'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",
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

  Future<void> _submitForm() async {
    if (defaultIncomingRequestDocuState == null) {

      return;
    }

    final reqDocuID = defaultIncomingRequestDocuState!.docu_request_id;
    final isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      _formKey.currentState?.save();

      try {
        final url = Uri.parse('$api_url/api/documents/create_returned_comment/$reqDocuID');
        final request = http.MultipartRequest('POST', url)
          ..fields['docu_request_comment'] = docu_request_comment ?? '';


        print(docu_request_comment);

        final response = await request.send();

        if (response.statusCode == 200) {
          print('You have successfully sent the comment');
        } else {
          print('Failed to send comment. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {

    }
  }





  Future<void>sendReturnUpdateStatus()async{
    final reqDocuID = defaultIncomingRequestDocuState!.docu_request_id;
    print(reqDocuID);

    final status_value = "Returned";
    try{
      final response = await http.post(Uri.parse('${api_url}/api/documents/update_forwarded_request_returned_status/$reqDocuID'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",
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
