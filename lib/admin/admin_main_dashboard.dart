import 'package:docutrack_main/main.dart';
import 'package:flutter/material.dart';
import 'package:docutrack_main/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/custom_widget/custom_side_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdminMainDashboard extends StatefulWidget {
  const AdminMainDashboard({super.key});

  @override
  State<AdminMainDashboard> createState() => _AdminMainDashboardState();
}

class MainDetails {
  final String? id;
  final String? memorandum_number;
  final String? docu_type;
  final String? docu_title;
  final String? docu_dateNtime_released;
  final List<dynamic>? docu_recipient;
  final String? status;
  final String? docu_source;
  bool is_deleted;


  MainDetails({
    required this.id,
    required this.memorandum_number,
    required this.docu_type,
    required this.docu_title,
    required this.docu_dateNtime_released,
    required this.docu_recipient,
    required this.status,
    required this.docu_source,
    this.is_deleted = false,
  });
}




class _AdminMainDashboardState extends State<AdminMainDashboard> {
  MainDocumentDetailDashboardState? mainDocumentDetailDashboardState;
  var api_url = dotenv.env['API_URL'];
  String selectedFilter = 'Day';
  int? selectedValue;
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;

  TextEditingController searchController = TextEditingController();
  List<MainDocumentDetails> dataTableSource = [];
  late List<MainDocumentDetails> defaultData;

  @override
  void initState(){
    super.initState();
    mainDocumentDetailDashboardState = Provider.of<MainDocumentDetailDashboardState>(context, listen: false);
    defaultData = mainDocumentDetailDashboardState!.mainDocumentDetailsList;
    refreshDataTableSource();
  }

  void refreshDataTableSource() {
    dataTableSource = defaultData.where((docu) => !docu.is_deleted).toList();
  }



  void filterData(String query) {
    if (mainDocumentDetailDashboardState != null) {
      List<MainDocumentDetails> filteredList;

      if (query.isNotEmpty) {
        List<String> queryWords = query.toLowerCase().split(' ');

        filteredList = mainDocumentDetailDashboardState!
            .mainDocumentDetailsList
            .where((docu) {

          String allRecipients = (docu.docu_recipient != null)
              ? docu.docu_recipient.map((recipient) => recipient.toString()).join(', ').toLowerCase()
              : '';


          return queryWords.every((word) =>
          (docu.memorandum_number?.toLowerCase() ?? '').contains(word) ||
              (docu.docu_type.toLowerCase() ?? '').contains(word) ||
              (docu.docu_title.toLowerCase() ?? '').contains(word) ||
              (docu.status?.toLowerCase() ?? '').contains(word) ||
              (docu.docu_dateNtime_released.toLowerCase() ?? '').contains(word) ||
              allRecipients.contains(word)
          );
        }).toList();
      } else {

        filteredList = defaultData;
      }


      mainDocumentDetailDashboardState!.setMainDetailDashboardState(filteredList);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int crossAxisCount = (width > 600) ? 4 : 2;
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
      body: Consumer<MainDocumentDetailDashboardState>(
        builder: (context, mainDocumentDetailDashboardState, child){
          dataTableSource =
              mainDocumentDetailDashboardState.mainDocumentDetailsList
                  .where((docu)=>!docu.is_deleted).toList();
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
                                      'Main',
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
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
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
                              ),
                              Divider(
                                thickness: 1.5,
                                color: Colors.black,
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: DataTable(
                                      columnSpacing: 85,
                                      columns: [
                                        DataColumn(
                                          label: Text(
                                            'Order No.',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                            label: Text(
                                              'Document Type',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Subject',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Date Released',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Recipient',
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
                                              ),
                                            )
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
                                      rows: rowData(dataTableSource),
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

  List<DataRow> rowData(List<MainDocumentDetails> source) {
    return source.map((_mainDocumentDetailsList) =>
        DataRow(cells: [
          DataCell(Text(_mainDocumentDetailsList.memorandum_number ?? '',
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          )),
          DataCell(Text(_mainDocumentDetailsList.docu_type ?? '',
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          )),
          DataCell(Text(_mainDocumentDetailsList.docu_title ?? '',
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          )),
          DataCell(Text(_mainDocumentDetailsList.docu_dateNtime_released ?? '',
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          )),
          DataCell(Text(_mainDocumentDetailsList.docu_recipient.join(', '),
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          )),
          DataCell(Text(_mainDocumentDetailsList.status ?? '',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: _getStatusColor(_mainDocumentDetailsList.status)
            ),
          )),
          DataCell(
            Row(
              children: [
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
                                            String? docuIdToDelete = _mainDocumentDetailsList.id.toString();
                                            try {
                                              final http.Response response = await http.delete(
                                                Uri.parse('${api_url}/api/documents/deleting_document_details/documentID=$docuIdToDelete'),
                                                headers: <String, String>{
                                                  'Content-Type': 'application/json; charset=UTF-8',
                                                },
                                                body: jsonEncode({'id': docuIdToDelete}),
                                              );
                                              if (response.statusCode == 200) {

                                                mainDocumentDetailDashboardState!.removeAdminData(docuIdToDelete);
                                                _mainDocumentDetailsList.is_deleted = true;
                                                refreshDataTableSource();
                                                setState(() {});
                                                print('Document deleted successfully');

                                                Navigator.pop(context); // Close the dialog
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Document deleted successfully'),
                                                  ),
                                                );
                                              } else {

                                                print('Error deleting document. Status code: ${response.statusCode}');
                                              }
                                            } catch (e) {

                                              print('Error: $e');
                                            }

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
                  },
                ),
              ],
            ),
          ),
        ]),
    ).toList() ?? [];
  }
  Color _getStatusColor(String? status) {
    if (status == 'Received') {
      return Colors.green;
    } else if (status == 'Forwarded') {
      return Colors.blue;
    } else {
      return Colors.grey;
    }
  }
}
