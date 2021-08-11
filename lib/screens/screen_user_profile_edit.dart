import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../main.dart';

class EditProfile extends StatefulWidget {
  late final Token token;
  late final User userFinal;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // late String userName;
  late String displayName;
  late String emailAddress;
  late String statusMessage;
  late String password;

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySubmit = GlobalKey<FormState>();

  void _updateUserData(Token token) async {
    print('running update user data: ' +
        displayName +
        emailAddress +
        statusMessage);
    String tokenString = token.token;
    try {
      final response = await http.put(
          Uri.parse(
              'http://ccproject.robertdoes.it/users'), //TODO which is the right route and way to write .put request?
          headers: {
            // get right route
            "Content-Type": "application/json",
            "Charset": "utf-8",
            "Accept": "application/json",
            "Authorization": "Bearer $tokenString",
          },
          body: jsonEncode({
            'displayName': displayName,
            'email': emailAddress,
            'statusMessage': statusMessage,
          }));
      if (response.statusCode == 200) {
        print('profile data updated succesfully, I guess');
      }
    } catch (err, stack) {
      logger.e("Login failed...", err, stack);
      throw err;
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as List;
    widget.token = arguments[0] as Token;
    widget.userFinal = arguments[1] as User;
    // userName = widget.userFinal.name;
    displayName = widget.userFinal.displayName;
    emailAddress = widget.userFinal.email;
    statusMessage = widget.userFinal.statusMessage;
    String userPasswordToCheck = '';
    String newPassword = '';

    bool _validatePasswordStructure(String value) {
      String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
      RegExp regExp = new RegExp(pattern);
      return regExp.hasMatch(value);
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Update profile data',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                // key: _formKey1,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                    initialValue: displayName, // for testing
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Display name:',
                      border: OutlineInputBorder(),
                    ),
                    /*validator: (value) {
                    if (value!.length < 4) {
                      return 'Enter at least 4 characters';
                    } else {
                      return null;
                    }
                  },*/
                    maxLength: 20,
                    onSaved: (value) {
                      if (value!.length > 0) {
                        displayName = value;
                      }
                    }
                    // onSaved: (value) => displayName = value!),
                    ),
              ),
              Text(
                'Display name will be shown throughout the app, replacing user name.',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.deepPurple.shade300),
              ),
              SizedBox(
                height: 10,
              ),
              /*TextField(
                    decoration: kTextFieldUserEmailTextDecoration,
                    onChanged: (value) {
                      */ /*userEmail = value;*/ /*
                    },
                  ),*/
              Form(
                key: _formKey1,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  initialValue: emailAddress, // for testing
                  decoration: const InputDecoration(
                    isDense: true,
                    /*icon: Icon(Icons.email),*/
                    hintText: 'Enter your email address',
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (!EmailValidator.validate(value!)) {
                      return 'Please enter valid email';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (String? value) {
                    if (value!.length > 0) {
                      emailAddress = value;
                    }
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey2,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  initialValue: statusMessage, // for testing
                  decoration: const InputDecoration(
                    isDense: true,
                    /*icon: Icon(Icons.email),*/
                    hintText: 'Update your status message.',
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (String? value) {
                    if (value!.length > 0) {
                      statusMessage = value;
                    }
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
                  initialValue: 'Password1!',
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'New password',
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
                  onSaved: (value) => newPassword = value!,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                style: kFilledButtonStyle,
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

                    _updateUserData(widget.token);

                    final message = 'Profile data updated';
                    final snackBar = SnackBar(
                      content: Text(
                        message,
                        style: TextStyle(fontSize: 15),
                      ),
                      backgroundColor: Colors.green.shade300,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
