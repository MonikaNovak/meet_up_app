import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/EventMeeting.dart';
import 'package:meet_up_vor_2/api/models/Group.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/api/models/UserGeneral.dart';
import 'package:meet_up_vor_2/api/providers/lists.dart';
import '../constants.dart';

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
  late final Token token;
  late final List<UserGeneral> participants;

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  Set<Marker> _markers = {};
  String _address = '';
  String eventJoined = '';

  void _onMapCreated(GoogleMapController controller) async {
    _markers.add(
      Marker(
        markerId: MarkerId('id-1'),
        // position: LatLng(47.23962176969944, 9.597157658181816),
        position: LatLng(widget.event.lat, widget.event.long),
        infoWindow: InfoWindow(
          title: widget.event.eventName,
          snippet: widget.event.time,
        ),
      ),
    );
    _streamController.sink.add(_markers);

    List<Placemark> _placemarks =
        // await placemarkFromCoordinates(47.23962176969944, 9.597157658181816);
        await placemarkFromCoordinates(widget.event.lat, widget.event.long);
    Placemark place = _placemarks[0];
    print(_placemarks.toString());
    print(place.toString());
    _address = '${place.street}, ${place.locality}, ${place.postalCode}';
    print('address: ' + _address);
    _streamControllerAddress.sink.add(_address);
  }

  void _hardcodeGroup() {
    widget.linkedGroup = Lists().hardcodeListOfGroups()[0];
  }

  void _hardcodeListParticipants() {
    widget.participants = Lists().hardcodeListOfUsers();
  }

  final StreamController<Set<Marker>> _streamController = StreamController();
  final StreamController<String> _streamControllerAddress = StreamController();
  final StreamController<String> _streamControllerJoinEvent =
      StreamController();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as List;
    widget.event = arguments[0] as EventMeeting;
    widget.userPassed = arguments[1] as User;
    widget.token = arguments[2] as Token;
    _hardcodeGroup();
    _hardcodeListParticipants();

    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: kMainPurple,
          title: Text(
            widget.event.eventName,
            style: TextStyle(fontSize: 20.0),
          )),
      body: SafeArea(
        minimum: EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'members_list', arguments: [
                  widget.token,
                  widget.userPassed,
                  widget.participants,
                  'Participants'
                ]);
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Show participants',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                    Icon(Icons.arrow_right, color: Colors.deepPurple),
                  ]),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*RichText(
                    text: TextSpan(
                        style: TextStyle(fontSize: 15.0, color: Colors.black),
                        children: <TextSpan>[
                      TextSpan(text: 'Time: '),
                      TextSpan(
                          text: widget.event.time,
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold))
                    ]),),*/
                Text(
                  widget.event.time,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                StreamBuilder<String>(
                    stream: _streamControllerAddress.stream,
                    initialData: _address,
                    builder: (context, snapshot) {
                      return Text(
                        _address,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      );
                    }),
                Text(
                  widget.event.description,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                SizedBox(
                  height: 10.0,
                ),
                StreamBuilder<String>(
                    stream: _streamControllerJoinEvent.stream,
                    initialData: eventJoined,
                    builder: (context, snapshot) {
                      if (eventJoined == '') {
                        return TextButton(
                          onPressed: () {
                            // TODO join event and rebuild
                            eventJoined = 'Event joined';
                            _streamControllerJoinEvent.sink.add(eventJoined);
                          },
                          child: Text(
                            'Join event',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: kFilledButtonStyle,
                        );
                      } else {
                        return Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.lightGreen,
                            ),
                            Text(
                              'Event joined.',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple.shade300,
                              ),
                            ),
                          ],
                        );
                      }
                    }),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
            ListTile(
              tileColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
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
                child: Icon(
                  Icons.chat,
                  color: Colors.deepPurple,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, 'group_detail', arguments: [
                  widget.token,
                  widget.userPassed,
                  widget.linkedGroup
                ]);
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
                          target: LatLng(widget.event.lat, widget.event.long),
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
