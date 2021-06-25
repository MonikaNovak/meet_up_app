import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/components/app_bar.dart';
import 'package:meet_up_vor_2/screens/page_friendlist.dart';

import '../main.dart';
import 'page_events.dart';
import 'page_home.dart';
import 'page_groups.dart';

class MainScreen extends StatefulWidget {
/*  late final int pageIndex = 0;
  late final List<Widget> pageList;*/
  late final ValueNotifier<int> _indexNotifier = ValueNotifier(0);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    logger.d("Rebuild main screen"); // console feedback
    final user = ModalRoute.of(context)!.settings.arguments as User;

    Widget _buildBody(int index) {
      switch (index) {
        case 0:
          {
            return new HomePage(user);
          }
        case 1:
          {
            return new PeoplePage();
          }
        case 2:
          {
            return new GroupsPage(user);
          }
        case 3:
          {
            return new ChatPage(user);
          }
      }
      // last return is only a fallback but should not happen
      return new HomePage(user);
    }

    /*widget.pageList = <Widget>[
      HomePage(user),
      PeoplePage(),
      LocationPage(),
      ChatPage(),
    ];*/

    return ValueListenableBuilder(
      valueListenable: widget._indexNotifier,
      builder: (BuildContext context, int index, Widget? child) {
        logger.d("building main screen body");
        return Scaffold(
          appBar: MyAppBar(user),
          body: _buildBody(index),
          /*body: widget.pageList[index],*/
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: index,
            onTap: (value) {
              widget._indexNotifier.value = value;
// setState(() {
//   pageIndex = value;
// });
            },
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.grey,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_filled,
                ),
                label: 'home',
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.people,
                  ),
                  label: 'people'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.wc,
                  ),
                  label: 'groups'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.event,
                  ),
                  label: 'events'),
            ],
          ),
        );
      },
    );
  }
}
