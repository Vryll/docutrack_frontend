import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:docutrack_main/main.dart';
import 'package:docutrack_main/style.dart';
import 'package:docutrack_main/staff/worspace_uploadfile.dart';
import 'package:docutrack_main/custom_widget/staff_custom_nav_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:docutrack_main/staff/staff_workspace_preview.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:async';

class Workspace extends StatefulWidget {
  const Workspace({Key? key}) : super(key: key);

  @override
  _WorkspaceState createState() => _WorkspaceState();
}
//
// class WorkspaceDocuCount {
//   final int docuCount;
//
//   const WorkspaceDocuCount({
//     required this.docuCount,
//   });
//
//   factory WorkspaceDocuCount.fromJson(Map<String, dynamic>json){
//     return WorkspaceDocuCount(
//       docuCount: json['docuCount'] as int,
//     );
//   }
// }

class WorkspaceDocuDetail {
  final int? id;
  final String? workspace_docu_type;
  final String? workspace_docu_title;
  final String? first_name;
  final String? middle_name;
  final String? last_name;
  final String? admin_office;
  final String? workspace_docu_file;
  final String? upload_dateNtime;
  final String? workspace_docu_comment;
  final String? workspace_docu_status;
  final int? docu_details_count;

  const WorkspaceDocuDetail({
    required this.id,
    required this.workspace_docu_type,
    required this.workspace_docu_title,
    required this.first_name,
    required this.middle_name,
    required this.last_name,
    required this.admin_office,
    required this.workspace_docu_file,
    required this.upload_dateNtime,
    required this.workspace_docu_comment,
    required this.workspace_docu_status,
    required this. docu_details_count,
  });

  factory WorkspaceDocuDetail.fromJson(Map<String, dynamic> json) {
    return WorkspaceDocuDetail(
      id: json['id'] ?? 0,
      workspace_docu_type: json['workspace_docu_type'] ?? '',
      workspace_docu_title: json['workspace_docu_title'] ?? '',
      first_name: json['user_first_name'] ?? '',
      middle_name: json['user_middle_name'] ?? '',
      last_name: json['user_last_name'] ?? '',
      admin_office: json['staff_office_name'] ?? '',
      workspace_docu_file: json['workspace_docu_file'] ?? '',
      upload_dateNtime: json['upload_dateNtime'] ?? '',
      workspace_docu_comment: json['workspace_docu_comment'] ?? '',
      workspace_docu_status: json['workspace_docu_status'] ?? '',
      docu_details_count: json['docu_details_count'] ?? 0,
    );
  }

  static List<WorkspaceDocuDetail> fromJsonList(List<dynamic> list) {
    return list.map((json) => WorkspaceDocuDetail.fromJson(json)).toList();
  }

  @override
  String toString() {
    return 'WorkspaceDocuDetail(id: $id, workspace_docu_type: $workspace_docu_type, first_name: $first_name, middle_name: $middle_name,last_name: $last_name,admin_office: $admin_office,workspace_docu_file: $workspace_docu_file,upload_dateNtime: $upload_dateNtime,workspace_docu_comment: $workspace_docu_comment,workspace_docu_status: $workspace_docu_status, docu_details_count: $docu_details_count)';
  }
}

class WorkspaceDocumentDetailList {
  int? id;
  String? workspace_docu_type;
  String? workspace_docu_title;
  String? first_name;
  String? middle_name;
  String? last_name;
  String? admin_office;
  String? workspace_docu_file;
  String? upload_dateNtime;
  String? workspace_docu_comment;
  String? workspace_docu_status;
  int? docu_details_count;

  WorkspaceDocumentDetailList({
    required this.id,
    required this.workspace_docu_type,
    required this.workspace_docu_title,
    required this.first_name,
    required this.middle_name,
    required this.last_name,
    required this.admin_office,
    required this.workspace_docu_file,
    required this.upload_dateNtime,
    required this.workspace_docu_comment,
    required this.workspace_docu_status,
    required this.docu_details_count,
  });
}

class SelectedWorkspaceDocuDetials{
  // int? id;
  String? workspace_docu_file;
  String? workspace_docu_comment;

  SelectedWorkspaceDocuDetials({
    // required this.id,
    required this.workspace_docu_file,
    required this.workspace_docu_comment,
  });

  factory SelectedWorkspaceDocuDetials.fromJson(Map<String, dynamic>json){
    return SelectedWorkspaceDocuDetials(
      // id: json['id'] as int,
      workspace_docu_file: json['workspace_docu_file'] ?? '',
      workspace_docu_comment: json['workspace_docu_comment'] ?? '',
    );
  }
}

