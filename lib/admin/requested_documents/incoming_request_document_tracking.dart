import 'package:docutrack_main/admin/admin_home_page.dart';
import 'package:flutter/material.dart';
import 'package:docutrack_main/custom_widget/custom_side_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:docutrack_main/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/style.dart';
import 'package:docutrack_main/admin/requested_documents/requested_docu_preview.dart';
import 'package:docutrack_main/admin/requested_documents/incoming_request_docu_attachments.dart';
import 'package:docutrack_main/localhost.dart';

class IncomingRequestedTrackingProgress extends StatefulWidget {
  const IncomingRequestedTrackingProgress({super.key});

  @override
  State<IncomingRequestedTrackingProgress> createState() => _IncomingRequestedTrackingProgress();
}

class ListForwardedRequestedDocumentFile{
  int? forwarded_requested_docu_id;
  String? forwarded_subject;
  String? forwarded_requested;
  String? forwarded_docu_request_recipient;
  String? forwarded_date_requested;
  String? forwarded_requested_docu_file;

  ListForwardedRequestedDocumentFile({
    required this.forwarded_requested_docu_id,
    required this.forwarded_subject,
    required this.forwarded_requested,
    required this.forwarded_docu_request_recipient,
    required this.forwarded_date_requested,
    required this.forwarded_requested_docu_file,
  });

  factory ListForwardedRequestedDocumentFile.fromJson(Map<String, dynamic>json){
    return ListForwardedRequestedDocumentFile(
      forwarded_requested_docu_id: json['forwarded_requested_docu_id'],
      forwarded_subject: json['forwarded_subject'],
      forwarded_requested: json['forwarded_requested'],
      forwarded_docu_request_recipient: json['forwarded_docu_request_recipient'],
      forwarded_date_requested: json['forwarded_date_requested'],
      forwarded_requested_docu_file: json['forwarded_requested_docu_file'],
    );
  }

  static List<ListForwardedRequestedDocumentFile>fromJsonList(List<dynamic>list){
    List<ListForwardedRequestedDocumentFile> forwardedRequestedDocumentFileList = [];
    for(var json in list){
      forwardedRequestedDocumentFileList.add(ListForwardedRequestedDocumentFile.fromJson(json));
    }
    return forwardedRequestedDocumentFileList;
  }



  @override
  String toString(){
    return 'ListForwardedRequestedDocumentFile {forwarded_requested_docu_id: $forwarded_requested_docu_id,forwarded_subject: $forwarded_subject, forwarded_requested: $forwarded_requested, forwarded_docu_request_recipient: $forwarded_docu_request_recipient, forwarded_date_requested: $forwarded_date_requested, forwarded_requested_docu_file: $forwarded_requested_docu_file}';
  }
}

class DefaultIncomingRequestDocu {
  String? docu_request_id;
  String? docu_request_topic;
  String? requested;
  String? docu_request_recipient;
  String? docu_request_deadline;
  String? docu_request_file;

  DefaultIncomingRequestDocu({
    required this.docu_request_id,
    required this.docu_request_topic,
    required this.requested,
    required this.docu_request_recipient,
    required this.docu_request_deadline,
    required this.docu_request_file,
  });

  factory DefaultIncomingRequestDocu.fromJson(Map<String, dynamic>json){
    return DefaultIncomingRequestDocu(
      docu_request_id: json['docu_request_id'] ?? '',
      docu_request_topic: json['docu_request_topic'] ?? '',
      requested:json['requested'] ?? '',
      docu_request_recipient: json ['docu_request_recipient'] ?? '',
      docu_request_deadline: json['docu_request_deadline'] ?? '',
      docu_request_file:json['docu_request_file'] ?? '',
    );
  }
}

class ForwardRequestRecordDetail {
  String? forwardedRequestedDocuStatus;
  String? forwardedSubject;
  String? forwardedRequested;
  String? forwardedDocuRequestRecipient;
  String? forwardedDateRequested;
  String? forwardedRequestedDocuFile;
  String? forwardedRequestedDocuTimeStamp;

  ForwardRequestRecordDetail({
    required this.forwardedRequestedDocuStatus,
    required this.forwardedSubject,
    required this.forwardedRequested,
    required this.forwardedDocuRequestRecipient,
    required this.forwardedDateRequested,
    required this.forwardedRequestedDocuFile,
    required this.forwardedRequestedDocuTimeStamp,
  });
}



class _IncomingRequestedTrackingProgress extends State<IncomingRequestedTrackingProgress> {
  var api_url = dotenv.env['API_URL'];

  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;
  ScrollController _scrollController = ScrollController();

  SelectedIncomingRequestedDocuDetails? selectedIncomingRequestedDocuDetails;
  ForwardedRequestDocumentDetails? forwardedRequestDocumentDetails;
  DefaultIncomingRequestDocuState? defaultIncomingRequestDocuState;



  @override
  void initState() {
    super.initState();
    selectedIncomingRequestedDocuDetails = Provider.of<SelectedIncomingRequestedDocuDetails>(context, listen: false);
    forwardedRequestDocumentDetails = Provider.of<ForwardedRequestDocumentDetails>(context, listen: false);
    defaultIncomingRequestDocuState = Provider.of<DefaultIncomingRequestDocuState>(context, listen: false);
  }








