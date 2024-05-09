import 'package:docutrack_main/main.dart';
import 'package:docutrack_main/style.dart';
import 'package:docutrack_main/superadmin/superadmin_archived.dart';
import 'package:flutter/material.dart';
import 'package:docutrack_main/superadmin/superadmin_homepage.dart';
import 'package:docutrack_main/superadmin/generate_adminAccount.dart';
import 'package:docutrack_main/superadmin/superadmin_dashboard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:docutrack_main/superadmin/superadmin_aboutUs.dart';
import 'package:docutrack_main/superadmin/superadmin_my_profile_page.dart';
import 'package:docutrack_main/superadmin/superadmin_records_dashboard.dart';
import 'package:docutrack_main/localhost.dart';

class SideNav extends StatefulWidget {
  const SideNav({Key? key}) : super(key: key);

  @override
  _SideNavState createState() => _SideNavState();
}

class AdminData {
  final int? id;
  final String? email;
  final String? admin_logo;
  final String? office_name;
  final int? userId;

  const AdminData({
    required this.id,
    required this.email,
    required this.admin_logo,
    required this.office_name,
    required this.userId,
  });

  factory AdminData.fromJson(Map<String, dynamic> json) {
    return AdminData(
      id: json['id'],
      email: json['email'],
      admin_logo: json['admin_logo'] ,
      office_name: json['office_name'] ,
      userId: json['user_id'],
    );
  }

  static List<AdminData> fromJsonList(List<dynamic> list) {
    List<AdminData> adminDataList = [];
    for (var json in list) {
      adminDataList.add(AdminData.fromJson(json));
    }
    return adminDataList;
  }

  @override
  String toString() {
    return 'AdminData(id: $id, email: $email, admin_logo: $admin_logo, office_name: $office_name, userId: $userId)';
  }
}


class SuperadminProfileDetails {
  int? userId;
  String? email;
  String? superadmin_name;
  String? superadmin_image;
  String? password;

  int? user_id;

  SuperadminProfileDetails({
    required this.userId,
    required this.email,
    required this.superadmin_name,
    required this.superadmin_image,
    required this.password,

    required this.user_id,
  });

  factory SuperadminProfileDetails.fromJson(Map<String, dynamic> json) {
    return SuperadminProfileDetails(
      userId: json['user']['userId'] ?? '',
      email: json['user']['email'] ?? '',
      superadmin_name: json['superadmin_data']['superadmin_name'] ?? '',
      superadmin_image: json['superadmin_data']['superadmin_image'],
      password: json['user']['password'] ?? '',

      user_id: json['superadmin_data']['user_id'] ?? '',
    );
  }
}

class ReceiversRecordDetails {
  final int? record_id;
  final int? docu_details_id;
  final String? docu_title;
  final String? memorandum_number;
  final String? status;
  final String? type;
  final int? user_staff_id;
  final String? admin_office;
  final String? first_name;
  final String? last_name;
  final String? time_scanned;


  ReceiversRecordDetails({
    required this.record_id,
    required this.docu_details_id,
    required this.docu_title,
    required this.memorandum_number,
    required this.status,
    required this.type,
    required this.user_staff_id,
    required this.admin_office,
    required this.first_name,
    required this.last_name,
    required this.time_scanned,

  });

  factory ReceiversRecordDetails.fromJson(Map<String, dynamic> json) {
    return ReceiversRecordDetails(
      record_id: json['record_id'],
      docu_details_id: json['docu_details']['docu_details_id'],
      docu_title: json['docu_details']['docu_title'],
      memorandum_number: json['docu_details']['memorandum_number'],
      status: json['docu_details']['status'],
      type: json['docu_details']['type'],
      user_staff_id: json['user_staff']['user_staff_id'],
      admin_office: json['user_staff']['admin_office'],
      first_name: json['user_staff']['first_name'],
      last_name: json['user_staff']['last_name'],
      time_scanned: json['time_scanned'],
    );
  }

  static List<ReceiversRecordDetails> fromJsonList(List<dynamic> list) {
    List<ReceiversRecordDetails> receiversRecordDetails = [];
    for (var json in list) {
      receiversRecordDetails.add(ReceiversRecordDetails.fromJson(json));
    }
    return receiversRecordDetails;
  }

