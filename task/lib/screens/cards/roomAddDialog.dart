import 'package:flutter/material.dart';
import 'package:task/utils/mediaQuery.dart';

class RoomAddDialogResult {
  bool petValue;
  bool confirmed;

  RoomAddDialogResult({required this.petValue, required this.confirmed});
}

Future<RoomAddDialogResult?> showRoomAddDialog(BuildContext context, bool petLimitReached) async {
  bool petValue = false;

  return showDialog<RoomAddDialogResult>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Add Room"),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: SizeConfig.Height * 0.1,
              child: Column(
                children: [
                  Row(
                    children: [
                      Checkbox.adaptive(
                        value: petLimitReached == true ? false : petValue,
                        onChanged: (value) {
                          setState(() {
                            petLimitReached != true ? {petValue = value ?? false} : {};
                          });
                        },
                      ),
                      const Text(
                        "Do you have pets ?",
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ],
                  ),
                  Text(
                    petLimitReached == true ? "U have Reached pet limit" : "",
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(RoomAddDialogResult(petValue: petValue, confirmed: false));
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(RoomAddDialogResult(petValue: petValue, confirmed: true));
            },
            child: const Text("Add Room"),
          ),
        ],
      );
    },
  );
}
