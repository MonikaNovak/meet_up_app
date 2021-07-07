import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/EventMeeting.dart';
import 'package:meet_up_vor_2/api/models/Group.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/models/User.dart';

/// from database:
/// group:
/// info - name
/// list of members
/// list of events
/// action leave group (remove group from group list)
/// later group messenger

class GroupDetail extends StatefulWidget {
  // late final Token token;
  late final User userPassed;
  late final Group group;

  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  late String messageText;
  late List<EventMeeting> _listOfEvents;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as List;
    widget.group = arguments[0] as Group;
    widget.userPassed = arguments[1] as User;
    _buildEventList();
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Group details',
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.grey.shade300,
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 30.0,
                    /*backgroundImage: AssetImage(kUserProfilePicAddress),*/
                    backgroundImage:
                        new NetworkImage(widget.group.groupImageUrl),
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    widget.group.groupName,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  child: Text(
                    'Show members',
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, 'group_members',
                        arguments: widget.userPassed);
                  },
                ),
                TextButton(
                  child: Text(
                    'Leave group',
                  ),
                  onPressed: () {
                    _showAlertDialog(context);
                  },
                ),
              ],
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
              height: 10.0,
            ),
            Expanded(
              //TODO build up chat messenger
              flex: 2,
              child: Container(
                color: Colors.grey.shade300,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          messageText = value;
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        /*messageMap[messageMap.length + 1] = [
                      widget.userFinal.userName,
                      messageText
                    ];*/
                      },
                      child: Text('Send'),
                    )
                  ],
                ),
              ),
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
        Navigator.pushNamed(context, 'event_detail',
            arguments: [event, widget.group, widget.userPassed]);
      },
    );
  }

  _buildEventList() async {
    List<EventMeeting> listOfEvents = new List.empty(growable: true);
    try {
      listOfEvents = widget.group.events;
    } catch (exception) {
      print(exception.toString());
    }

    print('feedback - group detail - fetch list of events');
    _listOfEvents = listOfEvents;
  }

  _showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget confirmButton = TextButton(
      child: Text("Leave group"),
      onPressed: () {
        // TODO leave group function
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Are you sure you want to leave this group?"),
      content: Text(
          "Only the admin of the group can add you back to the members list"),
      actions: [
        cancelButton,
        confirmButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
