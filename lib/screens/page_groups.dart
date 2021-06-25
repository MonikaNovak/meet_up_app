import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/components/app_bar.dart';

class GroupsPage extends StatefulWidget {
  late final User userFinal;

  GroupsPage(this.userFinal) {
    print(
        'feedback user name passed to group page: ' + userFinal.getUserName());
  }

  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*      appBar: MyAppBar(),*/
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
