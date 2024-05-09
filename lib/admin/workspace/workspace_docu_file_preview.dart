import 'package:docutrack_main/main.dart';
import 'package:flutter/material.dart';
import 'package:docutrack_main/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/custom_widget/custom_side_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:docutrack_main/localhost.dart';



class DocuFilePreview extends StatefulWidget {
  const DocuFilePreview({super.key});

  @override
  State<DocuFilePreview> createState() => _DocuFilePreviewState();
}

class _DocuFilePreviewState extends State<DocuFilePreview> {
  var api_url = dotenv.env['API_URL'];
  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();

  int? docuId;
  String? workspace_docu_file;
  String? workspace_docu_comment = "";
  Color? selectedTileColor;

  SelectedDocuPreviewState? selectedDocuPreviewState;
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;

  @override
  void initState(){
    super.initState();
    selectedDocuPreviewState = Provider.of<SelectedDocuPreviewState>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: isMobile(context)
            ? AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          toolbarHeight: 65,
          title: Text(
            'PDF Preview',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: secondaryColor,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: secondaryColor,
          ),
        ) : null,
        drawer: isMobile(context)
            ? Drawer(
          backgroundColor: primaryColor,
          child: SideNav(),
        ) : null,
        body:Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isWeb(context) ?
            Container(
              color: primaryColor,
              child: SideNav(),
              width: size300_80(context),
            ) : Container(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isWeb(context) ? 40 : 20, vertical: isWeb(context) ? 40 : 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (MediaQuery.of(context).size.width > 600)
                      Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'PDF Preview',
                                style: GoogleFonts.poppins(
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
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
                    Expanded(
                      child: ListView(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height,
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                            constraints: const BoxConstraints(maxWidth: 700),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 1.0,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: selectedDocuPreviewState!.workspace_docu_file != null
                                ? PageView.builder(
                              itemCount: 1,
                              itemBuilder: (context, index) => SizedBox(
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: SfPdfViewer.network(
                                    selectedDocuPreviewState!.workspace_docu_file!,
                                    key: Key(index.toString()),
                                    // pageLayoutMode: PdfPageLayoutMode.single,
                                    scrollDirection: PdfScrollDirection.vertical,
                                  ),
                                ),
                              ),
                            )
                                : Center(
                              child: Text(
                                'No PDF selected',
                                style: GoogleFonts.poppins(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                    color: Colors.grey
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle the button press
                              SendApprovedDocuStatus();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(10.0),
                              fixedSize: Size(140, 50),
                              primary: primaryColor,
                              onPrimary: secondaryColor,
                              shadowColor: Colors.transparent,
                              //  side: BorderSide(color: primaryColor, width: 2),
                              shape: StadiumBorder(),
                            ),
                            child: Text(
                              'Approve',
                              style: GoogleFonts.poppins(
                                color: secondaryColor,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              showCommentPopup(context);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(10.0),
                              fixedSize: Size(140, 50),
                              primary: secondaryColor,
                              onPrimary: primaryColor,
                              shadowColor: Colors.transparent,
                              side: BorderSide(color: primaryColor, width: 2),
                              shape: StadiumBorder(),
                            ),
                            child: Text(
                              'Revise',
                              style: GoogleFonts.poppins(
                                color: primaryColor,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
  void showCommentPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          title: Text(
            'Add Comment',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 15
            ),
          ),
          content: Container(
            height: 200,
            width: 300,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 1.0,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: TextFormField(
                key: Key('workspace_docu_comment'),
                decoration: InputDecoration(
                  hintText: 'Enter your comment',
                  hintStyle: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 14
                  ),
                  border: InputBorder.none,
                ),
                onSaved: (value){
                  workspace_docu_comment = value;
                },
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async{
                      await _updateForm();
                      await SendRevisedDocuStatus();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Confirm',
                      style: GoogleFonts.poppins(
                        color: secondaryColor,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10.0),
                      fixedSize: Size(90, 40),
                      primary: primaryColor,
                      onPrimary: Colors.white,
                      shadowColor: Colors.transparent,
                      side: BorderSide(color: primaryColor, width: 2),
                      shape: StadiumBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  Future<void> SendApprovedDocuStatus() async {
    String workspaceDocuStatus = 'Approved';
    int? docuId = selectedDocuPreviewState?.docuId;
    print(docuId);

    final response = await http.post(
      Uri.parse('${api_url}/api/workspace/UpdatingWorkspaceDocuStatus/docuID=$docuId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        "ngrok-skip-browser-warning": "$localhost_port",
      },
      body: jsonEncode(<String, String>{
        'workspace_docu_status': workspaceDocuStatus,
      }),
    );

    if (response.statusCode == 201) {
      print('Successfully sent to the backend!');
    } else {
      print('Failed to send to the backend. Status code: ${response.statusCode}');
    }
  }

  Future<void> SendRevisedDocuStatus() async {
    String workspaceDocuStatus = 'Revised';
    int? docuId = selectedDocuPreviewState?.docuId;
    print(docuId);

    final response = await http.post(
      Uri.parse('${api_url}/api/workspace/UpdatingWorkspaceDocuStatus/docuID=$docuId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        "ngrok-skip-browser-warning": "$localhost_port",
      },
      body: jsonEncode(<String, String>{
        'workspace_docu_status': workspaceDocuStatus,
      }),
    );

    if (response.statusCode == 201) {
      print('Successfully sent to the backend!');
    } else {
      print('Failed to send to the backend. Status code: ${response.statusCode}');
    }
  }

  Future<void>_updateForm()async{
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
    }

    int? docuId = selectedDocuPreviewState!.docuId;
    print(docuId);

    try{
      final url = Uri.parse('${api_url}/api/workspace/updateWorkspaceDocuDetail/docuID=$docuId');
      final request = http.MultipartRequest('POST', url)
        ..fields['workspace_docu_comment'] = workspace_docu_comment!;

      final response = await request.send();
      print(response);
      if(response.statusCode == 200){
        print('Workspace Document Comment was successfully Saved!');
      }
    }catch(e){
      print('error: $e');
    }
  }
}
