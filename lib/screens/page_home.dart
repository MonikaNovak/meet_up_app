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

  //
  //
  // hardcoded lists:
  List<EventMeeting> _hardcodeListOfEvents() {
    List<EventMeeting> listOfEvents = new List.empty(growable: true);
    EventMeeting event1 = new EventMeeting('aaa', 47.23962176969944,
        9.597157658181816, 'Gin degustation', 'Fr 2.7.2021');
    EventMeeting event2 = new EventMeeting('bbb', 47.23962176969944,
        9.597157658181816, 'Whiskey degustation', 'Fr 9.7.2021');
    EventMeeting event3 = new EventMeeting('ccc', 47.23962176969944,
        9.597157658181816, 'Beer degustation', 'Fr 16.7.2021');
    listOfEvents.add(event1);
    listOfEvents.add(event2);
    listOfEvents.add(event3);
    print('feedback - list of events hardcoded: ' +
        listOfEvents[0].eventName +
        listOfEvents[1].eventName +
        listOfEvents[2].eventName);
    return listOfEvents;
  }

  List<Group> _hardcodeListOfGroups() {
    List<Group> listOfGroups = new List.empty(growable: true);

    List<EventMeeting> listOfEvents = new List.empty(growable: true);
    EventMeeting event1 = new EventMeeting('aaa', 47.23962176969944,
        9.597157658181816, 'Gin degustation', 'Fr 2.7.2021');
    EventMeeting event2 = new EventMeeting('bbb', 47.23962176969944,
        9.597157658181816, 'Whiskey degustation', 'Fr 9.7.2021');
    EventMeeting event3 = new EventMeeting('ccc', 47.23962176969944,
        9.597157658181816, 'Beer degustation', 'Fr 16.7.2021');
    listOfEvents.add(event1);
    listOfEvents.add(event2);
    listOfEvents.add(event3);

    List<UserGeneral> listOfUsers = new List.empty(growable: true);
    UserGeneral friend1 = new UserGeneral(
        'leonido24',
        'leon.barrett@example.com',
        'https://randomuser.me/api/portraits/men/29.jpg',
        'I like lemon ice-cream.',
        'Leon');
    UserGeneral friend2 = new UserGeneral(
        'ramanid',
        'ramon.peck@example.com',
        'https://randomuser.me/api/portraits/men/6.jpg',
        'I like chocolate ice-cream.',
        'Ramon');
    UserGeneral friend3 = new UserGeneral(
        'rossalinda',
        'ross.bryant@example.com',
        'https://randomuser.me/api/portraits/women/99.jpg',
        'I like strawberry ice-cream.',
        'Rossi');
    UserGeneral friend4 = new UserGeneral(
        'barretoo',
        'leon.barrett@example.com',
        'https://randomuser.me/api/portraits/men/62.jpg',
        'I like cherry ice-cream.',
        'Barret');
    UserGeneral friend5 = new UserGeneral(
        'pickle',
        'ramon.peck@example.com',
        'https://randomuser.me/api/portraits/women/85.jpg',
        'I like vanilla ice-cream.',
        'Pecky');
    UserGeneral friend6 = new UserGeneral(
        'bumblebee',
        'ross.bryant@example.com',
        'https://randomuser.me/api/portraits/men/47.jpg',
        'I like ginger ice-cream.',
        'Bryant');
    listOfUsers.add(friend1);
    listOfUsers.add(friend2);
    listOfUsers.add(friend3);
    listOfUsers.add(friend4);
    listOfUsers.add(friend5);
    listOfUsers.add(friend6);

    Group group1 = new Group(
        'monika.n',
        'https://www.jolie.de/sites/default/files/styles/facebook/public/images/2017/07/14/partypeople.jpg?itok=H8Kltq60',
        'The crazy people',
        '1111',
        listOfUsers,
        listOfEvents);
    Group group2 = new Group(
        'jimmy',
        'https://www.jolie.de/sites/default/files/styles/facebook/public/images/2017/07/14/partypeople.jpg?itok=H8Kltq60',
        'The weird people',
        '2222',
        listOfUsers,
        listOfEvents);
    Group group3 = new Group(
        'luca',
        'https://www.jolie.de/sites/default/files/styles/facebook/public/images/2017/07/14/partypeople.jpg?itok=H8Kltq60',
        'The awesome people',
        '3333',
        listOfUsers,
        listOfEvents);
    listOfGroups.add(group1);
    listOfGroups.add(group2);
    listOfGroups.add(group3);
    return listOfGroups;
  }
  //
  //
  //

  List<String> _locationsAddresses = new List.empty(growable: true);
  late List<EventMeeting> _listOfEvents;
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
              _buildEventList();
              return _buildWidget();
          }
        });
  }

  Widget _buildWidget() {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Upcoming events:',
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
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'New messages:',
                textAlign: TextAlign.left,
                style: kTextStyleItalic,
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: kContainerBoxDecoration,
                child: Text('ToDo messages'),
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
        hardocdedListOfGroups = _hardcodeListOfGroups();
        Group groupToPass = hardocdedListOfGroups[1];
        // TODO pass the correct group or link group
        Navigator.pushNamed(context, 'event_detail',
            arguments: [event, groupToPass, widget.userFinal]);
      },
    );
  }

  _buildEventList() async {
    List<EventMeeting> listOfEvents = new List.empty(growable: true);
    try {
      if (widget.token.token == '123456789') {
        listOfEvents = _hardcodeListOfEvents();
      } else {
        listOfEvents = _hardcodeListOfEvents();
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
