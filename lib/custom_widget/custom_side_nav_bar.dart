import 'package:docutrack_main/admin/admin_archived.dart';
import 'package:docutrack_main/admin/outgoing_documents/admin_dashboard.dart';
import 'package:docutrack_main/admin/admin_home_page.dart';
import 'package:docutrack_main/admin/admin_main_dashboard.dart';
import 'package:docutrack_main/main.dart';
import 'package:docutrack_main/sign_in.dart';
import 'package:docutrack_main/style.dart';
import 'package:flutter/material.dart';
import 'package:docutrack_main/admin/generate_qrcode_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/admin/receive_documents/admin_recieve_dashboard.dart';
import 'package:docutrack_main/admin/requested_documents/admin_request_document.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:docutrack_main/admin/requested_documents/admin_request_dashboard.dart';
import 'package:docutrack_main/admin/admin_my_profile_page.dart';
import 'package:intl/intl.dart';
import 'package:docutrack_main/admin/workspace/admin_workspace.dart';
import 'package:docutrack_main/admin/admin_aboutUS.dart';
import 'package:docutrack_main/localhost.dart';

class SideNav extends StatefulWidget {
  const SideNav({Key? key}) : super(key: key);

  @override
  _SideNavState createState() => _SideNavState();
}

//Dart object for outgoing
class DocumentDetails {
  final String? id;
  final String? memorandum_number;
  final String? docu_type;
  final String? docu_title;
  final String? docu_dateNtime_released;
  final List<dynamic>? docu_recipient;
  final String? status;
  bool is_deleted;


  DocumentDetails({
    required this.id,
    required this.memorandum_number,
    required this.docu_type,
    required this.docu_title,
    required this.docu_dateNtime_released,
    required this.docu_recipient,
    required this.status,
    this.is_deleted = false,
  });

  factory DocumentDetails.fromJson(Map<String, dynamic> json) {
    return DocumentDetails(
      id: json['id'].toString() ?? '',
      memorandum_number: json['memorandum_number'] ?? '',
      docu_type: json['docu_type'] ?? '',
      docu_title: json['docu_title'] ?? '',
      docu_dateNtime_released: json['docu_dateNtime_released'] ?? '',
      docu_recipient: json['docu_recipient'] ?? [],
      status: json['status'] ?? '',
      is_deleted: json['is_deleted'] ?? false,
    );
  }

  static List<DocumentDetails> fromJsonList(List<dynamic> list) {
    List<DocumentDetails> docuDetailList = [];
    for (var json in list) {
      // Use the factory constructor to create a DocumentDetails instance
      docuDetailList.add(DocumentDetails.fromJson(json));
    }
    return docuDetailList;
  }

  @override
  String toString() {
    return 'DocumentDetails(id: $id, memorandum_number: $memorandum_number, docu_type: $docu_type, docu_title: $docu_title, docu_dateNtime_released: $docu_dateNtime_released, docu_recipient: $docu_recipient, status: $status, is_deleted: $is_deleted)';
  }
}


//DART OBJECT FOR WORKSPACE DOCUMENT DETAILS DASHBOARD
class WorkspaceDocumentDetails {
  final int? id;
  final String? workspace_docu_type;
  final String? workspace_docu_title;
  final String? upload_dateNtime;
  final String? first_name;
  final String? middle_name;
  final String? last_name;
  final String? workspace_docu_file;

  WorkspaceDocumentDetails({
    required this.id,
    required this.workspace_docu_type,
    required this.workspace_docu_title,
    required this.upload_dateNtime,
    required this.first_name,
    required this.middle_name,
    required this.last_name,
    required this.workspace_docu_file,
  });

  factory WorkspaceDocumentDetails.fromJson(Map<String, dynamic> json) {
    return WorkspaceDocumentDetails(
      id: json['id'] ?? '',
      workspace_docu_type: json['workspace_docu_type'] ?? '',
      workspace_docu_title: json['workspace_docu_title'] ?? '',
      upload_dateNtime: json['upload_dateNtime'] ?? '',
      first_name: json['first_name'] ?? '',
      middle_name: json['middle_name'] ?? '',
      last_name: json['last_name'] ?? '',
      workspace_docu_file: json['workspace_docu_file'] ?? '',
    );
  }

  String getFormattedDateTime() {
    if (upload_dateNtime != null) {
      final parsedDateTime = DateTime.parse(upload_dateNtime!);
      final formattedDate = DateFormat('MM/dd/yyyy').format(parsedDateTime);
      final formattedTime = DateFormat('hh:mm a').format(parsedDateTime);
      return '$formattedDate - $formattedTime';
    }
    return '';
  }


