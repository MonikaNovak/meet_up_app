/*import 'dart:html';*/
import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/Message.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/api/api_client.dart';
import 'package:meet_up_vor_2/api/providers/MessageProvider.dart';

class ChatPage extends StatefulWidget {
  late final User userFinal;
  /*late final Message message;*/

  ChatPage(this.userFinal);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String messageText;

  @override
  Widget build(BuildContext context) {
    /*   _getMessage();*/
    return Scaffold(
/*      appBar: MyAppBar(),*/
      body: SafeArea(
        minimum: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            ListTile(
              tileColor: Colors.grey.shade300,
              trailing: Icon(
                Icons.location_on,
              ),
              title: Text('Metting at Strandbad'),
              subtitle: Text('Event time: Friday 17.00'),
              onTap: () {
                Navigator.pushNamed(context, 'event_detail',
                    arguments: widget.userFinal);
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            ListTile(
              tileColor: Colors.grey.shade300,
              trailing: Icon(
                Icons.location_on,
              ),
              title: Text('Metting at Strandbad'),
              subtitle: Text('Event time: Friday 17.00'),
              onTap: () {
                Navigator.pushNamed(context, 'event_detail',
                    arguments: widget.userFinal);
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            ListTile(
              tileColor: Colors.grey.shade300,
              trailing: Icon(
                Icons.location_on,
              ),
              title: Text('Metting at Strandbad'),
              subtitle: Text('Event time: Friday 17.00'),
              onTap: () {
                Navigator.pushNamed(context, 'event_detail',
                    arguments: widget.userFinal);
              },
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
    );
  }
}
