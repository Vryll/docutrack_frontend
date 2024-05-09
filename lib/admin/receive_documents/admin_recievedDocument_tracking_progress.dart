import 'package:flutter/material.dart';
import 'package:docutrack_main/custom_widget/custom_side_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:docutrack_main/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/admin/receive_documents/admin_receiver_approval.dart';
import 'package:docutrack_main/style.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:docutrack_main/localhost.dart';

class RecievedTrackingProgress extends StatefulWidget {

  const RecievedTrackingProgress({super.key});

  @override
  State<RecievedTrackingProgress> createState() => _RecievedTrackingProgressState();
}
class RecievedDocumentDetails{
  String? memorandum_number;
  String? docu_type;
  String? docu_title;
  String? docu_dateNtime_released;
  String? docu_sender;
  String? status;
  String? id;

  RecievedDocumentDetails({
    this.memorandum_number,
    this.docu_type,
    this.docu_title,
    this.docu_dateNtime_released,
    this.docu_sender,
    this.status,
    this.id,
  });
}

class UserData {
  final int user_id;
  final String? first_name;
  final String? middle_name;
  final String? last_name;
  final int? staff_data_id;
  final String? email;
  final String? role;
  final String? user_image_profile;
  final String? admin_office;
  final String? staff_position;
  final String? employee_id_image;
  final String? user_selfie_image;

  UserData({
    required this.user_id,
    required this.first_name,
    required this.middle_name,
    required this.last_name,
    this.staff_data_id,
    required this.email,
    required this.role,
    this.user_image_profile,
    required this.admin_office,
    this.staff_position,
    this.employee_id_image,
    this.user_selfie_image,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    var user = json['user'];
    var staffData = json['staff_data'];
    var receiveRecord = json['receive_record'];

    return UserData(
      user_id: user['user_id'],
      first_name: user['first_name'],
      middle_name: user['middle_name'],
      last_name: user['last_name'],
      staff_data_id: staffData?['staff_data_id'],
      email: user['email'],
      role: user['role'],
      user_image_profile: staffData?['user_image_profile'],
      admin_office: json['admin_office'],
      staff_position: staffData?['staff_position'],
      employee_id_image: receiveRecord?['employee_id_image'],
      user_selfie_image: receiveRecord?['user_selfie_image'],
    );
  }
}


class ReceivingTrackingProgressDetails {
  String? role;
  String? first_name;
  String? last_name;
  String? office_name;
  String? time_scanned;

  ReceivingTrackingProgressDetails({
    required this.role,
    required this.first_name,
    required this.last_name,
    required this.office_name,
    required this.time_scanned,
  });

  factory ReceivingTrackingProgressDetails.fromJson(Map<String, dynamic> json) {
    return ReceivingTrackingProgressDetails(
      role: json['role'] ?? '',
      first_name: json['first_name'] ?? '',
      last_name: json['last_name'],
      office_name: json['office_name'] ?? '',
      time_scanned: json['time_scanned'] ?? '',
    );
  }

  String getFormattedDateTime(String? dateTime) {
    if (dateTime != null) {
      final parsedDateTime = DateTime.parse(dateTime);
      final formattedDate = DateFormat('MM/dd/yyyy').format(parsedDateTime);
      final formattedTime = DateFormat('hh:mm a').format(parsedDateTime);
      return '$formattedDate - $formattedTime';
    }
    return '';
  }

  static List<ReceivingTrackingProgressDetails> fromJsonList(List<dynamic> list) {
    List<ReceivingTrackingProgressDetails> receivingTrackingProgressDetailList = [];
    for (var json in list) {
      receivingTrackingProgressDetailList.add(ReceivingTrackingProgressDetails.fromJson(json));
    }
    return receivingTrackingProgressDetailList;
  }

  @override
  String toString() {
    return 'ReceivingTrackingProgressDetails(role: $role, first_name: $first_name,last_name: $last_name ,office_name: $office_name ,time_scanned: $time_scanned)';
  }
}

class _RecievedTrackingProgressState extends State<RecievedTrackingProgress> with WidgetsBindingObserver{
  var api_url = dotenv.env['API_URL'];

