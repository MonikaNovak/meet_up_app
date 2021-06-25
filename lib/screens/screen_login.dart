import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/api_client.dart';
import 'package:meet_up_vor_2/api/providers/LoginProvider.dart';
import 'package:meet_up_vor_2/constants.dart';
import 'package:meet_up_vor_2/main.dart';
import 'screen_register.dart';
import 'package:riverpod/riverpod.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
/*  class _WelcomeScreenState extends State<WelcomeScreen> {*/
  String userName = '';
  String userPassword = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _login() async {
    var user =
        await LoginProvider(Client().init()).login(userName, userPassword);
    logger.d("Hakuna matata ${user!.email}"); // console feedback
    Navigator.pushReplacementNamed(context, 'main_screen',
        /*arguments: <String, String>{
          'userNameArg': userName,
          'userPasswordArg': userPassword,
        });*/
        arguments: user);
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
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Image.asset('images/logo_placeholder.png'),
                  height: 100.0,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
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
                    /*if (value!.length < 4) {
                      return 'Enter at least 4 characters';
                    } else {
                      return null;
                    }*/
                  },
                  maxLength: 30,
                  onSaved: (value) => setState(() => userName = value!),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.length < 7) {
                      return 'Password must be at least 7 characters long';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) => setState(() => userPassword = value!),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.deepPurple),
                  ),
                  onPressed: () {
                    print(userName + userPassword);
                    final isValid = _formKey.currentState!.validate();

                    if (isValid) {
                      _formKey.currentState!.save();

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

                    /*Navigator.push(context,
                        MaterialPageRoute(builder: (context) => OverviewScreen()));*/
                    _login();
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
