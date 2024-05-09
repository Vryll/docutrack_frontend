import 'package:flutter/material.dart';
import 'package:docutrack_main/style.dart';
import 'package:docutrack_main/custom_widget/custom_side_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:docutrack_main/main.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:docutrack_main/localhost.dart';

class Admin_Archived extends StatefulWidget {
  Admin_Archived({Key? key}) : super(key: key);

  @override
  State<Admin_Archived> createState() => _Admin_ArchivedState();
}

class ArchivedDocumentDetails{
  final int? docu_id;
  final String? memorandum_number;
  final String? docu_title;
  final String? docu_type;
  final String? docu_status;
  final String? docu_sender;
  final String? docu_dateNtime_released;
  final String? docu_dateNtime_created;
  final List<dynamic>? docu_recipient;
  final String? docu_file;
  bool? is_deleted;
  final String? deleted_at;
  int? archivedCount;

  ArchivedDocumentDetails({
    required this.docu_id,
    required this.memorandum_number,
    required this.docu_title,
    required this.docu_type,
    required this.docu_status,
    required this.docu_sender,
    required this.docu_dateNtime_released,
    required this.docu_dateNtime_created,
    required this.docu_recipient,
    required this.docu_file,
    required this.is_deleted,
    required this.deleted_at,
    required this.archivedCount,
  });