  SelectedRecievedDocuDetails? selectedRecievedDocuDetails;
  StaffUserData? staffUserData;
  ReceivedDocuTrackingProgressState? receivedDocuTrackingProgressState;
  ScrollController _scrollController = ScrollController();

  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;

  late Timer _timer;
  bool _isPageActive = true;
  bool dataFetched = false;

  @override
  void initState(){
    super.initState();
    selectedRecievedDocuDetails = Provider.of<SelectedRecievedDocuDetails>(context, listen: false);
    staffUserData = Provider.of<StaffUserData>(context, listen: false);

    fetchReceivedDocumenTrackingProgress();
    startTimer();
    // _timer = Timer.periodic(Duration(seconds: 5), (timer) {
    //   print('Timer is triggered!');
    //
    // });
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      print('Timer is triggered!');

      fetchReceivedDocumenTrackingProgress();
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    _timer.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _isPageActive = true;
      resumeTimer();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _isPageActive = false;
      pauseTimer();
    }
  }

  void resumeTimer() {
    dataFetched = false;
    startTimer();
  }

  void pauseTimer() {
    _timer.cancel();
  }


  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    receivedDocuTrackingProgressState = Provider.of<ReceivedDocuTrackingProgressState>(context, listen:true);

  }

  void fetchDataFromProvider() {
    String? fetchedDocuId = selectedRecievedDocuDetails!.docuId;
    String? fetchedMemorandumNumber = selectedRecievedDocuDetails!.memorandum_number;
    String? fetchedDocuType = selectedRecievedDocuDetails!.docu_type;
    String? fetchedDocuTitle = selectedRecievedDocuDetails!.docu_title;
    String? fetchedDocuNTimeReleased = selectedRecievedDocuDetails!.docu_dateNtime_released;
    String? fetchedSender = selectedRecievedDocuDetails!.docu_sender;
    String? fetchedStatus = selectedRecievedDocuDetails!.status;


    print(fetchedDocuId);
    print(fetchedMemorandumNumber);
    print(fetchedDocuType);
    print(fetchedDocuTitle);
    print(fetchedDocuNTimeReleased);
    print(fetchedSender);
    print(fetchedStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile(context) ? AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 65,
        title: Text(
          'Dashboard',
          style: GoogleFonts.poppins(
            fontSize: 24,
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
          isWeb(context) ?
          Container(
            color: primaryColor,
            child: SideNav(),
            width: size300_80(context),
          ) : Container(),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
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
                              'Dashboard',
                              style: GoogleFonts.poppins(
                                fontSize: 45,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(width: 50),
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
                      SizedBox(height: 30.0),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Document Tracking Progress',
                            style: GoogleFonts.poppins(
                              fontSize: size20_15(context),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          width: 7,
                          height: 7,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          'Received',
                          style: GoogleFonts.poppins(
                            fontSize: size15_12(context),
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: (isWeb(context)) ? 290 : (isMobile(context) ? 80 : 80),
                          columns: [
                            DataColumn(label: Text('Order No.',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )
                            )),
                            DataColumn(label: Text('Document Type',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )
                            )),
                            DataColumn(label: Text('Subject',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )
                            )),
                            DataColumn(label: Text('Date/Time Received',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )
                            )),
                            DataColumn(label: Text('Recipient/\s',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ))),
                            DataColumn(label: Text('Status',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ))),
                            DataColumn(label: Text('Action',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )
                            )),
                          ],
                          rows: [
                            DataRow(cells: [
                              DataCell(Text(selectedRecievedDocuDetails!.memorandum_number ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                ),)),
                              DataCell(Text(selectedRecievedDocuDetails!.docu_type ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                ),)),
                              DataCell(Text(selectedRecievedDocuDetails!.docu_title ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                ),)),
                              DataCell(Text(selectedRecievedDocuDetails!.docu_dateNtime_released ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                ),)),
                              DataCell(Text(selectedRecievedDocuDetails!.docu_sender ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                ),)),
                              DataCell(Text(selectedRecievedDocuDetails!.status ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                    color: _getStatusColor(selectedRecievedDocuDetails!.status)
                                ),)),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.remove_red_eye_outlined),
                                  onPressed: ()async{
                                    String? docuId = selectedRecievedDocuDetails!.docuId;
                                    print(docuId);
                                    try{
                                      final response = await http.post(Uri.parse('${api_url}/api/scanner/receiver_information/document_details=$docuId'));
                                      print(response);
                                      if(response.statusCode==200){
                                        Map<String, dynamic> data = json.decode(response.body);
                                        UserData userData = UserData.fromJson(data);
                                        print(userData);
                                        staffUserData!.setStaffUserData(
                                            userData.user_id.toString(),
                                            userData.first_name ?? "", // Handle nulls
                                            userData.middle_name ?? "",
                                            userData.last_name ?? "",
                                            userData.staff_data_id.toString(),
                                            userData.email ?? "",
                                            userData.role ?? '',
                                            userData.user_image_profile ?? '',
                                            userData.admin_office ?? "",
                                            userData.staff_position ?? "",
                                            userData.employee_id_image ?? "",
                                            userData.user_selfie_image ?? ""
                                        );


                                        // staffUserData!.setStaffUserData(user_id ,first_name,middle_name, last_name, staff_data_id,email,admin_office,staff_position,employee_id_image,user_selfie_image );

                                        // print(user_id);
                                        // print(first_name);
                                        // print(middle_name);
                                        // print(last_name);
                                        // print(staff_data_id);
                                        // print(email);
                                        // print(admin_office);
                                        // print(staff_position);
                                        // print(employee_id_image);
                                        // print(user_selfie_image);

                                      }
                                    }catch(e){
                                      print('error: $e');
                                    }
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context)=>ReceiverApproval()
                                        ));
                                  },
                                ),
                              )
                            ]),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Document',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              height: 2,
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(width: 8),
                              Text(
                                'Status',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  height: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Consumer<ReceivedDocuTrackingProgressState>(
                      builder: (context, receivedDocuTrackingProgressState, child) {
                        var trackingDetailsList = receivedDocuTrackingProgressState.receivingTrackingProgressDetailList;

                        if (trackingDetailsList.isEmpty) {
                          return Center(child: Text('No tracking details available'));
                        }

                        return SizedBox(
                          height: 300,
                          child: ListView.builder(
                            itemCount: trackingDetailsList.length,
                            itemBuilder: (context, index) {
                              var item = trackingDetailsList[index];

                              return ListTile(
                                title: Text('${item.first_name} ${item.last_name}',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      '${item.office_name.toString()} | ',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 9,
                                      ),
                                    ),

                                    Text(item.role.toString(),
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  item.getFormattedDateTime(item.time_scanned),
                                  // item.time_scanned.toString(),
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
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

  Color _getStatusColor(String? status) {
    if (status == 'Received') {
      return Colors.green;
    } else if (status == 'Declined') {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  Future<void> fetchReceivedDocumenTrackingProgress() async {
    try {
      final String? docuId = selectedRecievedDocuDetails!.docuId;
      print(docuId);

      if (docuId == null) {
        print('Error: docuId is null');
        return;
      }

      final response = await http.get(Uri.parse(
          '${api_url}/api/scanner/getReceive_document_tracking_progress/document_id=$docuId'),
        headers:{
          'Accept': 'application/json',
          "ngrok-skip-browser-warning": "$localhost_port",
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print(responseData);

        if (responseData is List) {
          List<ReceivingTrackingProgressDetails> receivingTrackingProgressDetailList =
          List<ReceivingTrackingProgressDetails>.from(responseData.map((json) =>
              ReceivingTrackingProgressDetails.fromJson(json),
          ));
          print(receivingTrackingProgressDetailList);

          receivedDocuTrackingProgressState!.setReceivedDocuTrackingProgress(receivingTrackingProgressDetailList);
        }
      }
    } catch (e) {
      print('error: $e');
    }
  }
}
