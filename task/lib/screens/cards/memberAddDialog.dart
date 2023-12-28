import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task/screens/model/roomModel.dart';
import 'package:task/utils/mediaQuery.dart';
import 'package:uuid/uuid.dart' as uID;

class MemberAddDialogResult {
  Members member;
  MemberAddDialogResult({required this.member});
}

Future<MemberAddDialogResult?> showMemberAddDialog(BuildContext context, childLength) async {
  //
  bool child = false;
  var childAge;
  TextEditingController firstNameText = TextEditingController();
  TextEditingController lastNameText = TextEditingController();
  TextEditingController dobText = TextEditingController();

  return showDialog<MemberAddDialogResult>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Add Member"),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: SizeConfig.Height * 0.24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: firstNameText,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(12.0),
                            labelText: "firstName",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.Width * 0.03,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: lastNameText,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(12.0),
                            labelText: "lastName",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  childLength >= 2
                      ? Text("1 room has max 2 children U have added 2 child now u can not add more child",
                              style: TextStyle(color: Colors.red))
                          .paddingOnly(top: 12.0, bottom: 12.0)
                      : Row(
                          children: [
                            Text(
                              "Child",
                              style: TextStyle(fontSize: 15.0),
                            ),
                            Checkbox.adaptive(
                              value: child,
                              onChanged: (value) {
                                child = value!;
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                  Row(
                    children: [
                      Text(
                        "Date of Birth ",
                        style: TextStyle(fontSize: 15.0),
                      ),
                      SizedBox(
                        width: SizeConfig.Width * 0.03,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null) {
                            dobText.text = DateFormat('dd MM yyyy').format(picked).toString();

                            setState(() {});
                          }
                          DateTime dobDate = DateFormat('dd MM yyyy').parse(dobText.text);
                          DateTime currentDate = DateTime.now();
                          childAge = currentDate.year - dobDate.year;
                          // if (age <= 3) {
                          //   await Get.rawSnackbar(
                          //       title: "The child's age should not be more than 3 years...",
                          //       snackPosition: SnackPosition.BOTTOM);
                          // }
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            children: [
                              Text(dobText.text != "" ? dobText.text : "DD_MM_YYYY"),
                              Icon(Icons.calendar_month).paddingOnly(left: 6.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    child != true
                        ? ""
                        : childAge == null
                            ? ""
                            : childAge <= 3
                                ? "The child's age should not be more than 3 years.."
                                : "",
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(MemberAddDialogResult(
                member: Members(
                  memberId: uID.Uuid().v4(),
                  firstName: firstNameText.text,
                  lastName: lastNameText.text,
                  dateOfBirth: dobText.text,
                  child: child,
                ),
              ));
            },
            child: Text("Add Member"),
          ),
        ],
      );
    },
  );
}
