import 'package:docutrack_main/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/style.dart';
import 'package:docutrack_main/custom_widget/custom_side_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:docutrack_main/admin/workspace/workspace_docu_file_preview.dart';
import 'package:docutrack_main/localhost.dart';

class AdminWorkspaceDashboard extends StatefulWidget {
  const AdminWorkspaceDashboard({super.key});

  @override
  State<AdminWorkspaceDashboard> createState() => _AdminWorkspaceDashboardState();
}

class WorkspaceDocumentDetail{
  int? id;
  String? workspace_docu_type;
  String? workspace_docu_title;
  String? upload_dateNtime;
  String? first_name;
  String? middle_name;
  String? last_name;
  String? workspace_docu_file;

  WorkspaceDocumentDetail({
    required this.id,
    required this.workspace_docu_type,
    required this.workspace_docu_title,
    required this.upload_dateNtime,
    required this.first_name,
    required this.middle_name,
    required this.last_name,
    required this.workspace_docu_file,
  });
}

class SelectedWorkspaceDocuDetail {
  final int id;
  final String workspaceDocuFile;

  SelectedWorkspaceDocuDetail({required this.id, required this.workspaceDocuFile});

  factory SelectedWorkspaceDocuDetail.fromJson(Map<String, dynamic> json) {
    return SelectedWorkspaceDocuDetail(
      id: json['id'] as int,
      workspaceDocuFile: json['workspace_docu_file'] as String,
    );
  }
}


class _AdminWorkspaceDashboardState extends State<AdminWorkspaceDashboard> {
  var api_url = dotenv.env['API_URL'];

  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;

  ScrollController _scrollController = ScrollController();
  ClerkUsernameState? clerkUsernameState;
  WorkspaceDocumentDetailDashboardState? workspaceDocumentDetailDashboardState;
  SelectedDocuPreviewState? selectedDocuPreviewState;
  OverallWorkspaceDocuDetailsCountState? overallWorkspaceDocuDetailsCountState;


  int? id;
  String? docuId;
  String? workspace_docu_type;
  String? workspace_docu_title;
  String? upload_dateNtime;
  String? first_name;
  String? middle_name;
  String? last_name;
  String? workspace_docu_file;

  TextEditingController searchController = TextEditingController();
  late List<WorkspaceDocumentDetails> defaultData;



  void filterData(String query) {
    if (workspaceDocumentDetailDashboardState != null) {
      List<WorkspaceDocumentDetails> filteredList;

      if (query.isNotEmpty) {
        List<String> queryWords = query.toLowerCase().split(' ');

        filteredList = workspaceDocumentDetailDashboardState!
            .workspaceDocumentDetailsList
            .where((docu) {

          String allRecipients = ((docu.first_name ?? '') + ' ' + (docu.last_name ?? '')).toLowerCase();


          return queryWords.every((word) =>
          docu.workspace_docu_type!.toLowerCase().contains(word) ||
              docu.workspace_docu_title!.toLowerCase().contains(word) ||
              docu.upload_dateNtime!.toLowerCase().contains(word) ||
              allRecipients.contains(word));
        })
            .toList();
      } else {

        filteredList = defaultData;
      }


      workspaceDocumentDetailDashboardState!.setWorkspaceDocuDetailsList(filteredList);
    }
  }


  @override
  void initState(){
    super.initState();
    workspaceDocumentDetailDashboardState = Provider.of<WorkspaceDocumentDetailDashboardState>(context, listen: false);
    selectedDocuPreviewState = Provider.of<SelectedDocuPreviewState>(context, listen: false);
    overallWorkspaceDocuDetailsCountState= Provider.of<OverallWorkspaceDocuDetailsCountState>(context, listen: false);
    defaultData = workspaceDocumentDetailDashboardState!.workspaceDocumentDetailsList;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile(context) ? AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 65,
        title: Text(
          'Workspace',
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
                            child: Text(
                              'Workspace',
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

                      SizedBox(height: 20),
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
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  scrollDirection: Axis.vertical,
                                  child: DataTable(
                                    columnSpacing: (isWeb(context)) ? 290 : (isMobile(context) ? 120 : 120),
                                    columns: [
                                      DataColumn(
                                          label: Text(
                                            'Document Type',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          )
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Title',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Date/Time Released',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
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
    return workspaceDocumentDetailDashboardState?.workspaceDocumentDetailsList
        .map((workspaceDocumentDetailsList) => DataRow(
      cells: [
        DataCell(Text(workspaceDocumentDetailsList.workspace_docu_type ?? '',
          style: GoogleFonts.poppins(
            fontSize: 14,
          ),
        )),
        DataCell(Text(workspaceDocumentDetailsList.workspace_docu_title ?? '',
          style: GoogleFonts.poppins(
            fontSize: 14,
          ),
        )),
        DataCell(Text(workspaceDocumentDetailsList.getFormattedDateTime() ?? '',
          style: GoogleFonts.poppins(
            fontSize: 14,
          ),
        )),
        DataCell(Text('${workspaceDocumentDetailsList.first_name ?? ''} ${workspaceDocumentDetailsList.last_name ?? ''}',
          style: GoogleFonts.poppins(
            fontSize: 14,
          ),
        )),
        DataCell(
          ButtonBar(
            children: [
              IconButton(
                icon: Icon(Icons.remove_red_eye_outlined, size: 23,),
                onPressed: () async {
                  int? docuId = workspaceDocumentDetailsList.id;
                  try {
                    final response = await http.get(Uri.parse('$api_url/api/workspace/getWorkspacePreviewDocu/$docuId'),
                      headers:{'Accept': 'application/json',
                        "ngrok-skip-browser-warning": "$localhost_port",
                      },
                    );

                    if (response.statusCode == 200) {
                      final Map<String, dynamic> data = json.decode(response.body);
                      final SelectedWorkspaceDocuDetail selectedWorkspaceDocuDetail = SelectedWorkspaceDocuDetail.fromJson(data);

                      int docuId = selectedWorkspaceDocuDetail.id;
                      String workspace_docu_file = selectedWorkspaceDocuDetail.workspaceDocuFile;

                      selectedDocuPreviewState!.setSelectedDocuPreview(docuId,workspace_docu_file );
                      print(docuId);
                      print(workspace_docu_file);
                    } else {
                      print('Failed to load workspace document details: ${response.statusCode}');
                    }
                  } catch (e) {
                    print('Error: $e');
                  }

                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>DocuFilePreview())
                  );
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
      ],
    ))
        .toList() ?? [];
  }
}

