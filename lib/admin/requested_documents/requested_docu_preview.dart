import 'package:flutter/material.dart';
import 'package:docutrack_main/custom_widget/custom_side_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:docutrack_main/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/style.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class RequestDocuPreview extends StatefulWidget {
  const RequestDocuPreview({super.key});

  @override
  State<RequestDocuPreview> createState() => _RequestDocuPreviewState();
}

class _RequestDocuPreviewState extends State<RequestDocuPreview> {
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;

  ///APPSTATE PROVIDER
  SelectedRequestedDocuDetails? selectedRequestedDocuDetails;

  @override
  void initState(){
    super.initState();
    selectedRequestedDocuDetails = Provider.of<SelectedRequestedDocuDetails>(context, listen: false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile(context) ? AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 65,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preview',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: secondaryColor,
              ),
            ),
          ],
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

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  height: 485,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                  child: selectedRequestedDocuDetails!.docu_request_file != null
                      ? PageView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) => SizedBox(
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: SizedBox(
                          height: 50,
                          child: SfPdfViewer.network(
                            selectedRequestedDocuDetails!.docu_request_file!,
                            key: Key(index.toString()),
                            // pageLayoutMode: PdfPageLayoutMode.single,
                            scrollDirection: PdfScrollDirection.vertical,
                          ),
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
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

               SizedBox(height: 40),

               Container(
                 margin: EdgeInsets.only(left: 50),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       'Comment',
                       style: GoogleFonts.poppins(
                         fontSize: 16,
                         fontWeight: FontWeight.bold,
                       ),
                     ),

                     SizedBox(height: 10),
                     Container(
                       width: 250,
                       padding: EdgeInsets.all(16.0),
                       decoration: BoxDecoration(
                         color: Colors.grey[200],
                         borderRadius: BorderRadius.circular(10.0),
                       ),
                       child: Text(
                         'Your Comment Text Here',
                         style: TextStyle(
                           color: Colors.black, // Text color
                           fontSize: 12.0, // Text size
                         ),
                       ),
                     )
                   ],
                 ),
               )
              ],
            ),
          ),
        ],
      )
    );
  }
}
