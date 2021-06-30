import 'dart:io';
import 'package:meet_up_vor_2/api/api_client.dart';
import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/providers/LoginProvider.dart';
import 'package:meet_up_vor_2/constants.dart';
import 'package:email_validator/email_validator.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //
  //
  // USE LOCAL OR REST API: 0 for local, 1 for api
  int useApi = 0;
  //
  //
  //
  String userName = '';
  String userPassword = '';
  String userEmail = '';
  String userPasswordToCheck = '';
  late Token token;

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySubmit = GlobalKey<FormState>();

  // login to local json get token placeholder
  Future<Token> _getTokenPlaceholder() async {
    var token = await LoginProvider(Client().init()).getToken();
    return token;
  }

  bool _validatePasswordStructure(String value) {
    /*String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';*/ // original regex also for special characters
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  void _register() async {
    var httpClient = new HttpClient();
    var url = 'http://172.21.250.154:5000/api/Account/register';
    var request = await httpClient.getUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.deepPurple),
        title: Text(
          'Register account',
          style: TextStyle(color: Colors.deepPurple),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image.asset('images/logo_placeholder.png'),
                height: 80.0,
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey1,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  initialValue: 'theUser', // for testing
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
                  validator: (value) {
                    if (value!.length < 4) {
                      return 'Enter at least 4 characters';
                    } else {
                      return null;
                    }
                  },
                  maxLength: 30,
                  onSaved: (value) => setState(() => userName = value!),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              /*TextField(
                    decoration: kTextFieldUserEmailTextDecoration,
                    onChanged: (value) {
                      */ /*userEmail = value;*/ /*
                    },
                  ),*/
              Form(
                key: _formKey2,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  initialValue: 'email@email.com', // for testing
                  decoration: const InputDecoration(
                    isDense: true,
                    /*icon: Icon(Icons.email),*/
                    hintText: 'Enter your email address',
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Email address is required';
                    } else if (!EmailValidator.validate(value)) {
                      return 'Please enter valid email';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (String? value) {
                    userEmail = value!;
                    print(userEmail);
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey3,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  initialValue: 'Password1!', // for testing
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (!_validatePasswordStructure(value!)) {
                      return 'Password must contain at least:\n1 lower case\n1 upper case\n1 number\nand must be at least 8 characters long';
                    } else {
                      userPasswordToCheck = value;
                      return null;
                    }
                  },
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey4,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  initialValue: 'Password1!', // for testing
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Confirm password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (userPasswordToCheck != value) {
                      return "Passwords don't match";
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
                key: _formKeySubmit,
                onPressed: () async {
                  if (_formKey1.currentState!.validate() &&
                      _formKey2.currentState!.validate() &&
                      _formKey3.currentState!.validate() &&
                      _formKey4.currentState!.validate()) {
                    _formKey1.currentState!.save();
                    _formKey2.currentState!.save();
                    _formKey3.currentState!.save();
                    _formKey4.currentState!.save();

                    if (useApi == 0) {
                      token = await _getTokenPlaceholder();
                    } else if (useApi == 1) {
                      // TODO register user and login to get token
                    }
                    print(token.token);

                    final message = 'Account created\nuser name: $userName';
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
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
                /*TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.deepPurple),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      print(userEmail);
                      _formKey.currentState!.save();
                      */ /*Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OverviewScreen()));*/ /*
                      */ /*Navigator.pushNamed(context, 'main_screen',
                          arguments: <String, String>{
                            'userNameArg': userName,
                            'userPasswordArg': userPassword,
                          });*/ /*
                    },
                    child: Text(
                      "Let's meet up!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),*/
              ),
            ],
          ),
        ),
      ),
    );
  }
}
