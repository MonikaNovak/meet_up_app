import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/EventMeeting.dart';
import 'package:meet_up_vor_2/api/models/Group.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/api_client.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/api/providers/LoginProvider.dart';

/// from database:
/// list of events the user joined

class EventPage extends StatefulWidget {
  late final Token token;
  EventPage(this.token);
  late final User userFinal;
  late final Group groupToPass;

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Future<User> _getUser(Token token) async {
    var userFuture;
    if (token.token == '123456789') {
      userFuture =
          await LoginProvider(Client().init()).getUserLocalJson() as User;
    } else {
      // TODO get user from database
    }
    return userFuture;
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

    Group group1 = new Group(
        'monika.n',
        'https://www.jolie.de/sites/default/files/styles/facebook/public/images/2017/07/14/partypeople.jpg?itok=H8Kltq60',
        'The crazy people',
        '1111',
        listOfEvents);
    Group group2 = new Group(
        'jimmy',
        'https://www.jolie.de/sites/default/files/styles/facebook/public/images/2017/07/14/partypeople.jpg?itok=H8Kltq60',
        'The weird people',
        '2222',
        listOfEvents);
    Group group3 = new Group(
        'luca',
        'https://www.jolie.de/sites/default/files/styles/facebook/public/images/2017/07/14/partypeople.jpg?itok=H8Kltq60',
        'The awesome people',
        '3333',
        listOfEvents);
    listOfGroups.add(group1);
    listOfGroups.add(group2);
    listOfGroups.add(group3);
    return listOfGroups;
  }
  //
  //
  //

  void _defineUser() async {
    widget.userFinal = await _getUser(widget.token);
    // widget.groupToPass = widget.userFinal.groups[0]; TODO HARDCODED
    List<Group> listGroupsTemp = _hardcodeListOfGroups();
    widget.groupToPass = listGroupsTemp[0];
  }

  final _biggerFont = const TextStyle(fontSize: 18.0);
  late List<EventMeeting> _listOfEvents;
  late List<EventMeeting> _listOfEventsFiltered;
  TextEditingController searchController = new TextEditingController();

  Key _k3 = new GlobalKey();
  GlobalKey<FormState> _formKey3 = new GlobalKey<FormState>();

  final StreamController<List<EventMeeting>> _streamController =
      new StreamController();

  // late String messageText;

  @override
  Widget build(BuildContext context) {
    print('feedback build page events');
    _defineUser();
    return FutureBuilder<User>(
      future: _getUser(widget.token),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
                child: new Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: new CircularProgressIndicator()));
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else {
              print('feedback - events page - building list...');
              print('feedback - get a group to pass - group name: ' +
                  widget.groupToPass.groupName);
              _buildList();
              searchController.addListener(() {
                filterEvents();
              });
              return _buildWidget();
            }
        }
      },
    );
  }

  Widget _buildWidget() {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey3,
              child: TextField(
                key: _k3,
                controller: searchController,
                decoration: InputDecoration(
                    labelText: 'Search',
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: Theme.of(context).primaryColor)),
                    prefixIcon: Icon(Icons.search,
                        color: Theme.of(context).primaryColor)),
              ),
            ),
          ),
          StreamBuilder<List<EventMeeting>>(
              stream: _streamController.stream,
              initialData: _listOfEventsFiltered,
              builder: (context, snapshot) {
                return Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0.0),
                    itemCount: _listOfEventsFiltered.length,
                    itemBuilder: (context, i) {
                      return _buildRow(_listOfEventsFiltered[i]);
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }

  _buildList() async {
    List<EventMeeting> listOfEvents = new List.empty(growable: true);
    try {
      // listOfEvents = widget.userFinal.events; TODO HARDCODED
      listOfEvents = _hardcodeListOfEvents();
    } catch (exception) {
      print(exception.toString());
    }

    print('feedback - groups page - fetch friend list complete');
    _listOfEvents = listOfEvents;
    _listOfEventsFiltered = listOfEvents;
  }

  Widget _buildRow(EventMeeting event) {
    return new ListTile(
      leading: new CircleAvatar(
          backgroundColor: Colors.grey, child: Icon(Icons.location_on)
          /*backgroundImage: AssetImage(kUserProfilePicAddress),*/
          ),
      title: new Text(
        event.eventName,
        style: _biggerFont,
      ),
      subtitle:
          new Text('Time: ' + event.time + '\nLocation: ' + 'event.location'),
      onTap: () {
        Navigator.pushNamed(context, 'event_detail',
            arguments: [event, widget.groupToPass, widget.userFinal]);
      },
    );
  }

  filterEvents() {
    List<EventMeeting> _listOfEventsLocal = [];
    _listOfEventsLocal.addAll(_listOfEvents);
    if (searchController.text.isNotEmpty) {
      _listOfEventsLocal.retainWhere((group) {
        String searchTerm = searchController.text.toLowerCase();
        // String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String eventName = group.eventName.toLowerCase();
        bool nameMatches = eventName.contains(searchTerm);

        if (nameMatches == true) {
          return true;
        }

        return false;
      });
    }
    _listOfEventsFiltered = _listOfEventsLocal;
    _streamController.sink.add(_listOfEventsFiltered);
  }
}