  static List<WorkspaceDocumentDetails> fromJsonList(List<dynamic> list) {
    List<WorkspaceDocumentDetails> workspaceDocumentDetailsList = [];
    for (var json in list) {
      workspaceDocumentDetailsList.add(WorkspaceDocumentDetails.fromJson(json));
    }
    return workspaceDocumentDetailsList;
  }

  @override
  String toString() {
    return 'WorkspaceDocumentDetails(id: $id, workspace_docu_type: $workspace_docu_type, workspace_docu_title: $workspace_docu_title,upload_dateNtime: $upload_dateNtime ,first_name: $first_name, middle_name: $middle_name,last_name: $last_name, workspace_docu_file: $workspace_docu_file)';
  }
}


//Dart object for recieved
class RecievedDocumenDetails{
  final String? id;
  final String? memorandum_number;
  final String? docu_type;
  final String? docu_title;
  final String? docu_dateNtime_released;
  final String? docu_sender;
  final String? status;
  bool is_deleted;

  RecievedDocumenDetails({
    required this.id,
    required this.memorandum_number,
    required this.docu_type,
    required this.docu_title,
    required this.docu_dateNtime_released,
    required this.docu_sender,
    required this.status,
    this.is_deleted = false,
  });
  factory RecievedDocumenDetails.fromJson(Map<String, dynamic>json){
    return RecievedDocumenDetails(
      id: json['id'].toString() ?? '',
      memorandum_number: json['memorandum_number'] ?? '',
      docu_type: json['docu_type'] ?? '',
      docu_title: json['docu_title'] ?? '',
      docu_dateNtime_released: json['docu_dateNtime_released'] ?? '',
      docu_sender: json['docu_sender'] ?? '',
      status: json['status'] ?? '',
      is_deleted: json['is_deleted'] ?? false,
    );
  }
  static List<RecievedDocumenDetails>fromJsonList(List<dynamic>list){
    List<RecievedDocumenDetails>recievedDocuDetailsList=[];
    for(var json in  list){
      recievedDocuDetailsList.add(RecievedDocumenDetails.fromJson(json));
    }
    return recievedDocuDetailsList;
  }

  @override
  String toString() {
    return 'DocumentDetails{id: $id, memorandum_number $memorandum_number,docu_type: $docu_type, docu_title: $docu_title, docu_dateNtime_released: $docu_dateNtime_released, docu_sender: $docu_sender, status: $status, is_deleted: $is_deleted}';
  }
}

//Dart object for Main Dashboard
class MainDocumentDetails {
  final int id;
  final String? memorandum_number;
  final String docu_type;
  final String docu_title;
  final String docu_dateNtime_released;
  final List<dynamic> docu_recipient;
  final String? status;
  final String docu_source;
  bool is_deleted;


  MainDocumentDetails({
    required this.id,
    required this.memorandum_number,
    required this.docu_type,
    required this.docu_title,
    required this.docu_dateNtime_released,
    required this.docu_recipient,
    required this.status,
    required this.docu_source,
    this.is_deleted = false,
  });

  factory MainDocumentDetails.fromJson(Map<String, dynamic> json) {
    return MainDocumentDetails(
      id: json['id'] ?? '',
      memorandum_number: json['memorandum_number'],
      docu_type: json['docu_type'] ?? '',
      docu_title: json['docu_title'] ?? '',
      docu_dateNtime_released: json['docu_dateNtime_released'] ?? '',
      docu_recipient: json['docu_recipient'] ?? '',
      status: json['status'] ,
      docu_source: json['docu_source'] ?? '' ,
      is_deleted: json['is_deleted'] ?? false,
    );
  }

  @override
  String toString() {
    return 'MainDocumentDetails{id: $id,memorandum_number: $memorandum_number ,docuType: $docu_type, docuTitle: $docu_title, docuDateNtimeReleased: $docu_dateNtime_released, docuRecipient: $docu_recipient, status: $status, docuSource: $docu_source, is_deleted: $is_deleted}';
  }
}

//DART OBJECT FOR REQUESTED DOCUMENT DASHBOARD DETAILS
class RequestDocumentDetails {
  final int? id;
  final String? process_type;
  final String? status;
  final String? requested;
  final String? docu_request_topic;
  final String? docu_request_recipient;
  final String? docu_request_deadline;
  final String? requested_docu_file;

  bool is_deleted;

  RequestDocumentDetails({
    required this.id,
    required this.process_type,
    required this.status,
    required this.docu_request_topic,
    required this.requested,
    required this.docu_request_recipient,
    required this.docu_request_deadline,
    required this.requested_docu_file,

    this.is_deleted = false,
  });

