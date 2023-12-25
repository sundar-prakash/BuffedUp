import 'package:BuffedUp/const/Colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable, camel_case_types
class pagemenu extends StatelessWidget {
  IconData icon;
  String header;
  String subtext;
  String count;
  Widget? navigator; // Changed type to Widget
  Color bgcolor;

  pagemenu(
    this.header,
    this.icon,
    this.count, {
    this.subtext = "",
    this.navigator,
    this.bgcolor = accentColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    void _onPress() {
      if (navigator != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => navigator!,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Not in use'),
            duration: Duration(milliseconds: 500),
          ),
        );
      }
    }

    return Hero(
      tag: header,
      child: GestureDetector(
        onTap: () => _onPress(),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: bgcolor,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(10),
          child: ListTile(
              leading: Icon(icon),
              title: Text(header),
              subtitle: subtext.isNotEmpty
                  ? Text(
                      subtext,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    )
                  : null,
              trailing: Text(
                count,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ),
      ),
    );
  }
}
