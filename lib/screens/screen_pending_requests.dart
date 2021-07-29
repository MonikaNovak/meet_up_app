import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/Friend.dart';

class PendingRequests extends StatefulWidget {
  const PendingRequests({Key? key}) : super(key: key);

  @override
  _PendingRequestsState createState() => _PendingRequestsState();
}

class _PendingRequestsState extends State<PendingRequests> {
  late List<Friend> _listOfFriendsPending;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    // _listOfFriendsPending = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pending friend requests',
        ),
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
}
