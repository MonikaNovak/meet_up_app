import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/constants.dart';
import 'package:email_validator/email_validator.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String userName = '';
  String userPassword = '';
  String userEmail = '';
  String userPasswordToCheck = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySecond =
      GlobalKey<FormState>(); // check why second key

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
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    if (value!.length < 4) {
                      return 'Enter at least 4 characters';
                    } else {
                      return null;
                    }
                  },
                  maxLength: 30,
                  onSaved: (value) => setState(() => userName = value!),
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
                TextFormField(
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
                      userPasswordToCheck = value;
                      return null;
                    }
                  },
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Repeat password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.length < 7) {
                      return 'Password must be at least 7 characters long';
                    } else if (userPasswordToCheck != value) {
                      return "Password doesn't match";
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
                  key: _formKeySecond,
                  onPressed: () {
                    final isValid = _formKey.currentState!.validate();

                    if (isValid) {
                      _formKey.currentState!.save();

                      final message =
                          /*'Username: $username\nPassword: $password\nEmail: $email';*/
                          'User name: $userName\nEmail: $userEmail';
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
                        // TODO include email address
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
      ),
    );
  }
}
