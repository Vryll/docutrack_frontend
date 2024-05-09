import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/custom_widget/custom_side_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:docutrack_main/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:docutrack_main/style.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:docutrack_main/localhost.dart';

class DocuTrackingProgress extends StatefulWidget {
  const DocuTrackingProgress({Key? key}) : super(key: key);

  @override
  State<DocuTrackingProgress> createState() => _DocuTrackingProgressState();
}

class DocumentDetailList {
  String? memorandum_number;
  String? docu_type;
  String? docu_title;
  String? docu_dateNtime_released;
  String? docu_dateNtime_created;
  String? docu_sender;
  List<dynamic>? docu_recipient;
  String? status;
  String? id;

  DocumentDetailList({
    this.memorandum_number,
    this.docu_type,
    this.docu_title,
    this.docu_dateNtime_released,
    this.docu_dateNtime_created,
    this.docu_sender,
    this.docu_recipient,
    this.status,
    this.id,
  });

  String getFormattedDateTime(String? dateTime) {
    if (dateTime != null) {
      final parsedDateTime = DateTime.parse(dateTime);
      final formattedDate = DateFormat('MM/dd/yyyy').format(parsedDateTime);
      final formattedTime = DateFormat('hh:mm a').format(parsedDateTime);
      return '$formattedDate - $formattedTime';
    }
    return '';
  }
}

class TrackingProgressDetails {
  String? docu_dateNtime_created;
  String? docu_sender;
  int? docuId;
  int? scanned_docu_user_id;
  String? office_name;
  String? time_scanned;
  String? status;

  TrackingProgressDetails({
    required this.docu_dateNtime_created,
    required this.docu_sender,
    required this.docuId,
    required this.scanned_docu_user_id,
    required this.office_name,
    required this.time_scanned,
    required this.status,
  });

  factory TrackingProgressDetails.fromJson(Map<String, dynamic> json) {
    return TrackingProgressDetails(
      docu_dateNtime_created: json['docu_dateNtime_created'] ?? '',
      docu_sender: json['docu_sender'] ?? '',
      docuId: json['docuId'] ?? 0,
      scanned_docu_user_id: json['scanned_docu_user_id'] ?? 0,
      office_name: json['office_name'] ?? '',
      time_scanned: json['time_scanned'] ?? '',
      status: json['status'] ?? '',
    );
  }

  String getFormattedDateTime() {
    if (time_scanned != null) {
      final parsedDateTime = DateTime.parse(time_scanned!);
      final formattedDate = DateFormat('MM/dd/yyyy').format(parsedDateTime);
      final formattedTime = DateFormat('hh:mm a').format(parsedDateTime);
      return '$formattedDate - $formattedTime';
    }
    return '';
  }

  static List<TrackingProgressDetails> fromJsonList(List<dynamic> list) {
    return List<TrackingProgressDetails>.from(list.map((json) => TrackingProgressDetails.fromJson(json)));
  }

  @override
  String toString() {
    return 'TrackingProgressDetail(docu_dateNtime_created: $docu_dateNtime_created, docu_sender: $docu_sender, docuId: $docuId, scanned_docu_user_id: $scanned_docu_user_id, office_name: $office_name, time_scanned: $time_scanned, status: $status)';
  }
}

class OutgoingTrackingProgressDisplay {
  String? docu_dateNtime_released;
  String? docu_sender;
  int? docuId;
  int? scanned_docu_user_id;
  String? office_name;
  String? upload_dateNtime;
  String? status;

  OutgoingTrackingProgressDisplay({
    required this.docu_dateNtime_released,
    required this.docu_sender,
    required this.docuId,
    required this.scanned_docu_user_id,
    required this.office_name,
    required this.upload_dateNtime,
    required this.status,
  });
}

class _DocuTrackingProgressState extends State<DocuTrackingProgress> {
  var api_url = dotenv.env['API_URL'];

  SelectedDocuDetails? selectedDocuDetails;
  OutgoingDocuTrackingProgressState? outgoingDocuTrackingProgressState;

