// import 'dart:js_util';

import 'package:docutrack_main/signup_staff.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'style.dart'; // Assuming primaryColor is defined here
import 'package:docutrack_main/sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'dart:ffi' as ffi;
import 'dart:ui' as ui;
import 'package:docutrack_main/custom_widget/custom_side_nav_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:docutrack_main/custom_widget/custom_superadmin_sideNavBar.dart';
import 'package:docutrack_main/guest/guest_form.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:docutrack_main/admin/outgoing_documents/admin_document_tracking_progress.dart';
import 'package:docutrack_main/admin/receive_documents/admin_recievedDocument_tracking_progress.dart';
import 'package:docutrack_main/staff/worksSpace_Page.dart';
import 'package:docutrack_main/admin/admin_archived.dart';
import 'package:docutrack_main/staff/staff_archived.dart';
import 'package:docutrack_main/superadmin/superadmin_archived.dart';
import 'package:docutrack_main/superadmin/superadmin_records_dashboard.dart';
import 'package:docutrack_main/admin/requested_documents/incoming_request_document_tracking.dart';
import 'package:docutrack_main/admin/requested_documents/admin_requestedDocument_tracking_progress.dart';
import 'package:docutrack_main/admin/requested_documents/admin_request_dashboard.dart';
import 'package:docutrack_main/custom_widget/staff_custom_nav_bar.dart';
import 'package:docutrack_main/staff/scanned_history.dart';


final RouteObserver<ModalRoute> routeObserver =
    RouteObserver<ModalRoute>();

void main() async {
  await dotenv.load(fileName: "config.env");
  runApp(
    ChangeNotifierProvider(
      create: (context) => SelectedItemProvider(),
      child: const MyApp(),
    ),
  );
}

class SelectedItemProvider with ChangeNotifier {
  String _selectedItem = 'Home';
  String get selectedItem => _selectedItem;

  void setSelectedItem(String item) {
    _selectedItem = item;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => MyappState()
        ),

        // ChangeNotifierProvider(
        //     create: (context) => DocumentDetailsState()
        // ),
        ChangeNotifierProvider(
            create: (context) => QrCodeDataState()
        ),

        ChangeNotifierProvider(
            create: (context) => signUserState()
        ),

        ChangeNotifierProvider(
            create: (context) => ScannedIdQRState()
        ),
        ChangeNotifierProvider(
            create: (context)=> DocumentDetailState()
        ),
        ChangeNotifierProvider(
            create: (context)=>UserJwtToken()
        ),
        ChangeNotifierProvider(
            create: (context)=>StaffIDImageState()
        ),
        ChangeNotifierProvider(
            create: (context)=> StaffSelfieImageState()
        ),
        ChangeNotifierProvider(
            create: (context) => DocumentDetailDashboardState()
        ),
        ChangeNotifierProvider(
            create: (context)=> WorkspaceDocumentDetailDashboardState()
        ),
        ChangeNotifierProvider(
            create: (context) => RecieveDocumentDetailDashboardState()
        ),
        ChangeNotifierProvider(
            create: (context)=>RequestedDocumentDetailDashboardState()
        ),
        ChangeNotifierProvider(
            create: (context)=> ReceiversRecordDetailsDashboard()
        ),
        ChangeNotifierProvider(
            create: (context)=>IncomingRequestedDocumentDetailDashboardState()
        ),
        ChangeNotifierProvider(
            create: (context)=>SelectedIncomingRequestedDocuDetails()
        ),
        ChangeNotifierProvider(
            create: (context)=>MainDocumentDetailDashboardState()
        ),
        ChangeNotifierProvider(create:
            (create)=>UserOfficeNameState()
        ),
        ChangeNotifierProvider(
            create: (context)=>SelectedDocuDetails()
        ),
        ChangeNotifierProvider(
            create: (context)=>SelectedDocuPreviewState()
        ),

        ChangeNotifierProvider(
            create: (context) => UserIdState()
        ),
        ChangeNotifierProvider(
            create: (context) => SelectedRecievedDocuDetails()
        ),
        ChangeNotifierProvider(
            create: (context)=>SelectedRequestedDocuDetails()
        ),
        ChangeNotifierProvider(
            create: (context)=>SelectedAdminDetailsState()
        ),
        ChangeNotifierProvider(
            create: (context)=> StaffUserData()
        ),
        ChangeNotifierProvider(
            create: (context)=>UserAccountsDashboard()
        ),
        ChangeNotifierProvider(
            create: (context)=>GuestDetailState()
        ),
        ChangeNotifierProvider(
            create: (context)=>AdminProfileState()
        ),
        ChangeNotifierProvider(
            create: (context) => SuperadminProfileState()
        ),
        ChangeNotifierProvider(
            create: (context)=>OutgoingDocuCount()
        ),
        ChangeNotifierProvider(
            create: (context)=>ClerkUsernameState()
        ),
        ChangeNotifierProvider(
            create: (context)=>WorkspaceDocuDetailState()
        ),
        ChangeNotifierProvider(
            create: (context)=>DocumentCountForWorkspace()
        ),
        ChangeNotifierProvider(create:
            (context)=>OverallWorkspaceDocuDetailsCountState()
        ),
        ChangeNotifierProvider(
            create: (context)=>ClerkDetailState()
        ),
        ChangeNotifierProvider(
            create: (context)=>SelectWorkspaceDocuDetailState()
        ),
        ChangeNotifierProvider(
            create: (context)=>ScannedRecordCountState()
        ),
        ChangeNotifierProvider(create:
            (context)=>ForgetPasswordState()
        ),
        ChangeNotifierProvider(
            create: (context)=>OutgoingDocuTrackingProgressState()
        ),
        ChangeNotifierProvider(create:
            (context)=>ReceivedDocuTrackingProgressState()
        ),
        ChangeNotifierProvider(
            create: (context)=>PDFDocuFilePreviewState()
        ),
        ChangeNotifierProvider(create:
            (context)=>ArchivedDocuDetailsState()
        ),
        ChangeNotifierProvider(create:
            (context)=>ArchivedWorkspaceDocuDetailState()
        ),
        ChangeNotifierProvider(
            create: (context)=>ArchivedScannedReceivedRecordState()
        ),
        ChangeNotifierProvider(
            create: (conext)=>GuestDocumentDetailState()
        ),
        ChangeNotifierProvider(
            create: (context)=>SelectedScannedDocu()
        ),
        ChangeNotifierProvider(
            create: (context)=>ReceiverData()
        ),
        ChangeNotifierProvider(
            create: (context)=>ForwardedRequestDocumentDetails()
        ),
        ChangeNotifierProvider(
            create: (context)=>SelectedForwardedRequestedDocuFile()
        ),
        ChangeNotifierProvider(
            create: (context)=>DefaultIncomingRequestDocuState()
        ),
        ChangeNotifierProvider(
            create: (context)=>SelectedDefaultRequestDocuState()
        ),
        ChangeNotifierProvider(
            create: (context)=>ForwardedOutgoingRequestDocumentDetails()
        ),
        ChangeNotifierProvider(
            create: (context)=>ForwardRequestRecord()
        ),
        ChangeNotifierProvider(
            create: (context)=>ClerkScannedHistoryState()
        ),
        ChangeNotifierProvider(create:
            (context)=>ClerkScannedtrackingProgressState()
        ),

