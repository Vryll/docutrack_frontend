  import 'package:flutter/material.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:provider/provider.dart';
  import 'package:docutrack_main/main.dart';
  import 'package:flutter_dotenv/flutter_dotenv.dart';
  import 'package:docutrack_main/style.dart';
  import 'package:http/http.dart' as http;
  import 'dart:convert';
  import 'package:docutrack_main/custom_widget/custom_side_nav_bar.dart';
  import 'package:docutrack_main/admin/admin_home_page.dart';
  import 'package:flutter_spinkit/flutter_spinkit.dart';
  import 'package:docutrack_main/localhost.dart';

  class ReceiverApproval extends StatefulWidget {
    const ReceiverApproval({super.key});

    @override
    State<ReceiverApproval> createState() => _ReceiverApprovalState();
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

  class UpdateDeleteStatus {
    final String? status_value;

    const UpdateDeleteStatus({
      required this.status_value,
    });

    factory UpdateDeleteStatus.fromJson(Map<String, dynamic> json) {
      return UpdateDeleteStatus(
        status_value: json['status_value'],
      );
    }
    Map<String, dynamic> toJson() {
      return {
        'status_value': status_value,
      };
    }
  }

  class _ReceiverApprovalState extends State<ReceiverApproval> {
    var api_url = dotenv.env['API_URL'];

    SelectedRecievedDocuDetails? selectedRecievedDocuDetails;
    StaffUserData? staffUserData;

    String admin_office = "";
    String staff_position = "";

    bool isMobile (BuildContext context) =>
        MediaQuery.of(context).size.width <= 600;
    bool isWeb (BuildContext context) =>
        MediaQuery.of(context).size.width > 600;



    @override
    void initState(){
      super.initState();
      selectedRecievedDocuDetails = Provider.of<SelectedRecievedDocuDetails>(context, listen: false);
      staffUserData = Provider.of<StaffUserData>(context, listen: false);
    }

    void fetchDataFromProvider() {
      String? fetchedDocuId = selectedRecievedDocuDetails!.docuId;
      String? fetchedDocuType = selectedRecievedDocuDetails!.docu_type;
      String? fetchedDocuTitle = selectedRecievedDocuDetails!.docu_title;
      String? fetchedDocuNTimeReleased = selectedRecievedDocuDetails!.docu_dateNtime_released;
      String? fetchedSender = selectedRecievedDocuDetails!.docu_sender;
      String? fetchedStatus = selectedRecievedDocuDetails!.status;

      // Now you can use the fetched values as needed
      print(fetchedDocuId);
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isWeb(context) ? 40 : 20, vertical: isWeb(context) ? 40 : 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (MediaQuery.of(context).size.width > 600)
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Receiver\'s Approval',
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
                      Text(
                        'Check for Receiver’s Approval',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Data Table
                      const SizedBox(height: 20),
                      Container(
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
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                              child: Text(
                                'Document Information',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 0.5,
                              color: Colors.black,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columnSpacing: 0.2 * MediaQuery.of(context).size.width,
                                columns: [
                                  DataColumn(label: Text('Document Type',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      )
                                  )),
                                  DataColumn(label: Text('Title',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      )
                                  )),
                                  DataColumn(label: Text('Date Released',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ))),
                                  DataColumn(label: Text('Sender',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ))),
                                ],
                                rows: [

                                  DataRow(cells: [
                                    DataCell(Text(selectedRecievedDocuDetails!.docu_type ?? '',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                      ),
                                    )),
                                    DataCell(Text(selectedRecievedDocuDetails!.docu_title ?? '',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                      ),
                                    )),
                                    DataCell(Text(selectedRecievedDocuDetails!.docu_dateNtime_released ?? '',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                      ),
                                    )),
                                    DataCell(Text(selectedRecievedDocuDetails!.docu_sender ?? '',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                      ),
                                    )),
                                  ])
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Receivers Information',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                      Consumer<StaffUserData>(
                                        builder: (context, staffUserData, child){
                                          String staffFirstName = staffUserData.first_name ?? "";
                                          String staffLastName = staffUserData.last_name ?? "";
                                          String email = staffUserData.email ?? "";
                                          String role = staffUserData.role ?? "";
                                          String user_image_profile = staffUserData.user_image_profile ?? "";
                                          String admin_office = staffUserData.admin_office ?? "";
                                          String adminOfficeString = admin_office.replaceAll('[', '').replaceAll(']', '');
                                          List<String> adminOfficeList = adminOfficeString.split(',');
                                          String staff_position = staffUserData.staff_position ?? "";
                                          String staffPositionString = staff_position.replaceAll('[', '').replaceAll(']', '');
                                          List<String> staffPositionList = staffPositionString.split(',');
                                          // String? employeeIDImage = staffUserData.employee_id_image;

                                          return Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Consumer<StaffUserData>(
                                                builder: (context, staffUserData, child) {
                                                  if (staffUserData.role == 'clerk') {
                                                    return ClipOval(
                                                      child: staffUserData.user_image_profile!.isNotEmpty
                                                          ? Image.network(
                                                        staffUserData.user_image_profile.toString(),
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                      )
                                                          : Container(
                                                        width: 100,
                                                        height: 100,
                                                        color: Colors.grey,
                                                      ),
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                },
                                              ),
                                              SizedBox(height: 15),
                                              Text(
                                                '$staffFirstName $staffLastName',
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Email: $email',
                                                style: GoogleFonts.poppins(
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: adminOfficeList.length,
                                                  itemBuilder: (context, index){
                                                    return LayoutBuilder(
                                                        builder: (BuildContext context, BoxConstraints constraints) {
                                                          if (isMobile(context)) {
                                                            return Column(
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .center,
                                                              crossAxisAlignment: CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Text(
                                                                  'Office and Position',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 15),
                                                                Card(
                                                                  child: SizedBox(
                                                                    width: MediaQuery.of(context).size.width,
                                                                    height: 50,
                                                                    child: Align(
                                                                      alignment: Alignment.center,
                                                                      child: Text(
                                                                        adminOfficeList[index].toString(),
                                                                        style: GoogleFonts.poppins(
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 10),
                                                                Card(
                                                                  child: SizedBox(
                                                                    width: MediaQuery.of(context).size.width,
                                                                    height: 50,
                                                                    child: Align(
                                                                      alignment: Alignment
                                                                          .center,
                                                                      child: Text(
                                                                        staffPositionList[index]
                                                                            .toString(),
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          } else {
                                                            return Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Card(
                                                                    child: SizedBox(
                                                                      height: 50,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                        child: Align(
                                                                          alignment: Alignment.center,
                                                                          child: Text(
                                                                            adminOfficeList[index].toString(),
                                                                            style: GoogleFonts.poppins(
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(width: 20),
                                                                Expanded(
                                                                  child: Card(
                                                                    child: SizedBox(
                                                                      height: 50,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                        child: Align(
                                                                          alignment: Alignment.center,
                                                                          child: Text(
                                                                            staffPositionList[index].toString(),
                                                                            style: GoogleFonts.poppins(
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          }
                                                        }
                                                    );
                                                  }
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    Container(
                                      child: Consumer<StaffUserData>(
                                        builder: (context, staffUserData, child) {
                                          if (staffUserData.role != 'clerk') {
                                            return Column(
                                              children: [
                                                const SizedBox(height: 20),
                                                Text(
                                                  'Employee ID',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    width: 400,
                                                    height: 300,
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.black,
                                                        width: 1.0,
                                                      ),
                                                    ),

                                                    child: Builder(
                                                      builder: (context) {
                                                        String? employeeIdImage = staffUserData.employee_id_image ?? "";
                                                        print(employeeIdImage);
                                                        return employeeIdImage.isNotEmpty
                                                            ? Image.network(
                                                          employeeIdImage,
                                                          width: 100,
                                                          height: 100,
                                                          fit: BoxFit.cover,
                                                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? progress) {
                                                            return progress == null
                                                                ? child
                                                                : LinearProgressIndicator(
                                                              value: progress.expectedTotalBytes != null
                                                                  ? progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1)
                                                                  : null,
                                                            );
                                                          },
                                                        )
                                                            : Placeholder();
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return Container(
                                              color: Colors.transparent,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    Consumer<StaffUserData>(
                                      builder: (context, staffUserData, child) {
                                        if (staffUserData.role != 'clerk') {
                                          return Column(
                                            children: [
                                              Text(
                                                'Employee Selfie',
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  width: 300,
                                                  height: 500,
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.black,
                                                      width: 1.0,
                                                    ),
                                                  ),

                                                  child: Builder(
                                                    builder: (context) {
                                                      String? userSelfieImage = staffUserData.user_selfie_image ?? "";
                                                      return userSelfieImage.isNotEmpty
                                                          ? Image.network(
                                                        userSelfieImage,
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? progress) {
                                                          return progress == null
                                                              ? child
                                                              : LinearProgressIndicator(
                                                            value: progress.expectedTotalBytes != null
                                                                ? progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1)
                                                                : null,
                                                          );
                                                        },
                                                      )
                                                          : Placeholder();
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Consumer<StaffUserData>(
                        builder: (context, staffUserData, child) {
                          if (staffUserData.role != 'clerk') {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BuildApproveBtn(),
                                const SizedBox(width: 20),
                                BuildDeclinetBtn(),
                              ],
                            );
                          } else {
                            return Container();
                          }
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

    Widget BuildApproveBtn() => Expanded(
      child: ElevatedButton(
        onPressed: () {
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
                          'Are you sure you want to confirm?',
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
                                child: Text('Yes',
                                  style: GoogleFonts.poppins(
                                  ),
                                ),
                                onPressed: () async {
                                  updateStaffDocumentStatus();
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
                                            // crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                size: 100,
                                                color: Colors.green,
                                              ),
                                              SizedBox(height: 10.0),
                                              Text(
                                                'Receiver\'s approval has been ',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                'successfully approved!',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              SizedBox(height: 25.0),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  ElevatedButton(
                                                    child: Text('OK'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => AdminHome()),
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
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 13),
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
        child: Text(
          'Approve',
          style: GoogleFonts.poppins(
              color: secondaryColor,
              fontSize: 14
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(5.0),
          fixedSize: Size(140, 50),
          primary: primaryColor,
          onPrimary: secondaryColor,
          shadowColor: Colors.transparent,
          //  side: BorderSide(color: primaryColor, width: 2),
          shape: StadiumBorder(),
        ),
      ),
    );
    Widget BuildDeclinetBtn() => Expanded(
      child: ElevatedButton(
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
                          'Are you sure you want to decline?',
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
                                  updateDeclineStaffNDocumentStatus();
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
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                size: 100,
                                                color: Colors.green,
                                              ),
                                              SizedBox(height: 10.0),
                                              Text(
                                                'Receiver\'s approval has been declined!',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              SizedBox(height: 25.0),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  ElevatedButton(
                                                    child: Text('OK'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => AdminHome(),
                                                        ),
                                                      );
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 13),
                                                      textStyle: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                      ),
                                                      primary: Colors.white,
                                                      onPrimary: Colors.green,
                                                      elevation: 3,
                                                      shadowColor: Colors.transparent,
                                                      shape: StadiumBorder(
                                                        side: BorderSide(
                                                          color: Colors.green,
                                                          width: 2,
                                                        ),
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
                                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 13),
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
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15,),
                            Expanded(
                              child: ElevatedButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 13),
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
        child: Text(
          'Decline',
          style: GoogleFonts.poppins(
            fontSize: 14,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(5.0),
          fixedSize: Size(140, 50),
          primary: secondaryColor,
          onPrimary: primaryColor,
          shadowColor: Colors.transparent,
          side: BorderSide(color: primaryColor, width: 2),
          shape: StadiumBorder(),
        ),
      ),
    );


    Future<void> updateStaffDocumentStatus() async {
      final userId = staffUserData!.user_id;
      print('Updating status for user: $userId');

      final url = '${api_url}/api/scanner/update_guest_document_status/$userId';
      print(url);

      final updateStatus = UpdateStatus(status_value: 'Received');

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            "ngrok-skip-browser-warning": "$localhost_port",
          },
          body: jsonEncode(updateStatus.toJson()),
        );

        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          print('Status_Value was successfully sent to the backend');

        } else {
          print('Sending status_value failed with status code: ${response.statusCode}');

        }
      } catch (e) {
        print('Error: $e');

      }
    }

    Future<void> updateDeclineStaffNDocumentStatus() async {
      final userId = staffUserData!.user_id;
      print(userId);

      final url = '${api_url}/api/scanner/update_guest_document_status/$userId';
      print(url);

      final updateDelStatus = UpdateDeleteStatus(status_value: 'Declined');
      print(updateDelStatus);

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            "ngrok-skip-browser-warning": "$localhost_port",
          },
          body: jsonEncode(updateDelStatus.toJson()),
        );

        print(response);
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          print('Status_Value was successfully sent to the backend');
        } else {
          print('Sending status_value failed');

        }
      } catch (e) {
        print('Error: $e');

      }
    }
  }
