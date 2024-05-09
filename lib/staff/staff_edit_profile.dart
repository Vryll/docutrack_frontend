import 'package:docutrack_main/custom_widget/staff_custom_nav_bar.dart';
import 'package:docutrack_main/staff/staff_profile.dart';
import 'package:flutter/material.dart';
import 'package:docutrack_main/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:docutrack_main/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:ui' as ui;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StaffEditProfile extends StatefulWidget {
  const StaffEditProfile({Key? key}) : super(key: key);

  @override
  State<StaffEditProfile> createState() => _StaffEditProfileState();
}

class StaffInformation {
  final String first_name;
  final String middle_name;
  final String last_name;
  final String admin_office;
  final String staff_position;

  const StaffInformation({
    required this.first_name,
    required this.middle_name,
    required this.last_name,
    required this.admin_office,
    required this.staff_position,
  });

  factory StaffInformation.fromJson(Map<String, dynamic> json) {
    return StaffInformation(
      first_name: json['first_name'],
      middle_name: json['middle_name'],
      last_name: json['last_name'],
      admin_office: json['admin_office'],
      staff_position: json['staff_position'],
    );
  }
}

class _StaffEditProfileState extends State<StaffEditProfile> {
  var api_url = dotenv.env['API_URL'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  UserIdState? userIdState;
  MyappState? myAppState;

  String? first_name = "";
  String? middle_name = "";
  String last_name = "";
  String? admin_office = "";
  String staff_position = "";
  String jwtToken = "";

  XFile? _image;



  List<dynamic>? officeNames;
  String? office_name;

  List<dynamic>? staffPosition;
  String? position_name;

  Future<void> _getImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }



  fetchDocuSenderNRecipient() async {
    final response = await http.get(Uri.parse(
        '${api_url}/api/documents/getDocumentSender'));
    if (response.statusCode == 200) {
      setState(() {
        officeNames = json.decode(response.body);
      });
    }
  }

  fetchStaffPosition() async {
    final response = await http.get(Uri.parse('${api_url}/api/accounts/getStaffPosition/all'));
    if (response.statusCode == 200) {
      setState(() {
        staffPosition = json.decode(response.body);
      });
    }
  }

  @override
  void initState(){
    super.initState();
    fetchDocuSenderNRecipient();
    fetchStaffPosition();
    userIdState = Provider.of<UserIdState>(context, listen: false);
    myAppState = Provider.of<MyappState>(context, listen: false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      drawer: SideNav(),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
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

          ],
        ),
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
        ),
        actions: [
          /// UPDATED (12-03-23) ICON BUTTON ONLY
          IconButton(
            onPressed: () async{
              if (!_formKey.currentState!.validate()) {
                return;
              } else {
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
                try{
                  await _submitForm();

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
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                      onPressed: () async {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StaffProfile(),
                                          ),
                                        );
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
                        ),
                      );
                    },
                  );
                }catch(e){
                  print('Error: $e');
                  Navigator.pop(context);

                }
                };
              },
            icon: const Icon(Icons.check),
            color: secondaryColor,
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: secondaryColor,
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(top: 20,left: 10, right: 10),
                child: Column(
                  children: [
                    Row(
                      children: [

                      ],
                    ),

                    GestureDetector(
                      onTap: () {
                        _getImage();
                      },
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: secondaryColor,
                            width: 2.0,
                          ),
                        ),
                        child: _image == null
                            ? CircleAvatar(
                          backgroundColor: secondaryColor,
                          radius: 75,
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 90.0,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ) : ClipOval(
                          child: Image.network(
                            _image!.path,
                            width: 130,
                            height: 130,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    color: secondaryColor,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.0),
                          Text(
                            'Personal Information',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'First Name',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,

                                      ),
                                    ),
                                    Text(
                                      '*',
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.red
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                BuildInputFirstName(),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Text(
                                      'Middle Name',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,

                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 10.0),
                                BuildInputMiddleName(),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Text(
                                      'Last Name',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,

                                      ),
                                    ),
                                    Text(
                                      '*',
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.red
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                BuildInputLastName(),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Text(
                                      'Office',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '*',
                                      style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          color: Colors.red
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                buildInputOffice(),
                                SizedBox(height: 20.0),
                                Row(
                                  children: [
                                    Text(
                                      'Position',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '*',
                                      style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          color: Colors.red
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                buildInputPosition(),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget BuildInputFirstName() => Container(
    child: TextFormField(
      key: Key('first_name'),
      decoration: InputDecoration(
        labelText: 'Enter your first name',
        labelStyle: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.grey,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
          ),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your first name.';
        }
      },
      onSaved: (value) {first_name = value;},
    ),
  );

  Widget BuildInputMiddleName() => Container(
    child: TextFormField(
      key: Key('middle_name'),
      decoration: InputDecoration(
        labelText: 'Enter your middle name',
        labelStyle: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.grey,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
          ),
        ),
      ),
      onSaved: (value) {middle_name = value;},
    ),
  );

  Widget BuildInputLastName() => Container(
    child: TextFormField(
      key: Key('last_name'),
      decoration: InputDecoration(
        labelText: 'Enter your last name',
        labelStyle: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.grey,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
          ),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your last name.';
        }
      },
      onSaved: (value) {last_name = value ?? '';},
    ),
  );

  Widget buildInputOffice() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Choose an office',
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

      items: officeNames?.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          child: Text(
            item['office_name'],
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
          value: item['office_name'],
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          admin_office = newValue;
        });
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please choose an office.';
        }
        return null;
      },
      onSaved: (value) {
        admin_office = value;
      },
    );
  }

  Widget buildInputPosition() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Choose a position',
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
      items: staffPosition?.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          child: Text(
            item['position_name'],
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
          value: item['position_name'],
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          staff_position = newValue.toString();
        });
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please choose a position.';
        }
        return null;
      },
      onSaved: (value) {
        staff_position = value.toString();
      },
    );

  }




  Future<void> _submitForm() async {
    final userId = userIdState!.userId;

    final isValid = _formKey.currentState!.validate();
    _formKey.currentState!.save(); // Save the form fields

    try {
      final url = Uri.parse('$api_url/api/accounts/edit_staff_Details/$userId');

      String? base64Image;
      if (_image != null) {
        List<int> imageBytes = await _image!.readAsBytes();
        base64Image = base64Encode(imageBytes);
      }

      final Map<String, dynamic> requestBody = {};

      if (base64Image != null) {
        requestBody['user_image_profile'] = base64Image;
      }

      if (first_name != null) {
        requestBody['first_name'] = first_name;
      }

      if (middle_name != null) {
        requestBody['middle_name'] = middle_name;
      }

      requestBody['last_name'] = last_name;
    
      if (admin_office != null) {
        requestBody['admin_office'] = admin_office;
      }

      requestBody['staff_position'] = staff_position;
    
      print(requestBody);

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      print(response);

      if (response.statusCode == 200) {
        print('Info updated successfully');
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

}
