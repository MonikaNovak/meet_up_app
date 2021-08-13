import 'package:flutter/material.dart';

import 'api/models/EventMeeting.dart';

const kTextFieldUserNameTextDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.transparent,
  hintText: 'enter name',
  hintStyle: TextStyle(color: Colors.grey),
);

const kTextFieldUserPasswordTextDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.transparent,
  hintText: 'enter password',
  hintStyle: TextStyle(color: Colors.grey),
);

const kTextFieldUserEmailTextDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.transparent,
  hintText: 'enter email address',
  hintStyle: TextStyle(color: Colors.grey),
);

const kTextFieldUserPasswordRepeatTextDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.transparent,
  hintText: 'validate password',
  hintStyle: TextStyle(color: Colors.grey),
);

const Color kMainPurple = Color.fromARGB(255, 56, 30, 89);

ButtonStyle kFilledButtonStyle = ButtonStyle(
  padding: MaterialStateProperty.all<EdgeInsets>(
    EdgeInsets.all(15.0),
  ),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
  ),
  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
);

const TextStyle kTextStyleItalic = TextStyle(
  fontStyle: FontStyle.italic,
);

BoxDecoration kContainerBoxDecoration = BoxDecoration(
    border: Border.all(
  color: Colors.grey.shade300,
  width: 1.0,
));

const kUserProfilePicAddress = 'images/profile_pic.jpg';
const kUserProfilePicPlaceholder = 'images/profile_pic_placeholder.png';
// const bool kMockApi = true; // for local json
const bool kMockApi = false;
// const String kBaseUrl = "https://example.com/api"; // for local json
const String kBaseUrl = "http://ccproject.robertdoes.it";
const kMyProfilePicUrl =
    'https://ucd13a959199624b78275d7c751b.previews.dropboxusercontent.com/p/thumb/ABMy2nsGy3hw9EzE6AX2KB5Jgxk2TtfDFEKGozrYkTWyP1oiXPWoj2kXepv7GOvEjcn4v6PnrhQjRFEmG5uUK8Ow_3jxp2BKDq3QEo7IvpPutGfSx-AtNf9FKdtjEvpX0Qm0FEQTxmhqkC9Xk3qJzKmazGyR47vIWusdNpIznMKGgWXY-YZu_tPHVEmjrdGUxAyNXio8MM0xzWScjJjE6rQn_I_O6dMTS1gczgBHToKqBj1jzGAF733gnfaIfXhNLvAiwGN7u-zhAFea2BzkkfT8snb_aKOdRAC-gfyaIPSt9_ZJJyeytJ7xy28qnvbeeoSDeh20D8V2YfMIaotdG2p7w6W9UPIV46fpWm_6S7Wxt9V1Wu4dNaR_K_gmpLL4gta20JsHBb1PGqbIYqQ5IoPR/p.jpeg?fv_content=true&size_mode=5';
