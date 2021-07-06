import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/api/providers/LoginProvider.dart';
import 'package:meet_up_vor_2/constants.dart';
import 'package:meet_up_vor_2/screens/screen_main.dart';
import 'package:meet_up_vor_2/api/api_client.dart';

// TODO why console prints feedback already at login?
// TODO upcoming events

class HomePage extends StatefulWidget {
  late final Token token;
  HomePage(this.token);
  late final User userFinal;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<User> _getUser(Token token) async {
    var userFuture;
    if (token.token == '123456789') {
      userFuture = await LoginProvider(Client().init()).login() as User;
    }
    return userFuture;
  }

  void _defineUser() async {
    widget.userFinal = await _getUser(widget.token);
  }

/*  @override
  void initState() {
    super.initState();
    _getUser(widget.token);
    print(widget.userFinal);
  }*/

  @override
  Widget build(BuildContext context) {
    _defineUser();
    return FutureBuilder<User>(
        future: _getUser(widget.token),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                print('feedback - build homepage, user: ' +
                    widget.userFinal.name);
              return _buildWidget();
          }
        });
  }

  Widget _buildWidget() {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.grey.shade400,
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 50.0,
                    /*backgroundImage: AssetImage(kUserProfilePicAddress),*/
                    backgroundImage:
                        new NetworkImage(widget.userFinal.profilImage),
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    widget.userFinal.displayName,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Upcoming events:',
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      'Afternoon swim at strandbad $index',
                    ),
                    subtitle: Text('time: Thursday 17:00'),
                    trailing: Icon(
                      Icons.location_on,
                    ),
                    tileColor: Colors.grey.shade300,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.grey.shade400,
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 50.0,
                    */ /*backgroundImage: AssetImage(kUserProfilePicAddress),*/ /*
                    */ /*ackgroundImage: new NetworkImage(userFinal.profilImage),*/ /*
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    */ /*userFinal.displayName,*/ /*
                    'text',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Upcoming events:',
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      'Afternoon swim at strandbad $index',
                    ),
                    subtitle: Text('time: Thursday 17:00'),
                    trailing: Icon(
                      Icons.location_on,
                    ),
                    tileColor: Colors.grey.shade300,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }*/
}
