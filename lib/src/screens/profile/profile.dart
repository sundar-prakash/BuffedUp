import 'dart:io';

import 'package:BuffedUp/const/DataTypes/UserProfile.dart';
import 'package:BuffedUp/src/services/authService.dart';
import 'package:BuffedUp/src/services/firestore/userdoc.dart';
import 'package:BuffedUp/src/widget/decoratedtextinput.dart';
import 'package:BuffedUp/src/widget/imagepicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class profilescreen extends StatefulWidget {
  UserProfile user;
  profilescreen(this.user, {super.key});

  @override
  State<profilescreen> createState() => _profilescreenState();
}

class _profilescreenState extends State<profilescreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _gymname = TextEditingController();
  TextEditingController _bio = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  XFile? _imageFile;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _gymname = TextEditingController(text: widget.user.gymName);
    _bio = TextEditingController(text: widget.user.bio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Profile")),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                            child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 100),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    iconSize: 120,
                                    onPressed: () async {
                                      final XFile? pickedFile =
                                          await pickImage();
                                      if (pickedFile != null) {
                                        setState(() {
                                          _imageFile = pickedFile;
                                        });
                                      }
                                    },
                                    icon: CircleAvatar(
                                      radius: 120,
                                      backgroundImage: _imageFile != null
                                          ? FileImage(File(_imageFile!.path))
                                              as ImageProvider // Explicit cast
                                          : NetworkImage(widget.user.avatar)
                                              as ImageProvider, // Explicit cast
                                    )),
                                RoundedTextField(
                                  controller: _nameController,
                                  decoration:
                                      const InputDecoration(labelText: 'Name'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Name is required';
                                    } else if (RegExp(
                                            r'[0-9!@#%^&*(),.?":{}|<>]')
                                        .hasMatch(value)) {
                                      return 'Name should not contain special characters or numbers';
                                    }
                                    return null; // Return null for no error
                                  },
                                ),
                                RoundedTextField(
                                  controller: _gymname,
                                  decoration: const InputDecoration(
                                      labelText: 'Your Gym Name'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Did you name your gym?';
                                    } else if (RegExp(
                                            r'[0-9!@#%^&*(),.?":{}|<>]')
                                        .hasMatch(value)) {
                                      return 'Gym Name should not contain special characters or numbers';
                                    }
                                    return null;
                                  },
                                ),
                                RoundedTextField(
                                  isMultiline: true,
                                  controller: _bio,
                                  decoration:
                                      const InputDecoration(labelText: 'Bio'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Few lines about yourself will not kil you';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                if (_isLoading)
                                  const CupertinoActivityIndicator(),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () async {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            if (_formKey.currentState!
                                                .validate()) {
                                              String? avatarurl =
                                                  widget.user.avatar;
                                              if (_imageFile != null) {
                                                avatarurl =
                                                    await uploadImageToFirebase(
                                                        _imageFile!,
                                                        'avatar',
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid);
                                              }
                                              await updateFirestoreProfile(
                                                  _nameController.text,
                                                  avatarurl!,
                                                  _gymname.text,
                                                  _bio.text);
                                            }
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            try {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Saved Successfully!'),
                                                ),
                                              );
                                            } catch (e) {}
                                            Navigator.pop(context);
                                          },
                                    child: const Text("Update"))
                              ]),
                        ))),
                    TextButton.icon(
                      onPressed: () {
                        logout();
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.logout),
                      label: Text("Logout"),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            side: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                        ),
                        overlayColor: MaterialStateProperty.all(
                            Colors.red.withOpacity(0.1)),
                        minimumSize: MaterialStateProperty.all(
                            Size(double.infinity, 50)),
                      ),
                    )
                  ]),
            )));
  }
}
