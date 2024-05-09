import 'package:flutter/material.dart';
import 'package:docutrack_main/style.dart';
import 'package:docutrack_main/custom_widget/staff_custom_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class ScanQRTracking extends StatelessWidget {
  const ScanQRTracking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryColor,
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(50.0),
                  topLeft: Radius.circular(50.0),
                ),
              ),
              child: Column(
                children: <Widget>[

                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Text(
                                'Document Tracking',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),

                      Container(

                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: SideNav(),
    );
  }
}