        // ChangeNotifierProvider(
        //     create: (context) => FetchedDocuDetailsDataState()
        // ),
      ],
      child: MaterialApp(
        title: 'DocuTrack',
        theme: null,
        home: HomePage(),
      ),
    );
  }
}

//IMPLEMENTATION OF PROVIDER
// class DocumentDetailsState extends ChangeNotifier{
//   String? docu_id = '';
//
//   void updateDocuID(String newDocuID){
//     docu_id = newDocuID;
//     notifyListeners();
//   }
// }

//PROVIDER FOR QRDATA
class QrCodeDataState extends ChangeNotifier{
  String? docu_id = "";
  String? memorandumNumber = "";
  String? docuTitle = "";
  String? docuType = "";
  String? docuReleased = "";
  String? docuSender = "";
  List<String> docuRecipient = [];
  String? docuFile = "";
  bool isQrDataSet = false;

  void setQrDataToFalse() {
    isQrDataSet = false;
    notifyListeners();
  }

  void cleanup() {
    // Perform any cleanup or resetting logic here
    docu_id = "";
    memorandumNumber = "";
    docuTitle = "";
    docuType = "";
    docuReleased = "";
    docuSender = "";
    docuRecipient = [];
    docuFile = "";
    isQrDataSet = false;

    // Notify listeners after cleanup
    notifyListeners();
  }

  void setqrData(String? newDocuID,String? newMemorandumNumber,  String? newDocuTitle, String? newDocuType,String? newDocuReleased,String? newDocuSender,  List<String> newDocuRecipient, String? newDocuFile){
    docu_id = newDocuID;
    memorandumNumber = newMemorandumNumber;
    docuTitle = newDocuTitle;
    docuType = newDocuType;
    docuReleased = newDocuReleased;
    docuSender = newDocuSender;
    docuRecipient = newDocuRecipient;
    docuFile = newDocuFile;

    isQrDataSet = true;

    print(docu_id);
    print(memorandumNumber);
    print(docuTitle);
    print(docuType);
    print(docuReleased);
    print(docuSender);
    print(docuRecipient);
    print(docuFile);
    print("Qr is set!!!");
    notifyListeners();
  }
}

//PROVIDER FOR SCANNED DATA
class scannedDataState extends ChangeNotifier{
  String? scanned_docuId;
  String? scanned_memorandumNumber;
  String? scanned_docuTitle;
  String? scanned_docuType;
  String? scanned_docuReleased;
  String? scanned_docuSender;
  String? scanned_docuRecipient;
  String? scanned_docuFile;

  void setScannedQRData(String? docuId,String memorandumNumber ,String? docuTitle,String? docuType,String? docuReleased,String? docuSender,String? docuRecipient, String? docuFile){

    scanned_docuTitle = docuId;
    scanned_memorandumNumber = memorandumNumber;
    scanned_docuTitle = docuTitle;
    scanned_docuType = docuType;
    scanned_docuReleased = docuReleased;
    scanned_docuSender = docuSender;
    scanned_docuRecipient = docuRecipient;
    scanned_docuFile = docuFile;

    notifyListeners();
  }
}

//PROVIDER FOR SIGN IN
class signUserState extends ChangeNotifier{
  String? username;
  String? password;

  String? admin_id;
  String? office_name;

  void setUsername(username){
    username = username;
    notifyListeners();
  }
  void setPassword(password){
    password = password;
    notifyListeners();
  }

  void setadminID(admin_id){
    admin_id = admin_id;
    notifyListeners();
  }
  void setofficeName(office_name){
    office_name = office_name;
    notifyListeners();
  }

}

class ScannedIdQRState extends ChangeNotifier{
  String? docuId = "";


  void setScannedIdQr(String? newdocuId){
    docuId = newdocuId;
    notifyListeners();
    print(docuId);
  }
}


//PROVIDER FOR HANDLING TOKEN
class MyappState extends ChangeNotifier {
  var api_url = dotenv.env['API_URL'];
  var user_Token = "";

  var apiUrl = "api_url";

  void setToken(String token){
    user_Token = token;
    notifyListeners();
    print(user_Token);
  }
}

class DocumentDetailState extends ChangeNotifier{
  String? docuId;
  String? docu_type;
  String? docu_title;
  String? memorandum_number;
  String? docu_sender;
  String? docu_dateNtime_released;


