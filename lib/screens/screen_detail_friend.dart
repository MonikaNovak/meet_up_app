import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/User.dart';

import '../constants.dart';

class UserProfileScreen extends StatefulWidget {
/*  late final User userFinal;

  UserProfileScreen(this.userFinal);*/

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userFinal = ModalRoute.of(context)!.settings.arguments as User;
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
                    backgroundImage: new NetworkImage(userFinal.avatarUrl),
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    /*'test',*/
                    userFinal.userName,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
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
                  Text(userFinal.email),
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
                  Text(userFinal.status),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.deepPurple),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Edit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.deepPurple),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'welcome_screen');
                  },
                  child: Text(
                    "Log out",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
