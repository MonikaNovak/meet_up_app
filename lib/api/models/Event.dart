import 'Friend.dart';

class Event {
  final String eventName;
  final String id;
  final String time;
  final String location;
/*  final List<Friend> members;*/

  const Event(
      this.id,
/*      this.members, */
      this.location,
      this.eventName,
      this.time);

  Event.fromJson(Map<String, dynamic> json)
      : eventName = json['eventName'],
        time = json['time'],
        id = json['id'],
        location = json['location']
/*  ,
        members = (json['friendslist'] as List<dynamic>)
            .map((e) => Friend.fromJson(e))
            .toList()*/
  ;
}
