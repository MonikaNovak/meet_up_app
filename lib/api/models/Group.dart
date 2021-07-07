import 'EventMeeting.dart';
import 'Friend.dart';

class Group {
  final String groupName;
  final String groupImageUrl;
  final String id;
  final String adminUsername;
/*  final List<Friend> members;*/
  final List<EventMeeting> events;

  const Group(
      this.adminUsername,
      this.groupImageUrl,
      this.groupName,
      this.id,
      /*this.members,*/
      this.events);

  Group.fromJson(Map<String, dynamic> json)
      : groupName = json['groupName'],
        groupImageUrl = json['groupImageUrl'],
        id = json['id'],
        adminUsername = json['adminUsername'],
        /*members = (json['friendslist'] as List<dynamic>)
            .map((e) => Friend.fromJson(e))
            .toList(),*/
        events = (json['eventslist'] as List<dynamic>)
            .map((e) => EventMeeting.fromJson(e))
            .toList();
}
