import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/screens/screen_settings.dart';
import 'package:meet_up_vor_2/constants.dart';
import 'package:meet_up_vor_2/screens/screen_detail_user_profile.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  late final User userFinal;

  MyAppBar(this.userFinal);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.deepPurple,
      title: Text(
        'Meet up Vorarlberg',
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, 'user_profile', arguments: userFinal);
            /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserProfileScreen()));*/
          },
          icon: CircleAvatar(
            radius: 50.0,
            backgroundImage: new NetworkImage(userFinal.avatarUrl),
          ),
          /*Image.asset(kUserProfilePicAddress),*/
        ),
        IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
            icon: Icon(Icons.settings)),
      ],
    );
  }
}