  @override
  String toString() {
    return 'ReceiversRecordDetails(record_id: $record_id, docu_details_id: $docu_details_id,docu_title: $docu_title,memorandum_number: $memorandum_number,status: $status,type: $type,user_staff_id: $user_staff_id,admin_office: $admin_office,first_name: $first_name,last_name: $last_name,time_scanned: $time_scanned)';
  }
}

class AdminAccCount{
  final int? adminCount;

  const AdminAccCount({
    required this.adminCount,
  });
  factory AdminAccCount.fromJson(Map<String, dynamic>json){
    return AdminAccCount(
        adminCount: json['adminCount']
    );
  }
}

class ScannedRecordsCnt{
  final int? count;

  const ScannedRecordsCnt({
    required this.count,
  });
  factory ScannedRecordsCnt.fromJson(Map<String, dynamic>json){
    return ScannedRecordsCnt(
        count: json['scanned_records']
    );
  }
}


class _SideNavState extends State<SideNav> {
  var api_url = dotenv.env['API_URL'];
  String selectedItem = '';
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isTablet (BuildContext context) =>
      MediaQuery.of(context).size.width <= 800;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 800;

  UserAccountsDashboard? userAccountsDashboard;
  SuperadminProfileState? superadminProfileState;
  MyappState? myAppState;
  UserIdState? userIdState;

  int? userId;
  String? email;
  String? superadmin_name;
  String? password;
  String? superadmin_image;
  int? user_id;

  String jwtToken = "";

  bool showDashboard = false;

  ReceiversRecordDetailsDashboard? receiversRecordDetailsDashboard;
  ScannedRecordCountState? scannedRecordCountState;

