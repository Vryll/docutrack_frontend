import 'package:docutrack_main/admin/admin_home_page.dart';
import 'package:docutrack_main/style.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:http_parser/http_parser.dart';
import 'package:docutrack_main/custom_widget/custom_side_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:docutrack_main/main.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:docutrack_main/admin/modified_docu_file_preview.dart';
import 'package:logger/logger.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:docutrack_main/localhost.dart';

class GenerateQR extends StatefulWidget {
  const GenerateQR({Key? key}) : super(key: key);

  @override
  State<GenerateQR> createState() => _GenerateQRState();
}

class PDFDocuFileView{
  final String? modified_docu_file;

  PDFDocuFileView({
    required this.modified_docu_file,
  });

  factory PDFDocuFileView.fromJson(Map<String, dynamic>json){
    return PDFDocuFileView(
      modified_docu_file: json['modified_docu_file'] ?? '',
    );
  }
}

class _GenerateQRState extends State<GenerateQR> with RouteAware{
  var api_url = dotenv.env['API_URL'];
  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();
  Uint8List? _qrCodeBytes;
  Future? _qrCodeSuccessfullyGenerated;
  PlatformFile? _selectedFile;
  // String? qrData;
  String? docu_title;
  String? type;
  String? docu_dateNtime_released;
  String? docu_sender;
  List<String> docu_recipient = [];
  String? memorandum_number;
  var logger = Logger();

  // String? docu_id = "";

  String? dateReleased;

  bool isPreview = false;

  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;


  QrCodeDataState? qrCodeDataState;
  UserOfficeNameState? userOfficeNameState;
  PDFDocuFilePreviewState? pdfDocuFilePreviewState;
  Uint8List? _fileBytes;


  // String? docuTitle;
  // String? docuType;
  // String? docuSender;
  // String? docuRecipient;
  // String? docuFile;

  String qrData = "";


  String fileContents = "";



  final GlobalKey _globalKey = GlobalKey();