  void setDocuDetails(String newDocuId,String newDocuType, String newDocuTitle, String newMemorandumOrder,  String newDocuSender, String newDocuReleased){
    docuId = newDocuId;
    docu_type = newDocuType;
    docu_title = newDocuTitle;
    memorandum_number = newMemorandumOrder;
    docu_sender = newDocuSender;
    docu_dateNtime_released = newDocuReleased;
    // docu_recipient = newDocuRecipient;
    // docu_file = newDocuFile;

    print(docuId);
    print(memorandum_number);
    print(docu_title);
    print(docu_type);
    print(docu_sender);
    print(docu_dateNtime_released);
    notifyListeners();
  }
}

class GuestDocumentDetailState extends ChangeNotifier{
  String? docuId;
  String? memorandum_number;
  String? docu_title;
  String? docu_type;
  String? docu_sender;
  String? docu_dateNtime_released;


  void setGuestDocuDetails(String newDocuId, String newMemorandumOrder, String newDocuTitle, String newDocuType, String newDocuSender, String newDocuReleased){
    docuId = newDocuId;
    memorandum_number = newMemorandumOrder;
    docu_title = newDocuTitle;
    docu_type = newDocuType;
    docu_sender = newDocuSender;
    docu_dateNtime_released = newDocuReleased;
    // docu_recipient = newDocuRecipient;
    // docu_file = newDocuFile;

    print(docuId);
    print(memorandum_number);
    print(docu_title);
    print(docu_type);
    print(docu_sender);
    print(docu_dateNtime_released);
    notifyListeners();
  }
}



class UserJwtToken extends ChangeNotifier{
  String? jwt_token;

  void setUserJwtToken(String newJwtToken){
    jwt_token = newJwtToken;
    print(jwt_token);
    notifyListeners();
  }
}

class StaffIDImageState extends ChangeNotifier {
  String? capturedImageEmpIDPath;
  // String? capturedSelfieImagePathBase64Data;
  String? capturedImageBase64;

  void setCapturedImage(String imagePath) {
    capturedImageEmpIDPath = imagePath;
    notifyListeners();
    print(capturedImageEmpIDPath);
  }

  // void setCapturedSelfieImage(String newSelfieImgBase64Data){
  //   capturedSelfieImagePathBase64Data = newSelfieImgBase64Data;
  //   notifyListeners();
  //   print(capturedSelfieImagePathBase64Data);
  // }

  void setCapturedImageBase64(String base64Data) {
    capturedImageBase64 = base64Data;
    notifyListeners();
    print(capturedImageBase64);
  }
}

class StaffSelfieImageState with ChangeNotifier{
  String? capturedImageEmpIDPath;
  String? capturedSelfieImagePathBase64Data;

  void setCapturedImage(String imagePath) {
    capturedImageEmpIDPath = imagePath;
    notifyListeners();
    print(capturedImageEmpIDPath);
  }

  void setCapturedSelfieImageBase64Data(String base64Data){
    capturedSelfieImagePathBase64Data = base64Data;
    notifyListeners();
    print(capturedSelfieImagePathBase64Data);
  }
}

class DocumentDetailDashboardState extends ChangeNotifier{
  List<DocumentDetails> _docuDetailsList = [];

  List<DocumentDetails> get docuDetailsList => _docuDetailsList;

  void setDocuDetailsList(List<DocumentDetails> newList) {
    _docuDetailsList = newList;
    notifyListeners();
    print(_docuDetailsList);
  }
//   List<DocumentDetails>getDocuDetailsList{
//     return _docuDetailsList ?? '';
// }
  void removeAdminData(String docuId) {
    // Remove the admin data with the specified ID from the list
    _docuDetailsList.removeWhere((docuDetails) => docuDetails.id == docuId);
    notifyListeners(); // Notify listeners after the data is removed
  }
}

class OutgoingDocuTrackingProgressState extends ChangeNotifier {
  List<TrackingProgressDetails> _trackingProgressDetailList = [];

  List<TrackingProgressDetails> get trackingProgressDetailList => _trackingProgressDetailList;

  void setOutgoingDocuTrackingProgress(List<TrackingProgressDetails> newOutgoingDocuList){
    _trackingProgressDetailList = newOutgoingDocuList;

    notifyListeners();
  }
}

class ReceivedDocuTrackingProgressState extends ChangeNotifier{
  List<ReceivingTrackingProgressDetails> _receivingTrackingProgressDetailList = [];

  List<ReceivingTrackingProgressDetails> get receivingTrackingProgressDetailList => _receivingTrackingProgressDetailList;

  void setReceivedDocuTrackingProgress(List<ReceivingTrackingProgressDetails> newReceiveTrackingProgressDetails){
    _receivingTrackingProgressDetailList = newReceiveTrackingProgressDetails;
    notifyListeners();
    print(_receivingTrackingProgressDetailList);
  }
}

class WorkspaceDocumentDetailDashboardState extends ChangeNotifier{
  List<WorkspaceDocumentDetails> _workspaceDocumentDetailsList = [];

  List<WorkspaceDocumentDetails> get workspaceDocumentDetailsList=>_workspaceDocumentDetailsList;

  void setWorkspaceDocuDetailsList(List<WorkspaceDocumentDetails> newWorkspaceDocuList){
    _workspaceDocumentDetailsList = newWorkspaceDocuList;
    notifyListeners();
    print(_workspaceDocumentDetailsList);
  }
}

class SelectWorkspaceDocuDetailState extends ChangeNotifier{
  int? id;
  String? workspace_docu_file;
  String? workspace_docu_comment;

  void setSelectedWorkspaceDocuDetail(int newID, String newWorkspaceDocuFile, String newWorkspaceDocuComment){
    id = newID;
    workspace_docu_file = newWorkspaceDocuFile;
    workspace_docu_comment = newWorkspaceDocuComment;

    notifyListeners();

    print(id);
    print(workspace_docu_file);
    print(workspace_docu_comment);
  }
}

