import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/models/User.dart';

class EventPage extends StatefulWidget {
  late final Token token;
  EventPage(this.token);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late String messageText;

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
              trailing: Icon(
                Icons.location_on,
              ),
              title: Text('Metting at Strandbad'),
              subtitle: Text('Event time: Friday 17.00'),
              onTap: () {
                /*Navigator.pushNamed(context, 'event_detail',
                    arguments: widget.userFinal);*/
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
                /*Navigator.pushNamed(context, 'event_detail',
                    arguments: widget.userFinal);*/
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
                /*Navigator.pushNamed(context, 'event_detail',
                    arguments: widget.userFinal);*/
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
