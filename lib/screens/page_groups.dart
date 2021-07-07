import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/Group.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/api/providers/LoginProvider.dart';
import 'package:meet_up_vor_2/api/api_client.dart';

/// from database:
/// list of groups

class GroupsPage extends StatefulWidget {
  late final Token token;
  GroupsPage(this.token);
  late final User userFinal;

  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
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

  final _biggerFont = const TextStyle(fontSize: 18.0);
  late List<Group> _listOfGroups;
  late List<Group> _listOfGroupsFiltered;
  TextEditingController searchController = new TextEditingController();

  Key _k2 = new GlobalKey();
  GlobalKey<FormState> _formKey2 = new GlobalKey<FormState>();

  final StreamController<List<Group>> _streamController =
      new StreamController();

  @override
  Widget build(BuildContext context) {
    print('feedback build page groups');
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
              print('feedback - groups page - building list...');
              _buildList();
              searchController.addListener(() {
                filterGroups();
              });
              return _buildWidget();
            }
        }
      },
    );
  }

  Widget _buildRow(Group group) {
    return new ListTile(
      leading: (group.groupImageUrl.length > 0)
          ? new CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: new NetworkImage(group.groupImageUrl),
            )
          : new CircleAvatar(
              backgroundColor: Colors.grey,
              child: Text(
                group.groupName[0],
                style: TextStyle(color: Colors.white),
              ),
              /*backgroundImage: AssetImage(kUserProfilePicAddress),*/
            ),
      title: new Text(
        group.groupName,
        style: _biggerFont,
      ),
      subtitle: new Text('Admin: ' + group.adminUsername),
      onTap: () {
        // TODO later only group
        Navigator.pushNamed(context, 'group_detail',
            arguments: [group, widget.userFinal]);
      },
    );
  }

  Widget _buildWidget() {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey2,
              child: TextField(
                key: _k2,
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
          StreamBuilder<List<Group>>(
              stream: _streamController.stream,
              initialData: _listOfGroupsFiltered,
              builder: (context, snapshot) {
                return Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0.0),
                    itemCount: _listOfGroupsFiltered.length,
                    itemBuilder: (context, i) {
                      return _buildRow(_listOfGroupsFiltered[i]);
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }

  _buildList() async {
    List<Group> listOfGroups = new List.empty(growable: true);
    try {
      listOfGroups = widget.userFinal.groups;
    } catch (exception) {
      print(exception.toString());
    }

    //setState(() {
    print('feedback - groups page - fetch friend list complete');
    _listOfGroups = listOfGroups;
    _listOfGroupsFiltered = listOfGroups;
    //});
  }

  filterGroups() {
    List<Group> _listOfGroupsLocal = [];
    _listOfGroupsLocal.addAll(_listOfGroups);
    if (searchController.text.isNotEmpty) {
      _listOfGroupsLocal.retainWhere((group) {
        String searchTerm = searchController.text.toLowerCase();
        // String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String groupName = group.groupName.toLowerCase();
        bool nameMatches = groupName.contains(searchTerm);

        if (nameMatches == true) {
          return true;
        }

        return false;
      });
    }
    _listOfGroupsFiltered = _listOfGroupsLocal;
    _streamController.sink.add(_listOfGroupsFiltered);
  }
}