class RecieveDocumentDetailDashboardState extends ChangeNotifier{
  List<RecievedDocumenDetails> _recievedDocuDetailsList = [];

  List<RecievedDocumenDetails> get recievedDocuDetailsList => _recievedDocuDetailsList;

  void setRecievedDocuDetailsList(List<RecievedDocumenDetails> newRecievedList){
    _recievedDocuDetailsList = newRecievedList;
    notifyListeners();
    print(_recievedDocuDetailsList);
  }

  void removeAdminData(String docuId) {

    _recievedDocuDetailsList.removeWhere((docuDetails) => docuDetails.id == docuId);
    notifyListeners();
  }
}

class RequestedDocumentDetailDashboardState extends ChangeNotifier{
  List<RequestDocumentDetails> _requestDocumentDetailsList =[];

  List<RequestDocumentDetails> get requestDocumentDetailsList => _requestDocumentDetailsList;

  void setRequestedDocumentDetailDashboardState(List<RequestDocumentDetails> newRequestedDocumenDetailsList){
    _requestDocumentDetailsList =  newRequestedDocumenDetailsList;
    notifyListeners();
    print(_requestDocumentDetailsList);
  }

  void removeAdminData(String docuId) {

    _requestDocumentDetailsList.removeWhere((docuDetails) => docuDetails.id == docuId);
    notifyListeners();
  }
}

class MainDocumentDetailDashboardState extends ChangeNotifier{
  List<MainDocumentDetails> _mainDocumentDetailsList = [];
  List<MainDocumentDetails> get mainDocumentDetailsList => _mainDocumentDetailsList;

  void setMainDetailDashboardState(List<MainDocumentDetails> newMainDocumenDetailsList){
    _mainDocumentDetailsList = newMainDocumenDetailsList;
    notifyListeners();
    print(_mainDocumentDetailsList);
  }
  void removeAdminData(String docuId) {

    _mainDocumentDetailsList.removeWhere((docuDetails) => docuDetails.id == docuId);
    notifyListeners();
  }
}

///ARCHIVED DOCUMENT DETAILS
class ArchivedDocuDetailsState extends ChangeNotifier{
  List<ArchivedDocumentDetails> _archivedDocuDetailsList = [];
  List<ArchivedDocumentDetails> get archivedDocuDetailsList => _archivedDocuDetailsList;

  int? archivedCount;

  void setArchivedDocuDetailsState(List<ArchivedDocumentDetails> newArchivedDetailsList){
    _archivedDocuDetailsList = newArchivedDetailsList;
    notifyListeners();
    print(_archivedDocuDetailsList);
  }
  void setArchivedCount(int newArchivedCount){
    archivedCount = newArchivedCount;
    notifyListeners();
    print(archivedCount);
  }

  void removeDocument(String docuId) {
    _archivedDocuDetailsList.removeWhere((document) => document.docu_id == docuId);
    notifyListeners();
  }
}
/// ARCHIVED SCANNED RECEIVED RECORDS
class ArchivedScannedReceivedRecordState extends ChangeNotifier{
  List<ArchivedScannedReceiveRecordDetails> _archivedScannedReceiveRecordDetailsList = [];
  List<ArchivedScannedReceiveRecordDetails> get archivedScannedReceiveRecordDetailsList => _archivedScannedReceiveRecordDetailsList;

  int? archivedRecordsCount;

  void setArchivedScannedReceivedRecord(List<ArchivedScannedReceiveRecordDetails> newArchiveScannedReceiveRecord){
    _archivedScannedReceiveRecordDetailsList = newArchiveScannedReceiveRecord;
    notifyListeners();
    print(_archivedScannedReceiveRecordDetailsList);
  }

  void setArchivedScannedRecordsCount(int newArchivedRecordsCount){
    archivedRecordsCount = newArchivedRecordsCount;
    notifyListeners();
    print(archivedRecordsCount);
  }

  void removeDocument(String recordId) {
    _archivedScannedReceiveRecordDetailsList.removeWhere((docu) => docu.record_id == recordId);
    notifyListeners();
  }
}

/// ARCHIVED WORKSPACE DOCUMENT DETAILS
class ArchivedWorkspaceDocuDetailState extends ChangeNotifier{
  List<ArchivedWorkspaceDocumentDetails> _archivedWorkspaceDocuDetalsList = [];
  List<ArchivedWorkspaceDocumentDetails> get archivedWorkspaceDocuDetalsList => _archivedWorkspaceDocuDetalsList;

  int? archived_workspace_docu_count;

  void setArchivedWorkspaceDocuDetails(List<ArchivedWorkspaceDocumentDetails> newArchivedWorkspaceDocuCount){
    _archivedWorkspaceDocuDetalsList = newArchivedWorkspaceDocuCount;
    notifyListeners();
    print(_archivedWorkspaceDocuDetalsList);
  }

  void setArchiveWorkspaceCount(int newArchiveWorkspacedocuCount){
    archived_workspace_docu_count = newArchiveWorkspacedocuCount;
    notifyListeners();
    print(archived_workspace_docu_count);
  }

  void removeDocument(String docuId) {
    _archivedWorkspaceDocuDetalsList.removeWhere((document) => document.workspace_docu_id == docuId);
    notifyListeners();
  }
}

class ClerkScannedHistoryState extends ChangeNotifier{
  List<ClerkScannedDocumentDetails> _clerkScannedDocumentDetailList = [];
  List<ClerkScannedDocumentDetails> get clerkScannedDocumentDetailList => _clerkScannedDocumentDetailList;

  int? scannedRecordCount;
  void setClerkScannedHistory(List<ClerkScannedDocumentDetails> newClerkScannedDocumentDetailList){
    _clerkScannedDocumentDetailList = newClerkScannedDocumentDetailList;
    notifyListeners();
    print(_clerkScannedDocumentDetailList);
  }

