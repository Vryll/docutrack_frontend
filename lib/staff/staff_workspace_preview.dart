import 'package:docutrack_main/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/style.dart';
import 'package:docutrack_main/custom_widget/staff_custom_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class StaffDocuPreview extends StatefulWidget {
  const StaffDocuPreview({Key? key}) : super(key: key);

  @override
  State<StaffDocuPreview> createState() => _StaffDocuPreviewState();
}

class _StaffDocuPreviewState extends State<StaffDocuPreview> {
  var api_url = dotenv.env['API_URL'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? workspace_docu_comment = "";
  SelectWorkspaceDocuDetailState? selectWorkspaceDocuDetailState;

  @override
  void initState() {
    super.initState();
    selectWorkspaceDocuDetailState =
        Provider.of<SelectWorkspaceDocuDetailState>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideNav(),
      appBar: AppBar(
        backgroundColor: primaryColor,
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
            const SizedBox(width: 1),
          ],
        ),
        centerTitle: true,
        title: Text(
          'Preview',
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
              height: 550,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: selectWorkspaceDocuDetailState!.workspace_docu_file != null
                  ? PageView.builder(
                itemCount: 1,
                itemBuilder: (context, index) => SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: SfPdfViewer.network(
                      selectWorkspaceDocuDetailState!.workspace_docu_file!,
                      key: Key(index.toString()),
                      scrollDirection: PdfScrollDirection.vertical,
                    ),
                  ),
                ),
              )
                  : const Center(
                child: Text('No PDF selected'),
              ),
            ),
            const SizedBox(height: 30.0),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Text(
                'Comment',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 40),
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: null,
                  readOnly: true,
                  style: GoogleFonts.poppins(
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                  decoration: InputDecoration(
                    hintText: 'There is no comment here.',
                    border: InputBorder.none,
                  ),
                  controller: TextEditingController(
                    text: selectWorkspaceDocuDetailState!.workspace_docu_comment,
                  ),
                ),              ),
            ),
          ],
        ),
      ),
    );
  }
}