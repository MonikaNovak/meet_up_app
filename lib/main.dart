import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:meet_up_vor_2/components/image_capture_widget.dart';
import 'package:meet_up_vor_2/generated/l10n.dart';
import 'package:meet_up_vor_2/screens/screen_detail_friend_add.dart';
import 'package:meet_up_vor_2/screens/screen_detail_event.dart';
import 'package:meet_up_vor_2/screens/screen_detail_friend_profile.dart';
import 'package:meet_up_vor_2/screens/screen_detail_group.dart';
import 'package:meet_up_vor_2/screens/screen_detail_group_add.dart';
import 'package:meet_up_vor_2/screens/screen_detail_members_list.dart';
import 'package:meet_up_vor_2/screens/screen_user_profile_edit.dart';
import 'package:meet_up_vor_2/screens/screen_main.dart';
import 'package:meet_up_vor_2/screens/screen_detail_friend_pending_requests.dart';
import 'package:meet_up_vor_2/screens/screen_register.dart';
import 'package:meet_up_vor_2/screens/screen_settings.dart';
import 'package:meet_up_vor_2/screens/screen_user_profile.dart';
import 'package:meet_up_vor_2/screens/screen_login.dart';

class MyLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return kDebugMode;
  }
}

// var request = await httpClient.getUrl(Uri.parse(url));
// request.headers.contentType = ContentType.json;  // only for PUT oder POST
// request.headers.add(HttpHeaders.authorizationHeader, 'myMagicToken');

var logger = Logger(printer: PrettyPrinter(), filter: new MyLogFilter());

var loggerNoStack =
    Logger(printer: PrettyPrinter(methodCount: 0), filter: new MyLogFilter());

/*void main() {
  runApp(ProviderScope(child: MyApp()));
}*/

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        S.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Colors.deepPurple,
          primarySwatch: Colors.deepPurple,
          splashColor: Colors.deepPurple.shade200,
          textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.black),
          )),
      initialRoute: 'welcome_screen',
      routes: {
        'welcome_screen': (context) => LoginScreen(),
        'register_screen': (context) => RegisterScreen(),
        'main_screen': (context) => MainScreen(),
        'user_profile': (context) => UserProfileScreen(),
        'settings_screen': (context) => SettingsScreen(),
        'group_detail': (context) => GroupDetail(),
        'event_detail': (context) => EventDetail(),
        'members_list': (context) => GroupMembers(),
        'friend_profile': (context) => FriendProfileScreen(),
        'image_capture': (context) => ImageCapture(),
        'add_friend': (context) => AddFriend(),
        'pending_requests': (context) => PendingRequests(),
        'user_edit_profile': (context) => EditProfile(),
        'add_group': (context) => AddGroup(),
      },
    );
  }
}
