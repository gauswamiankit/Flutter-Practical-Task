import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/screens/cards/roomAddDialog.dart';
import 'package:task/screens/cards/roomCards.dart';
import 'package:task/screens/controller/roomBookingController.dart';
import 'package:task/utils/mediaQuery.dart';

class RoomBookingScreen extends StatelessWidget {
  const RoomBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RoomBookingController roomBookingController = Get.put(
      RoomBookingController(),
    );
    SizeConfig().init(context);

    return GetBuilder<RoomBookingController>(builder: (roomBookingController) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Room booking'),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  RoomAddDialogResult? result =
                      await showRoomAddDialog(context, roomBookingController.petLimitreached);
                  result != null
                      ? {
                          if (result.confirmed == true)
                            {roomBookingController.addRoom(result.petValue)}
                        }
                      : {};
                },
                child: Row(
                  children: [
                    const Text("Add Room").paddingOnly(right: 12.0),
                    const Icon(Icons.add)
                  ],
                )).paddingOnly(right: 18.0)
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              roomCard(roomBookingController.roomModel, roomBookingController),
              ElevatedButton(
                      onPressed: () {
                        roomBookingController.createPDF();
                        // roomBookingController.fetchRooms();
                      },
                      child: const Text("SAVE"))
                  .paddingAll(18.0),
            ],
          ),
        ),
      );
    });
  }
}
