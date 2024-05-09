import 'package:flutter/material.dart';
import 'package:docutrack_main/custom_widget/custom_side_nav_bar.dart';
import 'package:docutrack_main/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

// void main() {
//   runApp(const AdminMain());
// }
//
// class AdminMain extends StatelessWidget {
//   const AdminMain({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => AppState(),
//       child: MaterialApp(
//         title: 'DocuTrack',
//         theme: ThemeData(
//           useMaterial3: true,
//           colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
//         ),
//         home: AdminHome(),
//       ),
//     );
//   }
// }
//
// class AppState extends ChangeNotifier {
//   Int? documentId;
//
//   void setDocumentId(Int id) {
//     documentId = id;
//     notifyListeners();
//   }
// }

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
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