class _WorkspaceState extends State<Workspace> with WidgetsBindingObserver {
  bool _showNewContainer = false;


  var api_url = dotenv.env['API_URL'];

  String jwtToken = "";

  Color? selectedTileColor = Colors.transparent;
  late Timer _timer;
  bool dataFetched = false;
  bool _isPageActive = true;

  MyappState? myAppState;
  UserIdState? userIdState;
  ClerkUsernameState? clerkUsernameState;
  WorkspaceDocuDetailState? workspaceDocuDetailState;
  DocumentCountForWorkspace? documentCountForWorkspace;
  SelectWorkspaceDocuDetailState? selectWorkspaceDocuDetailState;



  @override
  void initState() {
    super.initState();
    myAppState = Provider.of<MyappState>(context, listen: false);
    userIdState = Provider.of<UserIdState>(context, listen: false);
    clerkUsernameState = Provider.of<ClerkUsernameState>(context, listen: false);
    documentCountForWorkspace = Provider.of<DocumentCountForWorkspace>(context, listen: false);
    selectWorkspaceDocuDetailState = Provider.of<SelectWorkspaceDocuDetailState>(context, listen: false);
    fetchWorkspaceDocuDetailDetail();
    WidgetsBinding.instance?.addObserver(this);
    startTimer();
  }


