import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:meet_up_vor_2/api/models/EventMeeting.dart';
import 'package:meet_up_vor_2/api/models/Friend.dart';
import 'package:meet_up_vor_2/api/models/Group.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/api/models/UserGeneral.dart';
import 'package:meet_up_vor_2/api/providers/LoginProvider.dart';
import 'package:meet_up_vor_2/api/providers/lists.dart';
import 'package:meet_up_vor_2/constants.dart';
import 'package:meet_up_vor_2/api/api_client.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

/// from database:
/// token
/// list of events the user joined
/// new messages (later)

class HomePage extends StatefulWidget {
  // todo check token not necessary late?
  final Token token;
  HomePage(this.token);
  late final User userFinal;
  late final List<Friend> listOfFriendsToTest;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int countGetUserData = 0;
  Future<User> _getUser(Token token) async {
    var userFuture;
    String tokenString = token.token;
    if (token.token == '123456789') {
      userFuture =
          await LoginProvider(Client().init()).getUserLocalJson() as User;
    } else {
      try {
        final response = await http
            .get(Uri.parse('http://ccproject.robertdoes.it/users'), headers: {
          "Content-Type": "application/json",
          "Charset": "utf-8",
          "Accept": "application/json",
          "Authorization": "Bearer $tokenString",
        });
        if (response.statusCode == 200) {
          String jsonsDataString = response.body.toString();
          countGetUserData++;
          print(
              'FEEDBACK homepage - JSON status code 200, get user run nr. $countGetUserData data string: ' +
                  jsonDecode(jsonsDataString).toString());
          userFuture = User.fromJson(json.decode(response.body.toString()));
        }
      } catch (err, stack) {
        logger.e("Login failed...", err, stack);
        throw err;
      }
    }
    return userFuture;
  }

  void _getFriendsFromDatabase(Token token) async {
    var listOfFriends;
    String tokenString = token.token;
    try {
      final response = await http
          .get(Uri.parse('http://ccproject.robertdoes.it/friends'), headers: {
        "Content-Type": "application/json",
        "Charset": "utf-8",
        "Accept": "application/json",
        "Authorization": "Bearer $tokenString",
      });
      if (response.statusCode == 200) {
        String jsonsDataString = response.body.toString();
        print('FEEDBACK homepage - JSON status code 200, list of friends: ' +
            jsonDecode(jsonsDataString).toString());
      }
    } catch (err, stack) {
      logger.e("Login failed...", err, stack);
      throw err;
    }
  }

  void _defineUser() async {
    widget.userFinal = await _getUser(widget.token) as User;
  }

  List<String> _locationsAddresses = new List.empty(growable: true);
  late List<EventMeeting> _listOfEvents;
  late List<EventMeeting> _listOfEvents2;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  late List<Group> hardocdedListOfGroups;

