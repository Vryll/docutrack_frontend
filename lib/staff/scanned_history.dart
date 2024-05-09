import 'package:docutrack_main/main.dart';
import 'package:flutter/material.dart';
import 'package:docutrack_main/style.dart';
import 'package:docutrack_main/custom_widget/staff_custom_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:docutrack_main/staff/clerk_scanned_docu_tracking_progress.dart';

class ClerkScannedHistory extends StatefulWidget {
  const ClerkScannedHistory({super.key});

  @override
  State<ClerkScannedHistory> createState() => _ClerkScannedHistoryState();
}

class ClerkScannedDocuTrackingProgressDetails{
  String? role;
  String? first_name;
  String? last_name;
  String? office_name;
  String? time_scanned;

  ClerkScannedDocuTrackingProgressDetails({
    required this.role,
    required this.first_name,
    required this.last_name,
    required this.office_name,
    required this.time_scanned,
  });
  factory ClerkScannedDocuTrackingProgressDetails.fromJson(Map<String, dynamic> json) {
    return ClerkScannedDocuTrackingProgressDetails(
      role: json['role'] ?? '',
      first_name: json['first_name'] ?? '',
      last_name: json['last_name'],
      office_name: json['office_name'] ?? '',
      time_scanned: json['time_scanned'] ?? '',
    );
  }

  String getFormattedDateTime(String? dateTime) {
    if (dateTime != null) {
      final parsedDateTime = DateTime.parse(dateTime);
      final formattedDate = DateFormat('MM/dd/yyyy').format(parsedDateTime);
      final formattedTime = DateFormat('hh:mm a').format(parsedDateTime);
      return '$formattedDate - $formattedTime';
    }
    return '';
  }

  static List<ClerkScannedDocuTrackingProgressDetails> fromJsonList(List<dynamic> list) {
    return list.map((json) => ClerkScannedDocuTrackingProgressDetails.fromJson(json)).toList();
  }
  @override
  String toString() {
    return 'ClerkScannedDocuTrackingProgressDetails(role: $role, first_name: $first_name,last_name: $last_name ,office_name: $office_name ,time_scanned: $time_scanned)';
  }
}

class _ClerkScannedHistoryState extends State<ClerkScannedHistory> {
  var api_url = dotenv.env['API_URL'];
  Color? selectedTileColor = Colors.transparent;

  ClerkScannedHistoryState? clerkScannedHistoryState;
  ClerkScannedtrackingProgressState? clerkScannedtrackingProgressState;

  @override
  void initState(){
    super.initState();
    clerkScannedHistoryState = Provider.of<ClerkScannedHistoryState>(context, listen: false);
    clerkScannedtrackingProgressState = Provider.of<ClerkScannedtrackingProgressState>(context, listen: false);
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    // workspaceDocuDetailState = Provider.of<WorkspaceDocuDetailState>(context, listen: true);
    clerkScannedHistoryState = Provider.of<ClerkScannedHistoryState>(context, listen: true);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 65,
        leading: Row(
          children: [
            Builder(
              builder: (context) => IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu),
                color: secondaryColor,
              ),
            ),

          ],
        ),
        centerTitle: true,
        title: Text(
          'Scanned History',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
        ),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          //   icon: const Icon(Icons.arrow_back),
          //   color: secondaryColor,
          // ),
        ],
        automaticallyImplyLeading: false,
      ),

      ///Body or the content
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                        ],
                      )
                    ],
                  ),
                ),

                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    ///input the consumer build for total number of scanned items(check staff_archived.dart)
                    child: Consumer<ClerkScannedHistoryState>(
                      builder: (context, clerkScannedHistoryState, child) {
                        return Container(
                          child: Text(
                            'Total: ${clerkScannedHistoryState.scannedRecordCount?.toString() ?? '0'}',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(height: 10.0),

                ///input the consumer build for the tilelist of the scanned items(check staff_archived.dart)
                Consumer<ClerkScannedHistoryState>(
                  builder: (context, clerkScannedHistoryState, child) {
                    if (clerkScannedHistoryState != null) {
                      List<ClerkScannedDocumentDetails> clerkScannedDetails =
                          clerkScannedHistoryState.clerkScannedDocumentDetailList;

                      return Expanded(
                        child: ListView.builder(
                          itemCount: clerkScannedDetails.length,
                          itemBuilder: (context, index) {
                            ClerkScannedDocumentDetails clerkScannedDocuDetail =
                            clerkScannedDetails[index];

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey),
                                ),
                              ),
                              child: ListTile(
                                onTap: () async{
                                  int docuId = clerkScannedDocuDetail.docuId!;

                                  try{
                                    final response = await http.get(Uri.parse('${api_url}/api/scanner/getClerkScannedDocuTrackingProgress/docuId=$docuId'));

                                    if (response.statusCode == 200){
                                      final dynamic responseData = json.decode(response.body);
                                      final  clerkScannedRecordTrackingProgressCount = responseData['count'];
                                      final clerkScannedRecordTrackingProgress = responseData['data'];

                                      if(clerkScannedRecordTrackingProgress is List){
                                        List<ClerkScannedDocuTrackingProgressDetails> clerkScannedDocuTrackingList =
                                            clerkScannedRecordTrackingProgress.map((docu)=>ClerkScannedDocuTrackingProgressDetails.fromJson(docu)).toList();

                                        clerkScannedtrackingProgressState!.setClerkScannedTrackingProgress(clerkScannedDocuTrackingList);
                                        clerkScannedtrackingProgressState!.setClerkScannedTrackingProgressCount(clerkScannedRecordTrackingProgressCount);

                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context)=> ClerkTrackingProgress())
                                        );
                                      }else{
                                        print('Invalid response data format');
                                      }
                                    } else {
                                      print(
                                          'HTTP request failed with status code: ${response
                                              .statusCode}');
                                    }
                                  }catch(e){
                                    print('error: $e');
                                  }

                                },
                                title: Text(
                                  clerkScannedDocuDetail.docu_title.toString(),
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${clerkScannedDocuDetail.docu_type} | ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      '${clerkScannedDocuDetail.memorandum_number}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  (clerkScannedDocuDetail.time_scanned != null)
                                      ? (() {
                                    final parsedDateTime = DateTime.parse(clerkScannedDocuDetail.time_scanned.toString());
                                    final formattedDate = DateFormat('MM/dd/yyyy').format(parsedDateTime);
                                    final formattedTime = DateFormat('hh:mm a').format(parsedDateTime);
                                    return '$formattedDate - $formattedTime';
                                  })()
                                      : '',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {

                      return CircularProgressIndicator();
                    }
                  },
                )

              ],
            ),
          )
        ]
      ),


      drawer: SideNav(),
    );
  }
}
