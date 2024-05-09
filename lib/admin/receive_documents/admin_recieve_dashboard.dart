import 'package:flutter/material.dart';
import 'package:docutrack_main/custom_widget/custom_side_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:docutrack_main/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:docutrack_main/admin/receive_documents/admin_recievedDocument_tracking_progress.dart';
import 'package:docutrack_main/style.dart';
import 'package:docutrack_main/localhost.dart';


class AdminReceivedDashboard extends StatefulWidget {
  const AdminReceivedDashboard({super.key});

  @override
  State<AdminReceivedDashboard> createState() => _AdminReceivedDashboardState();
}

class RecievedDocumentDetail{
  String? memorandum_number;
  String? docu_type;
  String? docu_title;
  String? docu_dateNtime_released;
  String? docu_sender;
  String? status;
  String? id;
  bool is_deleted;

  RecievedDocumentDetail({
    this.memorandum_number,
    this.docu_type,
    this.docu_title,
    this.docu_dateNtime_released,
    this.docu_sender,
    this.status,
    this.id,
    this.is_deleted = false,
  });
}

class _AdminReceivedDashboardState extends State<AdminReceivedDashboard> {
  var api_url = dotenv.env['API_URL'];
  String? id = "";
  String? memorandum_number;
  String? docu_type = "";
  String? docu_title = "";
  String? docu_dateNtime_released = "";
  String? docu_sender = "";
  String? status = "".toString();
  String selectedFilter = 'Day';
  int? selectedValue;
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;

  RecieveDocumentDetailDashboardState? recieveDocumentDetailDashboardState;
  SelectedRecievedDocuDetails? selectedRecievedDocuDetails;

  ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  late List<RecievedDocumenDetails> defaultData;

  List<RecievedDocumenDetails> dataTableSource = [];

  void filterData(String query) {
    if (recieveDocumentDetailDashboardState != null) {
      List<RecievedDocumenDetails> filteredList;

      if (query.isNotEmpty) {
        List<String> queryWords = query.toLowerCase().split(' ');

        filteredList = recieveDocumentDetailDashboardState!
            .recievedDocuDetailsList
            .where((docu) {

          String allRecipients = (docu.docu_sender ?? '').toLowerCase();


          return queryWords.every((word) =>
          docu.memorandum_number!.toLowerCase().contains(word) ||
              docu.docu_type!.toLowerCase().contains(word) ||
              docu.docu_title!.toLowerCase().contains(word) ||
              docu.status!.toLowerCase().contains(word) ||
              docu.docu_dateNtime_released!.toLowerCase().contains(word) ||
              allRecipients.contains(word));
        }).toList();
      } else {

        filteredList = defaultData;
      }


      recieveDocumentDetailDashboardState!.setRecievedDocuDetailsList(filteredList);
    }
  }



  @override
  void initState(){
    super.initState();
    recieveDocumentDetailDashboardState = Provider.of<RecieveDocumentDetailDashboardState>(context, listen: false);
    selectedRecievedDocuDetails = Provider.of<SelectedRecievedDocuDetails>(context, listen: false);
    defaultData = recieveDocumentDetailDashboardState!.recievedDocuDetailsList;
    refreshDataTableSource();
  }