  void fetchReqDocuData(){
    String? fetchReqDocuId = selectedIncomingRequestedDocuDetails!.req_docu_id;
    String? fetchDocReqTopic = selectedIncomingRequestedDocuDetails!.docu_request_topic;
    String? fetchDocReqRecipient = selectedIncomingRequestedDocuDetails!.docu_request_recipient;
    String? fetchDocReqDeadline = selectedIncomingRequestedDocuDetails!.docu_request_deadline;
    String? fetchStatus = selectedIncomingRequestedDocuDetails!.status;
    String? fetchDocReqComment = selectedIncomingRequestedDocuDetails!.docu_request_comment;


    print(fetchReqDocuId);
    print(fetchDocReqTopic);
    print(fetchDocReqRecipient);
    print(fetchDocReqDeadline);
    print(fetchStatus);
    print(fetchDocReqComment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile(context) ? AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 65,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Document Tracking',
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
            child: SingleChildScrollView(
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Dashboard',
                                  style: GoogleFonts.poppins(
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                Text(
                                  'INCOMING | Request for Approval',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
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
                      SizedBox(height: 30.0),
                    if (MediaQuery.of(context).size.width < 600)
                      Text(
                        'INCOMING | Request for Approval',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    SizedBox(height: 20.0),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Scrollbar(
                        controller: _scrollController,
                        thickness: 4,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: (isWeb(context)) ? 260 : (isMobile(context) ? 100 : 100),
                            columns: [
                              DataColumn(label: Text('Subject',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  )
                              )),

                              DataColumn(label: Text('Deadline',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ))),
                              DataColumn(label: Text('Requested By',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  )
                              )),
                              DataColumn(label: Text('Recipient',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ))),

                              DataColumn(label: Text('Status',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ))),
                              DataColumn(label: Text('Actions',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ))),
                            ],
                            rows: [
                              DataRow(cells: [
                                DataCell(Text(selectedIncomingRequestedDocuDetails!.docu_request_topic ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                  ),
                                )),
                                DataCell(Text(selectedIncomingRequestedDocuDetails!.docu_request_deadline ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                  ),
                                )),
                                DataCell(Text(selectedIncomingRequestedDocuDetails!.requested ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                  ),
                                )),
                                DataCell(Text(selectedIncomingRequestedDocuDetails!.docu_request_recipient ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                  ),
                                )),

                                DataCell(Text(selectedIncomingRequestedDocuDetails!.status ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: _getStatusColor(selectedIncomingRequestedDocuDetails!.status),
                                  ),
                                )),
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.remove_red_eye_outlined,
                                        size: 23),
                                    onPressed: () async{
                                      await fetchedListofForwardedRequestedDocuments();
                                      await fetchDefaultIncomingDocuDetails();
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context)=>IncomingDocuAttachments())
                                      );
                                    },
                                  ),
                                )
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> fetchedListofForwardedRequestedDocuments() async {
    try {
      final reqDocuID = selectedIncomingRequestedDocuDetails!.req_docu_id;
      print(reqDocuID);

      final response = await http.get(Uri.parse('${api_url}/api/documents/getList_requested_document_file/$reqDocuID'),
        headers:{
          'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);


        if (responseData['additional_request_docu_file'] is List) {
          List<dynamic> additionalDocuFiles = responseData['additional_request_docu_file'];

          List<ListForwardedRequestedDocumentFile> forwardedRequestedDocumentFileList =
          additionalDocuFiles.map((item) =>
              ListForwardedRequestedDocumentFile.fromJson(item as Map<String, dynamic>))
              .toList();

          forwardedRequestDocumentDetails!.setForwardedRequestedDocumentFile(forwardedRequestedDocumentFileList);
          print(forwardedRequestedDocumentFileList);
        } else {
          print('Error: additional_request_docu_file is not a List');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Color _getStatusColor(String? status) {
    if (status == 'Received') {
      return Colors.green;
    } else if (status == 'Returned') {
      return Colors.red;
    } else if (status == 'Forwarded') {
      return Colors.blue;
    } else {
      return Colors.grey;
    }
  }

  Future<void> fetchDefaultIncomingDocuDetails() async {
    try {
      final reqDocuID = selectedIncomingRequestedDocuDetails?.req_docu_id;
      print(reqDocuID);

      final response = await http.get(
        Uri.parse('$api_url/api/documents/getList_requested_document_file/$reqDocuID'),
        headers:{
          'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);


        final int docuRequestId = responseData['default_requested_docu_file']['docu_request_id'] ?? '';
        final String docuRequestTopic = responseData['default_requested_docu_file']['docu_request_topic'] ?? '';
        final String requested = responseData['default_requested_docu_file']['requested'] ?? '';
        final String docuRequestRecipient = responseData['default_requested_docu_file']['docu_request_recipient'] ?? '';
        final String docuRequestDeadline = responseData['default_requested_docu_file']['docu_request_deadline'] ?? '' ;
        final String docuRequestFile = responseData['default_requested_docu_file']['docu_request_file'] ?? '';


        print('Document Request ID: $docuRequestId');
        print(docuRequestTopic);
        defaultIncomingRequestDocuState!.setDefaultIncomingRequestDocuState(docuRequestId, docuRequestTopic, requested, docuRequestRecipient, docuRequestDeadline, docuRequestFile);
      } else {
        print('Failed to fetch document. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

}

