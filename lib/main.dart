import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/screens/page_home.dart';
import 'package:meet_up_vor_2/screens/screen_detail_event.dart';
import 'package:meet_up_vor_2/screens/screen_detail_group.dart';
import 'package:meet_up_vor_2/screens/screen_detail_group_members.dart';
import 'package:meet_up_vor_2/screens/screen_main.dart';
import 'package:meet_up_vor_2/screens/page_friendlist.dart';
import 'package:meet_up_vor_2/screens/screen_register.dart';
import 'package:meet_up_vor_2/screens/screen_settings.dart';
import 'package:meet_up_vor_2/screens/screen_detail_user_profile.dart';
import 'package:meet_up_vor_2/screens/screen_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return kDebugMode;
  }
}

var logger = Logger(printer: PrettyPrinter(), filter: new MyLogFilter());

var loggerNoStack =
    Logger(printer: PrettyPrinter(methodCount: 0), filter: new MyLogFilter());

/*void main() {
  runApp(ProviderScope(child: MyApp()));
}*/

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          textTheme: TextTheme(
        bodyText2: TextStyle(color: Colors.black),
      )),
      initialRoute: 'welcome_screen',
      routes: {
        'welcome_screen': (context) => WelcomeScreen(),
        'register_screen': (context) => RegisterScreen(),
        'main_screen': (context) => MainScreen(),
        /*'home_page': (context) => HomePage(),*/
        'people_page': (context) => PeoplePage(),
        // location, chat
        'user_profile': (context) => UserProfileScreen(),
        'settings_screen': (context) => SettingsScreen(),
        'group_detail': (context) => GroupDetail(),
        'event_detail': (context) => EventDetail(),
        'group_members': (context) => GroupMembers(),
      },
    );
  }
}
