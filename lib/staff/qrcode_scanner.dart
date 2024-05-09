import 'package:docutrack_main/main.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:docutrack_main/staff/staff_viewPage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



class ScanQRCode extends StatefulWidget {
  const ScanQRCode({Key? key}) : super(key: key);

  @override
  _ScanQRCodeState createState() => _ScanQRCodeState();
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

class UpdateStatus {
  final String? status_value;

  const UpdateStatus({
    required this.status_value,
  });

  factory UpdateStatus.fromJson(Map<String, dynamic> json) {
    return UpdateStatus(
      status_value: json['status_value'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'status_value': status_value,
    };
  }
}


class _ScanQRCodeState extends State<ScanQRCode> {
  var api_url = dotenv.env['API_URL'];
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrCode = "";
  bool shouldScanQRCode = true;

  ScannedIdQRState? scannedIdQRState;

  scannedDataState? ScannedDataState;
  DocumentDetailState? documentDetailState;
  MyappState? myAppState;

  String jwtToken = "";
  String statusValue = "";

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
    documentDetailState = Provider.of<DocumentDetailState>(context, listen: false);
    myAppState = Provider.of<MyappState>(context, listen: false);
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
      // floatingActionButton: Padding(
      //   padding: EdgeInsets.only(bottom: 30.0),
      //   child: FloatingActionButton(
      //     onPressed: () async {
      //       await controller?.stopCamera();
      //
      //
      //           //put the path
      //
      //     },
      //     backgroundColor: Colors.white,
      //     child: Icon(
      //       Icons.circle_outlined,
      //       size: 55.0,
      //       color: Colors.black,
      //     ),
      //   ),
      // ),
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
            documentDetailState.setDocuDetails(docuId, docu_type, docu_title, memorandum_number, docu_sender, docu_dateNtime_released);


            Navigator.of(context).push(
              MaterialPageRoute(builder: (context)=>StaffPageView())
            );


            controller.stopCamera();
          }
        }
      });
    });
  }

}