  void setClerkScannedHistoryCount(int newScannedRecordCount){
    scannedRecordCount = newScannedRecordCount;

    notifyListeners();
    print(scannedRecordCount);
  }
}

class ClerkScannedtrackingProgressState extends ChangeNotifier{
  List<ClerkScannedDocuTrackingProgressDetails> _clerkScannedDocuTrackingList = [];

  List<ClerkScannedDocuTrackingProgressDetails> get clerkScannedDocuTrackingList=> _clerkScannedDocuTrackingList;

  int? trackingProgressCount;
  void setClerkScannedTrackingProgress(List<ClerkScannedDocuTrackingProgressDetails> newClerkScannedTrackingList){
    _clerkScannedDocuTrackingList = newClerkScannedTrackingList;

    notifyListeners();
    print(_clerkScannedDocuTrackingList);
  }

  void setClerkScannedTrackingProgressCount(int newTrackingProgressCount){
    trackingProgressCount = newTrackingProgressCount;

    notifyListeners();
    print(trackingProgressCount);
  }
}

class IncomingRequestedDocumentDetailDashboardState extends ChangeNotifier{
  List<IncomingRequestDocumentDetails> _incomingrequestDocumentDetailsList =[];

  List<IncomingRequestDocumentDetails> get incomingrequestDocumentDetailsList => _incomingrequestDocumentDetailsList;

  void setIncomingRequestedDocumentDetailDashboardState(List<IncomingRequestDocumentDetails> newIncomingRequestedDocumenDetailsList){
    _incomingrequestDocumentDetailsList =  newIncomingRequestedDocumenDetailsList;
    notifyListeners();
    print(_incomingrequestDocumentDetailsList);
  }
}

class UserAccountsDashboard extends ChangeNotifier {
  List<AdminData> _adminDataList = [];

  List<AdminData> get adminDataList => _adminDataList;

  void setUserAccountsDashboard(List<AdminData> newAdminDataList) {
    _adminDataList = newAdminDataList;

    notifyListeners();

    print(_adminDataList);
  }
  void removeAdminData(String adminId) {
    adminDataList.removeWhere((adminData) => adminData.id.toString() == adminId);
    notifyListeners();
  }
}

class WorkspaceDocuDetailState extends ChangeNotifier {
  List<WorkspaceDocuDetail> _workspaceDocuDetailList = [];

  List<WorkspaceDocuDetail> get workspaceDocuDetailList => _workspaceDocuDetailList;

  int? docuDetailsCount;
  void setWorkspaceDocuDetail(List<WorkspaceDocuDetail> newWorkspaceDocuDetail, int newDocuDetailsCount) {
    _workspaceDocuDetailList = newWorkspaceDocuDetail;
    docuDetailsCount = newDocuDetailsCount;
    notifyListeners();
    print(_workspaceDocuDetailList);
    print(docuDetailsCount);
  }

  void removeDocuDetail(int docuId) {
    _workspaceDocuDetailList.removeWhere((item) => item.id == docuId);
    notifyListeners();
  }
}

class ReceiversRecordDetailsDashboard extends ChangeNotifier{
  List<ReceiversRecordDetails> _receiversRecordDetails = [];

  List<ReceiversRecordDetails> get receiversRecordDetails =>_receiversRecordDetails;

  void setReceiversRecordDetailsDashboard(List<ReceiversRecordDetails> newReceiversRecordDetails){
    _receiversRecordDetails = newReceiversRecordDetails;
    notifyListeners();
    print(_receiversRecordDetails);
  }
  void removeAdminData(String record_id) {
    _receiversRecordDetails.removeWhere((record) => record.record_id == record_id);
    notifyListeners();
  }
}

class ForwardedRequestDocumentDetails extends ChangeNotifier{
  List<ListForwardedRequestedDocumentFile> _forwardedRequestedDocumentFileList = [];

  List<ListForwardedRequestedDocumentFile> get forwardedRequestedDocumentFileList => _forwardedRequestedDocumentFileList;

  void setForwardedRequestedDocumentFile(List<ListForwardedRequestedDocumentFile> newForwardedRequestedDocu){
    _forwardedRequestedDocumentFileList = newForwardedRequestedDocu;
    notifyListeners();
    print(_forwardedRequestedDocumentFileList);

  }
}


class ForwardedOutgoingRequestDocumentDetails extends ChangeNotifier {
  List<ListForwardedOutgoingRequestedDocumentFile> _forwardedOutgoingRequestedDocumentFileList = [];

  List<ListForwardedOutgoingRequestedDocumentFile> get forwardedOutgoingRequestedDocumentFileList => _forwardedOutgoingRequestedDocumentFileList;

  void setForwardedOutgoingRequestedDocumentFile(List<ListForwardedOutgoingRequestedDocumentFile> newForwardedOutgoingRequestedDocu) {
    _forwardedOutgoingRequestedDocumentFileList = newForwardedOutgoingRequestedDocu;
    notifyListeners();
    print(_forwardedOutgoingRequestedDocumentFileList);
  }
}

class ForwardRequestRecord extends ChangeNotifier {
  List<ForwardRequestRecordModel> _forwardRequestRecordList = [];

  List<ForwardRequestRecordModel> get forwardRequestRecordList => _forwardRequestRecordList;

  void setForwardRequestRecord(List<ForwardRequestRecordModel> newForwardRequestRecordList) {
    _forwardRequestRecordList = newForwardRequestRecordList;
    notifyListeners();
    print(_forwardRequestRecordList);
  }
}


class SelectedForwardedRequestedDocuFile extends ChangeNotifier{
  String? forwarded_requested_docu_file;

  void setSelectedForwardedRequestedDocuFile(String newForwardedRequestedDocuFile){
    forwarded_requested_docu_file = newForwardedRequestedDocuFile;

    notifyListeners();

    print('forwarded_requested_docu_file');
  }
}

