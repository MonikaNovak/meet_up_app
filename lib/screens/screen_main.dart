import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/components/app_bar.dart';
import 'package:meet_up_vor_2/screens/page_friendlist.dart';
import 'page_events.dart';
import 'page_home.dart';
import 'page_groups.dart';

class MainScreen extends StatefulWidget {
  late final ValueNotifier<int> _indexNotifier = ValueNotifier(0);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    //logger.d("Rebuild main screen"); // console feedback

    final token = ModalRoute.of(context)!.settings.arguments as Token;

    Widget _buildBody(int index) {
      switch (index) {
        case 0:
          {
            return new HomePage(token);
          }
        case 1:
          {
            //return new PeoplePage(token); changed for stream builder test
            return new FriendListPage(token);
          }
        case 2:
          {
            return new GroupsPage(token);
          }
        case 3:
          {
            return new EventPage(token);
          }
      }
      // last return is only a fallback but should not happen
      return new HomePage(token);
    }

    var appBar = MyAppBar(token);

    return ValueListenableBuilder(
      valueListenable: widget._indexNotifier,
      builder: (BuildContext context, int index, Widget? child) {
        return Scaffold(
          appBar: appBar,
          body: _buildBody(index),
          /*body: widget.pageList[index],*/
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: index,
            onTap: (value) {
              widget._indexNotifier.value = value;
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
                    Icons.contacts,
                  ),
                  label: 'friends'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.people,
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

// user from json
/*final user = ModalRoute.of(context)!.settings.arguments
        as User; //get user from local json
    Widget _buildBody(int index) {
      switch (index) {
        case 0:
          {
            return new HomePage(user);
          }
        case 1:
          {
            return new PeoplePage(user);
          }
        case 2:
          {
            return new GroupsPage(user);
          }
        case 3:
          {
            return new EventPage(user);
          }
      }
      // last return is only a fallback but should not happen
      return new HomePage(user);
    }*/
