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
import 'package:docutrack_main/admin/requested_documents/admin_requestedDocument_tracking_progress.dart';
import 'package:docutrack_main/localhost.dart';

class OutgoingRequestDocuAttachments extends StatefulWidget {
  const OutgoingRequestDocuAttachments({super.key});

  @override
  State<OutgoingRequestDocuAttachments> createState() => _OutgoingRequestDocuAttachmentsState();
}

class _OutgoingRequestDocuAttachmentsState extends State<OutgoingRequestDocuAttachments> {
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;


  var api_url = dotenv.env['API_URL'];

  MyappState? myAppState;
  UserIdState? userIdState;
  UserOfficeNameState? userOfficeNameState;
  // ForwardedOugoingRequestDocumentDetails? forwardedRequestedDocumentDetails;
  SelectedForwardedRequestedDocuFile? selectedForwardedRequestedDocuFile;
  DefaultIncomingRequestDocuState? defaultIncomingRequestDocuState;
  SelectedDefaultRequestDocuState? selectedDefaultRequestDocuState;
  SelectedRequestedDocuDetails? selectedRequestedDocuDetails;
  ForwardedOutgoingRequestDocumentDetails? forwardedOutgoingRequestDocumentDetails;

  String jwtToken = "";

  @override
  void initState(){
    super.initState();
    myAppState = Provider.of<MyappState>(context, listen: false);
    userIdState = Provider.of<UserIdState>(context, listen: false);
    userOfficeNameState = Provider.of<UserOfficeNameState>(context, listen: false);
    // forwardedRequestedDocumentDetails = Provider.of<ForwardedOugoingRequestDocumentDetails>(context, listen: false);
    selectedForwardedRequestedDocuFile = Provider.of<SelectedForwardedRequestedDocuFile>(context, listen: false);
    defaultIncomingRequestDocuState = Provider.of<DefaultIncomingRequestDocuState>(context, listen: false);
    selectedDefaultRequestDocuState = Provider.of<SelectedDefaultRequestDocuState>(context, listen: false);
    forwardedOutgoingRequestDocumentDetails = Provider.of<ForwardedOutgoingRequestDocumentDetails>(context, listen: false);
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

                  Consumer<ForwardedOutgoingRequestDocumentDetails>(
                    builder: (context, forwardedOutgoingRequestDocumentDetails, child) {
                      return Expanded(
                        child: ListView(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: ListView.builder(
                                itemCount: forwardedOutgoingRequestDocumentDetails.forwardedOutgoingRequestedDocumentFileList.length,
                                itemBuilder: (context, index) {

                                  ListForwardedOutgoingRequestedDocumentFile forwardedOutgoingDocuDetail =
                                  forwardedOutgoingRequestDocumentDetails.forwardedOutgoingRequestedDocumentFileList[index];

                                  return GestureDetector(
                                    onTap: () async{

                                      try {
                                        int? forwarded_reqDocuID = forwardedOutgoingDocuDetail!.forwarded_requested_docu_id;

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
                                        forwardedOutgoingDocuDetail.forwarded_subject ?? 'No Subject',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                        forwardedOutgoingDocuDetail.forwarded_requested ?? 'Unknown Sender',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: Text(
                                        forwardedOutgoingDocuDetail.forwarded_date_requested ?? 'Unknown Date',
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
                    alignment: Alignment.center,
                    child: Container(
                      height: 150,
                      width: 300,
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'Your Comment Text Here',
                        style: TextStyle(
                          color: Colors.black, // Text color
                          fontSize: 12.0, // Text size
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
