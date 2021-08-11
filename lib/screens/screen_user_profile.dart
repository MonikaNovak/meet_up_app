import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/api/providers/LoginProvider.dart';
import '../constants.dart';
import 'package:meet_up_vor_2/api/api_client.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

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
  late final String profilePicUrlString;
  Future<User> _getUser(Token token) async {
    var userFuture;
    String tokenString = token.token;
    if (token.token == '123456789') {
      userFuture =
          await LoginProvider(Client().init()).getUserLocalJson() as User;
    } else {
      try {
        final response = await http
            .get(Uri.parse('http://ccproject.robertdoes.it/users'), headers: {
          "Content-Type": "application/json",
          "Charset": "utf-8",
          "Accept": "application/json",
          "Authorization": "Bearer $tokenString",
        });
        if (response.statusCode == 200) {
          String jsonsDataString = response.body.toString();
          print('FEEDBACK - JSON status code 200, data string: ' +
              jsonDecode(jsonsDataString).toString());
          userFuture = User.fromJson(json.decode(response.body.toString()));
        }
      } catch (err, stack) {
        logger.e("Login failed...", err, stack);
        throw err;
      }
    }
    return userFuture;
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
                widget.userFinal = snapshot.data as User;
              profilePicUrlString = widget.userFinal.profileImageUrl;
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
        backgroundColor: kMainPurple,
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 20.0),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                              new NetworkImage('https://$profilePicUrlString'),
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
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              /*'test',*/
                              widget.userFinal.displayName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24.0),
                            ),
                            Text(
                              widget.userFinal.name,
                            )
                          ],
                        ),
                      ],
                    ),
                    /*IconButton(
                      icon: Icon(
                        Icons.edit,
                        size: 20,
                      ),
                      onPressed: () {},
                      color: Colors.deepPurple,
                    ),*/
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                color: Colors.grey.shade300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Email address:',
                            style: TextStyle(fontStyle: FontStyle.italic)),
                        Text(widget.userFinal.email),
                      ],
                    ),
                    /*IconButton(
                      icon: Icon(
                        Icons.edit,
                        size: 20,
                      ),
                      onPressed: () {},
                      color: Colors.deepPurple,
                    ),*/
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                color: Colors.grey.shade300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Status:',
                            style: TextStyle(fontStyle: FontStyle.italic)),
                        Text(widget.userFinal.statusMessage),
                      ],
                    ),
                    /*IconButton(
                      icon: Icon(
                        Icons.edit,
                        size: 20,
                      ),
                      onPressed: () {},
                      color: Colors.deepPurple,
                    ),*/
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
                    onPressed: () {
                      Navigator.pushNamed(context, 'user_edit_profile',
                          arguments: [widget.token, widget.userFinal]);
                    },
                    child: Text(
                      "Edit profile",
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
                      // TODO log out
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
