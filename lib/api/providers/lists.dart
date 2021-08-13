import 'package:meet_up_vor_2/api/models/EventMeeting.dart';
import 'package:meet_up_vor_2/api/models/EventMeetingAddress.dart';
import 'package:meet_up_vor_2/api/models/Friend.dart';
import 'package:meet_up_vor_2/api/models/Group.dart';
import 'package:meet_up_vor_2/api/models/UserGeneral.dart';

class Lists {
  List<Friend> hardcodeListOfFriends() {
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
    Friend friend7 = new Friend(
        'nicolatesla',
        'nicol@example.com',
        'https://randomuser.me/api/portraits/men/22.jpg',
        'I like smurf ice-cream.',
        'Nicko',
        1);
    Friend friend8 = new Friend(
        'lucid',
        'luca.rocks@example.com',
        'https://randomuser.me/api/portraits/men/46.jpg',
        'I like poppy ice-cream.',
        'Luca',
        1);
    Friend friend9 = new Friend(
        'lucia',
        'lucyloo@example.com',
        'https://randomuser.me/api/portraits/women/10.jpg',
        'I like caramel ice-cream.',
        'Lucinda',
        1);
    Friend friend10 = new Friend(
        'suzie',
        'suzylou@example.com',
        'https://randomuser.me/api/portraits/women/16.jpg',
        'I like rebarb ice-cream.',
        'Susanne Lou',
        1);
    Friend friend11 = new Friend(
        'fella',
        'felixcoffee@example.com',
        'https://randomuser.me/api/portraits/men/76.jpg',
        'I like coffee ice-cream.',
        'Felix',
        1);
    listOfFriends.add(friend1);
    listOfFriends.add(friend2);
    listOfFriends.add(friend3);
    listOfFriends.add(friend4);
    listOfFriends.add(friend5);
    listOfFriends.add(friend6);
    listOfFriends.add(friend7);
    listOfFriends.add(friend8);
    listOfFriends.add(friend9);
    listOfFriends.add(friend10);
    listOfFriends.add(friend11);
    return listOfFriends;
  }

  List<EventMeeting> hardcodeListOfEvents1() {
    List<EventMeeting> listOfEvents1 = new List.empty(growable: true);
    EventMeeting event1 = new EventMeeting(
        'aaa',
        47.22950598148911,
        9.580762120894667,
        "Gin degustation at Suzie's",
        'Fr 12.8.2021',
        'Bring your favourite snacks, drinks provided ;)');
    EventMeeting event2 = new EventMeeting(
        'bbb',
        47.4824351762003,
        9.74881431176205,
        'Barbecue at the river',
        'Sat 13.8.2021',
        'Everyone is welcome! Luca brings the guitar');
    EventMeeting event3 = new EventMeeting(
        'ccc',
        47.29094217989792,
        9.65780818911897,
        'D&D board game night',
        'We 18.8.2021',
        'Our casual gaming Wednesday (:');
    listOfEvents1.add(event1);
    listOfEvents1.add(event2);
    listOfEvents1.add(event3);

    return listOfEvents1;
  }

  List<EventMeetingAddress> hardcodeListOfEvents1Address() {
    List<EventMeetingAddress> listOfEvents1 = new List.empty(growable: true);
    EventMeetingAddress event1 = new EventMeetingAddress(
        'aaa',
        47.22950598148911,
        9.580762120894667,
        "Gin degustation at Suzie's",
        'Fr 12.8.2021',
        'Bring your favourite snacks, drinks provided ;)',
        '');
    EventMeetingAddress event2 = new EventMeetingAddress(
        'bbb',
        47.4824351762003,
        9.74881431176205,
        'Barbecue at the river',
        'Sat 13.8.2021',
        'Everyone is welcome! Luca brings the guitar',
        '');
    EventMeetingAddress event3 = new EventMeetingAddress(
        'ccc',
        47.29094217989792,
        9.65780818911897,
        'D&D board game night',
        'We 18.8.2021',
        'Our casual gaming Wednesday (:',
        '');
    listOfEvents1.add(event1);
    listOfEvents1.add(event2);
    listOfEvents1.add(event3);

    return listOfEvents1;
  }