class DefaultIncomingRequestDocuState extends ChangeNotifier{
  int? docu_request_id;
  String? docu_request_topic;
  String? requested;
  String? docu_request_recipient;
  String? docu_request_deadline;
  String? docu_request_file;

  void setDefaultIncomingRequestDocuState(int newDocuRequestId, String newDocuRequestTopic, String newRequested, String newDocuRequestRecipient, String newDocuRequestDeadline, String newDocuRequestFile){
    docu_request_id = newDocuRequestId;
    docu_request_topic = newDocuRequestTopic;
    requested = newRequested;
    docu_request_recipient = newDocuRequestRecipient;
    docu_request_deadline = newDocuRequestDeadline;
    docu_request_file = newDocuRequestFile;

    notifyListeners();

    print(docu_request_id);
  }
}

class SelectedDefaultRequestDocuState extends ChangeNotifier{
  String? docu_request_file;

  void setSelectedDefaultRequestDocu(String newDocuRequestFile){
    docu_request_file = newDocuRequestFile;

    notifyListeners();
    print(docu_request_file);
  }
}

class UserIdState extends ChangeNotifier{
  String? userId;

  void setUserId(String newUserId){
    userId = newUserId;
    notifyListeners();
    print(userId);
  }
}

class UserOfficeNameState extends ChangeNotifier {
  String? requestOfficeName;

  void setUserOfficeName(String? newRequestedOfficeName) {
    requestOfficeName = newRequestedOfficeName;
    notifyListeners();
    print(requestOfficeName);
  }

  String getStoredOfficeName() {
    return requestOfficeName ?? "";
  }
}

class SelectedDocuDetails extends ChangeNotifier{
  String? docuId;
  String? memorandum_number;
  String? docu_type;
  String? docu_title;
  String? docu_dateNtime_released;
  String? docu_dateNtime_created;
  String? docu_sender;
  String? docu_recipient;
  String? status;

  void setSelectedDocuDetails(String? newDocuId,String? newMemorandumNumber ,String newDocuType, String newDocuTitle, String newDocuNTimeReleased,String newDocuDateNTimeCreated,String newDocuSender,String newDocuRecipient, String newStatus){
    docuId = newDocuId;
    memorandum_number = newMemorandumNumber;
    docu_type = newDocuType;
    docu_title = newDocuTitle;
    docu_dateNtime_released = newDocuNTimeReleased;
    docu_dateNtime_created = newDocuDateNTimeCreated;
    docu_sender=newDocuSender;
    docu_recipient = newDocuRecipient;
    status = newStatus;
    notifyListeners();

    // print(docuId);
    // print(docu_type);
    // print(docu_title);
    // print(docu_dateNtime_released);
    // print(docu_recipient);
    // print(status);
  }
}

class SelectedRecievedDocuDetails extends ChangeNotifier{
  String? docuId;
  String? memorandum_number;
  String? docu_type;
  String? docu_title;
  String? docu_dateNtime_released;
  String? docu_sender;
  String? status;

  void setSelectedRecievedDocuDetails(String? newDocuId,String newMemorandumNumber ,String newDocuType, String newDocuTitle, String newDocuNTimeReleased, String newDocuSender, String newStatus){
    docuId = newDocuId;
    memorandum_number = newMemorandumNumber;
    docu_type = newDocuType;
    docu_title = newDocuTitle;
    docu_dateNtime_released = newDocuNTimeReleased;
    docu_sender = newDocuSender;
    status = newStatus;
    notifyListeners();

    // print(docuId);
    // print(docu_type);
    // print(docu_title);
    // print(docu_dateNtime_released);
    // print(docu_sender);
    // print(status);
  }
}

class SelectedRequestedDocuDetails extends ChangeNotifier{
  String? req_docu_id;
  String? process_type;
  String? docu_request_topic;
  String? requested;
  String? docu_request_recipient;
  String? docu_request_deadline;
  String? status;
  String? docu_request_comment;
  String? docu_request_file;

  void setSelectedRequestedDocuDetails(String newReqdocuID,String newProcessType ,String newDocuRequestTopic, String newRequested, String newDocuRequesteRecipient, String newDocuRequestDeadline, String newDocuStatus, String newDocuRequestComment, newDocuReqFile){
    req_docu_id = newReqdocuID;
    process_type = newProcessType;
    docu_request_topic = newDocuRequestTopic;
    requested = newRequested;
    docu_request_recipient = newDocuRequesteRecipient;
    docu_request_deadline = newDocuRequestDeadline;
    status = newDocuStatus;
    docu_request_comment = newDocuRequestComment;
    docu_request_file = newDocuReqFile;

    notifyListeners();
    print(req_docu_id);
    print(process_type);
    print(docu_request_topic);
    print(requested);
    print(docu_request_recipient);
    print(docu_request_deadline);
    print(status);
    print(docu_request_comment);
    print(docu_request_file);
  }
}

class SelectedIncomingRequestedDocuDetails extends ChangeNotifier{
  String? req_docu_id;
  String? process_type;
  String? docu_request_topic;
  String? requested;
  String? docu_request_recipient;
  String? docu_request_deadline;
  String? status;
  String? docu_request_comment;
  String? docu_request_file;

  void setSelectedIncomingRequestedDocuDetails(String newReqdocuID,String newProcessType ,String newDocuRequestTopic, String newRequested, String newDocuRequesteRecipient, String newDocuRequestDeadline, String newDocuStatus, String newDocuRequestComment, String newReqDocuFile){
    req_docu_id = newReqdocuID;
    process_type = newProcessType;
    docu_request_topic = newDocuRequestTopic;
    requested = newRequested;
    docu_request_recipient = newDocuRequesteRecipient;
    docu_request_deadline = newDocuRequestDeadline;
    status = newDocuStatus;
    docu_request_comment = newDocuRequestComment;
    docu_request_file = newReqDocuFile;

    notifyListeners();
    print(req_docu_id);
    print(process_type);
    print(docu_request_topic);
    print(requested);
    print(docu_request_recipient);
    print(docu_request_deadline);
    print(status);
    print(docu_request_comment);
    print(docu_request_file);
  }
}

