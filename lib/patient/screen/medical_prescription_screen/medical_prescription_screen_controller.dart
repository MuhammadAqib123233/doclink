import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:doclink/utils/const_res.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:doclink/patient/common/custom_ui.dart';
import 'package:doclink/patient/generated/l10n.dart';
import 'package:doclink/patient/model/appointment/fetch_appointment.dart';
import 'package:doclink/patient/model/custom/categories.dart';
import 'package:doclink/patient/model/user/registration.dart';
import 'package:doclink/utils/extention.dart';
import 'package:doclink/utils/update_res.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:http/http.dart' as http;

class MedicalPrescriptionScreenController extends GetxController {
  PrescriptionMedical? medicalPrescription;

  String? medicine = Get.arguments[0];
  AppointmentData? appointmentData = Get.arguments[1];
  RegistrationData? user = Get.arguments[2];

  @override
  void onInit() {
    decodeMedicine();
    super.onInit();
  }

  void decodeMedicine() {
    medicalPrescription = medicine == null
        ? PrescriptionMedical([], '')
        : PrescriptionMedical.fromJson(jsonDecode(medicine!));
  }

  void createPdf() async {
    CustomUi.loader();

    ///Creates a new PDF document
    PdfDocument document = PdfDocument();

    ///Adds page settings
    document.pageSettings.orientation = PdfPageOrientation.portrait;
    document.pageSettings.margins.all = 10;
    document.pageSettings.size = const Size(210, 297);

    ///Adds a page to the document
    PdfPage page = document.pages.add();
    PdfGraphics graphics = page.graphics;

    /// UI Section
    PdfFont? font5Bold =
        PdfStandardFont(PdfFontFamily.courier, 5, style: PdfFontStyle.bold);
    PdfFont? font3Regular =
        PdfStandardFont(PdfFontFamily.courier, 3, style: PdfFontStyle.regular);
    PdfSolidBrush havelockBlue = PdfSolidBrush(PdfColor(67, 120, 200));

    /// Starting pdf ui
    String appointmentNumber =
        '${PS.current.id} : ${appointmentData?.appointmentNumber ?? PS.current.doctorIo}';
    Size appointmentSize = font5Bold.measureString(appointmentNumber);

    ///Creates a text element to add the invoice number
    PdfTextElement element =
        PdfTextElement(text: appointmentNumber, font: font5Bold);
    element.brush = havelockBlue;

    ///Draws the heading on the page
    PdfLayoutResult result = element.draw(
        page: page,
        bounds:
            Offset(graphics.clientSize.width - appointmentSize.width - 0, 10) &
                Size(appointmentSize.width + 2, 20))!;
    String currentDate =
        '${PS.current.date} : ${(appointmentData?.createdAt ?? DateTime.now().millisecondsSinceEpoch.toString()).dateParse(ddMMMYyyy)}';
    Size textSize = font5Bold.measureString(currentDate);
    graphics.drawString(currentDate, font5Bold,
        brush: element.brush,
        bounds: Offset(graphics.clientSize.width - textSize.width - 0,
                result.bounds.bottom) &
            Size(textSize.width + 2, 20));
    element =
        PdfTextElement(text: '${PS.current.doctorDetail} ', font: font5Bold);
    element.brush = havelockBlue;
    result = resultBottom(
        element: element, page: page, result: result, bottomValue: 10);
    element = PdfTextElement(
        text: '${appointmentData?.doctor?.name ?? PS.current.unKnown} ',
        font: font3Regular);
    result = resultBottom(element: element, page: page, result: result);
    element = PdfTextElement(
        text: '${appointmentData?.doctor?.designation}', font: font3Regular);
    result = resultBottom(element: element, page: page, result: result);
    element = PdfTextElement(
        text: '${appointmentData?.doctor?.degrees}', font: font3Regular);
    result = resultBottom(element: element, page: page, result: result);
    element =
        PdfTextElement(text: '${PS.current.patientDetail} ', font: font5Bold);
    element.brush = havelockBlue;
    result = resultBottom(
        element: element, page: page, result: result, bottomValue: 10);
    element = PdfTextElement(
        text: user?.fullname ?? PS.current.unKnown, font: font3Regular);
    result = resultBottom(element: element, page: page, result: result);
    element = PdfTextElement(
        text: user?.gender == 0 ? PS.current.female : PS.current.male,
        font: font3Regular);
    result = resultBottom(element: element, page: page, result: result);
    element = PdfTextElement(
        text:
            '${PS.current.bod} : ${(user?.dob ?? createdDate).dateParse(ddMMMYyyy)}',
        font: font3Regular);
    result = resultBottom(element: element, page: page, result: result);

    ///Initialize PdfGrid for drawing the table
    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 4);
    grid.headers.add(1);
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = PS.current.medicalName;
    header.cells[1].value = PS.current.doseTime;
    header.cells[2].value = PS.current.doses;
    header.cells[3].value = PS.current.quantity;

