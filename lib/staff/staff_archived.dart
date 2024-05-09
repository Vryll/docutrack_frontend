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
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:async';

class StaffArchived extends StatefulWidget {
  const StaffArchived({Key? key}) : super(key: key);

  @override
  _StaffArchivedState createState() => _StaffArchivedState();
}

class ArchivedWorkspaceDocumentDetails{
  final int? workspace_docu_id;
  final String? workspace_docu_type;
  final String? workspace_docu_title;
  final String? workspace_docu_status;
  final String? upload_dateNtime;
  bool? is_deleted;
  final String? deleted_at;
  final int? archived_workspace_docu_count;

  ArchivedWorkspaceDocumentDetails({
    required this.workspace_docu_id,
    required this.workspace_docu_type,
    required this.workspace_docu_title,
    required this.workspace_docu_status,
    required this.upload_dateNtime,
    required this.is_deleted,
    required this.deleted_at,
    required this.archived_workspace_docu_count,
  });

  factory ArchivedWorkspaceDocumentDetails.fromJson(Map<String, dynamic>json){
    return ArchivedWorkspaceDocumentDetails(
        workspace_docu_id: json['workspace_docu_id'] ?? 0,
        workspace_docu_type: json['workspace_docu_type'] ?? '',
        workspace_docu_title: json['workspace_docu_title'] ?? '',
        workspace_docu_status: json['workspace_docu_status'] ?? '',
        upload_dateNtime: json['upload_dateNtime'] ?? '',
        is_deleted: json['is_deleted'] ?? '',
        deleted_at: json['deleted_at'] ?? '',
        archived_workspace_docu_count: json['archived_workspace_docu_count'] ?? 0,
    );
  }

  static List<ArchivedWorkspaceDocumentDetails> fromJsonList(List<dynamic>list){
    return list.map((json) => ArchivedWorkspaceDocumentDetails.fromJson(json)).toList();
  }

  @override
  String toString(){
    return 'ArchivedWorkspaceDocumentDetails(workspace_docu_id: $workspace_docu_id, workspace_docu_type: $workspace_docu_type, workspace_docu_title: $workspace_docu_title,workspace_docu_status: $workspace_docu_status, upload_dateNtime: $upload_dateNtime,is_deleted: $is_deleted,deleted_at: $deleted_at,archived_workspace_docu_count: $archived_workspace_docu_count)';
  }
}



class _StaffArchivedState extends State<StaffArchived> with WidgetsBindingObserver{
  bool _showNewContainer = false;


  var api_url = dotenv.env['API_URL'];

  String jwtToken = "";

  Color? selectedTileColor = Colors.transparent;


  MyappState? myAppState;
  UserIdState? userIdState;
  ArchivedWorkspaceDocuDetailState? archivedWorkspaceDocuDetailState;
  // ClerkUsernameState? clerkUsernameState;
  // WorkspaceDocuDetailState? workspaceDocuDetailState;
  // DocumentCountForWorkspace? documentCountForWorkspace;
  // SelectWorkspaceDocuDetailState? selectWorkspaceDocuDetailState;

  late Timer _timer;
  bool dataFetched = false;
  bool _isPageActive = true;



  @override
  void initState() {
    super.initState();
    myAppState = Provider.of<MyappState>(context, listen: false);
    userIdState = Provider.of<UserIdState>(context, listen: false);
    // clerkUsernameState = Provider.of<ClerkUsernameState>(context, listen: false);
    // documentCountForWorkspace = Provider.of<DocumentCountForWorkspace>(context, listen: false);
    // selectWorkspaceDocuDetailState = Provider.of<SelectWorkspaceDocuDetailState>(context, listen: false);
    fetchArchivedWorkspaceDocuDetails();
    WidgetsBinding.instance?.addObserver(this);
    startTimer();
  }


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

      fetchArchivedWorkspaceDocuDetails();
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
  void didChangeDependencies(){
    super.didChangeDependencies();
    // workspaceDocuDetailState = Provider.of<WorkspaceDocuDetailState>(context, listen: true);
    archivedWorkspaceDocuDetailState = Provider.of<ArchivedWorkspaceDocuDetailState>(context, listen: true);
  }

