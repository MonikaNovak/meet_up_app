import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/EventMeeting.dart';
import 'package:meet_up_vor_2/api/models/Group.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/models/User.dart';

import '../constants.dart';

/// from database:
/// group:
/// info - name
/// list of members
/// list of events
/// action leave group (remove group from group list)
/// later group messenger

class GroupDetail extends StatefulWidget {
  late final User userPassed;
  late final Group group;
  late final Token token;
  late final String admin;

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
    widget.token = arguments[0] as Token;
    widget.group = arguments[2] as Group;
    widget.userPassed = arguments[1] as User;
    widget.admin = 'Mihai Sandoval';
    _buildEventList();
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: kMainPurple,
        title: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 15.0,
              backgroundImage: new NetworkImage(widget.group.groupImageUrl),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              widget.group.groupName,
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
        /*actions: [
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) =>
                  [PopupMenuItem<int>(value: 0, child: Text('Leave group'))],
              onSelected: (item) => {_showAlertDialog(context)})
        ],*/
        actions: [_buildPopUpMenu()],
      ),
      body: SafeArea(
        minimum: EdgeInsets.fromLTRB(15.0, 0, 15.0, 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'members_list', arguments: [
                  widget.token,
                  widget.userPassed,
                  widget.group.members,
                  'Members'
                ]);
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Show members',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                    Icon(Icons.arrow_right, color: Colors.deepPurple),
                  ]),
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
            Expanded(
              child: Container(
                decoration: kContainerBoxDecoration,
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

  Widget _buildPopUpMenu() {
    if (widget.admin == widget.userPassed.name) {
      return PopupMenuButton(
          icon: Icon(Icons.more_vert),
          itemBuilder: (context) => [
                PopupMenuItem<int>(value: 0, child: Text('Delete group')),
                PopupMenuItem<int>(value: 1, child: Text('Add friends'))
              ],
          onSelected: (value) => {_popUpMenuOptionsAdmin(value)});
    } else {
      return PopupMenuButton(
          icon: Icon(Icons.more_vert),
          itemBuilder: (context) =>
              [PopupMenuItem<int>(value: 0, child: Text('Leave group'))],
          onSelected: (item) => {_showAlertDialogLeaveGroup(context)});
    }
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
            arguments: [event, widget.userPassed, widget.token]);
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

  _popUpMenuOptionsAdmin(Object? value) {
    if (value.toString() == '0') {
      // TODO add friends to group
    } else if (value.toString() == '1') {
      _showAlertDialogDeleteGroup(context);
    }
  }

  _showAlertDialogDeleteGroup(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget confirmButton = TextButton(
      child: Text("Delete group"),
      onPressed: () {
        // TODO leave group function
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Are you sure you want to delete this group?"),
      content:
          Text("All events creazed within the group will be deleted as well."),
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

  _showAlertDialogLeaveGroup(BuildContext context) {
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
