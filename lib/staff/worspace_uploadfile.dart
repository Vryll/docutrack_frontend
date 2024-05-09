import 'package:flutter/material.dart';
import 'package:docutrack_main/style.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:docutrack_main/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UploadFile extends StatefulWidget {
  final VoidCallback closeNewContainer;
  const UploadFile({Key? key, required this.closeNewContainer}) : super(key: key);

  @override
  _UploadFileState createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  var api_url = dotenv.env['API_URL'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? workspace_docu_type;
  String? workspace_docu_title;
  String? first_name;
  String? middle_name;
  String? last_name;
  String? workspace_docu_file;
  String? workspace_docu_status = "Pending";

  PlatformFile? _selectedFile;
  ClerkUsernameState? clerkUsernameState;
  UserIdState? userIdState;


  bool isFileAttached = false;
  bool _isFilePicked = false;


  List<dynamic>? docuTypes;

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        final selectedFile = result.files.first;


        if (selectedFile.extension == 'pdf') {
          setState(() {
            _selectedFile = selectedFile;
            _isFilePicked = true;
            print(_selectedFile);
          });
        } else {

          print('Selected file is not a PDF.');
        }
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  Future<void> fetchDocuType() async {
    final response = await http.get(Uri.parse('$api_url/api/documents/getDocuTypes'));
    if (response.statusCode == 200) {
      setState(() {
        docuTypes = json.decode(response.body);
      });
    }
  }

  void closeNewContainer() {
    setState(() {
      widget.closeNewContainer();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDocuType();
    clerkUsernameState = Provider.of<ClerkUsernameState>(context, listen: false);
    userIdState = Provider.of<UserIdState>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ModalBarrier(color: Colors.black.withOpacity(0.6), dismissible: false),
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(50.0),
                topLeft: Radius.circular(50.0),
              ),
            ),
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close_outlined),
                        color: Colors.black,
                        iconSize: 30,
                        onPressed: closeNewContainer
                        ,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(top: 20, ),
                ),
                Expanded( // Add Expanded widget
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: EdgeInsets.all(10.0),
                      children: [
                        SizedBox(height: 10),
                        BuildDocuType(),
                        SizedBox(height: 20),
                        BuildDocuTitle(),
                        SizedBox(height: 20),
                        BuildFirstName(),
                        SizedBox(height: 20),
                        BuildMiddleName(),
                        SizedBox(height: 20),
                        BuildLastName(),
                        SizedBox(height: 30),
                        if (isFileAttached || _selectedFile != null)
                          Row(
                            children: [
                              Icon(
                                Icons.attach_file,
                                color: Colors.black,
                                size: 17,
                              ),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  _selectedFile?.name ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.0,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 20),
                        !isFileAttached ? ElevatedButton(
                          onPressed: () {
                            _pickFile().then((_) {
                              if (_isFilePicked) {
                                setState(() {
                                  isFileAttached = true;
                                });
                              }
                            });
                          },
                          child: Text('Attach File',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: secondaryColor
                            ),),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(10.0),
                            fixedSize: Size(140, 55),
                            primary: primaryColor,
                            onPrimary: primaryColor,
                            elevation: 3,
                            shadowColor: Colors.transparent,
                            // side: BorderSide(color: Colors.white, width: 2),
                            shape: StadiumBorder(),
                          ),
                        ) : ElevatedButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {

                            } else {
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
                                              'Are you sure you want to upload?',
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
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      _submitForm();
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
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 20.0),                                                                child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Icon(
                                                                    Icons.check_circle,
                                                                    size: 100,
                                                                    color: Colors.green,
                                                                  ),
                                                                  SizedBox(height: 10.0),
                                                                  Text(
                                                                    'Document file has been successfully uploaded!',
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
                                                                        child: Text(
                                                                          'OK',
                                                                          style: GoogleFonts.poppins(),
                                                                        ),
                                                                        onPressed: () {
                                                                          Navigator.pop(context);
                                                                          closeNewContainer();
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 13),
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
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 13),
                                                      primary: Colors.white,
                                                      onPrimary: primaryColor,
                                                      elevation: 3,
                                                      shadowColor: Colors.white,
                                                      shape: StadiumBorder(side: BorderSide(
                                                          color: primaryColor, width: 2)),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 15,),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    child: FittedBox(
                                                      child: Text(
                                                        'Cancel',
                                                        style: GoogleFonts.poppins(
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
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
                            }
                          },
                          child: Text('Upload',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: secondaryColor
                            ),),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(10.0),
                            fixedSize: Size(140, 55),
                            primary: primaryColor,
                            onPrimary: primaryColor,
                            elevation: 3,
                            shadowColor: Colors.transparent,
                            // side: BorderSide(color: Colors.white, width: 2),
                            shape: StadiumBorder(),
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget BuildDocuType() => Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Document Type',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
        SizedBox(height: 5.0),
        Container(

          child: DropdownButtonFormField<String>(
            key: Key('workspace_docu_type'),
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
                  color: primaryColor,
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
                workspace_docu_type = newValue;
              });
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please choose a document type.';
              }
              return null;
            },
            onSaved: (value) {
              workspace_docu_type = value;
            },
          ),
        ),
      ],
    ),
  );

  Widget BuildDocuTitle() => Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Subject',
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Container(

          child: TextFormField(
            key: Key('workspace_docu_title'),
            decoration: InputDecoration(
              labelText: 'Enter document subject',
              labelStyle: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                  color: primaryColor,
                  width: 2.0,
                ),
              ),
              filled: true,
              fillColor: Colors.transparent,
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a document subject.';
              }
              return null;
            },
            onSaved: (value) {
              workspace_docu_title = value;
            },
          ),
        ),
      ],
    ),
  );

  Widget BuildFirstName() => Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Sender',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Text.rich(
          TextSpan(
            text: 'First Name ',
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black,
            ),

          ),
        ),
        SizedBox(height: 5.0),

        Container(
          height: 50,
          child: TextFormField(
            key: Key('first_name'),

            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                  color: primaryColor,
                  width: 2.0,
                ),
              ),
              filled: true,
              fillColor: Colors.transparent,
            ),
            enabled: false,
            initialValue: clerkUsernameState?.first_name,
            // onSaved: (value) {
            //   first_name = value;
            // },
            style: GoogleFonts.poppins(),
          ),
        ),
      ],
    ),
  );

  Widget BuildMiddleName() => Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: 'Middle Name ',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.black,
                ),

              ),
            ),
            SizedBox(height: 5.0),
            // INPUT MIDDLE NAME TEXTBOX
            Container(
              height: 50,
              child: TextFormField(
                key: Key('middle_name'),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: primaryColor,
                      width: 2.0,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
                enabled: false,
                initialValue: clerkUsernameState?.middle_name,
                // onSaved: (value) {
                //   middle_name = value;
                // },
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget BuildLastName() => Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Last Name ',
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black,
            ),

          ),
        ),
        SizedBox(height: 5.0),
        // INPUT LAST NAME TEXTBOX
        Container(
          height: 50,
          child: TextFormField(
            key: Key('last_name'),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              filled: true,
              fillColor: Colors.transparent,
            ),
            enabled: false,
            initialValue: clerkUsernameState?.last_name,
            // onSaved: (value) {
            //   last_name = value;
            // },
            style: GoogleFonts.poppins(),
          ),
        ),
      ],
    ),
  );


  Future<void> _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid && _selectedFile != null) {
      _formKey.currentState!.save();
      try {
        final String userId = userIdState!.userId.toString();
        print('Sending request...');
        final url = Uri.parse('${api_url}/api/workspace/createworkspace/user_id=$userId');
        final request = http.MultipartRequest('POST', url)
          ..fields['workspace_docu_type'] = workspace_docu_type!
          ..fields['workspace_docu_title'] = workspace_docu_title!
          ..fields['workspace_docu_status'] = workspace_docu_status!
          ..files.add(await http.MultipartFile.fromPath('workspace_docu_file', _selectedFile!.path ?? ""));

        print('Data before sending:');
        print(workspace_docu_status);
        print(workspace_docu_type);
        print(workspace_docu_title);
        print(_selectedFile);

        final response = await request.send();

        print('Response status code: ${response.statusCode}');
        print('Response body: ${await response.stream.bytesToString()}');

        if (response.statusCode == 200) {
          print('Successfully saved!');

        } else {
          print('Failed to save!');

        }
      } catch (e) {
        print('Error: $e');

      }
    }
  }

}
