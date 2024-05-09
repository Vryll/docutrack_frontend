import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:docutrack_main/main.dart';
import 'package:google_fonts/google_fonts.dart';

class StaffIdScanner extends StatefulWidget {
  final Function(bool) onComplete;
  const StaffIdScanner({required this.onComplete});

  @override
  State<StaffIdScanner> createState() => _StaffIdScannerState();
}

class _StaffIdScannerState extends State<StaffIdScanner> {
  late CameraController controller;
  late List<CameraDescription> cameras;
  late String imagePath;
  StaffIDImageState? staffIDImageState;

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.length > 0) {

        final frontCamera = cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras[0],
        );
        setState(() {
          controller = CameraController(frontCamera, ResolutionPreset.high);
        });
        controller.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        });
      }
    });
    staffIDImageState = Provider.of<StaffIDImageState>(context, listen: false);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildCameraPreview(),
          Positioned(
            top: 60.0,
            left: 15.0,
            child: Builder(
              builder: (BuildContext context) => IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back),
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 70.0,
            left: 50.0,
            right: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Container()),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Scan ID',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 40.0),
        child: InkWell(
          onTap: () {
            try {
              widget.onComplete(true);
              saveCapturedImage(context, controller);


            } catch (e) {
              print(e);
            }

          },
          child: Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(
              Icons.circle_outlined,
              size: 65.0,
              color: Colors.black,),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  Widget _buildCameraPreview() {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: 1.0,
            child: Center(
              child: AspectRatio(
                aspectRatio: deviceRatio,
                child: CameraPreview(controller),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Container(
              width: 320,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: Colors.yellow,
                  width: 3,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  Future<void> saveCapturedImage(BuildContext context, CameraController controller) async {
    try {
      final image = await controller.takePicture();
      final imagePath = image.path;
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'employeeID${DateTime.now().millisecondsSinceEpoch}.png';


      final imageBytes = await File(imagePath).readAsBytes();


      final base64String = base64Encode(imageBytes);



      staffIDImageState!.setCapturedImageBase64(base64String);


      final pngFile = File('${directory.path}/$fileName');
      await pngFile.writeAsBytes(imageBytes);

      print('Image saved to ${pngFile.path}');

      Future.delayed(Duration(milliseconds: 200), () {
        Navigator.of(context).pop();
      });
    } catch (e) {
      print(e);
    }
  }

}
