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
    if (token.token == '123456789') {
      userFuture = await LoginProvider(Client().init()).login() as User;
    }
    return userFuture;
  }

  void _defineUser() async {
    widget.userFinal = await _getUser(widget.token);
  }

  //friend list data
  bool _isProgressBarShown = true;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  late List<Friend> _listOfFriends;
  late List<Friend> _listOfFriendsFiltered;
  TextEditingController searchController = new TextEditingController();

  Key _k1 = new GlobalKey();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final StreamController<List<Friend>> _streamController = StreamController();

  @override
  Widget build(BuildContext context) {
    _defineUser();
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
              print('feedback - build friends page in build, user: ' +
                  widget.userFinal.name);
              _buildList();
              searchController.addListener(() {
                filterFriends();
              });
              return _buildWidget(isSearching);
            }
        }
      },
    );
  }

  Widget _buildWidget(bool isSearching) {
    print('feedback - rebuilding whole buildWidget (including search bar)');
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
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
              }),
          /*StreamBuilder<List<Friend>>(
              stream: _streamController.stream,
              initialData: _listOfFriends,
              builder: (context, snapshot) {
                return Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0.0),
                    itemCount: isSearching == true
                        ? _listOfFriendsFiltered.length
                        : _listOfFriends.length,
                    itemBuilder: (context, i) {
                      return isSearching == true
                          ? _buildRow(_listOfFriendsFiltered[i])
                          : _buildRow(_listOfFriends[i]);
                    },
                  ),
                );
              }),*/
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
        setState(() {
          print('feedback - friendlist - set state - on tap of friend row');
          Navigator.pushNamed(context, 'friend_profile', arguments: [
            friend.profileImageUrl,
            friend.name,
            friend.displayName,
            friend.email,
            friend.statusMessage
          ]);
        });
      },
    );
  }

  _buildList() async {
    List<Friend> listOfFriends = new List.empty(growable: true);
    try {
      listOfFriends = widget.userFinal.friends;
    } catch (exception) {
      print(exception.toString());
    }

    print('feedback - fetch friend list complete');
    _listOfFriends = listOfFriends;
    _listOfFriendsFiltered = listOfFriends;
    _isProgressBarShown = false;
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
