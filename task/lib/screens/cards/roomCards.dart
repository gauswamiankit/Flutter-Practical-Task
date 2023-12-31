import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:task/screens/cards/memberAddDialog.dart';
import 'package:task/screens/controller/roomBookingController.dart';
import 'package:task/screens/model/roomModel.dart';
import 'package:task/utils/mediaQuery.dart';

roomCard(List<RoomModel> roomModels, RoomBookingController roomBookingController) {
  return ListView.builder(
    itemCount: roomModels.length,
    shrinkWrap: true,
    physics: const ClampingScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      RoomModel roomModel = roomModels[index];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Room ${index + 1}",
                style: const TextStyle(fontSize: 18.0),
              ),
              GestureDetector(
                  onTap: () {
                    roomBookingController.deleteRoom("${roomModel.roomId}");
                  },
                  child: const Icon(Icons.delete)),
            ],
          ).paddingAll(18.0),
          Container(
            color: Colors.grey.shade200,
            child: Row(
              children: [
                Checkbox.adaptive(
                  value: roomModel.pet ?? false,
                  onChanged: (value) {},
                ),
                const Text(
                  "Do you have pets ?",
                  style: TextStyle(fontSize: 15.0),
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.Height * 0.03,
          ),
          Container(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            color: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Members",
                  style: TextStyle(fontSize: 15.0),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var childCount =
                        roomModel.members?.where((member) => member.child == true).length ?? 0;
                    MemberAddDialogResult? result;
                    roomModel.members!.length >= 3
                        ? {}
                        : {
                            result = await showMemberAddDialog(context, childCount),
                            result == null
                                ? {}
                                : roomBookingController.addMemberToRoom(
                                    "${roomModel.roomId}", result.member)
                          };
                  },
                  child: Row(
                    children: [
                      roomModel.members!.length >= 3
                          ? const Text("Room is Full")
                          : const Text("Add").paddingOnly(right: 12.0),
                      roomModel.members!.length >= 3 ? const Text("") : const Icon(Icons.add)
                    ],
                  ),
                ),
              ],
            ),
          ),

          // MEMBERS
          ListView.builder(
            itemCount: roomModel.members?.length ?? 0,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (BuildContext context, int i) {
              Members member = roomModel.members![i];

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Member ${i + 1}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                          onTap: () {
                            roomBookingController.deleteMemberFromRoom(
                                "${roomModel.roomId}", "${member.memberId}");
                          },
                          child: const Icon(Icons.delete)),
                    ],
                  ).paddingAll(18.0),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Text("${member.firstName} "),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.Width * 0.03,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Text("${member.lastName} "),
                        ),
                      ),
                    ],
                  ).paddingOnly(right: 18.0, left: 18.0),
                  Row(
                    children: [
                      const Text(
                        "Child",
                        style: TextStyle(fontSize: 15.0),
                      ),
                      Checkbox.adaptive(
                        value: member.child ?? false,
                        onChanged: (value) {},
                      ),
                    ],
                  ).paddingOnly(right: 18.0, left: 18.0),
                  Row(
                    children: [
                      const Text(
                        "Date of Birth",
                        style: TextStyle(fontSize: 15.0),
                      ),
                      SizedBox(
                        width: SizeConfig.Width * 0.03,
                      ),
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          children: [
                            Text("${member.dateOfBirth} "),
                            const Icon(Icons.calendar_month).paddingOnly(left: 12.0),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.Width * 0.18,
                      ),
                    ],
                  ).paddingOnly(right: 18.0, left: 18.0),
                  Container(
                    height: 2,
                    margin: const EdgeInsets.only(top: 18.0),
                    color: Colors.grey.shade300,
                  )
                ],
              );
            },
          ),
          Container(
            height: 3,
            color: Colors.grey,
          )
        ],
      );
    },
  );
}
