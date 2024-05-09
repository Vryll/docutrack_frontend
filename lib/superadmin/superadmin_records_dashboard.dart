import 'package:docutrack_main/main.dart';
import 'package:flutter/material.dart';
import 'package:docutrack_main/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/custom_widget/custom_superadmin_sideNavBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:docutrack_main/superadmin/list_scanned_records.dart';
import 'package:intl/intl.dart';
import 'package:docutrack_main/localhost.dart';

class RecordsDashboard extends StatefulWidget {
  const RecordsDashboard({super.key});

  @override
  State<RecordsDashboard> createState() => _RecordsDashboardState();
}

class ReceiveRecordDetail{
  final int? docu_details_id;
  final String? docu_title;
  final String? memorandum_number;
  final String? status;
  final String? type;
  final int? user_staff_id;
  final String? admin_office;
  final String? first_name;
  final String? last_name;
  final String? time_scanned;


  ReceiveRecordDetail({
    required this.docu_details_id,
    required this.docu_title,
    required this.memorandum_number,
    required this.status,
    required this.type,
    required this.user_staff_id,
    required this.admin_office,
    required this.first_name,
    required this.last_name,
    required this.time_scanned,

  });
}

class SelectedScannedDocument {
  String? memorandum_number;
  String? docu_type;
  String? docu_title;
  String? docu_dateNtime_created;
  String? docu_sender;
  String? docu_status;

  SelectedScannedDocument({
    this.memorandum_number,
    this.docu_type,
    this.docu_title,
    this.docu_dateNtime_created,
    this.docu_sender,
    this.docu_status,
  });

  factory SelectedScannedDocument.fromJson(Map<String, dynamic> json) {
    return SelectedScannedDocument(
      memorandum_number: json['memorandum_number'],
      docu_type: json['docu_type'],
      docu_title: json['docu_title'],
      docu_dateNtime_created: json['docu_dateNtime_created'],
      docu_sender: json['docu_sender'],
      docu_status: json['docu_status'],
    );
  }

  String getFormattedDateTime() {
    if (docu_dateNtime_created != null) {
      final parsedDateTime = DateTime.parse(docu_dateNtime_created!);
      final formattedDate = DateFormat('MM/dd/yyyy').format(parsedDateTime);
      final formattedTime = DateFormat('hh:mm a').format(parsedDateTime);
      return '$formattedDate - $formattedTime';
    }
    return '';
  }
}

class ReceiversInformation{
  int? user_id;
  String? role;
  String? office_name;
  String? email;
  String? first_name;
  String? middle_name;
  String? last_name;
  String? time_scanned;

  ReceiversInformation({
    required this.user_id,
    required this.role,
    required this.office_name,
    required this.email,
    required this.first_name,
    required this.middle_name,
    required this.last_name,
    required this.time_scanned,
  });

