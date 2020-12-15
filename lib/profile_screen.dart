import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practical_7bits/FirebaseHelper.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _mailAddressController = TextEditingController();
  PickedFile _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile Screen"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Spacer(),
              GestureDetector(
                onTap: () => _showPicker(context),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: CircleAvatar(
                    radius: 55.0,
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(
                              File(_image.path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.fitWidth,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(50)),
                            width: 100,
                            height: 100,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(letterSpacing: 1.0),
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      focusColor: Colors.blue,
                      hintText: "Enter your name"),
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600),
                  maxLength: 30,
                  maxLines: 1,
                  maxLengthEnforced: true,
                  // Only numbers can be entered
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextField(
                  controller: _mobileNumberController,
                  decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(letterSpacing: 1.0),
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                      focusColor: Colors.blue,
                      hintText: "Enter your number"),
                  keyboardType: TextInputType.phone,
                  style: TextStyle(

                      fontSize: 18.0,
                      fontWeight: FontWeight.w600),
                  maxLength: 16,
                  maxLines: 1,
                  maxLengthEnforced: true,
                  // Only numbers can be entered
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextField(
                  controller: _mailAddressController,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(letterSpacing: 1.0),
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                      focusColor: Colors.blue,
                      hintText: "Enter your email"),
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600),
                  maxLength: 40,
                  maxLines: 1,
                  maxLengthEnforced: true,
                  // Only numbers can be entered
                ),
              ),
              FlatButton(
                child: Text("Logout"),
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () {
                  FirebaseHelper.auth.signOut();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
              Spacer(flex:2)
            ],
          ),
        ));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
        });
  }

  _imgFromGallery() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }
}
