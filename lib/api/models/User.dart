import 'Friend.dart';

class User {
  final String name;
  final String displayName;
  final String email;
  final String profileImageUrl;
  final String statusMessage;
  final List<Friend> friends;
  final String id;

  // TODO remove status

  User(this.id, this.name, this.displayName, this.email, this.statusMessage,
      this.profileImageUrl, this.friends);

  User.fromJson(Map<String, dynamic> json)
      : id = json["_id"],
        name = json["userName"],
        displayName = json["displayName"],
        email = json["email"],
        statusMessage = json["statusMessage"],
        profileImageUrl = json["profilePicUrl"],
        friends = new List.empty(growable: true);
  /*friends = (json['friendslist'] as List<dynamic>)
            .map((e) => Friend.fromJson(e))
            .toList();*/

  User.fromJsonLocal(Map<String, dynamic> json)
      : name = json['name'],
        displayName = json['displayName'],
        email = json['email'],
        profileImageUrl = json['profilImage'],
        statusMessage = json['statusMessage'],
        id = json["_id"],
        friends = (json['friendslist'] as List<dynamic>)
            .map((e) => Friend.fromJsonLocal(e))
            .toList();
}