  List<EventMeeting> hardcodeListOfEvents2() {
    List<EventMeeting> listOfEvents2 = new List.empty(growable: true);
    EventMeeting event1 = new EventMeeting(
        'aaa',
        47.504726572867625,
        9.734753972001204,
        "For a swim at Strandbad",
        'Th 18.8.2021',
        "Gonna be hot, so let's cool down a bit");
    EventMeeting event2 = new EventMeeting('bbb', 47.49337377345543,
        9.724581079911998, "Mihai's Birthday", 'Sat 20.8.2021', 'No presents!');
    listOfEvents2.add(event1);
    listOfEvents2.add(event2);

    return listOfEvents2;
  }

  List<UserGeneral> hardcodeListOfUsers() {
    List<UserGeneral> listOfUsers = new List.empty(growable: true);
    UserGeneral friend1 = new UserGeneral(
        'leonido24',
        'leon.barrett@example.com',
        'https://randomuser.me/api/portraits/men/29.jpg',
        'I like lemon ice-cream.',
        'Leon');
    UserGeneral friend2 = new UserGeneral(
        'ramanid',
        'ramon.peck@example.com',
        'https://randomuser.me/api/portraits/men/6.jpg',
        'I like chocolate ice-cream.',
        'Ramon');
    UserGeneral friend3 = new UserGeneral(
        'rossalinda',
        'ross.bryant@example.com',
        'https://randomuser.me/api/portraits/women/99.jpg',
        'I like strawberry ice-cream.',
        'Rossi');
    UserGeneral friend4 = new UserGeneral(
        'barretoo',
        'leon.barrett@example.com',
        'https://randomuser.me/api/portraits/men/62.jpg',
        'I like cherry ice-cream.',
        'Barret');
    UserGeneral friend5 = new UserGeneral(
        'pickle',
        'ramon.peck@example.com',
        'https://randomuser.me/api/portraits/women/85.jpg',
        'I like vanilla ice-cream.',
        'Pecky');
    UserGeneral friend6 = new UserGeneral(
        'bumblebee',
        'ross.bryant@example.com',
        'https://randomuser.me/api/portraits/men/47.jpg',
        'I like ginger ice-cream.',
        'Bryant');
    listOfUsers.add(friend1);
    listOfUsers.add(friend2);
    listOfUsers.add(friend3);
    listOfUsers.add(friend4);
    listOfUsers.add(friend5);
    listOfUsers.add(friend6);
    return listOfUsers;
  }

  List<Group> hardcodeListOfGroups() {
    List<UserGeneral> listOfUsersLocal = hardcodeListOfUsers();
    List<Group> listOfGroups = new List.empty(growable: true);
    List<EventMeeting> listOfEventsLocal1 = hardcodeListOfEvents1();
    List<EventMeeting> listOfEventsLocal2 = hardcodeListOfEvents2();
    Group group1 = new Group(
        'Mihai Sandoval',
        'https://www.jolie.de/sites/default/files/styles/facebook/public/images/2017/07/14/partypeople.jpg?itok=H8Kltq60',
        'The crazy people',
        '1111',
        listOfUsersLocal,
        listOfEventsLocal1);
    Group group2 = new Group(
        'jimmy',
        'https://www.jolie.de/sites/default/files/styles/facebook/public/images/2017/07/14/partypeople.jpg?itok=H8Kltq60',
        'The weird people',
        '2222',
        listOfUsersLocal,
        listOfEventsLocal2);
    Group group3 = new Group(
        'luca',
        'https://www.jolie.de/sites/default/files/styles/facebook/public/images/2017/07/14/partypeople.jpg?itok=H8Kltq60',
        'The awesome people',
        '3333',
        listOfUsersLocal,
        listOfEventsLocal1);
    listOfGroups.add(group1);
    listOfGroups.add(group2);
    listOfGroups.add(group3);
    return listOfGroups;
  }
}
