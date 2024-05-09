import 'package:flutter/material.dart';
import 'package:docutrack_main/style.dart';
// import 'package:docutrack_main/custom_widget/staff_custom_nav_bar.dart';
import 'package:docutrack_main/custom_widget/custom_superadmin_sideNavBar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:docutrack_main/main.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:docutrack_main/localhost.dart';

class Superadmin_Archived extends StatefulWidget {
  Superadmin_Archived({Key? key}) : super(key: key);

  @override
  State<Superadmin_Archived> createState() => _Superadmin_ArchivedState();
}

class ArchivedScannedReceiveRecordDetails{
  final int? archived_records_count;
  final int? record_id;
  final int? docu_details_id;
  final String? docu_title;
  final String? memorandum_number;
  final String? status;
  final String? type;
  final int? user_staff_id;
  final String? admin_office;
  final String? first_name;
  final String? last_name;
  final String? recipient_status;
  final String? time_scanned;
  bool? is_deleted;

  ArchivedScannedReceiveRecordDetails({
    required this.archived_records_count,
    required this.record_id,
    required this.docu_details_id,
    required this.docu_title,
    required this.memorandum_number,
    required this.status,
    required this.type,
    required this.user_staff_id,
    required this.admin_office,
    required this.first_name,
    required this.last_name,
    required this.recipient_status,
    required this.time_scanned,
    required this.is_deleted,
  });

  factory ArchivedScannedReceiveRecordDetails.fromJson(Map<String, dynamic>json){
    return ArchivedScannedReceiveRecordDetails(
        archived_records_count: json['archived_records_count'] ?? 0,
        record_id: json['record_id'] ?? 0,
        docu_details_id: json['docu_details']['docu_details_id'] ?? 0,
        docu_title: json['docu_details']['docu_title'] ?? '',
        memorandum_number: json['docu_details']['memorandum_number'] ?? '',
        status: json['docu_details']['status'] ?? '',
        type: json['docu_details']['type'] ?? '',
        user_staff_id: json['user_staff']['user_staff_id'] ?? 0,
        admin_office: json['user_staff']['admin_office'] ?? '',
        first_name: json['user_staff']['first_name'] ?? '',
        last_name: json['user_staff']['last_name'] ?? '',
        recipient_status: json['recipient_status'] ?? '',
        time_scanned: json['time_scanned'] ?? '',
        is_deleted: json['is_deleted'] ?? '',
    );
  }

   static List<ArchivedScannedReceiveRecordDetails> fromJsonList(List<dynamic>list){
    return list.map((json)=> ArchivedScannedReceiveRecordDetails.fromJson(json)).toList();
   }

   @override
   String toString(){
    return 'ArchivedScannedReceiveRecordDetails(archived_records_count: $archived_records_count, record_id: $record_id,docu_details_id: $docu_details_id,docu_title: $docu_title,memorandum_number: $memorandum_number, status: $status,type: $type ,user_staff_id: $user_staff_id, admin_office: $admin_office, first_name: $first_name, last_name: $last_name, time_scanned: $time_scanned, is_deleted: $is_deleted )';
   }
}

class _Superadmin_ArchivedState extends State<Superadmin_Archived>  with WidgetsBindingObserver{
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;

  //PACKAGE IMPLEMENTATION
  var api_url = dotenv.env['API_URL'];


  late Timer _timer;
  bool dataFetched = false;
  bool _isPageActive = true;

  UserIdState? userIdState;
  ArchivedScannedReceivedRecordState? archivedScannedReceivedRecordState;

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    _timer.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Handle app lifecycle changes
    if (state == AppLifecycleState.resumed) {
      _isPageActive = true;
      resumeTimer();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _isPageActive = false;
      pauseTimer();
    }
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      print('Timer is triggered!');

