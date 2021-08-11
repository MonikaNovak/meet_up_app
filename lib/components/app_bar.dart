import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/api/providers/LoginProvider.dart';
import 'package:meet_up_vor_2/screens/screen_settings.dart';
import 'package:meet_up_vor_2/constants.dart';
import 'package:meet_up_vor_2/screens/screen_user_profile.dart';
import 'package:meet_up_vor_2/api/api_client.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  late final User userFinal;
  late final Token token;
  late final String profilePicUrlString;

  MyAppBar(this.token);

  Future<User> _getUser(Token token) async {
    var userFuture;
    String tokenString = token.token;
    if (token.token == '123456789') {
      userFuture =
          await LoginProvider(Client().init()).getUserLocalJson() as User;
    } else {
      try {
        final response = await http
            .get(Uri.parse('http://ccproject.robertdoes.it/users'), headers: {
          "Content-Type": "application/json",
          "Charset": "utf-8",
          "Accept": "application/json",
          "Authorization": "Bearer $tokenString",
        });
        if (response.statusCode == 200) {
          String jsonsDataString = response.body.toString();
          print('FEEDBACK appbar - JSON status code 200, data string: ' +
              jsonDecode(jsonsDataString).toString());
          userFuture = User.fromJson(json.decode(response.body.toString()));
        }
      } catch (err, stack) {
        logger.e("Login failed...", err, stack);
        throw err;
      }
    }
    return userFuture;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
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
                userFinal = snapshot.data as User;
              profilePicUrlString = userFinal.profileImageUrl;
              return AppBar(
                backgroundColor: kMainPurple,
                leading: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ImageIcon(
                    AssetImage('images/logo_meetup_inverted.png'),
                  ),
                ),
                /*leading: IconButton(
                    color: Colors.transparent,
                    onPressed: () {},
                    icon: CircleAvatar(
                      radius: 50.0,
                      backgroundImage:
                          AssetImage('images/logo_meetup_inverted.png'),
                    ),
                    */ /*Image.asset(kUserProfilePicAddress),*/ /*
                  ),*/
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
                          new NetworkImage('https://$profilePicUrlString'),
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
