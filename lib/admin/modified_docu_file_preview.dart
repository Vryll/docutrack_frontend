import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:docutrack_main/admin/admin_home_page.dart';
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


class DocuFilePreview extends StatefulWidget {
  const DocuFilePreview({Key? key}) : super(key: key);

  @override
  State<DocuFilePreview> createState() => _DocuFilePreviewState();
}

class _DocuFilePreviewState extends State<DocuFilePreview> {
  PDFDocuFilePreviewState? pdfDocuFilePreviewState;
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    pdfDocuFilePreviewState = Provider.of<PDFDocuFilePreviewState>(context, listen: true);
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
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context)=>AdminHome())
                            );
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
                          child: pdfDocuFilePreviewState!.modified_docu_file != null
                              ? PageView.builder(
                            itemCount: 1,
                            itemBuilder: (context, index) => SizedBox(
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: SfPdfViewer.network(
                                  pdfDocuFilePreviewState!.modified_docu_file!,
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
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BuildPrintBtn(onPressed: _printPdf),
                      // SizedBox(width: 20),
                      // BuildDownloadBtn(onPressed: () => _downloadPdf(context)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget BuildPrintBtn({required VoidCallback onPressed}) => Expanded(
    child: ElevatedButton(
      onPressed: () {
        _printPdf();
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
        //                 'Are you sure you want to print this document?',
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
        //                         ),
        //                       ),
        //                       onPressed: () async {
        //                         _printPdf();
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
      child: Text(
        'Print',
        style: GoogleFonts.poppins(
          color: secondaryColor,
          fontSize: 15,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(10.0),
        fixedSize: Size(140, 50),
        primary: primaryColor,
        onPrimary: secondaryColor,
        shadowColor: Colors.transparent,
        //  side: BorderSide(color: primaryColor, width: 2),
        shape: StadiumBorder(),
      ),
    ),
  );

  Widget BuildDownloadBtn({required VoidCallback onPressed}) => Expanded(
    child: ElevatedButton(
      onPressed: () {
        _downloadPdf(context);
      },
      child: Text(
        'Download',
        style: GoogleFonts.poppins(
          color: primaryColor,
          fontSize: 15,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(10.0),
        fixedSize: Size(140, 50),
        primary: secondaryColor,
        onPrimary: primaryColor,
        shadowColor: Colors.transparent,
        side: BorderSide(color: primaryColor, width: 2),
        shape: StadiumBorder(),
      ),
    ),
  );

  Future<void> _printPdf() async {
    final pdfData = await _loadPdfData(pdfDocuFilePreviewState!.modified_docu_file!);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfData,
    );
  }


  Future<Uint8List> _loadPdfData(String url) async {
    final pdfBytes = await http.readBytes(Uri.parse(url));
    return Uint8List.fromList(pdfBytes);
  }

  Future<void> _downloadPdf(BuildContext context) async {
    try {
      final pdfData = await _loadPdfData(pdfDocuFilePreviewState!.modified_docu_file!);
      final appDocDir = await getApplicationDocumentsDirectory();
      final file = File('${appDocDir.path}/downloaded_pdf.pdf');
      await file.writeAsBytes(pdfData);


      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Download Complete'),
            content: Text('The PDF file has been downloaded to your device.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while downloading the PDF file.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

}
