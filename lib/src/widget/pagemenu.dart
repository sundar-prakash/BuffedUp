import 'package:flutter/material.dart';

// ignore: must_be_immutable
class pagemenu extends StatelessWidget {
  IconData icon;
  String header;
  String subtext;
  String count;
  Color bgcolor;
  pagemenu(this.header, this.icon, this.count,
      {this.subtext = "", this.bgcolor = Colors.green, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
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
                  style: TextStyle(
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                )
              : null,
          trailing: Text(count)),
    );
  }
}
