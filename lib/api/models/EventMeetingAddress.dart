import 'Friend.dart';

class EventMeetingAddress {
  final String eventName;
  final String id;
  final String time;
  final double lat;
  final double long;
  final String description;
  final String address;

  const EventMeetingAddress(this.id, this.lat, this.long, this.eventName,
      this.time, this.description, this.address);
}
