import 'package:docutrack_main/style.dart';
import 'package:flutter/material.dart';
import 'package:docutrack_main/custom_widget/custom_superadmin_sideNavBar.dart';
import 'package:google_fonts/google_fonts.dart';

class SuperAdmin_HomePage extends StatefulWidget {
  const SuperAdmin_HomePage({Key? key}) : super(key: key);

  @override
  State<SuperAdmin_HomePage> createState() => _SuperAdmin_HomePageState();
}

class _SuperAdmin_HomePageState extends State<SuperAdmin_HomePage> {
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile(context)
          ? AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 65,
        iconTheme: IconThemeData(
          color: secondaryColor,
        ),
      ) : null,
      drawer: isMobile(context)
          ? Drawer(
        backgroundColor: primaryColor,
        child: SideNav(),
      ) : null,
      body: Row(
        children: [
          isWeb(context) ?
          Container(
            color: primaryColor,
            child: SideNav(),
            width: size300_80(context),
          ) : Container(),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 30, right: 30.0),
                  child: FittedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Keep track of\nyour documents.',
                          style: GoogleFonts.poppins(
                            color: primaryColor,
                            fontSize: 65,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                          maxLines: 2,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Effortlessly keep tabs on every document in your workflow.',
                          style: GoogleFonts.poppins(
                            color: primaryColor,
                            fontSize: 20,
                          ),
                          maxLines: 2,
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
