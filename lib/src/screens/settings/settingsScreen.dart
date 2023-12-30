import 'package:BuffedUp/const/DataTypes/UserProfile.dart';
import 'package:BuffedUp/src/screens/profile/profile.dart';
import 'package:BuffedUp/src/screens/settings/devloperinfoscreen.dart';
import 'package:BuffedUp/src/services/authService.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final UserProfile user;
  const SettingsScreen(this.user, {super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: Icon(Icons.people),
                    title: Text("Edit profile"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(widget.user),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(Icons.dark_mode),
                    title: const Text("Dark Mode"),
                    onTap: () {
                      setState(() {
                        isDarkMode = !isDarkMode;
                      });
                    },
                    trailing: Switch(
                      onChanged: (bool value) {
                        setState(() {
                          isDarkMode = value; // Update the dark mode status
                          // You can update your app's theme or settings here
                        });
                      },
                      value:
                          isDarkMode, // Set the switch value based on dark mode status
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(Icons.color_lens),
                    title: const Text("Main Color"),
                    onTap: () {
                      setState(() {
                        isDarkMode = !isDarkMode;
                      });
                    },
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeveloperInfoScreen(),
                        ),
                      );
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: Icon(Icons.info),
                    title: Text("Developer Info"),
                  ),
                  const Divider(),
                  const Spacer(),
                  const SizedBox(
                      height: 20), // Add space at the bottom of the ListView
                  TextButton.icon(
                    onPressed: () {
                      logout();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                      overlayColor: MaterialStateProperty.all(
                          Colors.red.withOpacity(0.1)),
                      minimumSize: MaterialStateProperty.all(
                          const Size(double.infinity, 50)),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
