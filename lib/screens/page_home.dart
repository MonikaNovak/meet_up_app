import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/constants.dart';
import 'package:meet_up_vor_2/screens/screen_main.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  late final User userFinal;

  HomePage(this.userFinal) {
    logger.d("building home page");
    print('feedback user name passed to homepage: ' + userFinal.getUserName());
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /*var arguments = new Map();*/

  @override
  Widget build(BuildContext context) {
    /*final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    print(arguments);
    userName = arguments['userNameArg'];*/

    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.grey.shade300,
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 50.0,
                    /*backgroundImage: AssetImage(kUserProfilePicAddress),*/
                    backgroundImage:
                        new NetworkImage(widget.userFinal.avatarUrl),
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    widget.userFinal.userName,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Text(
              'upcoming events:',
            ),
            ListTile(
              title: Text(
                'Afternoon swim at strandbad',
              ),
              subtitle: Text('time: Thursday 17:00'),
              trailing: Icon(
                Icons.add_location,
              ),
              tileColor: Colors.grey.shade300,
            ),
            SizedBox(
              height: 10.0,
            ),
            ListTile(
              title: Text(
                'Afternoon swim at strandbad',
              ),
              subtitle: Text('time: Thursday 17:00'),
              trailing: Icon(
                Icons.add_location,
              ),
              tileColor: Colors.grey.shade300,
            ),
            SizedBox(
              height: 10.0,
            ),
            ListTile(
              title: Text(
                'Afternoon swim at strandbad',
              ),
              subtitle: Text('time: Thursday 17:00'),
              trailing: Icon(
                Icons.add_location,
              ),
              tileColor: Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }
}
