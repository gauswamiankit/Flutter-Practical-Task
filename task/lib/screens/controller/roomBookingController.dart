import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:task/screens/model/roomModel.dart';
import 'package:uuid/uuid.dart' as uID;

class RoomBookingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<RoomModel> roomModel = [];
  bool petLimitreached = false;
  @override
  void onInit() {
    // TODO: implement onInit
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
        members: [
          // Members(
          //   memberId: uID.Uuid().v4(),
          //   firstName: "ankt",
          //   lastName: "giri",
          //   dateOfBirth: "02 05 2003",
          //   child: false,
          // ),
        ],
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
      existingRoomData.members!.add(member
          // Members(
          //   memberId: uID.Uuid().v4(),
          //   firstName: "new2",
          //   lastName: "member2",
          //   dateOfBirth: "03 15 2003",
          //   child: false,
          // ),
          );
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
}
