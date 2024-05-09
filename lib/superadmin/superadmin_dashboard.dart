import 'package:docutrack_main/main.dart';
import 'package:docutrack_main/style.dart';
import 'package:flutter/material.dart';
import 'package:docutrack_main/custom_widget/custom_superadmin_sideNavBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:docutrack_main/superadmin/superadmin_overview_account.dart';
import 'dart:async';

class SuperadminDashboard extends StatefulWidget {
  const SuperadminDashboard({super.key});

  @override
  State<SuperadminDashboard> createState() => _SuperadminDashboardState();
}

class AdminDetail {
  String? id;
  String? admin_id;
  String? office_name;
  String? user_id;

  AdminDetail({
    required this.id,
    required this.admin_id,
    required this.office_name,
    required this.user_id,
  });
}

class _SuperadminDashboardState extends State<SuperadminDashboard> {
  String selectedStatus = '';
  var api_url = dotenv.env['API_URL'];

  late Timer _timer;
  bool dataFetched = false;

  UserAccountsDashboard? userAccountsDashboard;
  SelectedAdminDetailsState? selectedAdminDetailsState;

  bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb(BuildContext context) => MediaQuery.of(context).size.width > 600;

  ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  late List<AdminData> defaultData;

  void filterData(String query) {
    if (userAccountsDashboard != null) {
      List<AdminData> filteredList;

      if (query.trim().isNotEmpty) {

        List<String> queryWords = query.toLowerCase().split(' ');

        filteredList = userAccountsDashboard!.adminDataList.where((docu) {

          return queryWords.every((word) =>
          docu.office_name!.toLowerCase().contains(word) ||
              docu.email!.toLowerCase().contains(word));
        }).toList();
      } else {

        filteredList = defaultData;
      }


      userAccountsDashboard!.setUserAccountsDashboard(filteredList);
    }
  }

  @override
  void initState() {
    super.initState();
    userAccountsDashboard = Provider.of<UserAccountsDashboard>(context, listen:false);
    selectedAdminDetailsState =
        Provider.of<SelectedAdminDetailsState>(context, listen: false);
    defaultData = userAccountsDashboard!.adminDataList;
    // fetchAdminData();
    // _timer = Timer.periodic(Duration(seconds: 5), (timer) {
    //   print('Timer is triggered!');
    //
    //   if (!dataFetched) {
    //     fetchAdminData();
    //   }
    // });
  }

  // @override
  // void dispose() {
  //   // Cancel the timer to avoid memory leaks
  //   _timer.cancel();
  //   super.dispose();
  // }

