import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/Friend.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/api/api_client.dart';
import 'package:meet_up_vor_2/api/providers/LoginProvider.dart';

/// from database:
/// search through users by username or email address
/// add user to friend list (later send friend request)

class AddFriend extends StatefulWidget {
  late final Token token;
  late final User userFinal;
  @override
  _AddFriendState createState() => _AddFriendState();

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
}

class _AddFriendState extends State<AddFriend> {
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

  String usernameToSearch = '';
  String emailToSearch = '';
  bool isFriendFound = false;
  late Friend searchedFriend;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  final StreamController<Friend> _streamControllerSearchedFriend =
      StreamController();

  @override
  Widget build(BuildContext context) {
    widget.token = ModalRoute.of(context)!.settings.arguments as Token;
    _defineUser();
    return FutureBuilder<User>(
        future: _getUser(widget.token),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('loading...');
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                print('feedback - build add friend in build, user: ' +
                    widget.userFinal.name);
              return _buildWidget();
          }
        });
  }

  _buildWidget() {
    print('feedback - building _buildWidget in add friend');
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Add a friend',
          style: TextStyle(fontSize: 15.0),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: <Widget>[
                Text('Search friend:'),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  initialValue: 'barretoo',
                  key: widget._formKey1,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'by username',
                    labelStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  onChanged: (value) {
                    usernameToSearch = value.toLowerCase();
                    print(usernameToSearch);
                  },
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextButton(
                  child: Text('Search by username'),
                  onPressed: () {
                    print('feedback - run fetch friend in add friend');
                    print('feedback - usernameToSearch = ' + usernameToSearch);
                    _fetchSearchedFriend();
                  },
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  key: widget._formKey2,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'by email',
                    labelStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  onChanged: (value) {
                    emailToSearch = value.toLowerCase();
                    print(emailToSearch);
                  },
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextButton(
                  child: Text('Search by email'),
                  onPressed: () {
                    _fetchSearchedFriend();
                  },
                ),
                StreamBuilder<Friend>(
                    stream: _streamControllerSearchedFriend.stream,
                    builder: (context, snapshot) {
                      if (isFriendFound)
                        return Container(
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      searchedFriend.profileImageUrl),
                                ),
                                title: new Text(
                                  searchedFriend.displayName +
                                      ' (' +
                                      searchedFriend.name +
                                      ')',
                                  style: _biggerFont,
                                ),
                                subtitle:
                                    new Text(searchedFriend.statusMessage),
                              ),
                              TextButton(
                                  onPressed: () {
                                    if (isFriendFound) {
                                      // TODO add user to friend list
                                      final message =
                                          searchedFriend.displayName +
                                              ' (' +
                                              searchedFriend.name +
                                              ') was added to your friendlist';
                                      final snackBar = SnackBar(
                                        content: Text(
                                          message,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        backgroundColor: Colors.green.shade300,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  child: Text('Add to friend list'))
                            ],
                          ),
                        );
                      else
                        return Container(
                          child: (usernameToSearch.length == 0 &&
                                  emailToSearch.length == 0)
                              ? Text('')
                              : Text(
                                  'no user found',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.red,
                                  ),
                                ),
                        );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _fetchSearchedFriend() {
    // TODO should it be async and awaiting the list?
    List<Friend> listOfUsers = new List.empty(growable: true);
    try {
      listOfUsers = widget.userFinal.friends;
    } catch (exception) {
      print(exception.toString());
    }
    isFriendFound = false;

    listOfUsers.forEach((element) {
      if (isFriendFound) {
        return;
      }
      print('feedback - user from list username: ' + element.name);
      if (element.name == usernameToSearch || element.email == emailToSearch) {
        searchedFriend = element;
        isFriendFound = true;
        print('feedback -  isFriendFound:');
        print(isFriendFound);
        _streamControllerSearchedFriend.sink.add(searchedFriend);
      } else {
        isFriendFound = false;
        searchedFriend = new Friend(
            'name', 'email', 'profileImageUrl', 'statusMessage', 'displayName');
        _streamControllerSearchedFriend.sink.add(searchedFriend);
      }
    });
  }
}
