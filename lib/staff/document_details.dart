import 'package:docutrack_main/main.dart';
import 'package:flutter/material.dart';
import 'package:docutrack_main/style.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/localhost.dart';


class DocuDetails extends StatefulWidget {
  const DocuDetails({Key? key}) : super(key: key);

  @override
  State<DocuDetails> createState() => _DocuDetailsState();
}
class DocumentDetails {
  final String docuId;
  final String memorandum_number;
  final String docu_title;
  final String docu_type;
  final String docu_sender;
  final String docu_dateNtime_released;

  const DocumentDetails({
    required this.docuId,
    required this.memorandum_number,
    required this.docu_title,
    required this.docu_type,
    required this.docu_sender,
    required this.docu_dateNtime_released,
  });

  factory DocumentDetails.fromJson(Map<String, dynamic> json) {
    return DocumentDetails(
      docuId: json['docu_id'].toString(),
      memorandum_number: json['memorandum_number'],
      docu_title: json['docu_title'],
      docu_type: json['docu_type'],
      docu_sender: json['docu_sender'],
      docu_dateNtime_released: json['docu_dateNtime_released'],
    );
  }
}


class _DocuDetailsState extends State<DocuDetails> {
  DocumentDetailState? documentDetailState;
  var api_url = dotenv.env['API_URL'];


  @override
  void initState(){
    super.initState();
    fetchDocuDetails();
    documentDetailState = Provider.of<DocumentDetailState>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 500,
                  height: 685,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Document Type',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 10),
                      DisplayDocumentType(),
                      SizedBox(height: 20),
                      Text(
                        'Subject',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 10),
                      DisplayDocuTitle(),
                      SizedBox(height: 20),
                      Text(
                        'Order No.',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 10),
                      DisplayMemorandumNumber(),
                      SizedBox(height: 20),
                      Text(
                        'Sender',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 10),
                      DisplayOfficeName(),
                      SizedBox(height: 20),
                      Text(
                        'Date and Time Released',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 10),
                      DisplayDateNTimeReleased(),
                      SizedBox(height: 20),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     ReceiveBtn(),
                      //     SizedBox(width: 30),
                      //     CancelBtn()
                      //   ],
                      // )
                    ],
                  ),

                ),
              ),
            ),
          ],
        )
    );
  }
  Widget DisplayMemorandumNumber() => Container(
    decoration: BoxDecoration(
      // color: Colors.grey[200,
      border: Border.all(
        color: Colors.grey,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(5.0),
    ),
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
    constraints: BoxConstraints(
      minWidth: 500.0,
      minHeight: 50.0,
    ),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        Provider.of<DocumentDetailState>(context).memorandum_number ?? '',
        style: GoogleFonts.poppins(
          color: Colors.grey,
          fontSize: 15,
        ),
      ),
    ),
  );

  Widget DisplayDocuTitle() => Container(
    decoration: BoxDecoration(
      // color: Colors.grey[100],
      border: Border.all(
        color: Colors.grey,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(5.0),
    ),
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
    constraints: BoxConstraints(
      minWidth: 500.0,
      minHeight: 50.0,
    ),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        Provider.of<DocumentDetailState>(context).docu_title ?? '',
        style: GoogleFonts.poppins(
          color: Colors.grey,
          fontSize: 15,
        ),
      ),
    ),
  );

  Widget DisplayDocumentType() => Container(
    decoration: BoxDecoration(
      // color: Colors.grey[100],
      border: Border.all(
        color: Colors.grey,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(5.0),
    ),
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
    constraints: BoxConstraints(
      minWidth: 500.0,
      minHeight: 50.0,
    ),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        Provider.of<DocumentDetailState>(context).docu_type ?? '',
        style: GoogleFonts.poppins(
          color: Colors.grey,
          fontSize: 15,
        ),
      ),
    ),
  );

  Widget DisplayOfficeName() => Container(
    decoration: BoxDecoration(
      // color: Colors.grey[100],
      border: Border.all(
        color: Colors.grey,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(5.0),
    ),
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
    constraints: BoxConstraints(
      minWidth: 500.0,
      minHeight: 50.0,
    ),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        Provider.of<DocumentDetailState>(context).docu_sender?? '',
        style: GoogleFonts.poppins(
          color: Colors.grey,
          fontSize: 15,
        ),
      ),
    ),
  );

  Widget DisplayDateNTimeReleased() => Container(
    decoration: BoxDecoration(
      // color: Colors.grey[100],
      border: Border.all(
        color: Colors.grey,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(5.0),
    ),
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
    constraints: BoxConstraints(
      minWidth: 500.0,
      minHeight: 50.0,
    ),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        Provider.of<DocumentDetailState>(context).docu_dateNtime_released?? '',
        style: GoogleFonts.poppins(
          color: Colors.grey,
          fontSize: 15,
        ),
      ),
    ),
  );

  Widget ReceiveBtn() => ElevatedButton(
    child: Text('Receive'),
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.all(10.0),
      fixedSize: Size(100, 50),
      textStyle: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      primary: Colors.white,
      onPrimary: primaryColor,
      elevation: 3,
      shadowColor: Colors.transparent,
      side: BorderSide(color: primaryColor, width: 2),
      shape: StadiumBorder(),
    ),
  );

  Widget CancelBtn() => ElevatedButton(
    child: Text('Cancel'),
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.all(10.0),
      fixedSize: Size(100, 50),
      textStyle: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      primary: primaryColor,
      onPrimary: secondaryColor,
      elevation: 3,
      shadowColor: Colors.transparent,
      shape: StadiumBorder(),
    ),
  );

  // Future<String>fetchDocuDetailsData() async{
  //   final ScannedIdQRState scannedIdQRState = Provider.of<ScannedIdQRState>(context);
  //   String? docuId = scannedIdQRState.docuId;
  //
  //
  //   final response = await http.get(Uri.parse('https://5db5-2001-4456-181-8900-7912-e226-3e99-8c42.ngrok-free.app/api/documents//getDocumentent_Details/$docuId'));
  //   print(response);
  //
  //   if(response.statusCode == 200){
  //     return response.body;
  //   }else{
  //   throw Exception('Failed to load data');
  //   }
  // }

  Future<DocumentDetails> fetchDocuDetails() async {
    final ScannedIdQRState scannedIdQRState =
    Provider.of<ScannedIdQRState>(context, listen: false);
    String? docuId = scannedIdQRState.docuId;


    final response = await http.get(Uri.parse(
        '${api_url}/api/documents/getDocumentent_Details/$docuId'),
      headers:{'Accept': 'application/json',
        "ngrok-skip-browser-warning": "$localhost_port",

      },
    );
    print(response);
    if (response.statusCode == 200) {
      final docuDetails = DocumentDetails.fromJson(jsonDecode(response.body));
      print(docuDetails);

      documentDetailState!.setDocuDetails(
        docuDetails.docuId,
        docuDetails.docu_type,
        docuDetails.docu_title,
        docuDetails.memorandum_number,
        docuDetails.docu_sender,
        docuDetails.docu_dateNtime_released,
      );
      print(docuDetails.docu_type);
      print(docuDetails.docu_title);
      print(docuDetails.memorandum_number);
      print(docuDetails.docu_sender);
      print(docuDetails.docu_dateNtime_released);
      return docuDetails;
    } else {
      throw Exception('Failed to load document details');
    }
  }
}

