import 'dart:io';
import 'package:BuffedUp/src/services/firestore/userdoc.dart';
import 'package:BuffedUp/src/widget/decoratedtextinput.dart';
import 'package:BuffedUp/src/widget/imagepicker.dart';
import 'package:BuffedUp/src/widget/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class aboutscreen extends StatefulWidget {
  const aboutscreen({super.key});

  @override
  State<aboutscreen> createState() => _aboutscreenState();
}

class _aboutscreenState extends State<aboutscreen> {
  final _nameController = TextEditingController();
  final _gymname = TextEditingController();
  final _bio = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  XFile? _imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
              child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const BigText("Before You Begin !"),
              const SizedBox(
                height: 10,
              ),
              const MediumText("Please tell about yourself"),
              const SizedBox(
                height: 20,
              ),
              const SubtitleText("We won't share your information"),
              const SizedBox(
                height: 20,
              ),
              IconButton(
                  iconSize: 120,
                  onPressed: () async {
                    final XFile? pickedFile = await pickImage();
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
                        : null,
                    child: _imageFile == null ? Icon(Icons.add) : null,
                  )),
              RoundedTextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  } else if (RegExp(r'[0-9!@#%^&*(),.?":{}|<>]')
                      .hasMatch(value)) {
                    return 'Name should not contain special characters or numbers';
                  }
                  return null; // Return null for no error
                },
              ),
      
            
              RoundedTextField(
                controller: _gymname,
                decoration: const InputDecoration(labelText: 'Your Gym Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Did you name your gym?';
                  } else if (RegExp(r'[0-9!@#%^&*(),.?":{}|<>]')
                      .hasMatch(value)) {
                    return 'Gym Name should not contain special characters or numbers';
                  }
                  return null;
                },
              ),
              RoundedTextField(
                isMultiline: true,
                controller: _bio,
                decoration: const InputDecoration(labelText: 'Bio'),
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
              if (_isLoading) const CupertinoActivityIndicator(),
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
                          if (_formKey.currentState!.validate() &&
                              _imageFile != null) {
                            String? avatarurl = await uploadImageToFirebase(
                                _imageFile!,
                                'avatar',
                                FirebaseAuth.instance.currentUser!.uid);
                            await updateFirestoreProfile(_nameController.text,
                                avatarurl!, _gymname.text, _bio.text);
                          }
                          setState(() {
                            _isLoading = false;
                          });
                        },
                  child: const Text("Done"))
            ]),
          ))),
    );
  }
}
