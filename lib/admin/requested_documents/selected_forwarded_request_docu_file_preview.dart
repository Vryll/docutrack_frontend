import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:docutrack_main/style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:docutrack_main/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:docutrack_main/custom_widget/custom_side_nav_bar.dart';
import 'package:docutrack_main/localhost.dart';

class ForwardedRequestedFilePreview extends StatefulWidget {
  const ForwardedRequestedFilePreview({super.key});

  @override
  State<ForwardedRequestedFilePreview> createState() => _ForwardedRequestedFilePreviewState();
}

class _ForwardedRequestedFilePreviewState extends State<ForwardedRequestedFilePreview> {
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;


  SelectedForwardedRequestedDocuFile? selectedForwardedRequestedDocuFile;
  SelectedDefaultRequestDocuState? selectedDefaultRequestDocuState;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedForwardedRequestedDocuFile = Provider.of<SelectedForwardedRequestedDocuFile>(context, listen: true);
    selectedDefaultRequestDocuState = Provider.of<SelectedDefaultRequestDocuState>(context, listen: true);
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
          'Preview',
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
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Preview',
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
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
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
                          child: selectedForwardedRequestedDocuFile!.forwarded_requested_docu_file != null
                              ? PageView.builder(
                            itemCount: 1,
                            itemBuilder: (context, index) => SizedBox(
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: SfPdfViewer.network(
                                  selectedForwardedRequestedDocuFile!.forwarded_requested_docu_file!,
                                  key: Key(index.toString()),
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
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }
}
