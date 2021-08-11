import 'package:flutter/material.dart';

import '../constants.dart';

class AddGroup extends StatefulWidget {
  late final String groupName;
  late final String imageUrl = '';

  @override
  _AddGroupState createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  @override
  Widget build(BuildContext context) {
    String imageUrlString = widget.imageUrl;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: kMainPurple,
        title: Text(
          'Create new group',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 50.0,
                child: imageUrlString.length == 0
                    ? Icon(
                        Icons.photo,
                        color: Colors.white,
                      )
                    : Image(image: NetworkImage('https://$imageUrlString')),
              ),
              SizedBox(
                height: 20.0,
              ),
              Form(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Group name:',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 20,
                  onSaved: (value) {
                    if (value!.length > 0) {
                      widget.groupName = value;
                    }
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  //TODO access gallery to choose a picture, rebuild page with picture on top
                },
                child: Text(
                  'Choose a picture',
                  style: TextStyle(color: Colors.white),
                ),
                style: kFilledButtonStyle,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextButton(
                onPressed: () {
                  //TODO add friend to group
                },
                child: Text(
                  'Add friends',
                  style: TextStyle(color: Colors.white),
                ),
                style: kFilledButtonStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
