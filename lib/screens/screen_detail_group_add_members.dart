import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/Friend.dart';

import '../constants.dart';

class GroupAddMembers extends StatefulWidget {
  @override
  _GroupAddMembersState createState() => _GroupAddMembersState();
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

class _GroupAddMembersState extends State<GroupAddMembers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: kMainPurple,
        title: Text(
          'Create new group',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      body: Container(),
    );
  }
}
