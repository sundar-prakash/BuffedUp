import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:BuffedUp/src/widget/glassscard.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperInfoScreen extends StatefulWidget {
  const DeveloperInfoScreen({Key? key}) : super(key: key);

  @override
  _DeveloperInfoScreenState createState() => _DeveloperInfoScreenState();
}

class _DeveloperInfoScreenState extends State<DeveloperInfoScreen> {
  late Future<void> fetchData;

  String name = '';
  String description = '';
  String avatar = '';
  String github = '';
  String instagram = '';
  String linkedin = '';
  String website = 'https://okayitssundar.netlify.app';
  String appVersion = 'beta 0.01';

  @override
  void initState() {
    super.initState();
    fetchData = _fetchData();
  }

  Future<void> _fetchData() async {
    final url = Uri.https('gist.githubusercontent.com',
        '/okayitssundar/d18907e6f64f2de1ab716a42d51400b8/raw/Data.json');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          name = jsonResponse['Header']['Title'];
          avatar = jsonResponse['Home']['Avatar'];
          final homeDescription = jsonResponse['Home']['Description'];
          description = homeDescription;
          final socialMedia = jsonResponse['Footer']['SocialMedia'];
          github = socialMedia[0]['Link'];
          instagram = socialMedia[1]['Link'];
          linkedin = socialMedia[2]['Link'];
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Developer Info"),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/devinfobg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          FutureBuilder<void>(
            future: fetchData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GlassCard(
                          name: name,
                          aboutMe: description,
                          avatarUrl: avatar,
                        ),
                        const SizedBox(height: 8),
                        _buildBlurredInfoRow('Website', website),
                        _buildBlurredInfoRow('GitHub', github),
                        _buildBlurredInfoRow('Instagram', instagram),
                        _buildBlurredInfoRow('LinkedIn', linkedin),
                        _buildBlurredInfoRow('App Version', appVersion),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

bool isURL(String string) {
  Uri uri = Uri.tryParse(string)!;
  return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
}

_launchURL(String url) async {
  final Uri? uri = Uri.tryParse(url);
  if (uri != null && await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw Exception('Could not launch $url');
  }
}

Widget _buildBlurredInfoRow(String label, String value) {
  return Container(
    margin: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
    ),
    child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(25)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: isURL(value) ? Icon(Icons.arrow_outward_rounded) : null,
            onTap: isURL(value) ? () => _launchURL(value) : null,
            title: Text(label),
            subtitle: Text(value),
          ),
        ),
      ),
    ),
  );
}
