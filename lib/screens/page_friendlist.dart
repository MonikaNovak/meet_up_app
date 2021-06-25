import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meet_up_vor_2/api/models/Friend.dart';

import '../constants.dart';

class PeoplePage extends StatefulWidget {
  @override
  _PeoplePageState createState() => new _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  //friend list data
  bool _isProgressBarShown = true;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  late List<FriendsModel> _listFriends;

  @override
  void initState() {
    super.initState();
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
          itemCount: _listFriends.length,
          itemBuilder: (context, i) {
            return _buildRow(_listFriends[i]);
          });
    }

    return Scaffold(
      body: widget,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO add friend
        },
      ),
      /*body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Container(
              child: Text('Friend1'),
            ),
            Container(
              child: Text('Friend2'),
            ),
          ],
        ),
      ),*/
    );
  }

  Widget _buildRow(FriendsModel friendsModel) {
    return new ListTile(
/*      leading: new CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: new NetworkImage(friendsModel.profileImageUrl),
      ),*/
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
          // todo open friend profile
        });
      },
    );
  }

  _fetchFriendsList() async {
    _isProgressBarShown = true;
    var url = 'https://randomuser.me/api/?results=10&nat=us';
    var httpClient = new HttpClient();

    List<FriendsModel> listFriends = new List.empty(growable: true);
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
          FriendsModel friendsModel =
              new FriendsModel(name, res['email'], profileUrl);
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
      _listFriends = listFriends;
      _isProgressBarShown = false;
    });
  }

  /*_fetchFriendsList() async {
    _isProgressBarShown = true;
    var url = 'https://randomuser.me/api/?results=100&nat=us';
    var httpClient = new HttpClient();

    List<FriendsModel> listFriends = new List.empty(growable: true);
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.accepted) {
        var json = await response.transform(utf8.decoder).join();
        Map data = jsonDecode(json);

        for (var res in data['results']) {
          var objName = res['name'];
          String name =
              objName['first'].toString() + " " + objName['last'].toString();

          var objImage = res['picture'];
          String profileUrl = objImage['large'].toString();
          FriendsModel friendsModel =
          new FriendsModel(name, res['email'], profileUrl);
          listFriends.add(friendsModel);
          print(friendsModel.profileImageUrl);
        }
      }
    } catch (exception) {
      print(exception.toString());
    }

    if (!mounted) return;

    setState(() {
      _listFriends = listFriends;
      _isProgressBarShown = false;
    });
  }*/
}
