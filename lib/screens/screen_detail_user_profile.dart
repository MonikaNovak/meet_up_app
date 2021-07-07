/*import 'dart:html';*/
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/api/providers/LoginProvider.dart';
import 'package:meet_up_vor_2/components/app_bar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../constants.dart';
import 'package:meet_up_vor_2/api/api_client.dart';

/// from database:
/// user info
/// action change profile pic - update somewhere to save as URL
/// action change display name, status
/// action log out
/// action delete profile

class UserProfileScreen extends StatefulWidget {
  late final Token token;
  late final User userFinal;
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
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

  /*@override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {

        _defineUser();
      });
      print('feedback print token in init state: ' + token.token);

      print('feedback print user name in init state: ' + userFinal.name);
    });
  }*/

  // define _userFinal from future user

  @override
  Widget build(BuildContext context) {
    widget.token = ModalRoute.of(context)!.settings.arguments as Token;
    _defineUser();
    // var userFinal = _getUser(token) as User;
    // print('in build user final name ' + userFinal.name);
    // final Future<User> _userFinal = _getUser(token);
    return FutureBuilder<User>(
        future: _getUser(widget.token),
        // future: userFinal,
        // future: _userFinal,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('loading...');
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                print('feedback - build user profile detail, user: ' +
                    widget.userFinal.name);
              return _buildWidget();
          }
        });
  }

  Widget _buildWidget() {
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
                      backgroundImage:
                          new NetworkImage(widget.userFinal.profilImage),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 15.0,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'image_capture',
                                  arguments: widget.userFinal);
                            },
                            iconSize: 12.0,
                            icon: Icon(
                              Icons.camera_alt,
                              size: 15.0,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Column(
                      children: <Widget>[
                        Text(
                          /*'test',*/
                          widget.userFinal.displayName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24.0),
                        ),
                        Text(
                          'username',
                        )
                      ],
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
                    Text(widget.userFinal.email),
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
                    Text(widget.userFinal.statusMessage),
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
            ]),
      ),
    );
  }
}
