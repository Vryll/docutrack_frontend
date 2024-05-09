import 'package:docutrack_main/main.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:docutrack_main/guest/guest_viewPage.dart';

class GuestScanQRCode extends StatefulWidget {
  const GuestScanQRCode({super.key});

  @override
  State<GuestScanQRCode> createState() => _GuestScanQRCodeState();
}

class Document {
  final String docuId;
  final String memorandumNumber;
  final String docuTitle;
  final String docuType;
  final String docuReleased;
  final String docuSender;
  final String docuRecipient;
  final String docuFile;

  Document({
    required this.docuId,
    required this.memorandumNumber,
    required this.docuTitle,
    required this.docuType,
    required this.docuReleased,
    required this.docuSender,
    required this.docuRecipient,
    required this.docuFile,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      docuId: json['docuId'],
      memorandumNumber: json['memorandumNumber'],
      docuTitle: json['docuTitle'],
      docuType: json['docuType'],
      docuReleased: json['docuReleased'],
      docuSender: json['docuSender'],
      docuRecipient: json['docuRecipient'],
      docuFile: json['docuFile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docuId': docuId,
      'memorandum': memorandumNumber,
      'docuTitle': docuTitle,
      'docuType': docuType,
      'docuReleased': docuReleased,
      'docuSender': docuSender,
      'docuRecipient': docuRecipient,
      'docuFile': docuFile,
    };
  }
}


class _GuestScanQRCodeState extends State<GuestScanQRCode> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrCode = "";
  bool shouldScanQRCode = true;

  ScannedIdQRState? scannedIdQRState;

  scannedDataState? ScannedDataState;

  String? docuId;
  String? memorandumNumber;
  String? docuTitle;
  String? docuType;
  String? docuReleased;
  String? docuSender;
  String? docuRecipient;
  String? docuFile;

  @override
  void initState(){
    super.initState();
    scannedIdQRState = Provider.of<ScannedIdQRState>(context, listen: false);
    // sendDocuIdToBackend;

    // sendDocuIdForCreate;


  }

  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildQrView(context),
          Positioned(
            top: 60.0,
            left: 15.0,
            child: Builder(
              builder: (BuildContext context) => IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back),
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 70.0,
            left: 50.0,
            right: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Container()),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Scan QR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.yellow,
        borderLength: 110,
        borderWidth: 3,
        cutOutSize: MediaQuery.of(context).size.width * 0.6,
      ),
    );
  }
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      if (!shouldScanQRCode) {
        return;
      }
      setState(() {
        qrCode = scanData.code;
        print('Scanned Data: ${qrCode}');

        if (qrCode != null) {
          shouldScanQRCode = false;
          List<String> qrCodeValues = qrCode!.split(',');
          print(qrCodeValues);

          if (qrCodeValues.length >= 5) {

            String docuId = qrCodeValues[0];
            String memorandum_number = qrCodeValues[1];
            String docu_title = qrCodeValues[2];
            String docu_dateNtime_released = qrCodeValues[3];
            String docu_type = qrCodeValues[4];
            String docu_sender = qrCodeValues[5];


            DocumentDetailState documentDetailState = Provider.of<DocumentDetailState>(context, listen: false);
            documentDetailState.setDocuDetails(docuId,docu_type, docu_title, memorandum_number, docu_sender, docu_dateNtime_released);



            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => GuestPageView(),
              ),
            );
            controller.stopCamera();
          }
        }
      });
    });
  }


  // Future<void> sendDocuIdToBackend(String? docuId) async {
  //   if (docuId == null) {
  //     print('docuId is null, cannot send to backend.');
  //     return;
  //   }
  //   final url = 'https://1de1-180-191-144-234.ngrok-free.app/api/documents/getDocumentent_Details/$docuId';
  //   print(url);
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //
  //     if (response.statusCode == 200) {
  //       // Handle the successful response here
  //       final Map<String, dynamic> responseData = json.decode(response.body);
  //       final int? docuId = responseData['docu_id'];
  //
  //       print(docuId);
  //       print('Backend Response: $responseData');
  //     } else {
  //       // Handle errors here
  //       print('HTTP Request Error: ${response.reasonPhrase}');
  //     }
  //   } catch (error) {
  //     print('Error sending request: $error');
  //   }
  // }
}