  @override
  Widget build(BuildContext context) {
    // _defineUser();
    // _buildEventList();
    return FutureBuilder<User>(
        future: _getUser(widget.token),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                widget.userFinal = snapshot.data as User;
              _buildEventList1();
              return _buildWidget();
          }
        });
  }

  Widget _buildWidget() {
    _listOfEvents2 = Lists().hardcodeListOfEvents2();
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextButton(
                onPressed: () {
                  // TODO go to pending requests
                },
                child: Text(
                  'Pending friend requests: 1',
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                )),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Upcoming joined events:',
                textAlign: TextAlign.left,
                style: kTextStyleItalic,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            /*Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Upcoming events:',
                style: TextStyle(
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.left,
              ),
            ),*/
            Expanded(
              // TODO list upcaming events sorted by date
              flex: 4,
              child: Container(
                decoration: kContainerBoxDecoration,
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    height: 10.0,
                    color: Colors.grey.shade300,
                  ),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0.0),
                  itemCount: _listOfEvents.length,
                  itemBuilder: (context, i) {
                    return _buildRow(_listOfEvents[i]
                        //, _locationsAddresses[i]
                        );
                  },
                ),
              ),
            ),
            /*Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _listOfEvents.length,
                itemBuilder: (context, i) {
                  return _buildRow(_listOfEvents[i]
                      //, _locationsAddresses[i]
                      );
                },
              ),
            ),*/
            /*SizedBox(
              height: 20.0,
            ),
            TextButton(
              onPressed: () {
                _getFriendsFromDatabase(widget.token);
              },
              child: Text('test get friends'),
            ),*/
            SizedBox(
              height: 10.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recently added events:',
                textAlign: TextAlign.left,
                style: kTextStyleItalic,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              // TODO list recently created events
              flex: 3,
              child: Container(
                decoration: kContainerBoxDecoration,
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    height: 10.0,
                    color: Colors.grey.shade300,
                  ),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0.0),
                  itemCount: _listOfEvents2.length,
                  itemBuilder: (context, i) {
                    return _buildRowGrey(_listOfEvents2[i]
                        //, _locationsAddresses[i]
                        );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(EventMeeting event
      // , String address
      ) {
    return new ListTile(
      // isThreeLine: true,
      // contentPadding: EdgeInsets.all(10.0),
      contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      //tileColor: Colors.grey.shade200,
      tileColor: Colors.transparent,
      leading: new CircleAvatar(
          // backgroundColor: Colors.grey,
          child: Icon(Icons.location_on)),
      dense: true,
      title: new Text(
        event.eventName,
        style: _biggerFont,
      ),
      subtitle: new Text('Time: ' + event.time + '\nLocation: ' + 'address'),
      onTap: () {
        hardocdedListOfGroups = Lists().hardcodeListOfGroups();
        Group groupToPass = hardocdedListOfGroups[1];
        // TODO pass the correct group or link group
        Navigator.pushNamed(context, 'event_detail',
            arguments: [event, groupToPass, widget.userFinal]);
      },
    );
  }

  Widget _buildRowGrey(EventMeeting event
      // , String address
      ) {
    return new ListTile(
      // isThreeLine: true,
      // contentPadding: EdgeInsets.all(10.0),
      contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      //tileColor: Colors.grey.shade200,
      tileColor: Colors.transparent,
      leading: new CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(
            Icons.location_on,
            color: Colors.white,
          )),
      dense: true,
      title: new Text(
        event.eventName,
        style: _biggerFont,
      ),
      subtitle: new Text('Time: ' + event.time + '\nLocation: ' + 'address'),
      onTap: () {
        hardocdedListOfGroups = Lists().hardcodeListOfGroups();
        Group groupToPass = hardocdedListOfGroups[1];
        // TODO pass the correct group or link group
        Navigator.pushNamed(context, 'event_detail',
            arguments: [event, groupToPass, widget.userFinal]);
      },
    );
  }

  _buildEventList1() async {
    List<EventMeeting> listOfEvents = new List.empty(growable: true);
    try {
      if (widget.token.token == '123456789') {
        listOfEvents = Lists().hardcodeListOfEvents1();
      } else {
        listOfEvents = Lists().hardcodeListOfEvents1();
        // listOfEvents = widget.userFinal.events; //TODO HARDCODED
      }
    } catch (exception) {
      print(exception.toString());
    }
    print('feedback - fetch list of events');
    _listOfEvents = listOfEvents;

    /*List<String> locationsAddresses = new List.empty(growable: true);
    // List<String> locationsAddresses =
    // List<String>.filled(listOfEvents.length, '');
    int idx = 0;
    _listOfEvents.forEach((element) async {
      List<Placemark> _placemarks =
          await placemarkFromCoordinates(element.lat, element.long);
      Placemark place = _placemarks[0];
      print('print street from place: ' + place.street.toString());

      String locationToString =
          '${place.street.toString()}, ${place.locality.toString()}, ${place.postalCode.toString()}';
      print('print locationn to string: ' + locationToString);
      print(idx);

      locationsAddresses.insert(idx, locationToString);
      // locationsAddresses[idx] = locationToString;
      idx++;
    });

    // TODO CHECK!!!
    _locationsAddresses = await locationsAddresses;
    print('why is this not working? _locationsAddresses length: ' +
        _locationsAddresses.length.toString());
    locationsAddresses.forEach((element) {
      print('print each location address ' + element);
    });*/
  }
}