  factory ReceiversInformation.fromJson(Map<String, dynamic> json) {
    return ReceiversInformation(
        user_id: json['user_id'],
        role: json['role'],
        office_name:json['office_name'],
        email: json['email'],
        first_name:json['first_name'],
        middle_name: json['middle_name'],
        last_name: json['last_name'],
        time_scanned: json['time_scanned'],
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


  static List<ReceiversInformation> fromJsonList(List<dynamic>list){
    List<ReceiversInformation> receiversInformationList = [];
    for(var json in list){
      receiversInformationList.add(ReceiversInformation.fromJson(json));
    }
    return receiversInformationList;
  }

  @override
  String toString(){
    return 'ReceiversInformation(user_id: $user_id, role: $role,office_name: $office_name,email: $email,first_name: $first_name,middle_name: $middle_name,last_name: $last_name, time_scanned: $time_scanned)';
  }
}


class _RecordsDashboardState extends State<RecordsDashboard> {
  var api_url = dotenv.env['API_URL'];

  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;
  ScrollController _scrollController = ScrollController();


  int? docu_details_id;
  String? docu_title;
  String? memorandum_number;
  String? status;
  String? type;
  int? user_staff_id;
  String? first_name;
  String? last_name;
  String? time_scanned;

  ReceiversRecordDetailsDashboard? receiversRecordDetailsDashboard;
  ScannedRecordCountState? scannedRecordCountState;
  SelectedScannedDocu? selectedScannedDocu;
  ReceiverData? receiverData;

  TextEditingController searchController = TextEditingController();
  late List<ReceiversRecordDetails> defaultData;
  List<ReceiversRecordDetails> dataTableSource = [];

  void filterData(String query) {
    if (receiversRecordDetailsDashboard != null) {
      List<ReceiversRecordDetails> filteredList;

      if (query.isNotEmpty) {
        List<String> queryWords = query.toLowerCase().split(' ');

        filteredList = receiversRecordDetailsDashboard!
            .receiversRecordDetails
            .where((docu) {

          String allRecipients = ((docu.first_name ?? '') + ' ' + (docu.last_name ?? '')).toLowerCase();


          return queryWords.every((word) =>
          docu.memorandum_number!.toLowerCase().contains(word) ||
              docu.docu_title!.toLowerCase().contains(word) ||
              docu.status!.toLowerCase().contains(word) ||
              docu.admin_office!.toLowerCase().contains(word)||
              docu.time_scanned!.toLowerCase().contains(word)||
              allRecipients.contains(word)
          );
        })
            .toList();
      } else {

        filteredList = defaultData;
      }


      receiversRecordDetailsDashboard!.setReceiversRecordDetailsDashboard(filteredList);
    }
  }


  @override
  void initState(){
    super.initState();
    receiversRecordDetailsDashboard = Provider.of<ReceiversRecordDetailsDashboard>(context, listen: false);
    selectedScannedDocu = Provider.of<SelectedScannedDocu>(context, listen: false);
    receiverData = Provider.of<ReceiverData>(context, listen: false);
    defaultData = receiversRecordDetailsDashboard!.receiversRecordDetails;
    refreshDataTableSource();
  }


  void refreshDataTableSource() {
    dataTableSource = defaultData;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile(context) ? AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 65,
        title: Text(
          'Scanned Documents',
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
      body: Consumer<ReceiversRecordDetailsDashboard>(
          builder: (context, receiversRecordDetailsDashboard, child) {
            dataTableSource =
                receiversRecordDetailsDashboard.receiversRecordDetails;
            return Row(
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
                          if (MediaQuery
                              .of(context)
                              .size
                              .width > 600)
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Documents',
                                    style: GoogleFonts.poppins(
                                      fontSize: 45,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
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
                          if (MediaQuery
                              .of(context)
                              .size
                              .width > 600)
                            const SizedBox(height: 30),

                          //Table
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
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      width: isMobile(context) ? 180 : 250.0,
                                      height: 35,
                                      child: TextField(
                                        controller: searchController,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              top: 2),
                                          hintText: 'Search',
                                          prefixIcon: Icon(Icons.search),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius
                                                .circular(
                                                20.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: primaryColor,
                                            ),
                                            borderRadius: BorderRadius
                                                .circular(20.0),
                                          ),
                                        ),
                                        onChanged: (value) {

                                          filterData(value);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Scrollbar(
                                    controller: _scrollController,
                                    trackVisibility: true,
                                    child: SingleChildScrollView(
                                      controller: _scrollController,
                                      scrollDirection: Axis.horizontal,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: DataTable(
                                          columnSpacing: (isWeb(context)) ? 322 : (isMobile(context) ? 150: 150),
                                          columns: [
                                            DataColumn(
                                              label: Text(
                                                'Order No.',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Document Type',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Subject',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Actions',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15
                                                ),
                                              ),
                                            ),
                                          ],
                                          rows: rowData(dataTableSource),
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
            );
          }
      ),


    );
  }
  Card buildCard(String title, String count, Color color) {
    return Card(
      color: color,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
              ),
              Text(
                count,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 45,
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

  List<DataRow> rowData(List<ReceiversRecordDetails> source) {
    return source.map((_receiversRecordDetails) =>
        DataRow(cells: [
          DataCell(Text(_receiversRecordDetails.memorandum_number ?? '',
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          )),
          DataCell(Text(_receiversRecordDetails.type ?? '',
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          )),
          DataCell(Text(_receiversRecordDetails.docu_title ?? '',
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          )),
          DataCell(
            IconButton(
              icon: Icon(Icons.remove_red_eye_outlined),
              onPressed: () async {
                try{
                  SelectedScannedDocument scannedDoc = await fetchSelectedScannedDocument(_receiversRecordDetails.docu_details_id!);
                  await fetchReceiversInformation(_receiversRecordDetails.docu_details_id!);
                  print(scannedDoc);
                }catch(e){
                  print('error: $e');
                }
                Navigator.of(context).push(
                 MaterialPageRoute(builder: (context) => ListScannedRecords())
               );
              },
            ),
          ),
        ]),
    ).toList();
  }

  Future<SelectedScannedDocument> fetchSelectedScannedDocument(int docuId) async {
    final response = await http.get(Uri.parse('${api_url}/api/scanner/getScanned_document/$docuId'),
      headers:{'Accept': 'application/json',
        "ngrok-skip-browser-warning": "$localhost_port",

      },
    );
    print(response);

    if (response.statusCode == 200) {

      var data = jsonDecode(response.body);
      var scannedDocData = data['scanned_data'];

      if (scannedDocData != null) {
        SelectedScannedDocument scannedDoc = SelectedScannedDocument.fromJson(scannedDocData as Map<String, dynamic>);
        selectedScannedDocu!.setSelectedScannedDocu(
            scannedDoc.memorandum_number!,
            scannedDoc.docu_type!,
            scannedDoc.docu_title!,
            scannedDoc.docu_dateNtime_created!,
            scannedDoc.docu_sender!,
            scannedDoc.docu_status!
        );

        return scannedDoc;
      } else {
        throw Exception('Scanned document data is not available');
      }
    } else {
      print('Error Status Code: ${response.statusCode}');
      print('Error Response Body: ${response.body}');
      throw Exception('Failed to load SelectedScannedDocument: Status Code ${response.statusCode}');
    }
  }

  Future<void> fetchReceiversInformation(int docuId) async {
    try {
      final response = await http.get(Uri.parse('${api_url}/api/scanner/getReceivers_scanned_docu/$docuId'),
        headers:{'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",

        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);

          if(responseData['receiver_data'] is List) {
            List<ReceiversInformation> receiversInformationList = List<ReceiversInformation>.from(
              responseData['receiver_data'].map((json)=>ReceiversInformation.fromJson(json)),
            );

            print(receiversInformationList);
            receiverData!.setReceiverData(receiversInformationList);
          }
        }else{
        print('error!');
      }
    } catch (e) {
      print('error: $e');
      throw e;
    }
  }
}