  factory ArchivedDocumentDetails.fromJson(Map<String, dynamic>json){
    return ArchivedDocumentDetails(
        docu_id: json['docu_id'] ?? 0,
        memorandum_number: json['memorandum_number'] ?? '',
        docu_title: json['docu_title'] ?? '',
        docu_type: json['docu_type']?? '' ,
        docu_status: json['docu_status'] ?? '',
        docu_sender: json['docu_sender'] ?? '',
        docu_dateNtime_released: json['docu_dateNtime_released'] ?? '',
        docu_dateNtime_created: json['docu_dateNtime_created']?? '' ,
        docu_recipient: json['docu_recipient'] ?? [],
        docu_file: json['docu_file']?? '' ,
        is_deleted: json['is_deleted']?? '',
        deleted_at: json['deleted_at']?? '',
        archivedCount: json['archivedCount'] ?? 0,
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

  static List<ArchivedDocumentDetails> fromJsonList(List<dynamic>list){
   return list.map((json) => ArchivedDocumentDetails.fromJson(json)).toList();
  }

  @override
  String toStirng(){
    return 'ArchivedDocumentDetails(docu_id: $docu_id,memorandum_number:$memorandum_number,docu_title: $docu_title, docu_type:$docu_type,docu_status:$docu_status,docu_sender: $docu_sender,docu_dateNtime_released: $docu_dateNtime_released, docu_dateNtime_created: $docu_dateNtime_created,docu_recipient: $docu_recipient,docu_file: $docu_file, is_deleted: $is_deleted,deleted_at: $deleted_at, archivedCount: $archivedCount)';
  }
}

class _Admin_ArchivedState extends State<Admin_Archived> with WidgetsBindingObserver{
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;

  //PACKAGE IMPLEMENTATION
  var api_url = dotenv.env['API_URL'];

  late Timer _timer;
  bool dataFetched = false;
  bool _isPageActive = true;


  //APPSTATE PROVIDER
  UserIdState? userIdState;
  ArchivedDocuDetailsState? archivedDocuDetailsState;



  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    _timer.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

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
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print('Timer is triggered!');

      fetchArchivedDocuDetails();
    });
  }
  void resumeTimer() {
    dataFetched = false;
    startTimer();
  }

  void pauseTimer() {
    _timer.cancel();
  }


  @override
  void initState(){
    super.initState();
    userIdState = Provider.of<UserIdState>(context, listen: false);
    fetchArchivedDocuDetails();
    WidgetsBinding.instance?.addObserver(this);
    startTimer();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    archivedDocuDetailsState=Provider.of<ArchivedDocuDetailsState>(context, listen: true);
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
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              'Total: ${archivedDocuDetailsState!.archivedCount ?? 0}' ,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          /// ListView Archived Documents Here
                          Consumer<ArchivedDocuDetailsState>(

                            builder: (context, archivedDocuDetailsState, child) {
                              if (archivedDocuDetailsState != null) {
                                List<ArchivedDocumentDetails> archivedDocuDetails = archivedDocuDetailsState.archivedDocuDetailsList;
                                return SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: archivedDocuDetails.length,
                                          itemBuilder: (context, index) {
                                            ArchivedDocumentDetails archivedDocuDetail = archivedDocuDetails[index];
                                            return Slidable(
                                              startActionPane: ActionPane(
                                                motion:  const StretchMotion(),
                                                children: [
                                                  SlidableAction(
                                                    backgroundColor: Colors.green,
                                                    icon: Icons.undo,
                                                    label: 'Undo',
                                                    onPressed: (BuildContext context) async {
                                                      final docuId = archivedDocuDetail.docu_id;
                                                      try{
                                                        final response = await http.get(Uri.parse(
                                                        '${api_url}/api/documents/restoring_document_details/documentID=$docuId'),
                                                          headers:{'Accept': 'application/json',
                                                            "ngrok-skip-browser-warning": "$localhost_port",
                                                          },
                                                        );

                                                        if (response.statusCode == 200){
                                                          print('the $docuId was successfull restored!');
                                                          archivedDocuDetailsState.removeDocument(docuId.toString());
                                                          setState(() {});
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
                                                      final docuId = archivedDocuDetail.docu_id;
                                                      try{
                                                        final response = await http.delete(Uri.parse(
                                                            '${api_url}/api/documents/hard_delete_document_details/documentID=$docuId'),
                                                          headers:{'Accept': 'application/json',
                                                            "ngrok-skip-browser-warning": "$localhost_port",
                                                          },
                                                        );

                                                        if (response.statusCode == 200){
                                                          print('the $docuId was successfull hard deleted!');
                                                          archivedDocuDetailsState.removeDocument(docuId.toString());
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
                                                    archivedDocuDetail.docu_title.toString(),
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
                                                              archivedDocuDetail.docu_type.toString(),
                                                            style: GoogleFonts.poppins(
                                                              fontSize: 10,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      Text(
                                                          archivedDocuDetail.docu_sender.toString(),
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
                                                      Text(
                                                          archivedDocuDetail.docu_status.toString(),
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 12,
                                                          color: archivedDocuDetail.docu_status == 'Approved'
                                                              ? Colors.green
                                                              : archivedDocuDetail.docu_status == 'Declined'
                                                              ? Colors.red
                                                              :archivedDocuDetail.docu_status == 'Pending'
                                                              ?Colors.black
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                    Text(
                                                        archivedDocuDetail.getFormattedDateTime(),
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

  Future<void> fetchArchivedDocuDetails() async {
    try {
      if (userIdState == null || userIdState!.userId == null) {
        print('Error: userIdState or userId is null');
        return;
      }
      final userId = userIdState!.userId;
      print(userId);

      final response = await http.get(
        Uri.parse('$api_url/api/documents/getSoftDeleted_outgoing_document_details/user_id=$userId'),
        headers:{'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",

        },
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print(responseData);


        final archivedCount = responseData['archived_docu_count'];
        final archivedDocuments = responseData['archived_document_details'];

        if (archivedDocuments is List) {
          List<ArchivedDocumentDetails> archivedDocuDetailsList =
          archivedDocuments.map((docu) => ArchivedDocumentDetails.fromJson(docu)).toList();


          archivedDocuDetailsState!.setArchivedDocuDetailsState(archivedDocuDetailsList);
          archivedDocuDetailsState!.setArchivedCount(archivedCount);
          print(archivedDocuDetailsList);
        } else {
          print('Invalid response data format');
        }
      } else {
        print('HTTP request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }



  void _onDismissed() {
  }
}