  late Timer _timer;

  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedDocuDetails = Provider.of<SelectedDocuDetails>(context, listen: false);
    fetchOutgoingDocumentTrackingProgress;


    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print('Timer is triggered!');
      fetchOutgoingDocumentTrackingProgress();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    outgoingDocuTrackingProgressState = Provider.of<OutgoingDocuTrackingProgressState>(context, listen: true);
  }

  void fetchDataFromProvider() {
    String? fetchedDocuId = selectedDocuDetails!.docuId;
    String? fetchedMemorandumNumber = selectedDocuDetails!.memorandum_number;
    String? fetchedDocuType = selectedDocuDetails!.docu_type;
    String? fetchedDocuTitle = selectedDocuDetails!.docu_title;
    String? fetchedDocuNTimeReleased = selectedDocuDetails!.docu_dateNtime_released;
    String? fetchedDocuRecipient = selectedDocuDetails!.docu_recipient;
    String? fetchedStatus = selectedDocuDetails!.status;


    print(fetchedDocuId);
    print(fetchedMemorandumNumber);
    print(fetchedDocuType);
    print(fetchedDocuTitle);
    print(fetchedDocuNTimeReleased);
    print(fetchedDocuRecipient);
    print(fetchedStatus);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int crossAxisCount = (width > 600) ? 4 : 2;

    return Scaffold(
      appBar: isMobile(context) ? AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 65,
        title: Text(
          'Dashboard',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
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
                                  'Document Tracking',
                                  style: GoogleFonts.poppins(
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                Text(
                                  'Outgoing Documents',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
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
                    if (MediaQuery.of(context).size.width > 600)
                    SizedBox(height: 30.0),
                    if (MediaQuery.of(context).size.width < 600)
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Document Tracking Progress',
                            style: GoogleFonts.poppins(
                              fontSize: size20_15(context),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          width: 7,
                          height: 7,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          'Outgoing',
                          style: GoogleFonts.poppins(
                            fontSize: size15_12(context),
                            color: Colors.black,
                          ),
                        ),
                      ],
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
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: (isWeb(context)) ? 290 : (isMobile(context) ? 85 : 85),
                            columns: [
                              DataColumn(label: Text('Order No.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  )
                              )),
                              DataColumn(label: Text('Document Type',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  )
                              )),
                              DataColumn(label: Text('Subject',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  )
                              )),
                              DataColumn(label: Text('Date/Time Released',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  )
                              )),
                              DataColumn(label: Text('Recipient/\s',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ))),
                              DataColumn(label: Text('Status',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ))),
                            ],
                            rows: [
                              DataRow(cells: [
                                DataCell(Text(selectedDocuDetails!.memorandum_number ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                  ),
                                )),
                                DataCell(Text(selectedDocuDetails!.docu_type ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                  ),
                                )),
                                DataCell(Text(selectedDocuDetails!.docu_title ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                  ),
                                )),
                                DataCell(Text(selectedDocuDetails!.docu_dateNtime_released ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                  ),
                                )),
                                DataCell(Text(selectedDocuDetails!.docu_recipient ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                  ),
                                )),
                                DataCell(Text(selectedDocuDetails!.status ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: _getStatusColor(selectedDocuDetails!.status)
                                  ),
                                )),
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Document',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              height: 2,
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(width: 8),
                              Text(
                                'Status',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  height: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Consumer<OutgoingDocuTrackingProgressState>(
                      builder: (context, outgoingDocuTrackingProgressState, child) {

                        List<TrackingProgressDetails> items = outgoingDocuTrackingProgressState.trackingProgressDetailList;

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
                                TrackingProgressDetails item = items[index];

                                return ListTile(
                                  title: Text(
                                    item.getFormattedDateTime(),
                                    // item.time_scanned.toString(),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                  subtitle: Text(item.office_name.toString(),
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                  trailing: Text(item.status.toString(),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      color: _getStatusColor(item.status.toString()),
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

                    Consumer<SelectedDocuDetails>(
                      builder: (context, selectedDocuDetails, child) {

                        DocumentDetailList item = DocumentDetailList(
                          docu_dateNtime_created: selectedDocuDetails.docu_dateNtime_created,
                          docu_sender: selectedDocuDetails.docu_sender,
                          status: selectedDocuDetails.status,
                        );

                        return Container(
                          height: 200,
                          child: ListTile(
                            title: Text(
                              item.getFormattedDateTime(item.docu_dateNtime_created),
                              // item.docu_dateNtime_created.toString(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                            subtitle: Text(item.docu_sender.toString(),
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            trailing: Text(item.status.toString(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                color: _getStatusColor(item.status.toString()),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
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

  Color _getStatusColor(String? status) {
    if (status == 'Received') {
      return Colors.green;
    }  else {
      return Colors.grey;
    }
  }


  Future<void> fetchOutgoingDocumentTrackingProgress() async {
    try {
      final String? docuId = selectedDocuDetails!.docuId;

      if (docuId == null) {
        print('Error: docuId is null');
        return;
      }

      final response = await http.get(
        Uri.parse('$api_url/api/scanner/getOutgoingDocumentTrackingProgress/document_id=$docuId'),
        headers:{
          'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",
        },
      );

      print(response);

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print(responseData);

        if (responseData is List) {
          List<TrackingProgressDetails> trackingProgressDetailList = List<TrackingProgressDetails>.from(
            responseData.map((json) => TrackingProgressDetails.fromJson(json)),
          );


          outgoingDocuTrackingProgressState!.setOutgoingDocuTrackingProgress(trackingProgressDetailList);

          print(trackingProgressDetailList);
        } else {
          print("Error: responseData is not a List");
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

}