  void refreshDataTableSource() {
    dataTableSource = defaultData.where((docu) => !docu.is_deleted).toList();
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
      body: Consumer<RecieveDocumentDetailDashboardState>(
        builder: (context, recieveDocumentDetailDashboardState, child){
          dataTableSource = recieveDocumentDetailDashboardState.recievedDocuDetailsList.
          where((docu)=> !docu.is_deleted).toList();
          return Row(
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dashboard',
                                      style: GoogleFonts.poppins(
                                        fontSize: 45,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                    Text(
                                      'Received Documents',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
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
                                child: Row(
                                  children: [
                                    if (MediaQuery.of(context).size.width < 600)
                                      Expanded(
                                        child: Text(
                                          'Received Documents',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    if (MediaQuery.of(context).size.width > 600)
                                      Spacer(),
                                    Container(
                                      height: 35.0,
                                      width: isMobile(context) ? 180 : 250.0,
                                      child: TextField(
                                        controller: searchController,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(top: 2),
                                          hintText: 'Search',
                                          prefixIcon: Icon(Icons.search),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20.0),
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
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1.5,
                                color: Colors.black,
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
                                        columnSpacing: (isWeb(context)) ? 290 : (isMobile(context) ? 80 : 150),
                                        columns: [
                                          DataColumn(
                                            label: Text(
                                              'Order No.',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                              label: Text(
                                                'Document Type',
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              )
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Subject',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Date Released',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Recipient/\s',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                              label: Text(
                                                'Status',
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              )
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Actions',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                        rows: rowData(dataTableSource),
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
          );
        },

      ),
    );
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
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
              ),
              Text(
                count,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 40,
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

  List<DataRow> rowData(List<RecievedDocumenDetails> source){
    return source.map((_recievedDocuDetailsList) =>
        DataRow(cells: [
          DataCell(Text(_recievedDocuDetailsList.memorandum_number!,
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          )),
          DataCell(Text(_recievedDocuDetailsList.docu_type!,
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          )),
          DataCell(Text(_recievedDocuDetailsList.docu_title!,
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          )),
          DataCell(Text(_recievedDocuDetailsList.docu_dateNtime_released!,
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          )),
          DataCell(Text(_recievedDocuDetailsList.docu_sender!,
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          )),
          DataCell(Text(_recievedDocuDetailsList.status!,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: _getStatusColor(_recievedDocuDetailsList.status!),
            ),
          )),
          DataCell(
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_red_eye_outlined, size: 23),
                    onPressed: ()async{
                      String? docuId = _recievedDocuDetailsList.id;
                      try{
                        final response = await http.get(Uri.parse('${api_url}/api/documents/getDocumentent_Details/$docuId'),
                          headers:{'Accept': 'application/json',
                            "ngrok-skip-browser-warning": "$localhost_port",
                          },
                        );

                        if(response.statusCode == 200){
                          Map<String, dynamic> data = json.decode(response.body);
                          String docuId = data["docu_id"].toString();
                          String memorandum_number = data["memorandum_number"];
                          String docu_type = data["docu_type"].toString();
                          String docu_title = data["docu_title"].toString();
                          String docu_dateNtime_released = data["docu_dateNtime_released"];
                          String docu_sender = data["docu_sender"].toString();
                          String docu_status = data["docu_status"].toString();

                          selectedRecievedDocuDetails!.setSelectedRecievedDocuDetails(docuId.toString(),memorandum_number,docu_type.toString(),docu_title,docu_dateNtime_released, docu_sender, docu_status.toString());

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RecievedTrackingProgress(),
                            ),
                          );

                          print(docuId);
                          print(docu_type);
                          print(docu_title);
                          print(docu_dateNtime_released);
                          print(docu_sender);
                          print(docu_status);
                        }

                      }catch(e){
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
                                      'Are you sure you want to delete this document?',
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
                                              String? docuId = _recievedDocuDetailsList.id!;
                                              print(docuId);
                                              try{
                                                final http.Response response = await http.delete(
                                                    Uri.parse('${api_url}/api/documents/deleting_document_details/documentID=$docuId'),
                                                    headers: <String, String>{
                                                      'Content-Type': 'application/json; charset=UTF-8',
                                                      "ngrok-skip-browser-warning": "$localhost_port",
                                                    },
                                                    body: jsonEncode({'id': docuId})
                                                );
                                                if (response.statusCode == 200) {

                                                  recieveDocumentDetailDashboardState!.removeAdminData(docuId);
                                                  _recievedDocuDetailsList.is_deleted = true;
                                                  refreshDataTableSource();
                                                  setState(() {});
                                                  print('Document deleted successfully');
                                                } else {

                                                  print('Error deleting document. Status code: ${response.statusCode}');
                                                }
                                              } catch (e) {

                                                print('Error: $e');
                                              }
                                              Navigator.pop(context);
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
                                              maxLines: 1,)),
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

                      //functionality
                      // String? docuId = _recievedDocuDetailsList.id!;
                      // print(docuId);
                      // try{
                      //   final http.Response response = await http.delete(
                      //       Uri.parse('${api_url}/api/scanner/deleting_document_details/documentID=$docuId'),
                      //       headers: <String, String>{
                      //         'Content-Type': 'application/json; charset=UTF-8',
                      //       },
                      //       body: jsonEncode({'id': docuId})
                      //   );
                      //   if (response.statusCode == 200) {
                      //     // Document deleted successfully
                      //     print('Document deleted successfully');
                      //   } else {
                      //     // Handle error, display error message, etc.
                      //     print('Error deleting document. Status code: ${response.statusCode}');
                      //   }
                      // } catch (e) {
                      //   // Handle network or other errors
                      //   print('Error: $e');
                      // }
                    },
                  ),
                ],
              )
          ),
        ]),
    ).toList().reversed.toList();
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
}
