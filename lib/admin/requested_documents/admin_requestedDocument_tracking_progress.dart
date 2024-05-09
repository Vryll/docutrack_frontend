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
import 'package:docutrack_main/admin/requested_documents/outgoing_requested_docu_attachments.dart';
import 'dart:async';
import 'package:docutrack_main/localhost.dart';

class RequestedTrackingProgress extends StatefulWidget {
  const RequestedTrackingProgress({super.key});

  @override
  State<RequestedTrackingProgress> createState() => _RequestedTrackingProgressState();
}

class ListForwardedOutgoingRequestedDocumentFile {
  int? forwarded_requested_docu_id;
  String? forwarded_subject;
  String? forwarded_requested;
  String? forwarded_docu_request_recipient;
  String? forwarded_date_requested;
  String? forwarded_requested_docu_file;

  ListForwardedOutgoingRequestedDocumentFile({
    required this.forwarded_requested_docu_id,
    required this.forwarded_subject,
    required this.forwarded_requested,
    required this.forwarded_docu_request_recipient,
    required this.forwarded_date_requested,
    required this.forwarded_requested_docu_file,
  });

  factory ListForwardedOutgoingRequestedDocumentFile.fromJson(Map<String, dynamic> json) {
    return ListForwardedOutgoingRequestedDocumentFile(
      forwarded_requested_docu_id: json['forwarded_requested_docu_id'],
      forwarded_subject: json['forwarded_subject'],
      forwarded_requested: json['forwarded_requested'],
      forwarded_docu_request_recipient: json['forwarded_docu_request_recipient'],
      forwarded_date_requested: json['forwarded_date_requested'],
      forwarded_requested_docu_file: json['forwarded_requested_docu_file'],
    );
  }

  static List<ListForwardedOutgoingRequestedDocumentFile> fromJsonList(List<dynamic> list) {
    List<ListForwardedOutgoingRequestedDocumentFile> forwardedOutgoingRequestedDocumentFileList = [];
    for (var json in list) {
      forwardedOutgoingRequestedDocumentFileList.add(ListForwardedOutgoingRequestedDocumentFile.fromJson(json));
    }
    return forwardedOutgoingRequestedDocumentFileList;
  }

  @override
  String toString() {
    return 'ListForwardedOutgoingRequestedDocumentFile {forwarded_requested_docu_id: $forwarded_requested_docu_id,forwarded_subject: $forwarded_subject, forwarded_requested: $forwarded_requested, forwarded_docu_request_recipient: $forwarded_docu_request_recipient, forwarded_date_requested: $forwarded_date_requested, forwarded_requested_docu_file: $forwarded_requested_docu_file}';
  }
}

class ForwardRequestRecordModel {
  String? forwardedRequestedDocuStatus;
  String? forwardedSubject;
  String? forwardedRequested;
  String? forwardedDocuRequestRecipient;
  String? forwardedDateRequested;
  String? forwardedRequestedDocuFile;
  String? forwardedRequestedDocuTimeStamp;

  ForwardRequestRecordModel({
    required this.forwardedRequestedDocuStatus,
    required this.forwardedSubject,
    required this.forwardedRequested,
    required this.forwardedDocuRequestRecipient,
    required this.forwardedDateRequested,
    required this.forwardedRequestedDocuFile,
    required this.forwardedRequestedDocuTimeStamp,
  });

  factory ForwardRequestRecordModel.fromJson(Map<String, dynamic> json) {
    return ForwardRequestRecordModel(
      forwardedRequestedDocuStatus: json['forwarded_requested_docu_status'],
      forwardedSubject: json['forwarded_subject'],
      forwardedRequested: json['forwarded_requested'],
      forwardedDocuRequestRecipient: json['forwarded_docu_request_recipient'],
      forwardedDateRequested: json['forwarded_date_requested'],
      forwardedRequestedDocuFile: json['forwarded_requested_docu_file'],
      forwardedRequestedDocuTimeStamp: json['forwarded_requested_docu_time_Stamp'],
    );
  }

  static List<ForwardRequestRecordModel> fromJsonList(List<dynamic> list) {
    return List<ForwardRequestRecordModel>.from(list.map((json)=>ForwardRequestRecordModel.fromJson(json)));
  }

  @override
  String toString() {
    return 'ForwardRequestRecord {forwardedRequestedDocuStatus: $forwardedRequestedDocuStatus, forwardedSubject: $forwardedSubject, forwardedRequested: $forwardedRequested, forwardedDocuRequestRecipient: $forwardedDocuRequestRecipient, forwardedDateRequested: $forwardedDateRequested, forwardedRequestedDocuFile: $forwardedRequestedDocuFile, forwardedRequestedDocuTimeStamp: $forwardedRequestedDocuTimeStamp}';
  }
}

class _RequestedTrackingProgressState extends State<RequestedTrackingProgress> {
  var api_url = dotenv.env['API_URL'];
  ScrollController _scrollController = ScrollController();
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;

  late Timer _timer;

  SelectedRequestedDocuDetails? selectedRequestedDocuDetails;
  ForwardedOutgoingRequestDocumentDetails? forwardedOutgoingRequestDocumentDetails;
  DefaultIncomingRequestDocuState? defaultIncomingRequestDocuState;
  ForwardRequestRecord? forwardRequestRecord;

