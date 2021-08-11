import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/Friend.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';

import '../constants.dart';

/// from database:
/// friend info
/// later direct message option
/// TODO request remove friend from list (with token)

class FriendProfileScreen extends StatelessWidget {
  late final Token token;
  late final Friend friend;
  late final String buttonMessage;

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as List;
    token = arguments[0];
    friend = arguments[1];
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: kMainPurple,
        title: Text(
          'User profile',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.grey.shade300,
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: new NetworkImage(friend.profileImageUrl),
                  ),
                  SizedBox(width: 20.0),
                  Column(
                    children: <Widget>[
                      Text(
                        friend.displayName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24.0),
                      ),
                      Text(
                        friend.name,
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.grey.shade300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('status'),
                  Text(friend.statusMessage),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            _buildLastWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildLastWidget() {
    Widget widget = SizedBox(
      height: 0,
    );
    int statusTemp = 0;
    if (friend.status == 4) {
      // TODO check if in friend list and update status
      statusTemp = 2; // for now just as not in friend list
    } else {
      statusTemp = friend.status;
    }
    if (statusTemp == 1) {
      widget = TextButton(
        onPressed: () {
          // TODO request remove friend from list (with token)
        },
        child: Text('Remove friend from friend list'),
      );
    } else if (statusTemp == 0) {
      widget = Text(
        'Friend request sent',
        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.lightGreen),
      );
    } else if (statusTemp == 3) {
      widget = Row(
        children: <Widget>[
          TextButton(
              onPressed: () {
                // TODO add to friend list
              },
              child: Text('Accept friend request')),
          TextButton(onPressed: () {}, child: Text('Decline friend request')),
        ],
      );
    } else if (statusTemp == 2) {
      widget = TextButton(
        onPressed: () {
          // TODO send friend request
        },
        child: Text('Send friend request'),
      );
    }
    return widget;
  }
}

/*class FriendProfileScreen extends StatefulWidget {
  @override
  _FriendProfileScreenState createState() => _FriendProfileScreenState();
}

class _FriendProfileScreenState extends State<FriendProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as List;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 15.0),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.grey.shade300,
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: new NetworkImage(arguments[0]),
                  ),
                  SizedBox(width: 20.0),
                  Column(
                    children: <Widget>[
                      Text(
                        arguments[2],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24.0),
                      ),
                      Text(
                        arguments[1],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.grey.shade300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('email address'),
                  Text(arguments[3]),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.grey.shade300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('status'),
                  Text(arguments[4]),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}*/
