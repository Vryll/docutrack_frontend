import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:docutrack_main/main.dart';
import 'package:docutrack_main/style.dart';
import 'package:docutrack_main/staff/worspace_uploadfile.dart';
import 'package:docutrack_main/custom_widget/staff_custom_nav_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:async';
import 'package:docutrack_main/staff/scanned_history.dart';
import 'package:docutrack_main/localhost.dart';

class ClerkTrackingProgress extends StatefulWidget {
  const ClerkTrackingProgress({super.key});

  @override
  State<ClerkTrackingProgress> createState() => _ClerkTrackingProgressState();
}

class _ClerkTrackingProgressState extends State<ClerkTrackingProgress> {
  var api_url = dotenv.env['API_URL'];
  Color? selectedTileColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Tracking Progress',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
        ),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          //   icon: const Icon(Icons.arrow_back),
          //   color: secondaryColor,
          // ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                          ],
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 20),

                      child: Consumer<ClerkScannedtrackingProgressState>(
                        builder: (context, clerkScannedtrackingProgressState, child) {
                          return Container(
                            child: Text(
                              'Total: ${clerkScannedtrackingProgressState.trackingProgressCount?.toString() ?? '0'}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 10.0),


                  Consumer<ClerkScannedtrackingProgressState>(
                    builder: (context, clerkScannedtrackingProgressState, child) {
                      if (clerkScannedtrackingProgressState != null) {
                        List<ClerkScannedDocuTrackingProgressDetails> clerkScannedTrackingDetails =
                            clerkScannedtrackingProgressState.clerkScannedDocuTrackingList;

                        return Expanded(
                          child: ListView.builder(
                            itemCount: clerkScannedTrackingDetails.length,
                            itemBuilder: (context, index) {
                              ClerkScannedDocuTrackingProgressDetails clerkScannedTrackingDocuDetail =
                              clerkScannedTrackingDetails[index];

                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                    '${clerkScannedTrackingDocuDetail.first_name} ${clerkScannedTrackingDocuDetail.last_name}',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  subtitle: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${clerkScannedTrackingDocuDetail.role} | ',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '${clerkScannedTrackingDocuDetail.office_name}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                    (clerkScannedTrackingDocuDetail.time_scanned != null)
                                        ? (() {
                                      final parsedDateTime = DateTime.parse(clerkScannedTrackingDocuDetail.time_scanned.toString());
                                      final formattedDate = DateFormat('MM/dd/yyyy').format(parsedDateTime);
                                      final formattedTime = DateFormat('hh:mm a').format(parsedDateTime);
                                      return '$formattedDate - $formattedTime';
                                    })()
                                        : '',
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {

                        return CircularProgressIndicator();
                      }
                    },
                  )


                ],
              ),
            )
          ]
      ),



      drawer: SideNav(),
    );
  }
}
