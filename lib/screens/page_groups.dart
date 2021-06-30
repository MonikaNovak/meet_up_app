import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/api/providers/LoginProvider.dart';
import 'package:meet_up_vor_2/api/api_client.dart';

class GroupsPage extends StatefulWidget {
  late final Token token;
  GroupsPage(this.token);

  late final User userFinal;

  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  Future<User?> _getUserData(Token token) async {
    if (token.token == '123456789') {
      var userFinal = await LoginProvider(Client().init()).login();
      return userFinal;
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.userFinal = _getUserData(widget.token) as User;
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            ListTile(
              tileColor: Colors.grey.shade300,
              leading: Icon(
                Icons.accessible_forward_sharp,
              ),
              title: Text('The crazy people'),
              subtitle: Text('Active events: 2'),
              onTap: () {
                Navigator.pushNamed(context, 'group_detail',
                    arguments: widget.userFinal);
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            ListTile(
              tileColor: Colors.grey.shade300,
              leading: Icon(
                Icons.accessible_forward_sharp,
              ),
              title: Text('The crazy people'),
              subtitle: Text('Active events: 2'),
              onTap: () {
                Navigator.pushNamed(context, 'group_detail',
                    arguments: widget.userFinal);
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            ListTile(
              tileColor: Colors.grey.shade300,
              leading: Icon(
                Icons.accessible_forward_sharp,
              ),
              title: Text('The crazy people'),
              subtitle: Text('Active events: 2'),
              onTap: () {
                Navigator.pushNamed(context, 'group_detail',
                    arguments: widget.userFinal);
              },
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
