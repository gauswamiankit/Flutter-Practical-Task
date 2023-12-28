import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task/screens/cards/pdfScreen.dart';
import 'package:task/screens/model/roomModel.dart';
import 'package:pdf/widgets.dart' as pw;

class RoomBookingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<RoomModel> roomModel = [];
  bool petLimitreached = false;
  @override
  void onInit() {
    super.onInit();
    fetchRooms();
  }

  void fetchRooms() async {
    try {
      var snapshot = await _firestore.collection('rooms').get();
      roomModel = snapshot.docs.map((e) => RoomModel.fromJson(e.data())).toList();
      petLimitreached = roomModel.any((room) => room.pet == true);

      update();
    } catch (e) {
      print("Error fetch data: $e");
    }
  }

  void addRoom(pet) async {
    try {
      var roomDocumentReference = _firestore.collection('rooms').doc();
      RoomModel roomData = RoomModel(
        roomId: roomDocumentReference.id,
        members: [],
        pet: pet ?? false,
      );
      var roomDataJson = roomData.toJson();
      await roomDocumentReference.set(roomDataJson);
      fetchRooms();
      update();
    } catch (e) {
      print("Error adding data: $e");
    }
  }

  addMemberToRoom(String roomId, member) async {
    try {
      var roomDocumentReference = _firestore.collection('rooms').doc(roomId);
      var roomSnapshot = await roomDocumentReference.get();
      var existingRoomData = RoomModel.fromJson(roomSnapshot.data()!);
      existingRoomData.members!.add(member);
      await roomDocumentReference.update(existingRoomData.toJson());
      fetchRooms();
      update();
    } catch (e) {
      print("Error adding member to room: $e");
    }
  }

  void deleteMemberFromRoom(String roomId, String memberId) async {
    try {
      var roomDocumentReference = _firestore.collection('rooms').doc(roomId);
      var roomSnapshot = await roomDocumentReference.get();
      var existingRoomData = RoomModel.fromJson(roomSnapshot.data()!);
      int indexToDelete =
          existingRoomData.members!.indexWhere((member) => member.memberId == memberId);
      if (indexToDelete != -1) {
        existingRoomData.members!.removeAt(indexToDelete);
        await roomDocumentReference.update(existingRoomData.toJson());
        fetchRooms();
        update();
      } else {
        print("Member not found");
      }
    } catch (e) {
      print("Error deleting member from room: $e");
    }
  }

  void deleteRoom(String documentId) async {
    try {
      var documentReference = _firestore.collection('rooms').doc(documentId);
      await documentReference.delete();
      fetchRooms();
      update();
    } catch (error) {
      print("Error deleting data: $error");
    }
  }

  // Future<File>
   createPDF() async {
    generatePDF(roomModel);
    // final document = pw.Document();

    // document.addPage(
    //   pw.Page(
    //     build: (pw.Context context) =>
    //         pw.Container(height: 50, width: 50, color: PdfColors.deepOrange, child: pw.Text("da")),
    //   ),
    // );

    // var status = await Permission.storage.status;
    // if (!status.isGranted) {
    //   await Permission.storage.request();
    // }

    // final directory = await getExternalStorageDirectory();
    // final file = File('${directory!.path}/room_data.pdf');
    // await file.writeAsBytes(await document.save());
    // await OpenFile.open(file.path);

    // return file;
  }
}