    ///Creates the header style
    PdfGridCellStyle headerStyle = PdfGridCellStyle();
    headerStyle.borders.all = PdfPen(
      PdfColor(255, 255, 255),
      width: 0,
    );
    headerStyle.cellPadding = PdfPaddings(bottom: 3, right: 3, left: 3, top: 3);
    headerStyle.backgroundBrush = havelockBlue;
    headerStyle.textBrush = PdfBrushes.white;
    headerStyle.font = font5Bold;
    for (int i = 0; i < header.cells.count; i++) {
      header.cells[i].stringFormat = PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle);

      header.cells[i].style = headerStyle;
    }
    PdfGridRow? row2;

    /// medicine
    medicalPrescription?.getMedicines().forEach((element) {
      row2 = grid.rows.add();
      for (int j = 0; j < header.cells.count; j++) {
        row2?.cells[j].value = element[j];
      }
    });

    ///Adds cell customizations
    for (int i = 0; i < grid.rows.count; i++) {
      PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        PdfGridCellStyle cellStyle = PdfGridCellStyle();
        cellStyle.borders.all = PdfPen(
          PdfColor(255, 255, 255),
          width: 0,
        );
        cellStyle.borders.bottom = PdfPen(PdfColor(217, 217, 217), width: 0);
        cellStyle.cellPadding =
            PdfPaddings(bottom: 3, right: 3, left: 3, top: 3);
        cellStyle.font = font3Regular;
        cellStyle.textBrush = PdfSolidBrush(PdfColor(131, 130, 136));
        if (i % 2 == 0) {
          cellStyle.backgroundBrush = PdfSolidBrush(PdfColor(244, 244, 244));
        } else {
          cellStyle.backgroundBrush = PdfSolidBrush(PdfColor(248, 248, 248));
        }
        row.cells[j].style = cellStyle;
        if (j == 0 || j == 1) {
          row.cells[j].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.left,
              lineAlignment: PdfVerticalAlignment.middle);
        } else {
          row.cells[j].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.center,
              lineAlignment: PdfVerticalAlignment.middle);
        }
      }
    }
    PdfLayoutFormat layoutFormat =
        PdfLayoutFormat(layoutType: PdfLayoutType.paginate);

    ///Set the grid style
    grid.style = PdfGridStyle(
        cellPadding: PdfPaddings(left: 5, right: 0, top: 5, bottom: 0),
        backgroundBrush: PdfBrushes.white,
        textBrush: PdfBrushes.black,
        font: font3Regular);
    //
    ///Draw the grid
    result = grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, result.bounds.bottom + 2, 0, 0),
        format: layoutFormat)!;

    ///Creates text elements to add the address and draw it to the page
    if (medicalPrescription!.notes!.isNotEmpty ||
        medicalPrescription?.notes == null) {
      element = PdfTextElement(text: '${PS.current.notes} : ', font: font5Bold);
      element.brush = havelockBlue;
      result = resultBottom(
          element: element, page: page, result: result, bottomValue: 10);
      element = PdfTextElement(
          text: medicalPrescription?.notes ?? '', font: font3Regular);
      result = resultBottom(element: element, page: page, result: result);
    }
    Size doctorTitleSize = font5Bold.measureString("Signature");
    var json = jsonDecode(appointmentData!.prescription!.medicine.toString());
    // Load the signature image
  if(json['signature'] != null){
    final Uint8List signatureImageBytes = await loadSignatureImageBytes('${ConstRes.itemBaseURL}${json['signature']}');
  final PdfBitmap signatureImage = PdfBitmap(signatureImageBytes);

  // Draw the signature image above the "Signature" text
  graphics.drawImage(
    signatureImage,
    Rect.fromLTWH(
      graphics.clientSize.width - doctorTitleSize.width - 5,
      result.bounds.bottom,
      doctorTitleSize.width + 2,
      20,
    ),
  );
  }
    element = PdfTextElement(text: "Signature", font: font5Bold);
    element.brush = PdfBrushes.black;
    element.draw(
        page: page,
        bounds: Offset(graphics.clientSize.width - doctorTitleSize.width - 5,
                result.bounds.bottom + 20) &
            Size(doctorTitleSize.width + 2, 20))!;
    List<int> bytes = document.saveSync();
    document.dispose();
    savedFile(bytes);
  }

  Future<Uint8List> loadSignatureImageBytes(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load signature image');
  }
}
  void savedFile(List<int> bytes) async {
    ///Get external storage directory
    final directory = await getApplicationSupportDirectory();

    ///Get directory path
    final path = directory.path;

    ///Create an empty file to write PDF data
    File file = File(
        '$path/${appointmentData?.appointmentNumber ?? PS.current.doctorIo}$pdf');

    ///Write PDF data
    await file.writeAsBytes(bytes, flush: true);

    /// loader remove
    Get.back();

    ///Open the PDF document in mobile
    OpenFilex.open(
        '$path/${appointmentData?.appointmentNumber ?? PS.current.doctorIo}$pdf');
  }

  PdfLayoutResult resultBottom(
      {required PdfTextElement element,
      required PdfPage page,
      required PdfLayoutResult result,
      double bottomValue = 2}) {
    return element.draw(
        page: page,
        bounds: Rect.fromLTWH(0, result.bounds.bottom + bottomValue, 0, 0))!;
  }
}