      fetchArchivedScannedReceivedRecords();
    });
  }

  void resumeTimer() {
    dataFetched = false;
    // startTimer();
  }

  void pauseTimer() {
    _timer.cancel();
  }

  @override
  void initState(){
    super.initState();
    userIdState = Provider.of<UserIdState>(context, listen: false);
    fetchArchivedScannedReceivedRecords();
    WidgetsBinding.instance?.addObserver(this);
    startTimer();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    // workspaceDocuDetailState = Provider.of<WorkspaceDocuDetailState>(context, listen: true);
    archivedScannedReceivedRecordState = Provider.of<ArchivedScannedReceivedRecordState>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: isMobile(context) ? AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          toolbarHeight: 65,
          title: Text(
            'Archived',
            style: GoogleFonts.poppins(
              fontSize: 22,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (MediaQuery.of(context).size.width > 600)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Archived',
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
                    if (MediaQuery.of(context).size.width > 600)
                      const SizedBox(height: 30),
                    Container(
                      // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                      // constraints: const BoxConstraints(maxWidth: 700),
                      // decoration: BoxDecoration(
                      //   color: Colors.white,
                      //   borderRadius: BorderRadius.circular(5.0),
                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: Colors.black.withOpacity(0.4),
                      //       blurRadius: 1.0,
                      //       offset: Offset(0, 1),
                      //     ),
                      //   ],
                      // ),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              'Total: ${archivedScannedReceivedRecordState!.archivedRecordsCount?.toString() ?? '0'}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          /// ListView Archived Documents Here
                          Consumer<ArchivedScannedReceivedRecordState>(
                            builder: (context, archivedScannedReceivedRecordState, child) {
                              if (archivedScannedReceivedRecordState != null) {
                                List<ArchivedScannedReceiveRecordDetails> archivedScannedReceiveRecordDetails = archivedScannedReceivedRecordState!.archivedScannedReceiveRecordDetailsList;
                                return SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: archivedScannedReceiveRecordDetails.length,
                                          itemBuilder: (context, index) {
                                            ArchivedScannedReceiveRecordDetails archivedScannedReceiveRecordDetail = archivedScannedReceiveRecordDetails[index];
                                            return Slidable(
                                              startActionPane: ActionPane(
                                                motion:  const StretchMotion(),
                                                children: [
                                                  SlidableAction(
                                                    backgroundColor: Colors.green,
                                                    icon: Icons.undo,
                                                    label: 'Undo',
                                                    onPressed: (BuildContext context) async {
                                                      final recordId= archivedScannedReceiveRecordDetail.record_id;
                                                      try{
                                                        final response = await http.get(Uri.parse(
                                                            '${api_url}/api/scanner/restoring_receive_record/record_id=$recordId'));

                                                        if (response.statusCode == 200){
                                                          archivedScannedReceivedRecordState!.removeDocument(recordId.toString());
                                                          setState(() {});
                                                          print('the $recordId was successfull restored!');
                                                        }
                                                      }catch(e){
                                                        print('error: $e');
                                                      }
                                                    },
                                                  ),

                                                ],
                                              ),
                                              endActionPane: ActionPane(
                                                motion: const BehindMotion(),
                                                children: [
                                                  SlidableAction(
                                                    backgroundColor: Colors.red,
                                                    icon: Icons.delete,
                                                    label: 'Delete',
                                                    onPressed: (BuildContext context) async {
                                                      final recordId= archivedScannedReceiveRecordDetail.record_id;
                                                      try{
                                                        final response = await http.get(Uri.parse(
                                                            '${api_url}/api/scanner/hard_delete_receive_record/record_id=$recordId'));

                                                        print(response);
                                                        if(response.statusCode == 200){
                                                          print('the $recordId was successfull hard deleted!');
                                                          archivedScannedReceivedRecordState!.removeDocument(recordId.toString());
                                                          setState(() {});
                                                        }
                                                      }catch(e){
                                                        print('error: $e');
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[50],
                                                  border: Border(
                                                    bottom: BorderSide(color: Colors.grey),
                                                  ),
                                                ),
                                                child: ListTile(
                                                    title: Text(
                                                      archivedScannedReceiveRecordDetail.docu_title.toString(),
                                                      style: GoogleFonts.poppins(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 15,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '${archivedScannedReceiveRecordDetail.type.toString()}:',
                                                              style: GoogleFonts.poppins(
                                                                fontSize: 10,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                            SizedBox(width: 2),
                                                            Text(
                                                              archivedScannedReceiveRecordDetail.memorandum_number.toString(),
                                                              style: GoogleFonts.poppins(
                                                                fontSize: 10,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                        Text(
                                                          '${archivedScannedReceiveRecordDetail.first_name} ${archivedScannedReceiveRecordDetail.last_name}',
                                                          style: GoogleFonts.poppins(
                                                            fontSize: 10,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // Text(
                                                        //   archivedDocuDetail.docu_status.toString(),
                                                        //   style: GoogleFonts.poppins(
                                                        //     fontSize: 12,
                                                        //     color: archivedDocuDetail.docu_status == 'Approved'
                                                        //         ? Colors.green
                                                        //         : archivedDocuDetail.docu_status == 'Declined'
                                                        //         ? Colors.red
                                                        //         :archivedDocuDetail.docu_status == 'Pending'
                                                        //         ?Colors.black
                                                        //         : Colors.grey, // Default color if not Approved or Revise
                                                        //   ),
                                                        // ),
                                                        Text(
                                                          archivedScannedReceiveRecordDetail.time_scanned.toString(),
                                                          style: GoogleFonts.poppins(
                                                            color: Colors.grey,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],

                                  ),
                                );
                              } else {

                                return Container();
                              }
                            },
                          )
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
  Future<void>fetchArchivedScannedReceivedRecords()async{
    try{
      final response = await http.get(Uri.parse(
        '${api_url}/api/scanner/getArchived_scanned_receive_records'),
        headers:{
          'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",
        },
      );

      if(response.statusCode == 200){
        final dynamic responseData = json.decode(response.body);

        final archivedRecordsCount = responseData['archived_records_count'];
        final archivedRecordsDocument = responseData['archived_records_data'];

        if(archivedRecordsDocument is List){
          List<ArchivedScannedReceiveRecordDetails> archivedScannedReceiveRecordDetailsList =
              archivedRecordsDocument.map((docu)=>ArchivedScannedReceiveRecordDetails.fromJson(docu)).toList();

          archivedScannedReceivedRecordState!.setArchivedScannedReceivedRecord(archivedScannedReceiveRecordDetailsList);
          archivedScannedReceivedRecordState!.setArchivedScannedRecordsCount(archivedRecordsCount);
          print('successfully fetched');
        }else{
          print('Invalid response data format');
        }
      }else{
        print('HTTP request failed with status code: ${response.statusCode}');
      }
    }catch(e){
      print('error: $e');
    }
  }
  void _onDismissed() {

  }
}