  @override
  void dispose(){
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
      _timer.cancel();
    }
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    workspaceDocuDetailState = Provider.of<WorkspaceDocuDetailState>(context, listen: true);
    // documentCountForWorkspace = Provider.of<DocumentCountForWorkspace>(context, listen: true);
  }

  void _closeNewContainer() {
    setState(() {
      _showNewContainer = false;
    });
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1 ), (timer) {
      print('Timer is triggered!');

        fetchWorkspaceDocuDetailDetail();
    });
  }

  void resumeTimer() {
    dataFetched = false;
    startTimer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
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
          'Workspace',
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
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(50.0),
                  topLeft: Radius.circular(50.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 40),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // button
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () async {
                        await sendTokenToBackendFetchClerkName(jwtToken);
                        setState(() {
                          _showNewContainer = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(10.0),
                        fixedSize: Size(140, 50),

                        primary: primaryColor,
                        onPrimary: Colors.white,
                        elevation: 3,
                        shadowColor: Colors.transparent,
                        shape: StadiumBorder(),
                      ),
                      child: Text(
                        'Upload File',
                        style: GoogleFonts.poppins(
                          // fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  // account list
                  SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 30),
                      child: Consumer<DocumentCountForWorkspace>(
                        builder: (context, documentCountForWorkspace, child) {
                          return Container(
                            child: Text(
                              'Total: ${workspaceDocuDetailState!.docuDetailsCount?.toString() ?? '0'}',
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
                  Consumer<WorkspaceDocuDetailState>(
                    builder: (context, workspaceDocuDetailState, child) {

                      if (workspaceDocuDetailState != null) {

                        List<WorkspaceDocuDetail> docuDetails = workspaceDocuDetailState!.workspaceDocuDetailList;

                        return Container(
                          child: Expanded(
                            child: ListView.builder(
                              itemCount: docuDetails.length,
                              itemBuilder: (context, index) {
                                WorkspaceDocuDetail docuDetail = docuDetails[index];

                                return Slidable(
                                  // startActionPane: ActionPane(
                                  //   motion:  const StretchMotion(),
                                  //   children: [
                                  //     SlidableAction(
                                  //       backgroundColor: Colors.blue,
                                  //       icon: Icons.archive_outlined,
                                  //       label: 'Archive',
                                  //       onPressed: (context) => _onDismissed(),
                                  //     ),
                                  //   ],
                                  // ),
                                  endActionPane: ActionPane(
                                    motion: const BehindMotion(),
                                    children: [
                                      SlidableAction(
                                        backgroundColor: Colors.red,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                        onPressed: (BuildContext context)async{
                                          final docuId = docuDetail.id;
                                          try{
                                            final response = await http.delete(Uri.parse(
                                              '${api_url}/api/workspace/deleting_workspace_document_details/docuId=$docuId'
                                            ));
                                            if (response.statusCode == 200){
                                              print('the $docuId was successfully deleted');
                                              Provider.of<WorkspaceDocuDetailState>(context, listen: false).removeDocuDetail(docuId!.toInt());
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
                                    child: Container(
                                      // margin: EdgeInsets.only(left: 10, right: 10),
                                      child: ListTile(
                                        title: Text(
                                          docuDetail.workspace_docu_title.toString(),
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
                                            Text(
                                              docuDetail.workspace_docu_type.toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                color: Colors.black,
                                              ),
                                            ), // First subtitle
                                            // Text(
                                            //   '${docuDetail.first_name} ${docuDetail.last_name}',
                                            //   style: GoogleFonts.poppins(
                                            //     fontSize: 10,
                                            //     color: Colors.grey,
                                            //   ),
                                            // ), // Second subtitle
                                          ],
                                        ),
                                        onTap: () async {
                                          //Backend Functionality
                                          try {
                                            int docuId = docuDetail.id!;
                                            final response = await http.get(Uri.parse('$api_url/api/workspace/getWorkspacePreviewDocu/$docuId'));

                                            if (response.statusCode == 200) {
                                              final Map<String, dynamic> data = json.decode(response.body);
                                              final SelectedWorkspaceDocuDetials selectedWorkspaceDocuDetials = SelectedWorkspaceDocuDetials.fromJson(data);

                                              String workspace_docu_file = selectedWorkspaceDocuDetials.workspace_docu_file?.toString() ?? '';
                                              String workspace_docu_comment = selectedWorkspaceDocuDetials.workspace_docu_comment?.toString() ?? '';


                                              selectWorkspaceDocuDetailState!.setSelectedWorkspaceDocuDetail(docuId, workspace_docu_file, workspace_docu_comment);
                                              print(docuId);
                                              print(workspace_docu_file);
                                              print(workspace_docu_comment);

                                              Navigator.of(context).push(
                                                  MaterialPageRoute(builder: (context) => StaffDocuPreview())
                                              );

                                            } else {
                                              print('Failed to load workspace document details: ${response.statusCode}');
                                            }
                                          } catch (e) {
                                            print('Error: $e');
                                          }
                                        },


                                        trailing: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 12),
                                            Text(
                                              docuDetail.workspace_docu_status.toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: docuDetail.workspace_docu_status == 'Approved'
                                                    ? Colors.green
                                                    : docuDetail.workspace_docu_status == 'Revise'
                                                    ? Colors.red
                                                    : Colors.black,
                                              ),
                                            ),

                                            Text(
                                              docuDetail.upload_dateNtime.toString(),
                                              style: GoogleFonts.poppins(
                                                color: Colors.grey,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );

                      } else {

                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          if (_showNewContainer)
            UploadFile(closeNewContainer: _closeNewContainer),
        ],
      ),
      drawer: SideNav(),
    );
  }

  Future<void> fetchWorkspaceDocuDetailDetail() async {
    final userId = userIdState?.userId;

    try {
      final response = await http.get(Uri.parse(
        '${api_url}/api/workspace/getWorkspaceDocuDetail/clerk_user=$userId',
      ));

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic>) {
          final List<dynamic> workspaceDocuDetailListJson =
              responseData['workspace_document_data'] ?? [];
          final int docuDetailsCount = responseData['docu_details_count'] ?? 0;

          List<WorkspaceDocuDetail> workspaceDocuDetailList =
          WorkspaceDocuDetail.fromJsonList(workspaceDocuDetailListJson);

          workspaceDocuDetailState!.setWorkspaceDocuDetail(
              workspaceDocuDetailList, docuDetailsCount);

          print(workspaceDocuDetailList);
        } else {
          print("Error: responseData is not a Map or does not contain 'workspace_document_data'");
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  Future<void> sendTokenToBackendFetchClerkName(String jwtToken) async {
    final userToken = myAppState!.user_Token;
    final url = '${api_url}/api/workspace/getClerkUserName';
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
        },
        body: jsonData,
      );
      if (response.statusCode == 200) {

        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print(responseBody);
        final Map<String, dynamic>? clerkUserName = responseBody['clerk_user_name'];
        final String first_name = clerkUserName!['first_name'];
        final String middle_name = clerkUserName['middle_name'];
        final String last_name = clerkUserName['last_name'];


        print("First Name: $first_name");
        print("Middle Name: $middle_name");
        print("Last Name: $last_name");

        clerkUsernameState!.setClerkUsernameState(first_name, middle_name, last_name);

      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      // Handle the error as needed
    }
  }

  // Future<void>fetchWorkspaceDocuCount() async{
  //   final userId = userIdState?.userId;
  //
  //   try{
  //     final response = await http.get(Uri.parse(
  //       '${api_url}/api/workspace/countWorkspaceDocu/clerk_user=$userId',
  //     ));
  //
  //     if(response.statusCode == 200){
  //       Map<String, dynamic> data = json.decode(response.body);
  //       int docuCount = data["docuCount"];
  //
  //       documentCountForWorkspace!.setDocumentCountForWorkspace(docuCount);
  //       print(docuCount);
  //     }
  //   }catch(e){
  //     print('Error: $e');
  //   }
  // }

  void _onDismissed() {

  }

}