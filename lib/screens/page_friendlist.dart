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

class PeoplePage extends StatefulWidget {
  late final Token token;
  PeoplePage(this.token);
  late final User userFinal;

  @override
  _PeoplePageState createState() => new _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
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

/*  @override
  void initState() {
    super.initState();
    _fetchFriendsList();
  }*/

  @override
  Widget build(BuildContext context) {
    _defineUser();
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
              _buildList();
              return _buildWidget();
            }
        }
      },
    );
  }

  Widget _buildWidget() {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              hintText: 'Search friend...',
              prefixIcon: Icon(Icons.search),
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.green, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.green, width: 2),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(0.0),
              itemCount: _listOfFriends.length,
              itemBuilder: (context, i) {
                return _buildRow(_listOfFriends[i]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // TODO add friend
        },
      ),
    );
  }

  Widget _buildRow(Friend friend) {
    return new ListTile(
      leading: (friend.profileImageUrl.length > 0)
          ? new CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: new NetworkImage(friend.profileImageUrl),
            )
          : new CircleAvatar(
              backgroundColor: Colors.grey,
              child: Text(
                friend.name[0],
                style: TextStyle(color: Colors.white),
              ),
              /*backgroundImage: AssetImage(kUserProfilePicAddress),*/
            ),
      title: new Text(
        friend.name,
        style: _biggerFont,
      ),
      subtitle: new Text(friend.status),
      onTap: () {
        setState(() {
          Navigator.pushNamed(context, 'friend_profile', arguments: [
            friend.profileImageUrl,
            friend.name,
            friend.email,
            friend.status
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

    setState(() {
      print('fetch friend list complete');
      _listOfFriends = listOfFriends;
      _isProgressBarShown = false;
    });
  }

  _fetchFriendsList() async {
    _isProgressBarShown = true;

    List<Friend> listOfFriends = new List.empty(growable: true);
    try {
      listOfFriends = widget.userFinal.friends;
    } catch (exception) {
      print(exception.toString());
    }

    if (!mounted) return;

    setState(() {
      print('fetch friend list complete');
      _listOfFriends = listOfFriends;
      _isProgressBarShown = false;
    });
  }
}

// ---------------------backup--------------------
/*class PeoplePage extends StatefulWidget {
  late final Token token;
  PeoplePage(this.token);

  late final User userFinal;

  @override
  _PeoplePageState createState() => new _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  Future<User?> _getUser(Token token) async {
    if (token.token == '123456789') {
      var userFinal = await LoginProvider(Client().init()).login();
      return userFinal;
    }
  }

  void _defineUser() async {
    widget.userFinal = await _getUser(widget.token) as User;
  }

  //friend list data
  bool _isProgressBarShown = true;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  late List<Friend> _listOfFriends;

  @override
  void initState() {
    super.initState();
    _defineUser();
    print('feedback get user: ' + widget.userFinal.statusMessage);
    _fetchFriendsList();
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;

    if (_isProgressBarShown) {
      widget = new Center(
          child: new Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: new CircularProgressIndicator()));
    } else {
      widget = new ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(0.0),
          itemCount: _listOfFriends.length,
          itemBuilder: (context, i) {
            return _buildRow(_listOfFriends[i]);
          });
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              hintText: 'Search friend...',
              prefixIcon: Icon(Icons.search),
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.green, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.green, width: 2),
              ),
            ),
          ),
          Expanded(child: widget),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // TODO add friend
        },
      ),
    );
  }

  Widget _buildRow(Friend friend) {
    return new ListTile(
      leading: (friend.profileImageUrl.length > 0)
          ? new CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: new NetworkImage(friend.profileImageUrl),
      )
          : new CircleAvatar(
        backgroundColor: Colors.grey,
        child: Text(
          friend.name[0],
          style: TextStyle(color: Colors.white),
        ),
        */ /*backgroundImage: AssetImage(kUserProfilePicAddress),*/ /*
      ),
      title: new Text(
        friend.name,
        style: _biggerFont,
      ),
      subtitle: new Text(friend.status),
      onTap: () {
        setState(() {
          Navigator.pushNamed(context, 'friend_profile', arguments: [
            friend.profileImageUrl,
            friend.name,
            friend.email,
            friend.status
          ]);
        });
      },
    );
  }

  _fetchFriendsList() async {
    _isProgressBarShown = true;

    List<Friend> listOfFriends = new List.empty(growable: true);
    try {
      listOfFriends = widget.userFinal.friends;
    } catch (exception) {
      print(exception.toString());
    }

    if (!mounted) return;

    setState(() {
      print('fetch friend list complete');
      _listOfFriends = listOfFriends;
      _isProgressBarShown = false;
    });
  }
}*/
// ---------------------backup-----------------------

// from randomuser.com
/*_fetchFriendsList() async {
    _isProgressBarShown = true;
    var url = 'https://randomuser.me/api/?results=10&nat=us';
    var httpClient = new HttpClient();

    List<Friend> listFriends = new List.empty(growable: true);
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      // request.headers.contentType = ContentType.json;  // only for PUT oder POST
      // request.headers.add(HttpHeaders.authorizationHeader, 'myMagicToken');
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var jsonString = await response.transform(utf8.decoder).join();
        Map data = json.decode(jsonString);

        print('feedback ' + data['results'].length.toString());

        for (var res in data['results']) {
          var objName = res['name'];

          String name =
              objName['first'].toString() + " " + objName['last'].toString();

          var objImage = res['picture'];
          String profileUrl = objImage['large'].toString();
          Friend friendsModel = new Friend(name, res['email'], profileUrl);
          listFriends.add(friendsModel);
          print(friendsModel.profileImageUrl);
        }
      } else {
        print('response not valid' + response.statusCode.toString());
      }
    } catch (exception) {
      print(exception.toString());
    }

    if (!mounted) return;

    setState(() {
      print('fetch friend list complete');
      _listOfFriends = listFriends;
      _isProgressBarShown = false;
    });
  }*/

/*Widget _buildRow(Friend friendsModel) {
    return new ListTile(
*/ /*      leading: new CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: new NetworkImage(friendsModel.profileImageUrl),
      ),*/ /*
      leading: (friendsModel.profileImageUrl.length > 0)
          ? new CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: new NetworkImage(friendsModel.profileImageUrl),
            )
          : new CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: AssetImage(kUserProfilePicAddress),
            ),
      title: new Text(
        friendsModel.name,
        style: _biggerFont,
      ),
      subtitle: new Text(friendsModel.email),
      onTap: () {
        setState(() {
          Navigator.pushNamed(context, 'friend_profile');
        });
      },
    );
  }*/
