import 'Friend.dart';
import 'Group.dart';
import 'EventMeeting.dart';

class User {
  final String name;
  final String displayName;
  final String email;
  final String profilImage;
  final int status;
  final String statusMessage;
  final messages;
  final List<Friend> friends;
  final List<Group> groups;
  final List<EventMeeting> events;

  User(
      this.name,
      this.displayName,
      this.email,
      this.profilImage,
      this.status,
      this.statusMessage,
      this.messages,
      this.friends,
      this.groups,
      this.events);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        displayName = json['displayName'],
        email = json['email'],
        profilImage = json['profilImage'],
        status = json['status'],
        statusMessage = json['statusMessage'],
        messages = json['messages'],
        friends = (json['friendslist'] as List<dynamic>)
            .map((e) => Friend.fromJson(e))
            .toList(),
        groups = (json['groupslist'] as List<dynamic>)
            .map((e) => Group.fromJson(e))
            .toList(),
        events = (json['eventslist'] as List<dynamic>)
            .map((e) => EventMeeting.fromJson(e))
            .toList();
}
