import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/api_client.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/providers/LoginProvider.dart';
import 'package:meet_up_vor_2/constants.dart';
import 'screen_register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //
  //
  // USE LOCAL OR REST API: 0 for local, 1 for api
  int useApi = 0;
  //
  //
  //

  String userName = '';
  String userPassword = '';
  late Token token;
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  // login to local json get token placeholder
  Future<Token> _getTokenPlaceholder() async {
    var token = await LoginProvider(Client().init()).getToken();
    return token;
  }

  // login Rest API with input data
  Future<Token> _getToken(String userName, String userPassword) async {
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
          /*"accountName": "$userName",
          "password": "$userPassword"*/
        }));

    print(response.statusCode);
    print(response.body);
    return Token.fromJson(jsonDecode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Image.asset('images/logo_placeholder.png'),
                    height: 100.0,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey2,
                    child: TextFormField(
                      initialValue: 'TheUser', // for testing
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Username',
                        border: OutlineInputBorder(),
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
                      initialValue: 'Password1!', // for testing
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
                      onSaved: (value) => setState(() => userPassword = value!),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.deepPurple),
                    ),
                    onPressed: () async {
                      print(userName + userPassword);

                      if (_formKey1.currentState!.validate() &&
                          _formKey2.currentState!.validate()) {
                        _formKey1.currentState!.save();
                        _formKey2.currentState!.save();
                        if (useApi == 0) {
                          token = await _getTokenPlaceholder();
                          /*userName = 'monika.n';*/
                        } else if (useApi == 1) {
                          token = await _getToken(userName, userPassword);
                        }

                        final message = 'Logged in as: $userName';
                        final snackBar = SnackBar(
                          content: Text(
                            message,
                            style: TextStyle(fontSize: 15),
                          ),
                          backgroundColor: Colors.green.shade300,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }

                      Navigator.pushReplacementNamed(context, 'main_screen',
                          arguments: token);
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
            ],
          ),
        ),
      ),
    );
  }
}

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
/*Future<Token> _getData() async {
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
