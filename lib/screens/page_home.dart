import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/EventMeeting.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/api/providers/LoginProvider.dart';
import 'package:meet_up_vor_2/constants.dart';
import 'package:meet_up_vor_2/api/api_client.dart';

/// from database:
/// token
/// list of events the user joined
/// new messages (later)

class HomePage extends StatefulWidget {
  late final Token token;
  HomePage(this.token);
  late final User userFinal;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<User> _getUser(Token token) async {
    var userFuture;
    if (token.token == '123456789') {
      userFuture = await LoginProvider(Client().init()).login() as User;
    }
    return userFuture;
  }

  void _defineUser() async {
    widget.userFinal = await _getUser(widget.token);
  }

  late List<EventMeeting> _listOfEvents;
  final _biggerFont = const TextStyle(fontSize: 18.0);

/*  @override
  void initState() {
    super.initState();
    _getUser(widget.token);
    print(widget.userFinal);
  }*/

  @override
  Widget build(BuildContext context) {
    _defineUser();
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
                _buildEventList();
              print(
                  'feedback - build homepage, user: ' + widget.userFinal.name);
              return _buildWidget();
          }
        });
  }

  Widget _buildWidget() {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.grey.shade400,
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 50.0,
                    /*backgroundImage: AssetImage(kUserProfilePicAddress),*/
                    backgroundImage:
                        new NetworkImage(widget.userFinal.profilImage),
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    widget.userFinal.displayName,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Upcoming events:',
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(0.0),
                itemCount: _listOfEvents.length,
                itemBuilder: (context, i) {
                  return _buildRow(_listOfEvents[i]);
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'New messages:',
              ),
            ),
            Container(
              child: Text('Messages TODO'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(EventMeeting event) {
    return new ListTile(
      leading: new CircleAvatar(
          backgroundColor: Colors.grey, child: Icon(Icons.location_on)),
      title: new Text(
        event.eventName,
        style: _biggerFont,
      ),
      subtitle:
          new Text('Time: ' + event.time + '\nLocation: ' + 'event.location'),
      onTap: () {
        // TODO pass the correct group or link group
        Navigator.pushNamed(context, 'event_detail',
            arguments: [event, widget.userFinal.groups[0], widget.userFinal]);
      },
    );
  }

  _buildEventList() async {
    // TODO sort events by date
    List<EventMeeting> listOfEvents = new List.empty(growable: true);
    try {
      listOfEvents = widget.userFinal.events;
    } catch (exception) {
      print(exception.toString());
    }

    print('feedback - group detail - fetch list of events');
    _listOfEvents = listOfEvents;
  }
}