  @override
  void initState(){
    super.initState();
    selectedRequestedDocuDetails = Provider.of<SelectedRequestedDocuDetails>(context, listen: false);
    forwardedOutgoingRequestDocumentDetails = Provider.of<ForwardedOutgoingRequestDocumentDetails>(context, listen: false);
    defaultIncomingRequestDocuState =   Provider.of<DefaultIncomingRequestDocuState>(context, listen: false);
    fetchForwardedRequestRecord;

    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      print('Timer is triggered!');
      fetchForwardedRequestRecord();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    forwardRequestRecord = Provider.of<ForwardRequestRecord>(context, listen: true);
  }

  void fetchReqDocuData(){
    String? fetchReqDocuId = selectedRequestedDocuDetails!.req_docu_id;
    String? fetchDocReqTopic = selectedRequestedDocuDetails!.docu_request_topic;
    String? fetchDocReqRecipient = selectedRequestedDocuDetails!.docu_request_recipient;
    String? fetchDocReqDeadline = selectedRequestedDocuDetails!.docu_request_deadline;
    String? fetchStatus = selectedRequestedDocuDetails!.status;
    String? fetchDocReqComment = selectedRequestedDocuDetails!.docu_request_comment;


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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Document Tracking',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: secondaryColor,
              ),
            ),
            // Text(
            //   'OUTGOING | Request for Approval Document',
            //   style: GoogleFonts.poppins(
            //     fontSize: 9,
            //     fontWeight: FontWeight.normal,
            //     color: secondaryColor.withOpacity(0.7),
            //   ),
            // ),
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
                                  'OUTGOING | Request for Approval',
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
                      const SizedBox(height: 30),
                    if (MediaQuery.of(context).size.width < 600)
                      Text(
                        'OUTGOING | Request for Approval',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    SizedBox(height: 20),
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
                        // trackVisibility: true,
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
                                DataCell(Text(selectedRequestedDocuDetails!.docu_request_topic ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                  ),
                                )),
                                DataCell(Text(selectedRequestedDocuDetails!.docu_request_deadline ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                  ),
                                )),

                                DataCell(Text(selectedRequestedDocuDetails!.docu_request_recipient ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                  ),
                                )),

                                DataCell(Text(selectedRequestedDocuDetails!.status ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.0,
                                    color: _getStatusColor(selectedRequestedDocuDetails!.status),
                                  ),
                                )),
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.remove_red_eye_outlined,
                                        size: 23),
                                    onPressed: () async{
                                      await fetchedListofRequestedDocuments();
                                      await fetchDefaultIncomingDocuDetails();

                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context)=>OutgoingRequestDocuAttachments())
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

                    Consumer<ForwardRequestRecord>(
                      builder: (context, forwardRequestRecord, child) {

                        List<ForwardRequestRecordModel> items = forwardRequestRecord.forwardRequestRecordList;

                        if (items.isEmpty) {
                          return Container();
                        } else {
                          return SizedBox(
                            height: 120,
                            // width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              itemCount: items.length,
                              reverse: true,

                              itemBuilder: (context, index) {
                                ForwardRequestRecordModel item = items[index];

                                return ListTile(
                                  title: Text(
                                    item.forwardedRequestedDocuTimeStamp ?? '',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                  subtitle: Text(
                                    item.forwardedDocuRequestRecipient ?? '',
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                  trailing: Text(
                                    item.forwardedRequestedDocuStatus ?? '',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      color: _getStatusColor(item.forwardedRequestedDocuStatus ?? ''),
                                      fontSize: 13,
                                    ),
                                  ),

                                );
                              },
                            ),
                          );
                        }
                      },
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

  Future<void> fetchedListofRequestedDocuments() async {
    try {
      final reqDocuID = selectedRequestedDocuDetails!.req_docu_id;
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

          List<ListForwardedOutgoingRequestedDocumentFile> forwardedOutgoingRequestedDocumentFileList =
          additionalDocuFiles.map((item) =>
              ListForwardedOutgoingRequestedDocumentFile.fromJson(item as Map<String, dynamic>))
              .toList();

          forwardedOutgoingRequestDocumentDetails!.setForwardedOutgoingRequestedDocumentFile(forwardedOutgoingRequestedDocumentFileList);
          print(forwardedOutgoingRequestedDocumentFileList);
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
      final reqDocuID = selectedRequestedDocuDetails?.req_docu_id;
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


  Future<void> fetchForwardedRequestRecord() async {
    final reqDocuId = selectedRequestedDocuDetails!.req_docu_id;

    try {
      final response = await http.get(Uri.parse('${api_url}/api/documents/getForwarded_document_records/$reqDocuId'),
        headers:{
          'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData.containsKey("forward_requested_data")) {
          List<ForwardRequestRecordModel> forwardRequestRecordList = List<ForwardRequestRecordModel>.from(
            (responseData["forward_requested_data"] as List<dynamic>).map((json) =>
                ForwardRequestRecordModel.fromJson(json as Map<String, dynamic>)
            ),
          );


          forwardRequestRecord!.setForwardRequestRecord(forwardRequestRecordList);
        } else {
          throw FormatException("Error: 'forward_requested_data' not found in response");

        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

}
