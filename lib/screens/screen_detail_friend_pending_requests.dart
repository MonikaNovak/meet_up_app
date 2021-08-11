import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/Friend.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/constants.dart';

class PendingRequests extends StatefulWidget {
  const PendingRequests({Key? key}) : super(key: key);

  @override
  _PendingRequestsState createState() => _PendingRequestsState();
}

class _PendingRequestsState extends State<PendingRequests> {
  late List<Friend> _listOfFriendsPending;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  late final Token token;

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as List;
    _listOfFriendsPending = arguments[0];
    token = arguments[1];
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Pending friend requests',
        ),
        backgroundColor: kMainPurple,
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(0.0),
        itemCount: _listOfFriendsPending.length,
        itemBuilder: (context, i) {
          return _buildRow(_listOfFriendsPending[i]);
        },
      ),
    );
  }

  Widget _buildRow(Friend friend) {
    late ListTile tile;
    if (friend.status == 0) {
      tile = ListTile(
        leading: CircleAvatar(
          // backgroundImage: CachedNetworkImageProvider(friend.profileImageUrl), TODO why is not working???
          backgroundImage: NetworkImage(friend.profileImageUrl),
        ),
        title: new Text(
          friend.displayName + ' (' + friend.name + ')',
          style: _biggerFont,
        ),
        trailing: Text(
          'Reguest sent',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.lightGreen,
          ),
        ),
        subtitle: new Text(friend.statusMessage),
        onTap: () {
          // TODO if in friend list view profile, else add as friend button (?)
          print('feedback - friendlist - set state - on tap of friend row');
          Navigator.pushNamed(context, 'friend_profile',
              arguments: [token, friend]);
        },
      );
    } else {
      tile = ListTile(
        leading: CircleAvatar(
          // backgroundImage: CachedNetworkImageProvider(friend.profileImageUrl), TODO why is not working???
          backgroundImage: NetworkImage(friend.profileImageUrl),
        ),
        title: new Text(
          friend.displayName + ' (' + friend.name + ')',
          style: _biggerFont,
        ),
        trailing: Text(
          'Accept friend\n request?',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.deepPurple,
          ),
        ),
        subtitle: new Text(friend.statusMessage),
        onTap: () {
          Navigator.pushNamed(context, 'friend_profile', arguments: [
            token,
            friend,
          ]);
        },
      );
    }
    return tile;
  }
}
