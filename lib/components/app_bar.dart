import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/api/providers/LoginProvider.dart';
import 'package:meet_up_vor_2/screens/screen_settings.dart';
import 'package:meet_up_vor_2/constants.dart';
import 'package:meet_up_vor_2/screens/screen_detail_user_profile.dart';
import 'package:meet_up_vor_2/api/api_client.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  late final User userFinal;
  late final Token token;

  MyAppBar(this.token);

  Future<User> _getUser(Token token) async {
    var userFuture;
    if (token.token == '123456789') {
      userFuture = await LoginProvider(Client().init()).login() as User;
    }
    return userFuture;
  }

  void _defineUser() async {
    userFinal = await _getUser(token);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    _defineUser();
    return FutureBuilder<User>(
        future: _getUser(token),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return AppBar(
                backgroundColor: Colors.deepPurple,
                leading: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError)
                return AppBar(
                  backgroundColor: Colors.deepPurple,
                  leading: Text('Error: ${snapshot.error}'),
                );
              else
                return AppBar(
                  backgroundColor: Colors.deepPurple,
                  title: Text(
                    'Meet up Vorarlberg',
                    style: TextStyle(fontSize: 15.0),
                  ),
                  actions: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'user_profile',
                            arguments: token);
                        /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserProfileScreen()));*/
                      },
                      icon: CircleAvatar(
                        radius: 50.0,
                        backgroundImage:
                            new NetworkImage(userFinal.profilImage),
                      ),
                      /*Image.asset(kUserProfilePicAddress),*/
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingsScreen()));
                        },
                        icon: Icon(Icons.settings)),
                  ],
                );
          }
        });
  }
}