  @override didChangeDependencies(){
    super.didChangeDependencies();

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
          'Accounts',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
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
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isWeb(context)
              ? Container(
            color: primaryColor,
            child: SideNav(),
            width: size300_80(context),
          )
              : Container(),
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
                            child: Text(
                              'Accounts',
                              style: GoogleFonts.poppins(
                                fontSize: 45,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
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
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 35.0,
                                width: isMobile(context) ? 180 : 250.0,
                                child: TextField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    contentPadding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                    hintText: 'Search',
                                    hintStyle: GoogleFonts.poppins(fontSize: 15),
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: primaryColor,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  onChanged: (value) {

                                    filterData(value);
                                  },
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Scrollbar(
                              controller: _scrollController,
                              trackVisibility: true,
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: DataTable(
                                    columnSpacing: (isWeb(context)) ? 325 : (isMobile(context) ? 165: 165),
                                    columns: [
                                      DataColumn(
                                        label: Text(
                                          'Profile',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                          label: Text(
                                            'Office Name',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                      DataColumn(
                                        label: Text(
                                          'Email Address',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Actions',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: rowData(),
                                  ),
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
          ),
        ],
      ),
    );
  }

  List<DataRow> rowData() {
    return userAccountsDashboard!.adminDataList
        .map(
          (_adminDataList) => DataRow(cells: [
        DataCell(ClipOval(
          child: Image.network(
            _adminDataList.admin_logo!,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? progress) {
              return progress == null
                  ? child
                  : CircularProgressIndicator(
                value: progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded /
                    (progress.expectedTotalBytes ?? 1)
                    : null,
              );
            },
          ),
        )),
        DataCell(Text(_adminDataList.office_name ?? '')),
        DataCell(Text(_adminDataList.email!)),
        DataCell(Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove_red_eye_outlined),
              onPressed: () async {
                String? adminId = _adminDataList.userId.toString();
                print(adminId);
                try {
                  final response = await http.get(Uri.parse(
                      '${api_url}/api/accounts/getAdminDetails/$adminId'));
                  print(response);
                  if (response.statusCode == 200) {
                    Map<String, dynamic> data = json.decode(response.body);
                    String email = data['user']['email'] ?? '';
                    int adminId = data['admin_data']['id'] ?? '';
                    String admin_logo =
                        data['admin_data']['admin_logo'] ?? '';
                    String admin_overview =
                        data['admin_data']['admin_overview'] ?? '';
                    String office_name =
                        data['admin_data']['office_name'] ?? '';
                    int userId = data['admin_data']['user_id'] ?? '';

                    print('Email: $email');
                    print('Admin ID: $adminId');
                    print('Admin Logo: $admin_logo');
                    print('Admin Overview: $admin_overview');
                    print('Office Name: $office_name');
                    print('User ID: $userId');

                    selectedAdminDetailsState!.setSelectedAdminDetailsState(
                        email,
                        adminId,
                        admin_logo,
                        admin_overview,
                        office_name,
                        userId);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OverviewAccount(),
                      ),
                    );
                  } else {
                    print(
                        'Failed to load admin details: ${response.statusCode}');
                  }
                } catch (e) {
                  print('error: $e');
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
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
                          padding:
                          const EdgeInsets.symmetric(horizontal: 20.0),
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
                                'Are you sure you want to delete this account?',
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
                                      child: Text(
                                        'Yes',
                                        style: GoogleFonts.poppins(),
                                      ),
                                      onPressed: () async {
                                        String? adminId =
                                        _adminDataList.id.toString();
                                        try {
                                          final http.Response response =
                                          await http.delete(
                                            Uri.parse(
                                                '${api_url}/api/accounts/deleting_admin_account/admin_id=$adminId'),
                                            headers: <String, String>{
                                              'Content-Type':
                                              'application/json; charset=UTF-8',
                                            },
                                            body:
                                            jsonEncode({'id': adminId}),
                                          );
                                          if (response.statusCode == 200) {

                                            print(
                                                'Admin Account deleted successfully');
                                            updateDataAfterDelete(adminId);
                                          } else {

                                            print(
                                                'Error deleting admin account. Status code: ${response.statusCode}');
                                          }
                                        } catch (e) {

                                          print('Error: $e');
                                        }


                                        Navigator.of(context).pop();
                                        Future.delayed(
                                            Duration(milliseconds: 100),
                                                () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    contentPadding:
                                                    EdgeInsets.zero,
                                                    content: Container(
                                                      width: 350,
                                                      height: 250,
                                                      decoration:
                                                      ShapeDecoration(
                                                        color: Colors.white,
                                                        shape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(5),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Icon(
                                                            Icons.check_circle,
                                                            size: 100,
                                                            color: Colors.green,
                                                          ),
                                                          SizedBox(
                                                              height: 10.0),
                                                          Text(
                                                            'Admin account has been successfully deleted!',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              // fontWeight: FontWeight.bold,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height: 25.0),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                            children: [
                                                              ElevatedButton(
                                                                child:
                                                                Text('OK'),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                      50,
                                                                      vertical:
                                                                      13),
                                                                  textStyle:
                                                                  GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                    14,
                                                                    // fontWeight: FontWeight.bold,
                                                                  ),
                                                                  primary: Colors
                                                                      .white,
                                                                  onPrimary:
                                                                  Colors
                                                                      .green,
                                                                  elevation: 3,
                                                                  shadowColor:
                                                                  Colors
                                                                      .transparent,
                                                                  shape: StadiumBorder(
                                                                      side: BorderSide(
                                                                          color: Colors
                                                                              .green,
                                                                          width:
                                                                          2)),
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
                                            });
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
                                        shape: StadiumBorder(
                                            side: BorderSide(
                                                color: primaryColor,
                                                width: 2)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      child: Text('Cancel'),
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
              },
            ),
          ],
        )),
      ]),
    ).toList();
  }
  void updateDataAfterDelete(String adminId) {

    userAccountsDashboard!.removeAdminData(adminId);


    userAccountsDashboard!.setUserAccountsDashboard(userAccountsDashboard!.adminDataList);


    setState(() {});
  }


  Card buildCard(String title, String count, Color color) {
    return Card(
      margin: EdgeInsets.zero,
      color: color,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
              ),
              Text(
                count,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
