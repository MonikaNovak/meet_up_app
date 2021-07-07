import 'Friend.dart';

class EventMeeting {
  final String eventName;
  final String id;
  final String time;
  final double lat;
  final double long;
/*  final List<Friend> members;*/

  const EventMeeting(
      this.id,
/*      this.members, */
      this.lat,
      this.long,
      this.eventName,
      this.time);

  EventMeeting.fromJson(Map<String, dynamic> json)
      : eventName = json['eventName'],
        time = json['time'],
        id = json['id'],
        lat = json['lat'],
        long = json['long']
/*  ,
        members = (json['friendslist'] as List<dynamic>)
            .map((e) => Friend.fromJson(e))
            .toList()*/
  ;
}
