import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/User.dart';

class EventDetail extends StatefulWidget {
  late User userFinal;

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  @override
  Widget build(BuildContext context) {
    final userFinal = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
/*      appBar: MyAppBar(),*/
      appBar: AppBar(
        title: Text(
          'Event details',
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Grill & Chill',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text('active hangout time'),
            Text(
              'Friday 18:00',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text('location'),
            Text(
              'Strandbad Bregenz',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.grey.shade300,
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 30.0,
                    /*backgroundImage: AssetImage(kUserProfilePicAddress),*/
                    backgroundImage: new NetworkImage(
                        'https://www.jolie.de/sites/default/files/styles/facebook/public/images/2017/07/14/partypeople.jpg?itok=H8Kltq60'),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: Text(
                      'Crazy people',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24.0),
                    ),
                  ),
                  Container(
                    child: Icon(Icons.chat),
                    padding: EdgeInsets.all(20.0),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade300,
                child: Text('Maybe a map here?'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