  @override
  void initState(){
    super.initState();
    userAccountsDashboard = Provider.of<UserAccountsDashboard>(context, listen:false);
    myAppState = Provider.of<MyappState>(context, listen: false);
    userIdState = Provider.of<UserIdState>(context, listen: false);
    superadminProfileState = Provider.of<SuperadminProfileState>(context, listen: false);
    scannedRecordCountState = Provider.of<ScannedRecordCountState>(context, listen: false);
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    receiversRecordDetailsDashboard = Provider.of<ReceiversRecordDetailsDashboard>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: primaryColor,
        child: Column(
          children: [
            DrawerHeader(
              padding: EdgeInsets.only(left: isTablet(context) ? 18 : 32.0, right: isMobile(context) ? 12 : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/DocuTrack(White).png',
                    height: 50,
                    width: 50,
                  ),
                  if (isWeb(context) || isMobile(context))
                    SizedBox(width: 5),
                  if (isWeb(context) || isMobile(context))
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'DocuTrack',
                          style: GoogleFonts.russoOne(
                            color: secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                          maxLines: 1,
                        ),
                        Text(
                          'Document Tracking and Management System',
                          style: GoogleFonts.poppins(
                            color: secondaryColor,
                            fontSize: 5.5,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  if (isMobile(context))
                    Spacer(),
                  if (isMobile(context))
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          color: secondaryColor,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  MyListTile(
                    icon: Icons.house,
                    title: (isWeb(context) || isMobile(context)) ? 'Home' : '',
                    onTap: () {
                      Provider.of<SelectedItemProvider>(context, listen: false).setSelectedItem('Home');
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SuperAdmin_HomePage()),
                      );
                    },
                    isSelected: Provider.of<SelectedItemProvider>(context).selectedItem == 'Home',
                  ),
                  MyListTile(
                    icon: Icons.switch_account,
                    title: (isWeb(context) || isMobile(context)) ? 'Generate Account' : '',
                    onTap: () {
                      Provider.of<SelectedItemProvider>(context, listen: false).setSelectedItem('Generate Account');
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Generate_AdminAcc()),
                      );
                    },
                    isSelected: Provider.of<SelectedItemProvider>(context).selectedItem == 'Generate Account',
                  ),
                  MyListTile(
                    icon: Icons.dashboard,
                    title: (isWeb(context) || isMobile(context)) ? 'Dashboard' : '',
                    onTap: () async {
                      setState(() {
                        showDashboard = !showDashboard;
                      });
                    },
                    icon2: showDashboard ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    onTrailing: () {},
                    isSelected: selectedItem == 'Dashboard',
                  ),
                  if (showDashboard)
                    Column(
                      children: [
                        Column(
                          children: [
                            MyListTile3(
                              icon: Icons.supervisor_account,
                              title: (isWeb(context) || isMobile(context)) ? 'Accounts' : '',
                              onTap: () async {
                                await fetchAdminData();
                                // await fetchAdminCount();
                                Provider.of<SelectedItemProvider>(context, listen: false).setSelectedItem('Accounts');
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SuperadminDashboard()),
                                );
                              },
                              isSelected: Provider.of<SelectedItemProvider>(context).selectedItem == 'Accounts',
                            ),
                            if (selectedItem == 'Accounts')
                              SizedBox(),
                          ],
                        ),
                        Column(
                          children: [
                            MyListTile3(
                              icon: Icons.file_present,
                              title: (isWeb(context) || isMobile(context)) ? 'Documents' : '',
                              onTap: () async {
                                await fetchReceiverRecordData();
                                // await fetchScannedRecordsCount();
                                Provider.of<SelectedItemProvider>(context, listen: false).setSelectedItem('Documents');
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RecordsDashboard()),
                                );
                              },
                              isSelected: Provider.of<SelectedItemProvider>(context).selectedItem == 'Documents',
                            ),
                            if (selectedItem == 'Documents')
                              SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  MyListTile(
                    icon: Icons.lightbulb,
                    title: (isWeb(context) || isMobile(context)) ? 'About Us' : '',
                    onTap: () {
                      Provider.of<SelectedItemProvider>(context, listen: false).setSelectedItem('About Us');
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUs()),);
                    },
                    isSelected: Provider.of<SelectedItemProvider>(context).selectedItem == 'About Us',
                  ),
                ],
              ),
            ),
            MyListTile(
              icon: Icons.archive,
              title: (isWeb(context) || isMobile(context)) ? 'Archived' : '',
              onTap: () async{
                Provider.of<SelectedItemProvider>(context, listen: false).setSelectedItem('Archived');
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => Superadmin_Archived()));
              },
              isSelected: Provider.of<SelectedItemProvider>(context).selectedItem == 'Archived',
            ),
            MyListTile(
              icon: Icons.person,
              title: (isWeb(context) || isMobile(context)) ? 'My Profile' : '',
              icon2: Icons.keyboard_arrow_right,
              onTap: () async{
                Provider.of<SelectedItemProvider>(context, listen: false).setSelectedItem('My Profile');
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfile()));
                await sendTokenToBackend(jwtToken);
                await fetchSuperadminDetails();

              },
              isSelected: Provider.of<SelectedItemProvider>(context).selectedItem == 'My Profile',
            ),
            MyListTile(
              icon: Icons.logout,
              title: (isWeb(context) || isMobile(context)) ? 'Logout' : '',
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SigningPage()));
              },
              isSelected: selectedItem == 'Logout',
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );

  }



  Future<void> fetchReceiverRecordData() async {
    try {
      final response = await http.get(Uri.parse('$api_url/api/scanner/getrecord_dashboard'),
        headers:{
          'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData['receive_records'] is List) {
          List<ReceiversRecordDetails> receiversRecordDetails = List<ReceiversRecordDetails>.from(
            responseData['receive_records'].map((json) => ReceiversRecordDetails.fromJson(json)),
          );

          print(receiversRecordDetails);
          receiversRecordDetailsDashboard!.setReceiversRecordDetailsDashboard(receiversRecordDetails);
        }
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error fetching receiver record data: $error');

    }
  }

  Future<void> sendTokenToBackend(String jwtToken) async {
    final userToken = myAppState!.user_Token;
    final url = '${api_url}/api/scanner/getJwtToken';
    print(url);

    final requestData = {
      'jwt_token': userToken,
    };

    final jsonData = jsonEncode(requestData);
    print(jsonData);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {

        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        final int userId = responseBody['user_id'];

        userIdState!.setUserId(userId.toString());


        print('User ID: $userId');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');

    }
  }

  Future<void> fetchAdminData() async {
    try {
      final response = await http.get(
        Uri.parse('$api_url/api/accounts/getAdminData/all'),
        headers:{
          'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print('successfully fetched');

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('admin_data')) {
          final dynamic adminData = responseData['admin_data'];

          if (adminData is List<dynamic>) {
            final List<AdminData> adminDataList =
            AdminData.fromJsonList(adminData);

            userAccountsDashboard?.setUserAccountsDashboard(adminDataList);
            print(adminDataList);
            return;
          }
        }

        print('admin_data not found or is not a List<dynamic>');
      }
    } catch (e) {
      print('error: $e');
    }
  }



  Future<SuperadminProfileDetails> fetchSuperadminDetails() async {
    try {
      final userId = userIdState!.userId;
      final response = await http.get(Uri.parse('$api_url/api/accounts/getSuperadminDetails/${userId}'),
        headers:{
          'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",
        },
      );
      print(response);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        final userId = responseData['user']?['userId'] ?? '';
        final email = responseData['user']?['email'] ?? '';
        final superadmin_name = responseData['superadmin_data']?['superadmin_name'] ?? '';
        final superadmin_image = responseData['superadmin_data']?['superadmin_image'] ?? '';
        final password = responseData['user']?['password'] ?? '';
        final user_id = responseData['superadmin_data']?['user_id'] ?? '';


        print(userId);
        print(email);
        print(password);
        print(superadmin_name);
        print(superadmin_image);
        print(user_id);

        final superadminProfileDetails = SuperadminProfileDetails(
          userId: userId,
          email: email,
          superadmin_name: superadmin_name,
          superadmin_image: superadmin_image,
          password: password,
          user_id: user_id,
        );

        superadminProfileState!.setSuperAdminProfileDetails(
            userId, email, superadmin_name,superadmin_image, password, user_id
        );

        return superadminProfileDetails;
      } else {
        throw Exception('Failed to fetch superadmin details');
      }
    } catch (e) {
      print("error: $e");
      throw e;
    }
  }
}


