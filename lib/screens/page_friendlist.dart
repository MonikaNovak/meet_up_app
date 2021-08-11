import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meet_up_vor_2/api/models/Friend.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/api/providers/LoginProvider.dart';
import 'package:meet_up_vor_2/api/api_client.dart';
import '../constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../main.dart';

/// from database:
/// list of friends

// TODO display users with requested friendship
// TODO display someone pending request from another user
// TODO list of friend only with accepted status

class FriendListPage extends StatefulWidget {
  late final Token token;
  FriendListPage(this.token);
  late final User userFinal;

  @override
  _FriendListPageState createState() => new _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
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
          print('FEEDBACK friendpage - JSON status code 200, data string: ' +
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

  void _getFriendsFromDatabase(Token token) async {
    var listOfFriends;
    String tokenString = token.token;
    try {
      final response = await http
          .get(Uri.parse('http://ccproject.robertdoes.it/friends'), headers: {
        "Content-Type": "application/json",
        "Charset": "utf-8",
        "Accept": "application/json",
        "Authorization": "Bearer $tokenString",
      });
      if (response.statusCode == 200) {
        String jsonsDataString = response.body.toString();
        print('FEEDBACK - JSON status code 200, list of friends: ' +
            jsonDecode(jsonsDataString).toString());
      }
    } catch (err, stack) {
      logger.e("Login failed...", err, stack);
      throw err;
    }
  }

  //
  //
  // hardcoded lists:
  List<Friend> _hardcodeListOfFriends() {
    List<Friend> listOfFriends = new List.empty(growable: true);
    // status 0 = pending, 1 = accepted, 2 = declined or no action yet - is actually necessary?, 3 = waiting for accept or decline
    Friend friend1 = new Friend(
        'leonido24',
        'leon.barrett@example.com',
        'https://randomuser.me/api/portraits/men/29.jpg',
        'I like lemon ice-cream.',
        'Leon',
        0);
    Friend friend2 = new Friend(
        'ramanid',
        'ramon.peck@example.com',
        'https://randomuser.me/api/portraits/men/6.jpg',
        'I like chocolate ice-cream.',
        'Ramon',
        0);
    Friend friend3 = new Friend(
        'rossalinda',
        'ross.bryant@example.com',
        'https://randomuser.me/api/portraits/women/99.jpg',
        'I like strawberry ice-cream.',
        'Rossi',
        1);
    Friend friend4 = new Friend(
        'barretoo',
        'leon.barrett@example.com',
        'https://randomuser.me/api/portraits/men/62.jpg',
        'I like cherry ice-cream.',
        'Barret',
        1);
    Friend friend5 = new Friend(
        'pickle',
        'ramon.peck@example.com',
        'https://randomuser.me/api/portraits/women/85.jpg',
        'I like vanilla ice-cream.',
        'Pecky',
        1);
    Friend friend6 = new Friend(
        'bumblebee',
        'ross.bryant@example.com',
        'https://randomuser.me/api/portraits/men/47.jpg',
        'I like ginger ice-cream.',
        'Bryant',
        3);
    listOfFriends.add(friend1);
    listOfFriends.add(friend2);
    listOfFriends.add(friend3);
    listOfFriends.add(friend4);
    listOfFriends.add(friend5);
    listOfFriends.add(friend6);
    return listOfFriends;
  }
  //
  //
  //

  //friend list data
  bool _isProgressBarShown = true;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  late List<Friend> _listOfFriends;
  late List<Friend> _listOfFriendsPending;
  late List<Friend> _listOfFriendsFiltered;
  TextEditingController searchController = new TextEditingController();

  Key _k1 = new GlobalKey();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final StreamController<List<Friend>> _streamController = StreamController();

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return FutureBuilder<User>(
      future: _getUser(widget.token),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            /*return Text('loading...');*/
            return Center(
                child: new Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: new CircularProgressIndicator()));
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else {
              // widget.userFinal = snapshot.data as User;
              _buildList();
              searchController.addListener(() {
                filterFriends();
              });
              _getFriendsFromDatabase(widget.token);
              return _buildWidget(isSearching);
            }
        }
      },
    );
  }

  Widget _buildWidget(bool isSearching) {
    print(
        'feedback friendlistpage - rebuilding whole buildWidget (including search bar)');
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, 'pending_requests',
                  arguments: [_listOfFriendsPending, widget.token]);
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Pending requests',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                  Icon(Icons.arrow_right, color: Colors.deepPurple),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
            child: Form(
              key: _formKey,
              child: TextField(
                key: _k1,
                controller: searchController,
                decoration: InputDecoration(
                    labelText: 'Search',
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: Theme.of(context).primaryColor)),
                    prefixIcon: Icon(Icons.search,
                        color: Theme.of(context).primaryColor)),
              ),
            ),
          ),
          StreamBuilder<List<Friend>>(
              stream: _streamController.stream,
              initialData: _listOfFriendsFiltered,
              builder: (context, snapshot) {
                if (_listOfFriendsFiltered.length == 0) {
                  return Text(
                    'No friend found.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  );
                } else {
                  return Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0.0),
                      itemCount: _listOfFriendsFiltered.length,
                      itemBuilder: (context, i) {
                        return _buildRow(_listOfFriendsFiltered[i]);
                      },
                    ),
                  );
                }
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, 'add_friend', arguments: widget.token);
        },
      ),
    );
  }

  Widget _buildRow(Friend friend) {
    return new ListTile(
      leading: CircleAvatar(
        // backgroundImage: CachedNetworkImageProvider(friend.profileImageUrl), TODO why is not working???
        backgroundImage: NetworkImage(friend.profileImageUrl),
      ),
      title: new Text(
        friend.displayName + ' (' + friend.name + ')',
        style: _biggerFont,
      ),
      subtitle: new Text(friend.statusMessage),
      onTap: () {
        Navigator.pushNamed(context, 'friend_profile', arguments: [
          widget.token,
          friend,
        ]);
        /*Navigator.pushNamed(context, 'friend_profile', arguments: [
          friend.profileImageUrl,
          friend.name,
          friend.displayName,
          friend.statusMessage,
          widget.token,
          false // friendToAdd
        ]);*/
      },
    );
  }

  _buildList() async {
    List<Friend> listOfFriendsAll = new List.empty(growable: true);
    List<Friend> listOfFriends = new List.empty(growable: true);
    List<Friend> listOfFriendsPending = new List.empty(growable: true);
    try {
      // listOfFriends = widget.userFinal.friends;
      listOfFriendsAll = _hardcodeListOfFriends();
    } catch (exception) {
      print(exception.toString());
    }

    // print('feedback - fetch friend list complete');
    // _listOfFriends = listOfFriends;
    listOfFriendsAll.forEach((element) {
      if (element.status == 1) {
        listOfFriends.add(element);
      } else if (element.status == 0 || element.status == 3) {
        listOfFriendsPending.add(element);
      }
    });
    _listOfFriends = listOfFriends;
    _listOfFriendsPending = listOfFriendsPending;
    _listOfFriendsFiltered = listOfFriends;
    _isProgressBarShown = false;

    /*_listOfFriends.forEach((element) {
      if (element.status == 0) {
        listOfFriendsPending.add(element);
      }
    });
    _listOfFriendsPending = listOfFriendsPending;*/
  }

  filterFriends() {
    List<Friend> _listOfFriendsLocal = [];
    _listOfFriendsLocal.addAll(_listOfFriends);
    if (searchController.text.isNotEmpty) {
      _listOfFriendsLocal.retainWhere((friend) {
        String searchTerm = searchController.text.toLowerCase();
        // String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String friendName = friend.displayName.toLowerCase();
        String friendUserName = friend.name.toLowerCase();
        bool nameMatches = friendName.contains(searchTerm);
        bool userNameMatches = friendUserName.contains(searchTerm);

        if (nameMatches == true) {
          return true;
        }

        if (userNameMatches == true) {
          return true;
        }

        return false;
      });
    }
    print('feedback - friendlist - filter friends');
    _listOfFriendsFiltered = _listOfFriendsLocal;
    _listOfFriendsFiltered
        .forEach((element) => print('from friend list: ' + element.name));
    _streamController.sink.add(_listOfFriendsFiltered);
  }
}
