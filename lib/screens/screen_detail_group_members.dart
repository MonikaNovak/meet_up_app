import 'package:flutter/material.dart';

class GroupMembers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Group details',
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: 10,
        padding: EdgeInsets.all(10.0),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            dense: true,
            leading: Icon(Icons.account_circle),
            title: Text('Member $index'),
            subtitle: Text("Let's party haaard!"),
          );
        },
      ),
    );
  }
}