class MyListTile extends StatelessWidget {
  final IconData icon;
  final IconData? icon2;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;
  final VoidCallback? onTrailing;

  MyListTile({
    required this.icon,
    this.icon2,
    required this.title,
    required this.onTap,
    required this.isSelected,
    this.onTrailing,
  });

  @override
  Widget build(BuildContext context) {
    bool isTablet (BuildContext context) =>
        MediaQuery.of(context).size.width <= 800;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: isSelected ? secondaryColor : null,
        child: Padding(
          padding: EdgeInsets.only(left: isTablet(context) ? 10 : 25.0, right: isTablet(context) ? 10 : 12),
          child: ListTile(
            leading: Icon(
              icon,
              color: isSelected ? primaryColor : secondaryColor,
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: isSelected ? primaryColor : secondaryColor,
              ),
            ),
            trailing: Icon(
              icon2,
              color: isSelected ? primaryColor : secondaryColor,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class MyListTile3 extends StatelessWidget {
  final IconData icon;
  final IconData? icon2;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;
  final VoidCallback? onTrailing;

  MyListTile3({
    required this.icon,
    this.icon2,
    required this.title,
    required this.onTap,
    required this.isSelected,
    this.onTrailing,
  });

  @override
  Widget build(BuildContext context) {
    bool isTablet (BuildContext context) =>
        MediaQuery.of(context).size.width <= 800;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: isSelected ? secondaryColor : null,
        child: Padding(
          padding: EdgeInsets.only(left: isTablet(context) ? 40 : 60),
          child: ListTile(
            leading: Icon(
              icon,
              color: isSelected ? primaryColor : secondaryColor,
              size: 20,
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isSelected ? primaryColor : secondaryColor,
              ),
            ),
            trailing: Icon(
              icon2,
              color: isSelected ? primaryColor : secondaryColor,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}
