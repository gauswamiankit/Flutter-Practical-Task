class RoomModel {
  String? roomId;

  List<Members>? members;
  bool? pet;

  RoomModel({this.roomId, this.members, this.pet});

  RoomModel.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(new Members.fromJson(v));
      });
    }
    pet = json['pet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomId'] = this.roomId;

    if (this.members != null) {
      data['members'] = this.members!.map((v) => v.toJson()).toList();
    }
    data['pet'] = this.pet;
    return data;
  }
}

class Members {
  String? memberId;
  String? lastName;
  String? firstName;
  String? dateOfBirth;
  bool? child;

  Members({this.memberId, this.lastName, this.firstName, this.dateOfBirth, this.child});

  Members.fromJson(Map<String, dynamic> json) {
    memberId = json['memberId']; 
    lastName = json['lastName'];
    firstName = json['firstName'];
    dateOfBirth = json['dateOfBirth'];
    child = json['child'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memberId'] = this.memberId;
    data['lastName'] = this.lastName;
    data['firstName'] = this.firstName;
    data['dateOfBirth'] = this.dateOfBirth;
    data['child'] = this.child;
    return data;
  }
}
 