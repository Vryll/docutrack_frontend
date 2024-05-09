import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docutrack_main/style.dart';
import 'package:docutrack_main/custom_widget/custom_superadmin_sideNavBar.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  bool isMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile(context) ? AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 65,
        title: Text(
          'About Us',
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
              child: Column(
                children: [
                  Padding(
                    padding: isMobile(context) ? EdgeInsets.symmetric(horizontal: 20, vertical: 30)
                        : EdgeInsets.symmetric(horizontal: 60, vertical: 50),
                    child: Column (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (MediaQuery.of(context).size.width > 600)
                          Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'About Us',
                                    style: GoogleFonts.poppins(
                                      fontSize: 45,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
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
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                  child: BuildTheSystem(context)
                              ),
                            ),
                            if (MediaQuery.of(context).size.width >= 920)
                              Expanded(
                                flex: 2,
                                child: Container(),
                              ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BuildTheSystemContent(context),
                                  SizedBox(height: 30.0),
                                  BuildTheDevelopers(context),
                                  BuildTheDevelopersContent(context),
                                ],
                              ),
                            ),
                            if (MediaQuery.of(context).size.width >= 920)
                              SizedBox(width: 20.0),
                            if (MediaQuery.of(context).size.width >= 920)
                              Expanded(
                                flex: 2,
                                child: Image.asset(
                                  'assets/DocuTrack (Red).png',
                                  height: 200,
                                  width: 200,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        BuildImageDeveloper(context),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height > 1000
                      ? MediaQuery.of(context).size.height * .2 : 50),
                  buildFooter(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget BuildTheSystem(BuildContext context) {
  return Column (
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'The System',
        style: GoogleFonts.poppins(
          color: Color(0xFF800000),
          fontSize: MediaQuery.of(context).size.width < 600 ? 16.0 : 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        'What’\s the system all about?',
        style: GoogleFonts.poppins(
          color: primaryColor,
          fontSize: MediaQuery.of(context).size.width < 600 ? 25.0 : 35.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Widget BuildTheSystemContent(BuildContext context) {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              'DocuTrack is a cutting-edge document tracking and management system seamlessly integrated as '
                  'both a mobile application and a user-friendly website. '
                  'Our innovative solution is designed to streamline the process of document management,'
                  ' ensuring efficiency and precision in handling physical documents.',
              style: GoogleFonts.poppins(
                color: primaryColor,
                fontSize: size16_14(context),
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          if (MediaQuery.of(context).size.width < 920)
            SizedBox(width: 10),
          if (MediaQuery.of(context).size.width < 920)
            Image.asset(
              'assets/DocuTrack (Red).png',
              height: MediaQuery.of(context).size.width <= 690 ? 120 : MediaQuery.of(context).size.width <= 600 ? 100 : MediaQuery.of(context).size.width < 550 ? 120 : 100,
              width: MediaQuery.of(context).size.width <= 690 ? 120 : MediaQuery.of(context).size.width <= 600 ? 100 : MediaQuery.of(context).size.width < 550 ? 120 : 100,
            ),
        ],
      ),
      SizedBox(height: 5),
      Text(
        'A standout feature of DocuTrack is our pioneering QR code '
            'scanning technology, meticulously designed for real-time tracking of physical documents. '
            'Each document is assigned a unique QR code, enabling swift and accurate monitoring. With a '
            'simple scan using our mobile application, users gain instant access to the document\'s current status and location, '
            'revolutionizing the tracking experience',
        style: GoogleFonts.poppins(
          color: primaryColor,
          fontSize: size16_14(context),
        ),
        textAlign: TextAlign.justify,
      ),
      SizedBox(height: 5),
      Text(
        'At DocuTrack, our team is a fusion of innovative visionaries '
            'dedicated to pioneering advancements in document management. With a diverse array of skills '
            'and experiences, we collaborate to make DocuTrack the exemplary solution '
            'for simplified document tracking and management.',
        style: GoogleFonts.poppins(
          color: primaryColor,
          fontSize: size16_14(context),
        ),
        textAlign: TextAlign.justify,
      ),
    ],
  );
}

Widget BuildTheDevelopers(BuildContext context) {
  return Column (
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'The Team',
        style: GoogleFonts.poppins(
          color: primaryColor,
          fontSize: MediaQuery.of(context).size.width < 600 ? 16.0 : 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        'Meet the development team',
        style: GoogleFonts.poppins(
          color: primaryColor,
          fontSize: MediaQuery.of(context).size.width < 600 ? 25.0 : 35.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Widget BuildTheDevelopersContent(BuildContext context) {
  return Text(
    'At DocuTrack, our team is a fusion of innovative visionaries dedicated to pioneering advancements in document management. With a diverse array of skills and experiences, we collaborate to make DocuTrack the exemplary solution for simplified document tracking and management.',
    style: GoogleFonts.poppins(
      color: primaryColor,
      fontSize: size16_14(context),
    ),
    textAlign: TextAlign.justify,
  );
}

Widget BuildImageDeveloper(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRect(
              child: Image.asset(
                'assets/Vryll.jpg',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              'Vryll Atilano',
              style: GoogleFonts.poppins(
                color: primaryColor,
                fontSize: size12_10(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Developer',
              style: GoogleFonts.poppins(
                color: primaryColor,
                fontSize: size11_09(context),
                // fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      SizedBox(width: 15),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRect(
              child: Image.asset(
                'assets/Nathalie.jpg',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              'Nathalie Enriquez',
              style: GoogleFonts.poppins(
                color: primaryColor,
                fontSize: size12_10(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Developer',
              style: GoogleFonts.poppins(
                color: primaryColor,
                fontSize: size11_09(context),
                // fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      SizedBox(width: 15),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRect(
              child: Image.asset(
                'assets/Al Rasid.jpg',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              'Al Rasid Arasain',
              style: GoogleFonts.poppins(
                color: primaryColor,
                fontSize: size12_10(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Developer',
              style: GoogleFonts.poppins(
                color: primaryColor,
                fontSize: size11_09(context),
                // fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget buildFooter(BuildContext context) {
  return Container (
    color: primaryColor,
    child: Container (
      margin: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20.0,
          bottom: 20.0
      ),
      child: Row(
        children: [
          Expanded (
            child: Column (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/DocuTrack(White).png',
                  height: 25,
                  width: 25,
                ),
                SizedBox(height: 10.0),
                Text(
                  'Keep track of your documents \nwith DocuTrack',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width < 650 ? 8.0 : 12.0,
                  ),
                ),
              ],
            ),
          ),
          Expanded (
            child: Column (
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Text(
                //   'Email us at:',
                //   style: GoogleFonts.poppins(
                //     color: Colors.white,
                //     fontSize: MediaQuery.of(context).size.width < 650 ? 8.0 : 12.0,
                //   ),
                // ),
                // Text(
                //   'xt202001896@wmsu.edu.ph',
                //   style: GoogleFonts.poppins(
                //     color: Colors.white,
                //     fontSize: MediaQuery.of(context).size.width < 650 ? 8.0 : 12.0,
                //   ),
                // ),
                // SizedBox(height: MediaQuery.of(context).size.width < 650 ? 10.0 : 20.0),
                SizedBox(height: 40),
                Text(
                  '© 2023 DocuTrack.  All rights reserved.',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width < 650 ? 7.0 : 12.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