  Future<void> _captureImg() async {
    try {
      RenderRepaintBoundary boundary =
      _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      _qrCodeBytes = byteData!.buffer.asUint8List();
      print(_qrCodeBytes);


    } catch (e) {
      print('error: $e');
    }
  }


  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['docx'],
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _selectedFile = result.files.first;
          _fileBytes = result.files.single.bytes;
          print(_selectedFile);

        });
      }
    } catch (e) {
      print('error picking file: $e');
    }
  }


  //Dropdown for docuTypes
  List<dynamic>? docuTypes;
  String? docu_type;

  //Dropdown for docuSender&Recipient
  List<dynamic>? officeNames;
  String? office_name;

  @override
  void initState() {
    super.initState();
    fetchDocuType();
    fetchDocuSenderNRecipient();
    ModifyPDFDocument();
    qrCodeDataState = Provider.of<QrCodeDataState>(context, listen: false);
    userOfficeNameState = Provider.of<UserOfficeNameState>(context, listen: false);
  }

  @override
  void dispose(){
    super.dispose();
    routeObserver.unsubscribe(this);
    qrCodeDataState!.cleanup();
    refreshState();
  }

  void refreshState() {
    if (mounted) {
      setState(() {
        isPreview = false;
        buildGenerateQrCode(
          qrCodeDataState!.docu_id = null,
          qrCodeDataState!.memorandumNumber = null,
          qrCodeDataState!.docuTitle = null,
          qrCodeDataState!.docuType = null,
          qrCodeDataState!.docuReleased = null,
          qrCodeDataState!.docuSender = null,
          qrCodeDataState!.docuRecipient = <String>[],
          qrCodeDataState!.docuFile = null,
        );
      });
    }
  }

  // @override
  // void didPush(){
  //   qrCodeDataState!.setQrDataToFalse;
  //   print("awesome");
  //
  // }
  //
  // @override
  // void didPopNext(){
  //   qrCodeDataState!.setQrDataToFalse;
  //   logger.d(qrCodeDataState!.isQrDataSet);
  //   print("sheesh");
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    qrCodeDataState = Provider.of<QrCodeDataState>(context, listen: true);
    pdfDocuFilePreviewState =  Provider.of<PDFDocuFilePreviewState>(context, listen: true);
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  //fetching data of document type from the database
  fetchDocuType() async {
    try {
      final response = await http.get(Uri.parse('${api_url}/api/documents/getDocuTypes'),
        headers:{'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",
        },
      );
      if (response.statusCode == 200) {
        docuTypes = json.decode(response.body);
        logger.i('Fetched document types successfully: $docuTypes');
      } else {
        logger.e('Failed to fetch document types. Status code: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error fetching document types: $e');
    }
  }


  Future<void> fetchDocuSenderNRecipient() async {
    try {
      final response = await http.get(Uri.parse("${api_url}/api/documents/getDocumentSender"),
        headers:{
          'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          officeNames = json.decode(response.body);
        });
      } else {
        print('Error fetching data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  String getStoredOfficeName() {
    return userOfficeNameState?.getStoredOfficeName() ?? "";
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
          'Generate QR Code',
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
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                child: Text(
                                  'Generate QR Code',
                                  style: GoogleFonts.poppins(
                                    fontSize: 45.0,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                  maxLines: 1,
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
                      const SizedBox(height: 30.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              child: Text(
                                'Document/QR Code Information',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text.rich(
                              TextSpan(
                                text: 'Document Type ',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            buildInputDocumentType(),
                            SizedBox(height: 20),
                            Text.rich(
                              TextSpan(
                                text: 'Order No. ',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            BuildMemorandumNumForm(),
                            SizedBox(height: 20),
                            Text.rich(
                              TextSpan(
                                text: 'Subject ',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            BuildInputDocumenTitle(),
                            SizedBox(height: 20),

                            Text.rich(
                              TextSpan(
                                text: 'Date Released ',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            buildDateReleased(),
                            SizedBox(height: 20),
                            Text(
                              'Office Name',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text.rich(
                              TextSpan(
                                text: 'Sender ',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            buildInputSender(),
                            SizedBox(height: 20),
                            Text.rich(
                              TextSpan(
                                text: 'Recipient/s ',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            buildInputRecipient(),
                            if (_selectedFile != null)
                              SizedBox(height: 30),
                            if (_selectedFile != null)
                              Row(
                                children: [
                                  Icon(
                                    Icons.attach_file,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10.0),
                                  Expanded(
                                    child: Text(
                                      _selectedFile?.name ?? '',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: _pickFile,
                              child: Text(
                                'Choose a file',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(10.0),
                                minimumSize: Size(120, 25),
                                primary: secondaryColor,
                                onPrimary: primaryColor,
                                shadowColor: secondaryColor,
                                side: BorderSide(color: primaryColor!, width: 2),
                                shape: StadiumBorder(),
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(0),
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 50.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Container(
                            height: 300,
                            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: qrCodeDataState!.isQrDataSet
                                ? Center(
                              child: buildGenerateQrCode(
                                qrCodeDataState!.docu_id,
                                qrCodeDataState!.memorandumNumber,
                                qrCodeDataState!.docuTitle,
                                qrCodeDataState!.docuType,
                                qrCodeDataState!.docuReleased,
                                qrCodeDataState!.docuSender,
                                qrCodeDataState!.docuRecipient,
                                qrCodeDataState!.docuFile,
                              ),
                            )
                                : Center(
                              child: Text(
                                'QR code',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(),
                          SizedBox(height: 30.0),
                          Container(
                            padding: const EdgeInsets.only(top: 50),
                            constraints: const BoxConstraints(maxWidth: 300),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BuildSaveBtn(),
                                SizedBox(width: 20),
                                !isPreview ?
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: qrCodeDataState!.isQrDataSet ? () async {
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
                                                      'Are you sure you want to save?',
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
                                                              await _captureImg();
                                                              _updateForm();
                                                              Navigator.pop(context);
                                                              showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return AlertDialog(
                                                                    contentPadding: EdgeInsets.zero,
                                                                    content: Container(
                                                                      width: 350,
                                                                      height: 250,
                                                                      decoration: ShapeDecoration(
                                                                        color: Colors.white,
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(5),
                                                                        ),
                                                                      ),
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.check_circle,
                                                                            size: 100,
                                                                            color: Colors.green,
                                                                          ),
                                                                          SizedBox(height: 10.0),
                                                                          Text(
                                                                            'Account has been successfully updated!',
                                                                            style: GoogleFonts.poppins(
                                                                              fontSize: 14,
                                                                            ),
                                                                            textAlign: TextAlign.center,
                                                                          ),
                                                                          SizedBox(height: 25.0),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              ElevatedButton(
                                                                                child: Text('OK'),
                                                                                onPressed: () {
                                                                                  setState(() {
                                                                                    isPreview = true;
                                                                                  });
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  padding: EdgeInsets.symmetric(
                                                                                      horizontal: 50, vertical: 13),
                                                                                  textStyle: GoogleFonts.poppins(
                                                                                    fontSize: 14,
                                                                                  ),
                                                                                  primary: Colors.white,
                                                                                  onPrimary: Colors.green,
                                                                                  elevation: 3,
                                                                                  shadowColor: Colors.transparent,
                                                                                  shape: StadiumBorder(
                                                                                    side: BorderSide(
                                                                                        color: Colors.green, width: 2),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              );
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
                                                              maxLines: 1,
                                                            )),
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
                                    } : null,
                                    child: Text('Save',
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
                                )
                                    :
                                BuildPreviewBtn(),
                              ],
                            ),
                          ),


                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget BuildMemorandumNumForm() => TextFormField(
    key: Key('memorandum_number'),
    decoration: InputDecoration(
      labelText: 'Enter order no.',
      labelStyle: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.grey,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: primaryColor
        ),
      ),
    ),
    validator: (String? value){
      if(value == null || value.isEmpty){
        return 'Please enter order number.';
      }
      return null;
    },
    onSaved: (value){memorandum_number = value;},
  );

  Widget BuildInputDocumenTitle() =>
      TextFormField(
        key: Key('docu_title'),
        decoration: InputDecoration(
          labelText: 'Enter a document subject',
          labelStyle: GoogleFonts.poppins(
            fontSize: 15,
            color: Colors.grey,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: primaryColor
            ),
          ),
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a document subject.';
          }
          return null;
        },
        onSaved: (value) {
          docu_title = value;
        },
      );

  Widget buildInputDocumentType() {
    return DropdownButtonFormField<String>(
      key: Key('docu_sender'),
      decoration: InputDecoration(
        labelText: 'Choose a document type',
        labelStyle: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.grey,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: primaryColor
          ),
        ),
      ),
      items: docuTypes?.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          child: Text(
            item['docu_type'],
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
          value: item['docu_type'],
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          docu_type = newValue;
        });
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please choose a document type.';
        }
        return null;
      },
      onSaved: (value) {
        docu_type = value;
      },
    );
  }
  Widget buildDateReleased() => TextFormField(
    key: Key('date_released'),
    onTap: () {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              datePickerTheme: DatePickerTheme.of(context).copyWith(
                shape: Border(),
              ),
              colorScheme: ColorScheme.light(
                primary: primaryColor,
              ),
            ),
            child: child!,
          );
        },
      ).then((selectedDate) {
        if (selectedDate != null) {
          // Handle the selected date
          String formattedDate = DateFormat('MM-dd-yyyy').format(selectedDate);
          setState(() {
            dateReleased = formattedDate;
          });
        }
      });
    },
    controller: TextEditingController(text: dateReleased),
    decoration: InputDecoration(
      labelText: 'Date Released',
      contentPadding: EdgeInsets.symmetric(horizontal: 10.00),
      labelStyle: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.grey,
      ),
      suffixIcon: Icon(
          Icons.calendar_today,
          color: Colors.black,
          size: 20
      ),
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: primaryColor
        ),
      ),
    ),
    validator: (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please choose a date';
      }
      return null;
    },
    onSaved: (value) {
      docu_dateNtime_released = value;
    },
  );


  Widget buildInputSender() {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
      enabled: false,
      initialValue: getStoredOfficeName(),
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.grey,
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      onSaved: (value) {
        docu_sender = value;
      },
    );
  }

  Widget buildInputRecipient() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Choose recipient\'s office name',
            labelStyle: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.grey,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: primaryColor
              ),
            ),
          ),
          items: officeNames?.map<DropdownMenuItem<String>>((item) {
            return DropdownMenuItem<String>(
              child: Text(
                item['office_name'],
                style: GoogleFonts.poppins(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              value: item['office_name'],
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              docu_recipient.add(newValue.toString());
            });
          },
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please choose recipient\'s office name';
            }
            return null;
          },
          onSaved: (value) {
            docu_recipient.add(value.toString());
          },
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Text(
              'Selected Offices:',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: SizedBox(
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: docu_recipient.length,
                  itemBuilder: (context, index) {
                    String officeName = docu_recipient.elementAt(index);

                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            officeName,
                            style: GoogleFonts.poppins(
                                fontSize: 14
                            ),
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                docu_recipient.remove(officeName);
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildGenerateQrCode(docu_id, memorandumNumber, docuTitle, docuType, docuReleased, docuSender, List<String> docuRecipient, docuFile) {
    return RepaintBoundary(
      key: _globalKey,
      child: QrImageView(
        data: docu_id +
            ',' +
            memorandumNumber +
            ',' +
            docuTitle +
            ',' +
            docuType +
            ',' +
            docuReleased +
            ',' +
            docuSender +
            ',' +
            docuRecipient.join(',') +
            ',' +
            docuFile,
        version: QrVersions.auto,
        size: 250.0,
      ),
    );
  }


  Widget BuildSaveBtn() => ElevatedButton(
    onPressed: !isPreview && !qrCodeDataState!.isQrDataSet ? () {
      _submitForm();
    } : null,
    child: Text(
        'Generate',
        style: GoogleFonts.poppins(
            color: secondaryColor,
            fontSize: 15
        )
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
  );

  Widget BuildPreviewBtn() => Expanded(
    child: ElevatedButton(
      onPressed: () async{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: SpinKitThreeBounce(
                color: secondaryColor,
                size: 30.0,
              ),
            );
          },
        );
        await ModifyPDFDocument();

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => DocuFilePreview()),
              (Route<dynamic> route) => false,
        );

      },
      child: Text(
          'Preview',
          style: GoogleFonts.poppins(
            color: secondaryColor,
            fontSize: 15,
          )
      ),
      style:  ElevatedButton.styleFrom(
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


//   //saving form
  Future<void> _submitForm() async {

    final isValid = _formKey.currentState!.validate();
    if (isValid && _fileBytes != null) {
      _formKey.currentState!.save();
      try {
        // List<int> nonNullableBytes = _qrCodeBytes ?? Uint8List(0);
        List<int> nonNullableFileBytes = _fileBytes ?? Uint8List(0);
        String base64File = base64Encode(nonNullableFileBytes);
        print(base64File);
        // String base64Image = base64Encode(nonNullableBytes);
        final url = Uri.parse(
            '${api_url}/api/documents/generate_qr_code');
        final request = http.MultipartRequest('POST', url)
          ..fields['memorandum_number'] = memorandum_number!
          ..fields['docu_title'] = docu_title!
          ..fields['docu_type'] = docu_type!
          ..fields['docu_dateNtime_released'] = docu_dateNtime_released!
          ..fields['docu_sender'] = docu_sender!
          ..fields['docu_recipient'] = docu_recipient.join(',')
          ..fields['docu_file'] = base64File!
          ..fields['docu_file_name'] = _selectedFile!.name;



        final response = await request.send();

        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();

          final Map<String, dynamic> responseMap = json.decode(responseBody);


          String successMessage = responseMap['success'];


          Map<String, dynamic> documentDetails = responseMap['Document_Details'];
          print(documentDetails);


          int docuId = documentDetails['docu_id'];
          String memorandumNumber = documentDetails['memorandum_number'];
          String docuTitle = documentDetails['docu_title'];
          String docuType = documentDetails['type'];
          String docuReleased = documentDetails['docu_dateNtime_released'];
          String docuSender = documentDetails['docu_sender'];
          List<String> docuRecipient = [];
          List<dynamic> docuRecipientData = documentDetails['docu_recipient'];
          docuRecipient = docuRecipientData.cast<String>();
          String docuFile = documentDetails['docu_file'];

          // print("Before setqrData:");
          // print("docu_id: $docuId");
          // print("memorandumNumber: $memorandumNumber");

          qrCodeDataState!.setqrData(docuId.toString(), memorandumNumber, docuTitle, docuReleased, docuType, docuSender, docuRecipient, docuFile);

          print("After setqrData:");
          print("docu_id: ${qrCodeDataState!.docu_id}");

          print(docuId);
          print(memorandumNumber);
          print(docuTitle);
          print(docuType);
          print(docuReleased);
          print(docuSender);
          print(docuRecipient);
          print(docuFile);

          print("file successfully uploaded");
          print(request);

          // updateQRData();
        } else {
          print('uploaded failed');
        }
      } catch (e) {
        print('error: $e');
      }
    }
  }

  //update form
  Future<void> _updateForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();

      try {
        List<int> nonNullableBytes = _qrCodeBytes ?? Uint8List(0);
        String base64Image = base64Encode(nonNullableBytes);
        print(base64Image);
        final qrCodeData = Provider.of<QrCodeDataState>(context, listen: false);

        if (qrCodeData.isQrDataSet) {
          final docu_id = qrCodeData.docu_id;
          print(docu_id);

          final url = Uri.parse('${api_url}/api/documents/update_generated_qr_code/${Uri.encodeComponent(docu_id!)}');

          final request = http.MultipartRequest('POST', url)
            ..files.add(http.MultipartFile.fromString(
                'docu_qr_code',
                base64Image));
          print(url);

          final response = await request.send();
          if (response.statusCode == 200) {

            print('Document updated successfully');
          } else {

            print('Upload failed with status code: ${response.statusCode}');
          }
        } else {
          print('QR data is not set');
        }
      } catch (e) {

        print('Error: $e');
      }
    }
  }

  void snackBar(context, String msg) {
    final snackBar = SnackBar(content: Text(
      msg,
      style: TextStyle(
        fontSize: 18,
        backgroundColor: Colors.green,
      ),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> ModifyPDFDocument() async {
    try {
      final docuId = qrCodeDataState!.docu_id;
      print(docuId);

      if (docuId == null) {

        throw Exception('docuId is null');
      }

      final response = await http.post(
        Uri.parse('${api_url}/api/documents/word_file_processing/$docuId'),
        headers:{'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",

        },

      );
      print(response);
      if (response.statusCode == 200) {
        print('QR code inserted into the document');

        final Map<String, dynamic>responseBody = jsonDecode(response.body);

        final String modified_docu_file = responseBody['modified_docu_file'];

        pdfDocuFilePreviewState!.setPDFDocuFilePreview(modified_docu_file);


        print(modified_docu_file);
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}