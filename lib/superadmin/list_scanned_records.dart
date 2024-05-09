import 'package:docutrack_main/main.dart';
import 'package:flutter/material.dart';
import 'package:docutrack_main/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/custom_widget/custom_superadmin_sideNavBar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:docutrack_main/superadmin/superadmin_records_dashboard.dart';
import 'package:intl/intl.dart';

class ListScannedRecords extends StatefulWidget {
  const ListScannedRecords({super.key});

  @override
  State<ListScannedRecords> createState() => _ListScannedRecordsState();
}

class SelectedScannedDocumentDisplay{
  String? memorandum_number;
  String? docu_type;
  String? docu_title;
  String? docu_dateNtime_created;
  String? docu_sender;
  String? docu_status;
  String? time_scanned;

  SelectedScannedDocumentDisplay({
    required this.memorandum_number,
    required this.docu_type,
    required this.docu_title,
    required this.docu_dateNtime_created,
    required this.docu_sender,
    required this.docu_status,
    required this.time_scanned,
  });
}

class _ListScannedRecordsState extends State<ListScannedRecords> {
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;
  ScrollController _scrollController = ScrollController();


  TextEditingController searchController = TextEditingController();
  late List<ReceiversInformation> defaultData;
  List<ReceiversInformation> dataTableSource = [];

  ///Appstate Provder
  SelectedScannedDocu? selectedScannedDocu;
  ReceiverData? receiverData;

  @override
  void initState(){
    super.initState();
    selectedScannedDocu = Provider.of<SelectedScannedDocu>(context, listen: false);
    defaultData = [];
    refreshDataTableSource();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    receiverData = Provider.of<ReceiverData>(context, listen: true);
  }

  void refreshDataTableSource() {
    dataTableSource = defaultData;
  }

  void filterData(String query) {
    if (query.isEmpty) {
      setState(() {
        dataTableSource = List.from(defaultData);
      });
      return;
    }

    List<String> queryWords = query.toLowerCase().split(' ');

    List<ReceiversInformation> filteredList = receiverData!.receiversInformationList.where((docu) {
      String combinedName = [
        docu.first_name,
        docu.middle_name,
        docu.last_name
      ].where((name) => name != null).join(" ").toLowerCase();

      return queryWords.every((word) =>
      combinedName.contains(word) ||
          docu.role!.toLowerCase().contains(word) ||
          docu.office_name!.toLowerCase().contains(word) ||
          docu.time_scanned!.toLowerCase().contains(word));
    }).toList();

    setState(() {
      dataTableSource = filteredList;
    });
  }


  @override
  Widget build(BuildContext context) {
    final parsedDateTime = DateTime.parse(selectedScannedDocu!.docu_dateNtime_created!);
    final formattedDate = DateFormat('MM/dd/yyyy').format(parsedDateTime);
    final formattedTime = DateFormat('hh:mm a').format(parsedDateTime);
    return Scaffold(
      appBar: isMobile(context) ? AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 65,
        title: Text(
          'Receivers',
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (MediaQuery.of(context).size.width > 600)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Receivers',
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
                    Center(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            width: 920,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 1.0,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columnSpacing: 65,
                                columns: [
                                  DataColumn(label: Text('Order No.',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ))),
                                  DataColumn(label: Text('Document Type',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ))),
                                  DataColumn(label: Text('Subject',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ))),
                                  DataColumn(label: Text('Date/TimeReleased',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ))),
                                  DataColumn(label: Text('Sender',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ))),
                                  DataColumn(label: Text('Status',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ))),
                                ],
                                rows: [
                                  DataRow(cells: [
                                    DataCell(Text(selectedScannedDocu!.memorandum_number ?? '',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                      ),
                                    )),

                                    DataCell(Text(selectedScannedDocu!.docu_type ?? '',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                      ),
                                    )),

                                    DataCell(Text(selectedScannedDocu!.docu_title ?? '',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                      ),
                                    )),

                                    DataCell(Text('$formattedDate - $formattedTime',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                      ),
                                    )),

                                    DataCell(Text(selectedScannedDocu!.docu_sender ?? '',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                      ),
                                    )),

                                    DataCell(Text(selectedScannedDocu!.docu_status ?? '',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                      ),
                                    )),
                                  ])
                                ],
                              ),
                            ),
                          ),


                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: isMobile(context) ? 10 : 50),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 1.0,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(width: 10),
                                Container(
                                  height: 35.0,
                                  width: (isWeb(context) || isMobile(context)) ? 150.0 : 100,
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                columnSpacing: (isWeb(context)) ? 290 : (isMobile(context) ? 80 : 150),
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      'Name',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                      label: Text(
                                        'Role',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      )
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Office',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Date/Time Scanned',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),

                                ],
                                rows: rowData(),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 20),
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
    final dataList = receiverData!.receiversInformationList;

    return dataList.map((_receiversInformation) =>
        DataRow(cells: [
          DataCell(Text(
            '${_receiversInformation.last_name}, ${_receiversInformation.first_name} ${_receiversInformation.middle_name ?? ''}',
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          )),
          DataCell(Text(_receiversInformation.role!,
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          )),
          DataCell(Text(_receiversInformation.office_name!,
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          )),
          DataCell(Text(_receiversInformation.getFormattedDateTime(),
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          )),
        ])
    ).toList(); // Convert the result of map to a List
  }

}
