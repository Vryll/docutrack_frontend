import 'package:docutrack_main/main.dart';
import 'package:flutter/material.dart';
import 'package:docutrack_main/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/custom_widget/custom_side_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:docutrack_main/admin/requested_documents/admin_requestedDocument_tracking_progress.dart';
import 'package:docutrack_main/admin/requested_documents/incoming_request_document_tracking.dart';
import 'package:docutrack_main/localhost.dart';

class RequestDashboard extends StatefulWidget {
  const RequestDashboard({super.key});

  @override
  State<RequestDashboard> createState() => _RequestDashboardState();
}

class RequestDocumentDetail{
  String? id;
  String? docu_request_topic;
  String? requested;
  String? docu_request_recipient;
  String? docu_request_deadline;
  String? docu_request_comment;
  String? docu_request_file;
  bool is_deleted;


  RequestDocumentDetail({
    this.id,
    this.docu_request_topic,
    this.requested,
    this.docu_request_recipient,
    this.docu_request_deadline,
    this.docu_request_comment,
    this.docu_request_file,
    this.is_deleted = false,
  });
}

class IncomingRequestDocumentDetail{
  String? id;
  String? docu_request_topic;
  String? requested;
  String? docu_request_recipient;
  String? docu_request_deadline;
  String? docu_request_comment;
  String? docu_request_file;
  bool is_deleted;

  IncomingRequestDocumentDetail({
    this.id,
    this.docu_request_topic,
    this.requested,
    this.docu_request_recipient,
    this.docu_request_deadline,
    this.docu_request_comment,
    this.docu_request_file,
    this.is_deleted = false,
  });
}

class _RequestDashboardState extends State<RequestDashboard> {
  var api_url = dotenv.env['API_URL'];

  String selectedValue = 'Outgoing';

  RequestedDocumentDetailDashboardState? requestedDocumentDetailDashboardState;
  SelectedRequestedDocuDetails? selectedRequestedDocuDetails;

  IncomingRequestedDocumentDetailDashboardState? incomingRequestedDocumentDetailDashboardState;
  SelectedIncomingRequestedDocuDetails? selectedIncomingRequestedDocuDetails;
  ForwardRequestRecord? forwardRequestRecord;

  String? id = "";
  String? docu_request_topic = "";
  String? requested = "";
  String? docu_request_recipient = "";
  String? docu_request_deadline = "";
  String? docu_request_comment = "";
  String? docu_request_file = "";

  int? selectedDate;
  String selectedFilter = 'Day';
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;

  ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  late List<RequestDocumentDetails> defaultData;
  List<RequestDocumentDetails> dataTableSource = [];

  @override
  void initState() {
    super.initState();
    requestedDocumentDetailDashboardState = Provider.of<RequestedDocumentDetailDashboardState>(context, listen: false);
    selectedRequestedDocuDetails = Provider.of<SelectedRequestedDocuDetails>(context, listen: false);
    forwardRequestRecord = Provider.of<ForwardRequestRecord>(context, listen: false);
    incomingRequestedDocumentDetailDashboardState = Provider.of<IncomingRequestedDocumentDetailDashboardState>(context, listen: false);
    selectedIncomingRequestedDocuDetails = Provider.of<SelectedIncomingRequestedDocuDetails>(context, listen: false);
    defaultData = requestedDocumentDetailDashboardState!.requestDocumentDetailsList;
    refreshDataTableSource();
  }

  void refreshDataTableSource() {
    dataTableSource = defaultData.where((docu) => !docu.is_deleted).toList();
  }