  factory RequestDocumentDetails.fromJson(Map<String, dynamic> json) {
    return RequestDocumentDetails(
      id: json['id'] ?? 0,
      status: json['status'],
      docu_request_topic: json['docu_request_topic'],
      requested: json['requested'],
      docu_request_recipient: json['docu_request_recipient'],
      docu_request_deadline: json['docu_request_deadline'],
      requested_docu_file: json['requested_docu_file'],
      process_type: json['process_type'],
      is_deleted: json['is_deleted'] ?? false,
    );
  }

  static List<RequestDocumentDetails> fromJsonList(List<dynamic> list) {
    return List<RequestDocumentDetails>.from(
      list.map((json) => RequestDocumentDetails.fromJson(json)),
    );
  }

  @override
  String toString() {
    return 'RequestDocumentDetails{id: $id, status: $status, docu_request_topic: $docu_request_topic, requested: $requested, docu_request_recipient: $docu_request_recipient, docu_request_deadline: $docu_request_deadline, requested_docu_file: $requested_docu_file, process_type: $process_type, is_deleted: $is_deleted}';
  }
}




//Incoming request document
class IncomingRequestDocumentDetails{
  final String? id;
  final String? status;
  final String? docu_request_topic;
  final String? requested;
  final String? docu_request_recipient;
  final String? docu_request_deadline;
  final String? docu_request_comment;
  final String? docu_request_file;
  final String? process_type;
  bool is_deleted;

  IncomingRequestDocumentDetails({
    required this.id,
    required this.status,
    required this.docu_request_topic,
    required this.requested,
    required this.docu_request_recipient,
    required this.docu_request_deadline,
    required this.docu_request_comment,
    required this.docu_request_file,
    required this.process_type,

    this.is_deleted = false,
  });

  factory IncomingRequestDocumentDetails.fromJson(Map<String, dynamic>json){
    return IncomingRequestDocumentDetails(
      id: json['id'].toString() ?? '',
      status: json['status'] ?? '',
      docu_request_topic: json['docu_request_topic'] ?? '',
      requested: json['requested'] ?? '',
      docu_request_recipient: json['docu_request_recipient'] ?? '',
      docu_request_deadline: json['docu_request_deadline'] ?? '',
      docu_request_comment: json['docu_request_comment'] ?? '',
      docu_request_file:json['docu_request_file'] ?? '',
      process_type:json['process_type'],
      is_deleted: json['is_deleted'] ?? false,
    );
  }
  static List<IncomingRequestDocumentDetails>fromJsonList(List<dynamic>list){
    List<IncomingRequestDocumentDetails>incomingrequestDocumentDetailsList =[];
    for(var json in list){
      incomingrequestDocumentDetailsList.add(IncomingRequestDocumentDetails.fromJson(json));
    }
    return incomingrequestDocumentDetailsList;
  }
  @override
  String toString(){
    return 'RequestedDocumentDetails{id: $id,status: $status, docu_request_topic: $docu_request_topic,requested: $requested, docu_request_recipient: $docu_request_recipient, docu_request_deadline: $docu_request_deadline, docu_request_comment: $docu_request_comment,docu_request_file: $docu_request_file,process_type: $process_type ,is_deleted: $is_deleted}';
  }
}



class MyDateTime {
  String? dateTime;

  MyDateTime({
    required this.dateTime,
  });

  factory MyDateTime.fromJson(Map<String, dynamic> json) {
    return MyDateTime(
      dateTime: json['dateTime'],
    );
  }
}

class WorkspaceDocuDetailsCount {
  int? countOVWorkspaceDocu;

  WorkspaceDocuDetailsCount({
    required this.countOVWorkspaceDocu,
  });

  factory WorkspaceDocuDetailsCount.fromJson(Map<String, dynamic> json) {
    return WorkspaceDocuDetailsCount(
      countOVWorkspaceDocu: json['overall_count'],
    );
  }
}




class _SideNavState extends State<SideNav> {
  var api_url = dotenv.env['API_URL'];
  bool isDashboardExpanded = false;
  MyappState? myAppState;
  UserIdState? userIdState;
  String jwtToken = "";
  List<Map<String, dynamic>> docuDetailsList = [];
  DocumentDetailDashboardState? documentDetailDashboardState;
  RecieveDocumentDetailDashboardState? recieveDocumentDetailDashboardState;
  UserOfficeNameState? userOfficeNameState;
  RequestedDocumentDetailDashboardState? requestedDocumentDetailDashboardState;
  IncomingRequestedDocumentDetailDashboardState? incomingRequestedDocumentDetailDashboardState;
  MainDocumentDetailDashboardState? mainDocumentDetailDashboardState;
  // AdminProfileState? adminProfileState;
  OutgoingDocuCount? outgoingDocuCount;
  WorkspaceDocumentDetailDashboardState? workspaceDocumentDetailDashboardState;
  OverallWorkspaceDocuDetailsCountState? overallWorkspaceDocuDetailsCountState;
  bool showDashboard = false;
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isTablet (BuildContext context) =>
      MediaQuery.of(context).size.width <= 800;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 800;

