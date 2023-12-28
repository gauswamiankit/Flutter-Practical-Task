import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../model/roomModel.dart';

Future<void> generatePDF(List<RoomModel> roomModels) async {
  final pdf = pw.Document();

  for (int index = 0; index < roomModels.length; index++) {
    RoomModel roomModel = roomModels[index];

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Room ${index + 1}",
                    style: pw.TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
              pw.Container(
                color: PdfColor.fromHex("#eeeeee"),
                child: pw.Row(
                  children: [
                    pw.Text(
                      "Do you have pets ? ${roomModel.pet}",
                      style: pw.TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(
                height: 30.0,
              ),
              pw.Container(
                padding: pw.EdgeInsets.only(left: 18.0, right: 18.0),
                color: PdfColor.fromHex("#eeeeee"),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Members",
                      style: pw.TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              pw.ListView.builder(
                itemCount: roomModel.members?.length ?? 0,
                itemBuilder: (pw.Context context, int i) {
                  Members member = roomModel.members![i];

                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            "Member ${i + 1}",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 1,
                            child: pw.Container(
                              padding: pw.EdgeInsets.all(14.0),
                              decoration: pw.BoxDecoration(
                                borderRadius: pw.BorderRadius.circular(6.0),
                                border: pw.Border.all(color: PdfColor.fromHex("#000000")),
                              ),
                              child: pw.Text("${member.firstName} "),
                            ),
                          ),
                          pw.SizedBox(
                            width: 30.0,
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Container(
                              padding: pw.EdgeInsets.all(14.0),
                              decoration: pw.BoxDecoration(
                                borderRadius: pw.BorderRadius.circular(6.0),
                                border: pw.Border.all(color: PdfColor.fromHex("#000000")),
                              ),
                              child: pw.Text("${member.lastName} "),
                            ),
                          ),
                        ],
                      ),
                      pw.Text(
                        "Child${member.child}",
                        style: pw.TextStyle(fontSize: 15.0),
                      ),
                      pw.Row(
                        children: [
                          pw.Text(
                            "Date of Birth",
                            style: pw.TextStyle(fontSize: 15.0),
                          ),
                          pw.SizedBox(
                            width: 30.0,
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(12.0),
                            decoration: pw.BoxDecoration(
                              borderRadius: pw.BorderRadius.circular(6.0),
                              border: pw.Border.all(color: PdfColor.fromHex("#000000")),
                            ),
                            child: pw.Row(
                              children: [
                                pw.Text("${member.dateOfBirth} "),
                              ],
                            ),
                          ),
                          pw.SizedBox(
                            width: 180.0,
                          ),
                        ],
                      ),
                      pw.Container(
                        height: 2,
                        margin: pw.EdgeInsets.only(top: 18.0),
                        color: PdfColor.fromHex("#cccccc"),
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
  final directory = await getExternalStorageDirectory();
  final file = File('${directory!.path}/room_data.pdf');
  await file.writeAsBytes(await pdf.save());
  await OpenFile.open(file.path);
}
