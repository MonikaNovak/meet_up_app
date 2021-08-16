import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/api_client.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/providers/LoginProvider.dart';
import 'package:meet_up_vor_2/constants.dart';
import 'package:meet_up_vor_2/generated/l10n.dart';
import 'screen_register.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //
  //
  // USE LOCAL OR REST API
  // 1. in constants change: const bool kMockApi = true;
  // 2. and: const String kBaseUrl = "https://example.com/api";
  // 3. useApi = 0 for local json, = 1 for api:
  int useApi = 1;
  //
  //

  String userName = '';
  String userPassword = '';
  late Token token;
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final FocusNode myFocusNode = new FocusNode();

  // login to local json
  void _loginLocalJson() {
    var token = new Token(token: '123456789');
    Navigator.pushReplacementNamed(context, 'main_screen', arguments: token);
  }

  // login mongoDB
  void _login(String userName, userPassword) async {
    // TODO only for recording
    // userPassword = '12345678';
    print('FEEDBACK at login - userName: ' +
        userName +
        ', password: ' +
        userPassword);
    var token =
        await LoginProvider(Client().init()).getToken(userName, userPassword);
    print('FEEDBACK at login - login api, token: ' + token!.token);
    Navigator.pushReplacementNamed(context, 'main_screen', arguments: token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).login),
        backgroundColor: kMainPurple,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Image.asset('images/logo_meetup.png'),
                  height: 100.0,
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey2,
                  child: TextFormField(
                    initialValue: 'Mihai Sandoval', // for testing
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.deepPurple,
                        ),
                      ),
                      // errorBorder:
                      //     OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
                      // focusedErrorBorder:
                      //     OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
                      // errorStyle: TextStyle(color: Colors.purple),
                    ),
                    /*validator: (value) {
                      if (value!.length < 4) {
                    return 'Enter at least 4 characters';
                  } else {
                    return null;
                    },*/
                    maxLength: 30,
                    onSaved: (value) {
                      setState(() {
                        userName = value!;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey1,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    initialValue: '12345678', // for testing
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.length < 7) {
                        return 'Password must be at least 8 characters long';
                      } else {
                        return null;
                      }
                    },
                    // onSaved: (value) => setState(() => userPassword = value!),
                    onSaved: (value) => setState(
                        () => userPassword = '12345678'), // for recording
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                  style: kFilledButtonStyle,
                  onPressed: () async {
                    if (_formKey1.currentState!.validate() &&
                        _formKey2.currentState!.validate()) {
                      _formKey1.currentState!.save();
                      _formKey2.currentState!.save();
                      if (useApi == 0) {
                        _loginLocalJson();
                      } else if (useApi == 1) {
                        _login(userName, userPassword);
                      }

                      final message = 'Welcome back, $userName!';
                      final snackBar = SnackBar(
                        content: Text(
                          message,
                          style: TextStyle(fontSize: 15),
                        ),
                        backgroundColor: Colors.green.shade300,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text(
                    "Let's meet up!",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RegisterScreen();
                    }));
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*Future<Token> _getTokenPlaceholder() async {
    var token = await LoginProvider(Client().init()).getTokenLocalApi();
    return token;
  }*/

// login Rest API with input data
/*Future<Token> _getToken(String userName, String userPassword) async {
    print('test run getToken');
    var url = 'http://172.21.250.154:5000/api/Account/Login';
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          // without input data from user:
          "accountName": "string",
          "password": "string"
          // with input data from user:
          */ /*"accountName": "$userName",
          "password": "$userPassword"*/ /*
        }));

    print(response.statusCode);
    print(response.body);
    return Token.fromJson(jsonDecode(response.body));
  }*/

// login using local json file old
/*void _login() async {
    var user =
        await LoginProvider(Client().init()).login(userName, userPassword);
    // logger.d("Hakuna matata ${user!.email}"); // console feedback
    Navigator.pushReplacementNamed(context, 'main_screen',
         arguments: <String, String>{
          'userNameArg': userName,
          'userPasswordArg': userPassword,
        });
        arguments: user);
  }*/

// get data rest API for later
/*Future<Token> _getTokenApi() async {
  print('test run getToken');
  var url = 'http://172.21.250.154:5000/api/Account/Login';
  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'token': '$token',
      },
      body: jsonEncode(
          <String, String>{"accountName": "string", "password": "string"}));

  print(response.statusCode);
  print(response.body);
  //return Token.fromJson(jsonDecode(response.body));
  return Token(token: (response.body));
}*/

// login Rest API with input data from raphael
/*Future<Token> _getToken(String userName, String userPassword) async {
  print('test run getToken');
  var url = 'http://172.21.250.154:5000/api/Account/Login';
  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        // without input data from user:
        "accountName": "string",
        "password": "string"
        // with input data from user:
        */ /*"accountName": "$userName",
          "password": "$userPassword"*/ /*
      }));

  print(response.statusCode);
  print(response.body);
  return Token.fromJson(jsonDecode(response.body));
}*/