class SelectedDocuPreviewState extends ChangeNotifier{
  int? docuId;
  String? workspace_docu_file;

  void setSelectedDocuPreview( int newDocuId, String newWorkspaceDocuFile){
    docuId = newDocuId;
    workspace_docu_file = newWorkspaceDocuFile;
    notifyListeners();
    print(docuId);
    print(workspace_docu_file);
  }
}

class SelectedAdminDetailsState extends ChangeNotifier{
  String? email;
  int? adminId;
  String? admin_logo;
  String? admin_overview;
  String? office_name;
  int? userId;

  void setSelectedAdminDetailsState(String newEmail, int newAdminID, String newAdminLogo, String newAdminOverview, String newOfficeName, int newUserId){
    email = newEmail;
    adminId = newAdminID;
    admin_logo = newAdminLogo;
    admin_overview = newAdminOverview;
    office_name = newOfficeName;
    userId = newUserId;

    notifyListeners();

    print(email);
    print(adminId);
    print(admin_logo);
    print(admin_overview);
    print(office_name);
    print(userId);
  }
}

class StaffUserData extends ChangeNotifier{
  String? user_id;
  String? first_name;
  String? middle_name;
  String? last_name;
  String? staff_data_id;
  String? email;
  String? role;
  String? user_image_profile;
  String? admin_office;
  String? staff_position;
  String? employee_id_image;
  String? user_selfie_image;


  void setStaffUserData(String newUserID, String newFirstName,String newMiddleName,String newLastName,String newStaffDataID,String newEmail,String newRole,String newUserImageProfile,newAdminOffice, String newStaffPosition, String newEmpIDImg, String UserSelfieImg){
    user_id = newUserID;
    first_name = newFirstName;
    middle_name = newMiddleName;
    last_name = newLastName;
    staff_data_id = newStaffDataID;
    email = newEmail;
    role = newRole;
    user_image_profile = newUserImageProfile;
    admin_office = newAdminOffice;
    staff_position = newStaffPosition;
    employee_id_image = newEmpIDImg;
    user_selfie_image = UserSelfieImg;

    notifyListeners();

    print(user_id);
    print(first_name);
    print(middle_name);
    print(last_name);
    print(staff_data_id);
    print(email);
    print(role);
    print(user_image_profile);
    print(staff_position);
    print(employee_id_image);
    print(user_selfie_image);
  }
}

class GuestDetailState extends ChangeNotifier{
  String? email;
  String? role;
  // String? employee_id_number;
  String? first_name;
  String? middle_name;
  String? last_name;
  String? guest_admin_office;

  void setGuestDetailState(String newEmail, String newRole, String newFirstName, String newMiddleName, String newLastName, String newGuestAdminOffice){
    email = newEmail;
    role = newRole;
    // employee_id_number = newEmployeeIDNumber;
    first_name = newFirstName;
    middle_name = newMiddleName;
    last_name = newLastName;
    guest_admin_office = newGuestAdminOffice;

    print(email);
    print(role);
    // print(employee_id_number);
    print(first_name);
    print(middle_name);
    print(last_name);
    print(guest_admin_office);

    notifyListeners();
  }
}

class AdminProfileState extends ChangeNotifier {
  String? email;
  String? password;
  String? admin_logo;
  String? admin_overview;
  String? admin_id;
  String? office_name;
  int? user_id;

  void setAdminProfileDetails(String newEmail, String newPassword, String newAdminLogo, String newAdminOverview,String newAdminId ,String newOfficeName, int newUserId){
    email = newEmail;
    password = newPassword;
    admin_logo = newAdminLogo;
    admin_overview = newAdminOverview;
    admin_id = newAdminId;
    office_name = newOfficeName;
    user_id = newUserId;

    notifyListeners();

    print(email);
    print(password);
    print(admin_logo);
    print(admin_overview);
    print(admin_id);
    print(office_name);
    print(user_id);
  }
}

class SuperadminProfileState extends ChangeNotifier {
  int? userId;
  String? email;
  String? superadmin_name;
  String? superadmin_image;
  String? password;
  int? user_id;

  void setSuperAdminProfileDetails(int? newUserID, String? newEmail, String? newSuperadminName, String? newSuperadminImage, String? newPassword, int? newUserId) {
    userId = newUserID;
    email = newEmail;
    superadmin_name = newSuperadminName;
    superadmin_image = newSuperadminImage;
    password = newPassword;
    user_id = newUserId;

    notifyListeners();

    print(email);
    print(superadmin_name);
    print(password);
    print(superadmin_image);
    print(user_id);
  }
}


class OutgoingDocuCount extends ChangeNotifier{
  int? count;

  void setOutgoingDocuCount(int newCount){
    count = newCount;
    notifyListeners();
    print(count);
  }
}

class ClerkUsernameState extends ChangeNotifier{
  String? first_name;
  String? middle_name;
  String? last_name;

  void setClerkUsernameState(String newFirstName, String newMiddleName, String newLastName){
    first_name = newFirstName;
    middle_name = newMiddleName;
    last_name = newLastName;
    notifyListeners();
    print(first_name);
    print(middle_name);
    print(last_name);
  }
}

class DocumentCountForWorkspace extends ChangeNotifier{
  int? docuCount;

  void setDocumentCountForWorkspace(int newDocuCount){
    docuCount = newDocuCount;
    notifyListeners();
    print(docuCount);
  }
}

class OverallWorkspaceDocuDetailsCountState extends ChangeNotifier{
  int? countOVWorkspaceDocu;

