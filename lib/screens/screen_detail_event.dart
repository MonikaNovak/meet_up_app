import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/EventMeeting.dart';
import 'package:meet_up_vor_2/api/models/Group.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

/// from database:
/// event:
/// info - name, time, latitude&longitude
/// list of participants
/// group the event is linked to
/// action join event (add event to user's event list)

class EventDetail extends StatefulWidget {
  late final EventMeeting event;
  late final Group linkedGroup;
  late final User userPassed;

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  Set<Marker> _markers = {};
  String address = '';

  void _onMapCreated(GoogleMapController controller) async {
    _markers.add(
      Marker(
        markerId: MarkerId('id-1'),
        position: LatLng(47.23962176969944, 9.597157658181816),
        infoWindow: InfoWindow(
          title: widget.event.eventName,
          snippet: widget.event.time,
        ),
      ),
    );
    _streamController.sink.add(_markers);

    List<Placemark> _placemarks =
        await placemarkFromCoordinates(47.23962176969944, 9.597157658181816);
    Placemark place = _placemarks[0];
    print(place.toString());
    address = '${place.street}, ${place.locality}, ${place.postalCode}';

    // TODO update location
  }

  void _getAddressFromLongLat() {}

  final StreamController<Set<Marker>> _streamController = StreamController();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as List;
    widget.event = arguments[0] as EventMeeting;
    widget.linkedGroup = arguments[1] as Group;
    widget.userPassed = arguments[2] as User;

    return Scaffold(
/*      appBar: MyAppBar(),*/
      appBar: AppBar(
        title: Text(
          'Event details',
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.event.eventName,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('Hangout time:'),
                    Text(
                      widget.event.time,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('Location:'),
                    StreamBuilder<Set<Marker>>(
                        stream: _streamController.stream,
                        initialData: _markers,
                        builder: (context, snapshot) {
                          return Text(
                            address,
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          );
                        }),
                    Text(
                      address,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        // TODO show list of participants
                      },
                      child: Text('Participants'),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO add event to your event list
                      },
                      child: Text(
                        'Join event',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ListTile(
              tileColor: Colors.grey.shade300,
              contentPadding: EdgeInsets.all(10.0),
              leading: CircleAvatar(
                radius: 30.0,
                backgroundImage:
                    new NetworkImage(widget.linkedGroup.groupImageUrl),
              ),
              title: Text(
                widget.linkedGroup.groupName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
              ),
              trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.chat),
              ),
              onTap: () {
                Navigator.pushNamed(context, 'group_detail',
                    arguments: [widget.linkedGroup, widget.userPassed]);
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            StreamBuilder<Set<Marker>>(
                stream: _streamController.stream,
                initialData: _markers,
                builder: (context, snapshot) {
                  return Expanded(
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      markers: _markers,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(47.23962176969944, 9.597157658181816),
                          zoom: 15),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
