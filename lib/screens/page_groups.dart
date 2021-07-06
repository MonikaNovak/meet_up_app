import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/Group.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/api/providers/LoginProvider.dart';
import 'package:meet_up_vor_2/api/api_client.dart';

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
        setState(() {
          Navigator.pushNamed(context, 'group_detail', arguments: widget.token);
        });
      },
    );
  }

  _buildList() async {
    List<Group> listOfGroups = new List.empty(growable: true);
    try {
      listOfGroups = widget.userFinal.groups;
    } catch (exception) {
      print(exception.toString());
    }

    setState(() {
      print('fetch friend list complete');
      _listOfGroups = listOfGroups;
    });
  }

  Widget _buildWidget() {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              hintText: 'Search group...',
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
              itemCount: _listOfGroups.length,
              itemBuilder: (context, i) {
                return _buildRow(_listOfGroups[i]);
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
}