  void filterData(String query) {
    if (requestedDocumentDetailDashboardState != null) {
      List<RequestDocumentDetails> filteredList = [];

      if (query.isNotEmpty) {
        List<String> queryWords = query.toLowerCase().split(' ');

        filteredList = requestedDocumentDetailDashboardState!
            .requestDocumentDetailsList
            .where((docu) {
          return queryWords.any((word) =>
          (docu.docu_request_topic?.toLowerCase().contains(word) ?? false) ||
              (docu.status?.toLowerCase().contains(word) ?? false) ||
              (docu.docu_request_deadline?.toLowerCase().contains(word) ?? false) ||
              (docu.requested?.toLowerCase().contains(word) ?? false));
        }).toList();
      } else {
        filteredList = defaultData;
      }

      requestedDocumentDetailDashboardState!
          .setRequestedDocumentDetailDashboardState(filteredList);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile(context) ? AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Dashboard',
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
                                  'Request for Approval Documents',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                  maxLines: 1,
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
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: DropdownButton<String>(
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value!;
                            });
                          },
                          items: ['Incoming', 'Outgoing']
                              .map((value) =>
                              DropdownMenuItem(
                                  value: value,
                                  child: Text(value)
                              ))
                              .toList(),
                          style: GoogleFonts.poppins(
                              color: Colors.black
                          ),
                          underline: SizedBox(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                if (MediaQuery.of(context).size.width < 600)
                                Expanded(
                                    child: Text(
                                      'Requested Documents',
                                      style: GoogleFonts.poppins(
                                        fontSize: isMobile(context) ? 14 : 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                if (MediaQuery.of(context).size.width > 600)
                                Spacer(),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: SizedBox(
                                    height: 35.0,
                                    width: isMobile(context) ? 180 : 250.0,
                                    child: TextField(
                                      controller: searchController,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(top: 2),
                                        hintText: 'Search',
                                        prefixIcon: Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: primaryColor,
                                          ),
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      onChanged: (value) {

                                        filterData(value);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1.5,
                            color: Colors.black,
                          ),
                          Expanded(
                            child: Scrollbar(
                              controller: _scrollController,
                              trackVisibility: true,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                controller: _scrollController,
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columnSpacing: (isWeb(context)) ? 290 : (isMobile(context) ? 80 : 150),
                                    columns: [
                                      DataColumn(
                                          label: Text(
                                            'Subject',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          )
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Date Released',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Sender',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Recipient/\s',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),

                                      DataColumn(
                                          label: Text(
                                            'Status',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          )
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Actions',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: rowData(),
                                  ),
                                ),
                              ),
                            ),
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
    );
  }

  Card buildCard(String title, String count, Color color) {
    return Card(
      margin: EdgeInsets.zero,
      color: color,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
              ),
              Text(
                count,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DataRow> rowData() {
    List<DataRow> rows = [];
    if (selectedValue == 'Outgoing') {
      for (var _requestDocumentDetailsList in requestedDocumentDetailDashboardState!
          .requestDocumentDetailsList) {
        rows.add(
          DataRow(cells: [
            DataCell(Text(_requestDocumentDetailsList.docu_request_topic!,
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            )),
            DataCell(Text(_requestDocumentDetailsList.docu_request_deadline!,
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            )),
            DataCell(Text(_requestDocumentDetailsList.requested!,
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            )),
            DataCell(Text(_requestDocumentDetailsList.docu_request_recipient!,
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            )),

            DataCell(Text(_requestDocumentDetailsList.status ?? 'N/A',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: _getStatusColor(_requestDocumentDetailsList.status),
              ),
            )),
            DataCell(
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_red_eye_outlined, size: 23,),
                    onPressed: () async {
                      String reqDocuId = _requestDocumentDetailsList.id!.toString();
                      print(reqDocuId);

                      String process_type = _requestDocumentDetailsList!.process_type.toString();

                      Map<String, dynamic>? documentData;

                      try {
                        final response = await http.get(Uri.parse('$api_url/api/documents/getRequestedDocument/req_docuId=$reqDocuId/$process_type'),
                          headers:{
                            'Accept': 'application/json',
                            "ngrok-skip-browser-warning": "$localhost_port",
                          },
                        );
                        print('Response Status Code: ${response.statusCode}');

                        if (response.statusCode == 200) {
                          Map<String, dynamic> data = json.decode(response.body);


                          if (data.containsKey("requested_document_data")) {
                            documentData = data["requested_document_data"];
                          } else if (data.containsKey("forwarded_document_data")) {
                            documentData = data["forwarded_document_data"];
                          }

                          if (documentData != null) {
                            String req_docu_id = documentData["req_docu_id"].toString();
                            String process_type = documentData["process_type"].toString();
                            String docu_request_topic = documentData["docu_request_topic"] ?? '';
                            String requested = documentData["requested"] ?? ''; // Handle null or missing field
                            String docu_request_recipient = documentData["docu_request_recipient"] ?? '';
                            String docu_request_deadline = documentData["docu_request_deadline"] ?? '';
                            String status = documentData["status"] ?? '';
                            String docu_request_comment = documentData['docu_request_comment'] ?? '';
                            String docu_request_file = documentData["docu_request_file"] ?? '';

                            print('req_docu_id: $req_docu_id');
                            print('docu_request_topic: $docu_request_topic');
                            print('requested: $requested');
                            print('docu_request_recipient: $docu_request_recipient');
                            print('docu_request_deadline: $docu_request_deadline');
                            print('status: $status');
                            print('docu_request_comment: $docu_request_comment');
                            print('docu_request_file: $docu_request_file');

                            selectedRequestedDocuDetails!.setSelectedRequestedDocuDetails(
                              req_docu_id,
                              process_type,
                              docu_request_topic,
                              requested,
                              docu_request_recipient,
                              docu_request_deadline,
                              status,
                              docu_request_comment,
                              docu_request_file,
                            );

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RequestedTrackingProgress(),
                              ),
                            );
                          }
                        } else {
                          print('Failed to load document details: ${response.statusCode}');
                        }
                      } catch (e) {
                        print('Error: $e');
                      }

                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
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
                                      'Are you sure you want to delete this document?',
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
                                              String? req_docuId = _requestDocumentDetailsList.id!.toString();
                                              try {
                                                final http.Response response = await http.delete(
                                                  Uri.parse('${api_url}/api/documents/deleting_requested_document_details/requested_documentID=$req_docuId'),
                                                  headers: <String, String>{
                                                    'Content-Type': 'application/json; charset=UTF-8',
                                                    "ngrok-skip-browser-warning": "$localhost_port",
                                                  },
                                                  body: jsonEncode({'id': req_docuId}),
                                                );
                                                if (response.statusCode == 200) {

                                                  print('Document deleted successfully');
                                                  requestedDocumentDetailDashboardState!.removeAdminData(req_docuId);
                                                  _requestDocumentDetailsList.is_deleted = true;
                                                  refreshDataTableSource();
                                                  setState(() {});
                                                } else {

                                                  print('Error deleting document. Status code: ${response.statusCode}');
                                                }
                                              }catch(e){
                                                print('error: $e');
                                              }
                                              Navigator.pop(context);
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
                                            child: FittedBox(child: Text('Cancel', maxLines: 1,)),
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
                  ),
                ],
              ),
            ),
          ]),
        );
      }
    } else if (selectedValue == 'Incoming') {
      for (var _incomingRequestDocumentDetailsList in incomingRequestedDocumentDetailDashboardState!
          .incomingrequestDocumentDetailsList) {
        rows.add(
          DataRow(cells: [
            DataCell(
                Text(_incomingRequestDocumentDetailsList.docu_request_topic!,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                )),
            DataCell(Text(
              _incomingRequestDocumentDetailsList.docu_request_deadline!,
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            )),
            DataCell(Text(_incomingRequestDocumentDetailsList.requested!,
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            )),

            DataCell(Text(
              _incomingRequestDocumentDetailsList.docu_request_recipient!,
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            )),


            DataCell(Text(_incomingRequestDocumentDetailsList.status ?? 'N/A',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: _getStatusColor(_incomingRequestDocumentDetailsList.status),
              ),
            )),
            DataCell(
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_red_eye_outlined, size: 23,),
                    onPressed: () async {
                      String reqDocuId = _incomingRequestDocumentDetailsList.id!;
                      print(reqDocuId);

                      String process_type = _incomingRequestDocumentDetailsList!.process_type.toString();

                      Map<String, dynamic>? documentData;

                      try {
                        final response = await http.get(Uri.parse('$api_url/api/documents/getRequestedDocument/req_docuId=$reqDocuId/$process_type'),
                          headers:{
                            'Accept': 'application/json',
                            "ngrok-skip-browser-warning": "$localhost_port",
                          },
                        );
                        print('Response Status Code: ${response.statusCode}');

                        if (response.statusCode == 200) {
                          Map<String, dynamic> data = json.decode(response.body);


                          if (data.containsKey("requested_document_data")) {
                            documentData = data["requested_document_data"];
                          } else if (data.containsKey("forwarded_document_data")) {
                            documentData = data["forwarded_document_data"];
                          }

                          if (documentData != null) {
                            String req_docu_id = documentData["req_docu_id"].toString();
                            String process_type = documentData["process_type"].toString();
                            String docu_request_topic = documentData["docu_request_topic"] ?? '';
                            String requested = documentData["requested"] ?? ''; // Handle null or missing field
                            String docu_request_recipient = documentData["docu_request_recipient"] ?? '';
                            String docu_request_deadline = documentData["docu_request_deadline"] ?? '';
                            String status = documentData["status"] ?? '';
                            String docu_request_comment = documentData['docu_request_comment'] ?? '';
                            String docu_request_file = documentData["docu_request_file"] ?? '';

                            print('req_docu_id: $req_docu_id');
                            print('docu_request_topic: $docu_request_topic');
                            print('requested: $requested');
                            print('docu_request_recipient: $docu_request_recipient');
                            print('docu_request_deadline: $docu_request_deadline');
                            print('status: $status');
                            print('docu_request_comment: $docu_request_comment');
                            print('docu_request_file: $docu_request_file');

                            selectedIncomingRequestedDocuDetails!.setSelectedIncomingRequestedDocuDetails(
                              req_docu_id,
                              process_type,
                              docu_request_topic,
                              requested,
                              docu_request_recipient,
                              docu_request_deadline,
                              status,
                              docu_request_comment,
                              docu_request_file,
                            );

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => IncomingRequestedTrackingProgress(),
                              ),
                            );
                          }
                        } else {
                          print('Failed to load document details: ${response.statusCode}');
                        }
                      } catch (e) {
                        print('Error: $e');
                      }



                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
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
                                      'Are you sure you want to delete this document?',
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
                                              String? req_docuId = _incomingRequestDocumentDetailsList.id!;
                                              try {
                                                final http.Response response = await http.delete(
                                                  Uri.parse('${api_url}/api/documents/deleting_requested_document_details/requested_documentID=$req_docuId'),
                                                  headers: <String, String>{
                                                    'Content-Type': 'application/json; charset=UTF-8',
                                                    "ngrok-skip-browser-warning": "$localhost_port",
                                                  },
                                                  body: jsonEncode({'id': req_docuId}),
                                                );
                                                if (response.statusCode == 200) {

                                                  print('Document deleted successfully');
                                                  requestedDocumentDetailDashboardState!.removeAdminData(req_docuId);
                                                  _incomingRequestDocumentDetailsList.is_deleted = true;
                                                  refreshDataTableSource();
                                                  setState(() {});

                                                } else {

                                                  print('Error deleting document. Status code: ${response.statusCode}');
                                                }
                                              }catch(e){
                                                print('error: $e');
                                              }
                                              Navigator.pop(context);
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
                                              maxLines: 1,)),
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
                  ),
                ],
              ),
            ),
          ]),
        );
      }
    }
    return rows;
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
}

