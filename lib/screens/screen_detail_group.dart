import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/User.dart';

class GroupDetail extends StatefulWidget {
/*  late final User userFinal;

  GroupDetail(this.userFinal);*/

  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  late String messageText;

  @override
  Widget build(BuildContext context) {
    final userFinal = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
/*      appBar: MyAppBar(),*/
      appBar: AppBar(
        title: Text(
          'Group details',
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                  Text(
                    'Crazy people',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextButton(
              child: Text(
                'show members',
              ),
              onPressed: () {
                Navigator.pushNamed(context, 'group_members');
              },
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: 10,
                padding: EdgeInsets.all(10.0),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    dense: true,
                    leading: Icon(Icons.account_circle),
                    title: Text('Event $index'),
                    subtitle: Text("Fr 17:00, Strandbad"),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
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
                        //TODO save message to the 'database'
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
}
