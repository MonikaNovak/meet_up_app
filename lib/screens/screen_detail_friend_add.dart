import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/Friend.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/models/UserGeneral.dart';
import '../constants.dart';

/// from database:
/// search through users by username or email address
/// add user to friend list (later send friend request)
/// TODO request search user by username (with token)
/// TODO request search user by email (with token)

class AddFriend extends StatefulWidget {
  @override
  _AddFriendState createState() => _AddFriendState();

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
}

class _AddFriendState extends State<AddFriend> {
  String usernameToSearch = '';
  String emailToSearch = '';
  bool isFriendFound = false;
  late UserGeneral searchedFriend;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  String requestSent = '';
  late final List<UserGeneral> _listOfUsers;
  late final Token token;

  //
  //
  // hardcoded lists:
  Future<List<UserGeneral>> _hardcodeListOfUsers() async {
    List<UserGeneral> listOfUsers = new List.empty(growable: true);
    // status 0 = pending, 1 = accepted, 2 = declined or no action yet - is actually necessary?, 3 = waiting for accept or decline
    UserGeneral friend1 = new UserGeneral(
        'leonido24',
        'leon.barrett@example.com',
        'https://randomuser.me/api/portraits/men/29.jpg',
        'I like lemon ice-cream.',
        'Leon');
    UserGeneral friend2 = new UserGeneral(
        'ramanid',
        'ramon.peck@example.com',
        'https://randomuser.me/api/portraits/men/6.jpg',
        'I like chocolate ice-cream.',
        'Ramon');
    UserGeneral friend3 = new UserGeneral(
        'rossalinda',
        'ross.bryant@example.com',
        'https://randomuser.me/api/portraits/women/99.jpg',
        'I like strawberry ice-cream.',
        'Rossi');
    UserGeneral friend4 = new UserGeneral(
        'barretoo',
        'leon.barrett@example.com',
        'https://randomuser.me/api/portraits/men/62.jpg',
        'I like cherry ice-cream.',
        'Barret');
    UserGeneral friend5 = new UserGeneral(
        'pickle',
        'ramon.peck@example.com',
        'https://randomuser.me/api/portraits/women/85.jpg',
        'I like vanilla ice-cream.',
        'Pecky');
    UserGeneral friend6 = new UserGeneral(
        'bumblebee',
        'ross.bryant@example.com',
        'https://randomuser.me/api/portraits/men/47.jpg',
        'I like ginger ice-cream.',
        'Bryant');
    listOfUsers.add(friend1);
    listOfUsers.add(friend2);
    listOfUsers.add(friend3);
    listOfUsers.add(friend4);
    listOfUsers.add(friend5);
    listOfUsers.add(friend6);
    return listOfUsers;
  }
  //
  //
  //

  final StreamController<UserGeneral> _streamControllerSearchedFriend =
      StreamController();
  final StreamController<String> _streamControllerRequestSend =
      StreamController();

  @override
  Widget build(BuildContext context) {
    token = ModalRoute.of(context)!.settings.arguments as Token;
    return FutureBuilder<List<UserGeneral>>(
        future: _hardcodeListOfUsers(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                _listOfUsers = snapshot.data as List<UserGeneral>;
              return _buildWidget();
          }
        });
  }

  _buildWidget() {
    print('feedback - building _buildWidget in add friend');
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: kMainPurple,
          title: Text(
            'Add a friend',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        body: SafeArea(
          minimum: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Search friend',
                      textAlign: TextAlign.left,
                      style: kTextStyleItalic,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    // initialValue: 'barretoo',
                    key: widget._formKey1,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: '...by username',
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
                    child: Text(
                      'Search by username',
                    ),
                    onPressed: () {
                      // TODO request search user by username (with token)
                      FocusManager.instance.primaryFocus?.unfocus();
                      print('feedback - run fetch friend in add friend');
                      print(
                          'feedback - usernameToSearch = ' + usernameToSearch);
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
                      labelText: '...by email',
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
                    child: Text(
                      'Search by email',
                    ),
                    onPressed: () {
                      // TODO request search user by email (with token)
                      FocusManager.instance.primaryFocus?.unfocus();
                      _fetchSearchedFriend();
                    },
                  ),
                  StreamBuilder<UserGeneral>(
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
                                  onTap: () {
                                    Friend generalUserAsFriend = new Friend(
                                        searchedFriend.name,
                                        searchedFriend.email,
                                        searchedFriend.profileImageUrl,
                                        searchedFriend.statusMessage,
                                        searchedFriend.displayName,
                                        4);
                                    Navigator.pushNamed(
                                        context, 'friend_profile',
                                        arguments: [
                                          token,
                                          generalUserAsFriend,
                                        ]);
                                  },
                                ),
                                StreamBuilder<String>(
                                    stream: _streamControllerRequestSend.stream,
                                    builder: (context, snapshot) {
                                      if (requestSent == '') {
                                        return TextButton(
                                          onPressed: () {
                                            requestSent = 'Friend request sent';
                                            _streamControllerRequestSend.sink
                                                .add(requestSent);
                                            if (isFriendFound) {
                                              // TODO request add user to a friend list (with token)
                                              final message =
                                                  'Friend request sent to: ' +
                                                      searchedFriend
                                                          .displayName +
                                                      ' (' +
                                                      searchedFriend.name +
                                                      ')';
                                              final snackBar = SnackBar(
                                                content: Text(
                                                  message,
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                backgroundColor:
                                                    Colors.green.shade300,
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          },
                                          child: Text(
                                            'Send friend request',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          style: kFilledButtonStyle,
                                        );
                                      } else {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.check,
                                              color: Colors.lightGreen,
                                            ),
                                            Text(
                                              'Friend request sent.',
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Colors.deepPurple.shade300,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }),
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
      ),
    );
  }

  _fetchSearchedFriend() {
    // TODO should it be async and awaiting the list? maybe not since we get the list on build
    List<UserGeneral> listOfUsers = new List.empty(growable: true);
    try {
      listOfUsers = _listOfUsers;
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
        searchedFriend = new UserGeneral(
            'name', 'email', 'profileImageUrl', 'statusMessage', 'displayName');
        _streamControllerSearchedFriend.sink.add(searchedFriend);
      }
    });
  }

  /*_fetchSearchedFriend() {
    // TODO should it be async and awaiting the list? maybe not since we get the list on build
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
        searchedFriend = new Friend('name', 'email', 'profileImageUrl',
            'statusMessage', 'displayName', 1);
        _streamControllerSearchedFriend.sink.add(searchedFriend);
      }
    });
  }*/
}