  void _closeNewContainer() {
    setState(() {
      _showNewContainer = false;
    });
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
          'Archived',
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
          Container(
            decoration: BoxDecoration(
              color: Colors.white,

            ),
            child: Column(
              children: <Widget>[
                // SizedBox(height: 40),
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

                // account list
                SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(right: 30),
                    child: Consumer<ArchivedWorkspaceDocuDetailState>(
                      builder: (context, archivedWorkspaceDocuDetailState, child) {
                        return Container(
                          child: Text(
                            'Total: ${archivedWorkspaceDocuDetailState.archived_workspace_docu_count?.toString() ?? '0'}',
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
                Consumer<ArchivedWorkspaceDocuDetailState>(
                  builder: (context, a, child) {

                    if (archivedWorkspaceDocuDetailState != null) {

                      List<ArchivedWorkspaceDocumentDetails> archivedWorkspaceDocuDetails = archivedWorkspaceDocuDetailState!.archivedWorkspaceDocuDetalsList;

                      return Container(
                        child: Expanded(
                          child: ListView.builder(
                            itemCount: archivedWorkspaceDocuDetails.length,
                            itemBuilder: (context, index) {
                              ArchivedWorkspaceDocumentDetails archivedWorkspaceDocuDetail = archivedWorkspaceDocuDetails[index];

                              return Slidable(
                                startActionPane: ActionPane(
                                  motion:  const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: Colors.green,
                                      icon: Icons.undo,
                                      label: 'Undo',
                                      onPressed: (BuildContext context) async{
                                        final docuId = archivedWorkspaceDocuDetail.workspace_docu_id;

                                        try{
                                          final response = await http.get(Uri.parse(
                                              '${api_url}/api/workspace/restore_workspace_document_details/docuId=$docuId'));

                                          if (response.statusCode == 200){
                                            print('the $docuId was successfull restored!');
                                            archivedWorkspaceDocuDetailState!.removeDocument(docuId.toString());
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
                                      onPressed: (BuildContext Context) async{
                                        final docuId = archivedWorkspaceDocuDetail.workspace_docu_id;

                                        try{
                                          final response = await http.delete(Uri.parse(
                                            '${api_url}/api/workspace/hard_delete_workspace_document_details/docuId=$docuId'));

                                          if(response.statusCode == 200){
                                            print('the $docuId was successfull hard deleted!');
                                            archivedWorkspaceDocuDetailState!.removeDocument(docuId.toString());
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
                                  child: Container(
                                    // margin: EdgeInsets.only(left: 10, right: 10),
                                    child: ListTile(
                                      title: Text(
                                        archivedWorkspaceDocuDetail.workspace_docu_title.toString(),
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
                                            archivedWorkspaceDocuDetail.workspace_docu_type.toString(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              color: Colors.black,
                                            ),
                                          ),
                                          // Text(
                                          //   '${docuDetail.first_name} ${docuDetail.last_name}',
                                          //   style: GoogleFonts.poppins(
                                          //     fontSize: 10,
                                          //     color: Colors.grey,
                                          //   ),
                                          // ), // Second subtitle
                                        ],
                                      ),
                                      trailing: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 12),
                                          Text(
                                            archivedWorkspaceDocuDetail.workspace_docu_status.toString(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: archivedWorkspaceDocuDetail.workspace_docu_status == 'Approved'
                                                  ? Colors.green
                                                  : archivedWorkspaceDocuDetail.workspace_docu_status == 'Revise'
                                                  ? Colors.red
                                                  : Colors.black,
                                            ),
                                          ),

                                          Text(
                                            (archivedWorkspaceDocuDetail.upload_dateNtime != null)
                                                ? (() {
                                              final parsedDateTime = DateTime.parse(archivedWorkspaceDocuDetail.upload_dateNtime.toString());
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
          if (_showNewContainer)
            UploadFile(closeNewContainer: _closeNewContainer),
        ],
      ),
      drawer: SideNav(),
    );
  }

  void _onDismissed() {

  }

  Future<void>fetchArchivedWorkspaceDocuDetails()async{
    final userId = userIdState!.userId;
    try{
      final response = await http.get(Uri.parse(
          '${api_url}/api/workspace/getArchived_workspace_docu_details/user_id=$userId'
      ));

      if(response.statusCode == 200){
        final dynamic responseData = json.decode(response.body);
        final archivedWorkspaceDocuCount = responseData['archived_workspace_docu_count'];
        final archivedWorkspaceDocuments = responseData['workspace_docu_details'];
        print(responseData);

        if(archivedWorkspaceDocuments is List){
          List<ArchivedWorkspaceDocumentDetails> archivedWorkspaceDocuDetalsList =
              archivedWorkspaceDocuments.map((docu)=> ArchivedWorkspaceDocumentDetails.fromJson(docu)).toList();

          archivedWorkspaceDocuDetailState!.setArchivedWorkspaceDocuDetails(archivedWorkspaceDocuDetalsList);
          archivedWorkspaceDocuDetailState!.setArchiveWorkspaceCount(archivedWorkspaceDocuCount);
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

}