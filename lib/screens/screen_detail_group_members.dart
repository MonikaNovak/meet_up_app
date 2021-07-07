import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/Friend.dart';
import 'package:meet_up_vor_2/api/models/User.dart';

/// from database:
/// list of members of the group
/// action add member to friend list (later send friend request)

class GroupMembers extends StatefulWidget {
  late final User userFinal;

  @override
  _GroupMembersState createState() => _GroupMembersState();
}

class _GroupMembersState extends State<GroupMembers> {
  late List<Friend> _listOfMembers;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    widget.userFinal = ModalRoute.of(context)!.settings.arguments as User;
    _buildList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Group details',
        ),
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
      trailing: (!_isInFriendList(friend))
          ? TextButton(
              onPressed: () {
                // TODO add friend
                final message = friend.displayName +
                    ' (' +
                    friend.name +
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
          : null,
      onTap: () {
        // TODO if in friend list view profile, else add as friend button (?)
        print('feedback - friendlist - set state - on tap of friend row');
        Navigator.pushNamed(context, 'friend_profile', arguments: [
          friend.profileImageUrl,
          friend.name,
          friend.displayName,
          friend.email,
          friend.statusMessage
        ]);
      },
    );
  }

  bool _isInFriendList(Friend friend) {
    // TODO check if in friend list
    return false;
  }

  _buildList() async {
    List<Friend> listOfMembers = new List.empty(growable: true);
    try {
      listOfMembers = widget.userFinal.friends;
    } catch (exception) {
      print(exception.toString());
    }

    print('feedback - fetch friend list complete');
    _listOfMembers = listOfMembers;
  }
}
