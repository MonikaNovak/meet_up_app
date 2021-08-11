import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/Friend.dart';
import 'package:meet_up_vor_2/api/models/Group.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/api/models/UserGeneral.dart';
import 'package:meet_up_vor_2/constants.dart';

/// from database:
/// list of members of the group
/// action add member to friend list (later send friend request)

class GroupMembers extends StatefulWidget {
  late final Token token;
  late final User userFinal;
  late final String title;

  @override
  _GroupMembersState createState() => _GroupMembersState();
}

class _GroupMembersState extends State<GroupMembers> {
  late List<UserGeneral> _listOfMembers;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as List;
    widget.token = arguments[0];
    widget.userFinal = arguments[1];
    _listOfMembers = arguments[2];
    widget.title = arguments[3];
    //_buildList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 20.0),
        ),
        backgroundColor: kMainPurple,
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(0.0),
        itemCount: _listOfMembers.length,
        itemBuilder: (context, i) {
          return _buildRow(_listOfMembers[i]);
        },
      ),
    );
  }

  Widget _buildRow(UserGeneral member) {
    return new ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(member.profileImageUrl),
      ),
      title: new Text(
        member.displayName + ' (' + member.name + ')',
        style: _biggerFont,
      ),
      subtitle: new Text(member.statusMessage),
      /*trailing: (!_isInFriendList(member))
          ? TextButton(
              onPressed: () {
                final message = member.displayName +
                    ' (' +
                    member.name +
                    ') was added to your friendlist';
                final snackBar = SnackBar(
                  content: Text(
                    message,
                    style: TextStyle(fontSize: 15),
                  ),
                  backgroundColor: Colors.green.shade300,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Text('Add to friend list'),
            )
          : null,*/
      onTap: () {
        Friend generalUserAsFriend = new Friend(
            member.name,
            member.email,
            member.profileImageUrl,
            member.statusMessage,
            member.displayName,
            4);
        Navigator.pushNamed(context, 'friend_profile', arguments: [
          widget.token,
          generalUserAsFriend,
        ]);
      },
    );
  }

  /*_buildList() async {
    List<UserGeneral> listOfMembers = new List.empty(growable: true);
    try {
      listOfMembers = widget.group.members;
    } catch (exception) {
      print(exception.toString());
    }

    print('feedback - fetch friend list complete');
    _listOfMembers = listOfMembers;
  }*/
}