  void setOverallWorkspaceDocuDetailsCount(int newCountOVWorkspaceDocu){
    countOVWorkspaceDocu = newCountOVWorkspaceDocu;
    notifyListeners();
    print(countOVWorkspaceDocu);
  }
}

class ClerkDetailState extends ChangeNotifier{
  int? userId;
  String? email;
  String? first_name;
  String? last_name;
  String? user_image_profile;
  String? admin_logo;
  String? office_name;
  String? staff_positon;

  void ClerkDetailsCleanup(){
    userId = 0;
    email = "";
    first_name = "";
    last_name = "";
    user_image_profile = "";
    admin_logo = "";
    office_name = "";
    staff_positon = "";

    notifyListeners();
  }

  void setClerkDetail(int newUserId, String newEmail, String newFirstName, String newLastName, String newUserImageProfile, String newAdminLogo,String newAdminOffice ,String newStaffPosition){
    userId = newUserId;
    email = newEmail;
    first_name = newFirstName;
    last_name = newLastName;
    user_image_profile = newUserImageProfile;
    admin_logo = newAdminLogo;
    office_name = newAdminOffice;
    staff_positon = newStaffPosition;

    notifyListeners();

    print(userId);
    print(email);
    print(first_name);
    print(last_name);
    print(user_image_profile);
    print(admin_logo);
    print(office_name);
    print(staff_positon);

  }
}



class ScannedRecordCountState extends ChangeNotifier{
  int? count;

  void setScannedRecordCount(int newCount){
    count = newCount;
    notifyListeners();
    print(count);
  }
}

class ForgetPasswordState extends ChangeNotifier{
  String? email;

  void setForgetPassword(String newEmail){
    email = newEmail;
    notifyListeners();
    print(email);
  }

}

class PDFDocuFilePreviewState extends ChangeNotifier{
  String? modified_docu_file;

  void setPDFDocuFilePreview(String newModifiedDocuFile){
    modified_docu_file = newModifiedDocuFile;
    notifyListeners();
    print(modified_docu_file);
  }
}

class SelectedScannedDocu extends ChangeNotifier{
  String? memorandum_number;
  String? docu_type;
  String? docu_title;
  String? docu_dateNtime_created;
  String? docu_sender;
  String? docu_status;

  void setSelectedScannedDocu(String newMemorandumOrder, String newDocuType, String newDocuTitle, String newDocuDateNTimeCreated, String newDocuSender, String newDocuStatus){
    memorandum_number = newMemorandumOrder;
    docu_type = newDocuType;
    docu_title = newDocuTitle;
    docu_dateNtime_created = newDocuDateNTimeCreated;
    docu_sender = newDocuSender;
    docu_status = newDocuStatus;

    notifyListeners();

    print(memorandum_number);
    print(docu_type);
    print(docu_title);
    print(docu_dateNtime_created);
    print(docu_sender);
    print(docu_status);

  }
}

class ReceiverData extends ChangeNotifier{
  List<ReceiversInformation> _receiversInformationList = [];
  List<ReceiversInformation> get receiversInformationList => _receiversInformationList;

  void setReceiverData(List<ReceiversInformation> newReceiverInfoList){
    _receiversInformationList = newReceiverInfoList;

    notifyListeners();
    print(_receiversInformationList);
  }
}


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              Expanded(
                child: Container(
                  color: primaryColor,
                  child: Splash(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isWeb (BuildContext context) =>
      MediaQuery.of(context).size.width > 600;

  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 5500));
     Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SigningPage(),),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: primaryColor,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right:20),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/DocuTrack(White).png',
                    height: size200_60(context),
                    width: size200_60(context),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text (
                        'DocuTrack',
                        style: GoogleFonts.russoOne(
                          color: Colors.white,
                          fontSize: size80_28(context),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),

                      Text (
                        'Document Tracking and Management System',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: size19_06(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SigningPage extends StatefulWidget {
  const SigningPage({Key? key}) : super(key: key);

  @override
  State<SigningPage> createState() => _SigningPageState();
}

class _SigningPageState extends State<SigningPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSuperMobile (BuildContext context) =>
      MediaQuery.of(context).size.width <= 270;

  @override
  Widget build(BuildContext context) {
    MyappState appState = context.watch<MyappState>();

    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 60.0),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: isSuperMobile(context) ? 90 : 100),
                  child: FittedBox(
                    child: Image.asset(
                      'assets/DocuTrack(White).png',
                      height: 75,
                      width: 75,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: FittedBox(
                    child: Column(
                      children: [
                        Text(
                          'DocuTrack',
                          style: GoogleFonts.russoOne(
                            color: secondaryColor,
                            fontSize: 43,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                        Text(
                          'Document Tracking Management System',
                          style: GoogleFonts.poppins(
                            color: secondaryColor,
                            fontSize: 10.8,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 90),
                FittedBox(
                  child: Text(
                    'Welcome!',
                    style: GoogleFonts.poppins(
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 70,
                    ),
                  ),
                ),
                const SizedBox(height: 90.0),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: Text('Sign In',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignIn(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(5.0),
                        minimumSize: Size(380, 55),
                        primary: primaryColor,
                        onPrimary: secondaryColor,
                        elevation: 3,
                        shadowColor: Colors.transparent,
                        side: BorderSide(color: secondaryColor, width: 2),
                        shape: StadiumBorder()
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: Text('Sign Up',
                      style: GoogleFonts.poppins(
                      fontSize: 15,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUp(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(10.0),
                        minimumSize: Size(380, 55),
                        primary: Colors.white,
                        onPrimary: primaryColor,
                        elevation: 3,
                        shadowColor: Colors.transparent,
                        shape: StadiumBorder()
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                TextButton(
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GuestForm(),
                        ),
                      );
                    },
                    child: Text(
                      'Continue as Guest',
                      style: GoogleFonts.poppins(
                        color: secondaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: secondaryColor,
                      ),
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}