  @override
  void initState() {
    super.initState();
    myAppState = Provider.of<MyappState>(context, listen: false);
    userIdState = Provider.of<UserIdState>(context, listen: false);
    documentDetailDashboardState = Provider.of<DocumentDetailDashboardState>(context, listen: false);
    recieveDocumentDetailDashboardState = Provider.of<RecieveDocumentDetailDashboardState>(context, listen: false);
    userOfficeNameState = Provider.of<UserOfficeNameState>(context, listen: false);
    requestedDocumentDetailDashboardState = Provider.of<RequestedDocumentDetailDashboardState>(context, listen: false);
    incomingRequestedDocumentDetailDashboardState = Provider.of<IncomingRequestedDocumentDetailDashboardState>(context, listen: false);
    mainDocumentDetailDashboardState = Provider.of<MainDocumentDetailDashboardState>(context, listen: false);
    // adminProfileState = Provider.of<AdminProfileState>(context, listen: false);
    sendTokenToBackend(jwtToken);
    outgoingDocuCount = Provider.of<OutgoingDocuCount>(context, listen:false);
    workspaceDocumentDetailDashboardState = Provider.of<WorkspaceDocumentDetailDashboardState>(context, listen: false);
    // fetchDocumentDetails(context);
    overallWorkspaceDocuDetailsCountState= Provider.of<OverallWorkspaceDocuDetailsCountState>(context, listen: false);
    sendDateTimeToBackend;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Drawer(
        child: Container(
          color: primaryColor,
          child: Column(
            children: [
              DrawerHeader(
                padding: EdgeInsets.only(left: isTablet(context) ? 18 : 32.0, right: isMobile(context) ? 12 : 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/DocuTrack(White).png',
                      height: 50,
                      width: 50,
                    ),
                    if (isWeb(context) || isMobile(context))
                      SizedBox(width: 5),
                    if (isWeb(context) || isMobile(context))
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'DocuTrack',
                            style: GoogleFonts.russoOne(
                              color: secondaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                            maxLines: 1,
                          ),
                          Text(
                            'Document Tracking and Management System',
                            style: GoogleFonts.poppins(
                              color: secondaryColor,
                              fontSize: 5.5,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    if (isMobile(context))
                      Spacer(),
                    if (isMobile(context))
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.keyboard_arrow_left,
                            color: secondaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    MyListTile(
                      icon: Icons.house,
                      title: (isWeb(context) || isMobile(context)) ? 'Home' : '',
                      onTap: () {
                        Provider.of<SelectedItemProvider>(context, listen: false).setSelectedItem('Home');
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminHome()),
                        );
                      },
                      isSelected: Provider.of<SelectedItemProvider>(context).selectedItem == 'Home',
                    ),
                    MyListTile(
                      icon: Icons.qr_code,
                      title: (isWeb(context) || isMobile(context)) ? 'Generate QR Code' : '',
                      onTap: () async{
                        await sendTokenToBackendFetchOfficeName(jwtToken);
                        Provider.of<SelectedItemProvider>(context, listen: false).setSelectedItem('Generate QR Code');
                        Navigator.pop(context);
                        Navigator.push(
                            context, MaterialPageRoute(
                            builder: (context) => GenerateQR())
                        );
                      },
                      isSelected: Provider.of<SelectedItemProvider>(context).selectedItem == 'Generate QR Code',
                    ),
                    MyListTile(
                      icon: Icons.email_outlined,
                      title: (isWeb(context) || isMobile(context)) ? 'Request for Approval' : '',
                      onTap: () async {
                        await sendTokenToBackendFetchOfficeName(jwtToken);
                        Provider.of<SelectedItemProvider>(context, listen: false).setSelectedItem('Make a Request');
                        Navigator.pop(context);
                        Navigator.push(
                            context, MaterialPageRoute(
                          builder: (context) => RequestDocu(),
                        )
                        );
                      },
                      isSelected: Provider.of<SelectedItemProvider>(context).selectedItem == 'Make a Request',
                    ),
                    MyListTile(
                      icon: Icons.dashboard,
                      icon2: showDashboard ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      title: (isWeb(context) || isMobile(context)) ? 'Dashboard' : '',
                      onTap: () async{
                        sendTokenToBackend(jwtToken);
                        await FetchMainDocumentDetailsDashboard();
                        Provider.of<SelectedItemProvider>(context, listen: false).setSelectedItem('Dashboard');
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminMainDashboard()),
                        );
                      },
                      onTrailing: () {
                        setState(() {
                          showDashboard = !showDashboard;
                        });
                      },
                      isSelected: Provider.of<SelectedItemProvider>(context).selectedItem == 'Dashboard',
                    ),

                    if (showDashboard)
                      Column(
                        children: [
                          MyListTile2(
                            icon: Icons.circle,
                            iconColor: Colors.red,
                            title: (isWeb(context) || isMobile(context)) ? 'Outgoing' : '',
                            onTap: () async {
                              // fetchDocumentDetails(context);
                              sendTokenToBackend(jwtToken);
                              sendDateTimeToBackend();
                              await fetchData();
                              Provider.of<SelectedItemProvider>(context, listen: false).setSelectedItem('Outgoing');
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminDashboard()),
                              );
                            },
                            isSelected: Provider.of<SelectedItemProvider>(context).selectedItem == 'Outgoing',
                          ),
                          MyListTile2(
                            icon: Icons.circle,
                            iconColor: Colors.blue,
                            title: (isWeb(context) || isMobile(context)) ? 'Received' : '',
                            onTap: () async {
                              sendTokenToBackend(jwtToken);
                              await FetchRecieveData();
                              Provider.of<SelectedItemProvider>(context, listen: false).setSelectedItem('Received');
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AdminReceivedDashboard()),
                              );
                            },
                            isSelected: Provider.of<SelectedItemProvider>(context).selectedItem == 'Received',
                          ),
                          MyListTile2(
                            icon: Icons.circle,
                            iconColor: Colors.orange,
                            title: (isWeb(context) || isMobile(context)) ? 'Requested' : '',
                            onTap: () async{
                              sendTokenToBackend(jwtToken);
                              await FetchRequestedDocumentDetails();
                              await FetchIncomingRequestedDocumentDetails();
                              Provider.of<SelectedItemProvider>(context, listen: false).setSelectedItem('Requested');
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RequestDashboard()),
                              );
                            },
                            isSelected: Provider.of<SelectedItemProvider>(context).selectedItem == 'Requested',
                          ),
                        ],
                      ),

                    MyListTile(
                      icon: Icons.account_tree_outlined,
                      title: (isWeb(context) || isMobile(context)) ? 'Workspace' : '',
                      onTap: () async{
                        await FetchWorkspaceData();
                        // await fetchWorkspaceDocuDetailCount();
                        Provider.of<SelectedItemProvider>(context, listen: false).setSelectedItem('Workspace');
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminWorkspaceDashboard()),
                        );
                      },
                      isSelected: Provider.of<SelectedItemProvider>(context).selectedItem == 'Workspace',
                    ),
                    MyListTile(
                      icon: Icons.lightbulb,
                      title: (isWeb(context) || isMobile(context)) ? 'About Us' : '',
                      onTap: () {
                        Provider.of<SelectedItemProvider>(context, listen: false).setSelectedItem('About Us');
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUs()),);
                      },
                      isSelected: Provider.of<SelectedItemProvider>(context).selectedItem == 'About Us',
                    ),
                  ],
                ),
              ),

              MyListTile(
                icon: Icons.archive,
                title: (isWeb(context) || isMobile(context)) ? 'Archived' : '',
                onTap: () async{
                  Provider.of<SelectedItemProvider>(context, listen: false).setSelectedItem('Archived');
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Admin_Archived()));
                },
                isSelected: Provider.of<SelectedItemProvider>(context).selectedItem == 'Archived',
              ),
              MyListTile(
                icon: Icons.person,
                title: (isWeb(context) || isMobile(context)) ? 'My Profile' : '',
                icon2: Icons.keyboard_arrow_right,
                onTap: () async{
                  // fetchAdminDetails();
                  Provider.of<SelectedItemProvider>(context, listen: false).setSelectedItem('My Profile');
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfile()));
                },
                isSelected: Provider.of<SelectedItemProvider>(context).selectedItem == 'My Profile',
              ),
              MyListTile(
                icon: Icons.logout,
                title: (isWeb(context) || isMobile(context)) ? 'Logout' : '',
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context)=>SigningPage())
                  );
                  // showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) {
                  //     return AlertDialog(
                  //       contentPadding: EdgeInsets.zero,
                  //       content: Container(
                  //         width: 350,
                  //         height: 270,
                  //         decoration: ShapeDecoration(
                  //           color: Colors.white,
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(5),
                  //           ),
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Icon(
                  //                 Icons.help,
                  //                 size: 100,
                  //                 color: primaryColor,
                  //               ),
                  //               SizedBox(height: 20.0),
                  //               Text(
                  //                 'Are you sure you want to logout?',
                  //                 style: GoogleFonts.poppins(
                  //                   fontSize: 14,
                  //                 ),
                  //                 textAlign: TextAlign.center,
                  //               ),
                  //               SizedBox(height: 25.0),
                  //               Row(
                  //                 children: [
                  //                   Expanded(
                  //                     child: ElevatedButton(
                  //                       child: Text('Yes',
                  //                         style: GoogleFonts.poppins(
                  //
                  //                         ),
                  //                       ),
                  //                       onPressed: () async {
                  //                         await Future.delayed(Duration(milliseconds: 1500), () {
                  //                           Navigator.push(context, MaterialPageRoute(builder: (context) => SigningPage()));
                  //                         });
                  //                       },
                  //                       style: ElevatedButton.styleFrom(
                  //                         padding: EdgeInsets.symmetric(
                  //                             horizontal: 40, vertical: 13),
                  //                         textStyle: GoogleFonts.poppins(
                  //                           fontSize: 14,
                  //                           fontWeight: FontWeight.bold,
                  //                         ),
                  //                         primary: Colors.white,
                  //                         onPrimary: primaryColor,
                  //                         elevation: 3,
                  //                         shadowColor: Colors.transparent,
                  //                         shape: StadiumBorder(side: BorderSide(
                  //                             color: primaryColor, width: 2)),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   SizedBox(width: 15,),
                  //                   Expanded(
                  //                     child: ElevatedButton(
                  //                       child: Text('Cancel'),
                  //                       onPressed: () {
                  //                         Navigator.pop(context);
                  //                       },
                  //                       style: ElevatedButton.styleFrom(
                  //                         padding: EdgeInsets.symmetric(
                  //                             horizontal: 33, vertical: 13),
                  //                         textStyle: GoogleFonts.poppins(
                  //                           fontSize: 14,
                  //                           // fontWeight: FontWeight.bold,
                  //                         ),
                  //                         primary: primaryColor,
                  //                         onPrimary: Colors.white,
                  //                         elevation: 3,
                  //                         shadowColor: Colors.transparent,
                  //                         shape: StadiumBorder(),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // );
                },
                isSelected: Provider.of<SelectedItemProvider>(context).selectedItem == 'Logout',
              ),
              SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }

  //backend functionality
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
          'Accept': 'application/json',
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

  // Future<void> sendTokenToBackendFetchClerkName(String jwtToken) async {
  //   final userToken = myAppState!.user_Token;
  //   final url = '${api_url}/api/workspace/getClerkUserName';
  //   print(url);
  //
  //   final requestData = {
  //     'jwt_token': userToken,
  //   };
  //
  //   final jsonData = jsonEncode(requestData);
  //   print(jsonData);
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json', // Specify JSON content type
  //       },
  //       body: jsonData, // Encode the data as JSON
  //     );
  //     if (response.statusCode == 200) {
  //       // Handle a successful response from the backend
  //       final Map<String, dynamic> responseBody = jsonDecode(response.body);
  //       print(responseBody);
  //
  //       final String requestOfficeName = responseBody['requested'];
  //
  //       userOfficeNameState!.setUserOfficeName(requestOfficeName);
  //
  //       // Use the office name as needed in your Dart code
  //       print('Requested Office Name: $requestOfficeName');
  //     } else {
  //       print('Error: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     print('Error: $error');
  //     // Handle the error as needed
  //   }
  // }


  //send token to backend
  Future<void> sendTokenToBackend(String jwtToken) async {
    final userToken = myAppState!.user_Token;
    final url = '${api_url}/api/scanner/getJwtToken';
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
          'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {

        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        final int userId = responseBody['user_id'];

        userIdState!.setUserId(userId.toString());


        print('User ID: $userId');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');

    }
  }

  //Other backend Functionality
  Future<void> fetchData() async {
    try {
      final String? userId = userIdState!.userId;
      if (userId == null) {
        print('Error: userId is null');
        return;
      }

      final response = await http.get(Uri.parse(
          '${api_url}/api/scanner/getDocumentDetailsDashboard/UserID=$userId'),
        headers:{
          'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",

        },
      );

      print(response);

      if (response.statusCode == 200) {
        // Decode the JSON response
        final dynamic responseData = json.decode(response.body);
        print(responseData);

        if (responseData is List) {
          List<DocumentDetails> docuDetailsList = List<DocumentDetails>.from(
            responseData.map((json) => DocumentDetails.fromJson(json)),
          );

          documentDetailDashboardState!.setDocuDetailsList(docuDetailsList);

          print(docuDetailsList);

        } else {

          print("Error: responseData is not a List");
        }
      } else {

        print('Error: ${response.statusCode}');
      }
    } catch (error) {

      print('Error: $error');
    }
  }

  Future<void>FetchWorkspaceData() async{
    try{
      final String? userId = userIdState!.userId;
      if(userId == null){
        print('error: userId is null');
        return;
      }
      final response = await http.get(Uri.parse(
          '${api_url}/api/workspace/getWorkspaceDocumentDetailsDashboard/userID=$userId'),
        headers:{'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",

        },
      );

      if(response.statusCode == 200){
        final dynamic responseData = json.decode(response.body);

        if(responseData is List){
          List<WorkspaceDocumentDetails> workspaceDocumentDetailsList = List<WorkspaceDocumentDetails>.from(
              responseData.map((json)=>WorkspaceDocumentDetails.fromJson(json))
          );
          workspaceDocumentDetailDashboardState!.setWorkspaceDocuDetailsList(workspaceDocumentDetailsList);
          print(workspaceDocumentDetailsList);
        }else{
          print('Error: responseData is not a List');
        }
      }else{
        print('Error: ${response.statusCode}');
      }
    }catch(e){
      print('error: $e');
    }
  }

  //Functionality in fetching the recieved data response
  Future<void>FetchRecieveData()async{
    try{
      final String? userId = userIdState!.userId;
      if (userId == null) {
        print('Error: userId is null');
        return;
      }
      final response = await http.get(Uri.parse(
          '${api_url}/api/scanner/getRecievedDocumentDetailsDashboard/UserID=$userId'),
        headers:{'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",

        },
      );
      print(response);

      if(response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData is List) {
          List<RecievedDocumenDetails> recievedDocuDetailsList = List<
              RecievedDocumenDetails>.from(
            responseData.map((json) => RecievedDocumenDetails.fromJson(json)),
          );
          recieveDocumentDetailDashboardState!.setRecievedDocuDetailsList(recievedDocuDetailsList);
          print(recievedDocuDetailsList);
        } else {

          print("Error: responseData is not a List");
        }
      }else {

        print('Error: ${response.statusCode}');
      }
    }catch(e){
      print('error: $e');
    }
  }


  ///FETCHING OF THE FOR OUTGOING REQUESTED DOCUMENT
  Future<void> FetchRequestedDocumentDetails() async {
    try {
      final String? userId = userIdState!.userId;
      if (userId == null) {
        print('Error: userId is null');
        return;
      }

      final response = await http.get(
          Uri.parse('$api_url/api/scanner/getRequestDocumentDetailsDashboard/user_id=$userId'),
        headers:{'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",

        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic>) {
          final List<dynamic> mergedDocumentList = responseData['merged_document_list'];

          List<RequestDocumentDetails> detailsList = List<RequestDocumentDetails>.from(
              mergedDocumentList.map((json) => RequestDocumentDetails.fromJson(json)));

          requestedDocumentDetailDashboardState!.setRequestedDocumentDetailDashboardState(detailsList);

          print(detailsList);
        } else {
          print("Error: responseData is not a Map");
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('error: $e');
    }
  }




  ///FETCHING OF DATA FOR INCOMING REQUESTED DOCUMENT
  Future<void>FetchIncomingRequestedDocumentDetails()async{
    try{
      final String? userId = userIdState!.userId;
      if (userId == null) {
        print('Error: userId is null');
        return;
      }
      final response = await http.get(Uri.parse(
          '$api_url/api/scanner/getIncomingRequestDocumentDetailsDashboard/user_id=$userId'),
        headers:{'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",

        },
      );

      if(response.statusCode == 200){
        final dynamic responseData = json.decode(response.body);

        if(responseData is List){
          List<IncomingRequestDocumentDetails>incomingrequestDocumentDetailsList = List<
              IncomingRequestDocumentDetails>.from(
            responseData.map((json)=>IncomingRequestDocumentDetails.fromJson(json)),
          );

          incomingRequestedDocumentDetailDashboardState!.setIncomingRequestedDocumentDetailDashboardState(incomingrequestDocumentDetailsList);
          print(incomingrequestDocumentDetailsList);
        }else{
          print("Error: responseData is not a List");
        }
      }else{
        print('Error: ${response.statusCode}');
      }
    }catch(e){
      print('error: $e');
    }
  }

  ///FETCHING OF DATA FOR MAIN DOCUMENT
  Future<void> FetchMainDocumentDetailsDashboard() async {
    try {
      final String? userId = userIdState!.userId;

      final response = await http.get(Uri.parse('$api_url/api/scanner/getMain_dashboard/$userId'),
        headers:{'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",

        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print(responseData);

        if (responseData is Map<String, dynamic> && responseData.containsKey('combined_data')) {
          List<dynamic> combinedDataList = responseData['combined_data'];

          List<MainDocumentDetails> mainDocumentDetailsList = combinedDataList.map((json) {
            return MainDocumentDetails.fromJson(json);
          }).toList();

          mainDocumentDetailDashboardState!.setMainDetailDashboardState(mainDocumentDetailsList);

          print(mainDocumentDetailsList);
        } else {
          print("Error: 'combined_data' key not found in responseData");
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  //FETCH ADMIN INFORMATION FOR UPDATING OF DATA


  Future<void> sendDateTimeToBackend() async {
    try {

      if (userIdState != null) {
        final userId = userIdState!.userId;
        DateTime date = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);
        print(formattedDate);

        final response = await http.post(
          Uri.parse('${api_url}/api/documents/DateTime/user_id=$userId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'formattedDate': formattedDate,
          }),
        );

        print(response.body);

        if (response.statusCode == 200) {
          print('Successfully sent to the backend');


          Map<String, dynamic> jsonResponse = json.decode(response.body);


          int count = jsonResponse['count'];


          print('Count from the backend: $count');

          outgoingDocuCount!.setOutgoingDocuCount(count);
        } else {
          print('Failed to create DateTime: ${response.statusCode}');

        }
      } else {
        print('userIdState is null');

      }
    } catch (e) {
      print('Error: $e');

    }
  }

  Future<WorkspaceDocuDetailsCount> fetchWorkspaceDocuDetailCount()async{
    final userId = userIdState!.userId;

    final response = await http.get(Uri.parse('${api_url}/api/workspace/getOverallWorkspaceDocuDetailsCount/$userId'),
      headers:{'Accept': 'application/json',
        "ngrok-skip-browser-warning": "$localhost_port",

      },
    );

    if(response.statusCode == 200){
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      int count = jsonResponse['overall_count'];
      overallWorkspaceDocuDetailsCountState!.setOverallWorkspaceDocuDetailsCount(count);
      print(count);
      return WorkspaceDocuDetailsCount.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }else{
      throw Exception('Failed to load Workspace Document Details Count');
    }
  }


}

/// NEW DRAWER

class MyListTile extends StatelessWidget {
  final IconData icon;
  final IconData? icon2;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;
  final VoidCallback? onTrailing;

  MyListTile({
    required this.icon,
    this.icon2,
    required this.title,
    required this.onTap,
    required this.isSelected,
    this.onTrailing,
  });

  @override
  Widget build(BuildContext context) {
    bool isTablet (BuildContext context) =>
        MediaQuery.of(context).size.width <= 800;

    return Container(
      color: isSelected ? secondaryColor : null,
      child: Padding(
        padding: EdgeInsets.only(left: isTablet(context) ? 10 : 25.0, right: isTablet(context) ? 10 : 12),
        child: ListTile(
          leading: GestureDetector(
            onTap: onTap,
            child: Icon(
              icon,
              color: isSelected ? primaryColor : secondaryColor,
            ),
          ),
          title: GestureDetector(
            onTap: onTap,
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: isSelected ? primaryColor : secondaryColor,
              ),
            ),
          ),
          trailing: GestureDetector(
            onTap: onTrailing,
            child: Icon(
              icon2,
              color: isSelected ? primaryColor : secondaryColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class MyListTile2 extends StatelessWidget {
  final IconData icon;
  final IconData? icon2;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;
  final VoidCallback? onTrailing;
  final Color? iconColor;

  MyListTile2({
    required this.icon,
    this.icon2,
    required this.title,
    required this.onTap,
    required this.isSelected,
    this.onTrailing,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    bool isTablet (BuildContext context) =>
        MediaQuery.of(context).size.width <= 800;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: isSelected ? secondaryColor : null,
        child: Padding(
          padding: EdgeInsets.only(left: isTablet(context) ? 40 : 60),
          child: ListTile(
            leading: Icon(
              icon,
              color: iconColor,
              size: 13,
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isSelected ? primaryColor : secondaryColor,
              ),
            ),
            trailing: Icon(
              icon2,
              color: isSelected ? primaryColor : secondaryColor,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}
