import 'dart:async';
import 'package:BuffedUp/const/DataTypes/UserProfile.dart';
import 'package:BuffedUp/src/services/firestore/ownerdoc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late TextEditingController _textEditingController;
  Timer? _debounce;
  DateTime? lastSavedDateTime;
  final FocusNode _focusNode = FocusNode();
  int _colorIndex = 0;
  final List<Color> _backgroundColor = [
    Colors.grey[100]!,
    Colors.blueAccent[100]!,
    Colors.amber[100]!,
    Colors.greenAccent[100]!,
    Colors.pinkAccent[100]!,
    Colors.purpleAccent[100]!,
  ];
  final List<Color> _appbarColor = [
    Colors.grey[400]!,
    Colors.blueAccent[400]!,
    Colors.amber[400]!,
    Colors.greenAccent[400]!,
    Colors.pinkAccent[400]!,
    Colors.purpleAccent[400]!,
  ];
  Future<UserProfile> fetchNotes() async {
    final u = await fetchOwner();

    return u;
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    lastSavedDateTime = DateTime.now();
    _colorIndex = 0; // Initialize with default color index
    fetchNotes().then((user) {
      setState(() {
        _textEditingController.text = user.notes!.text;
        lastSavedDateTime = user.notes?.lastSaved ?? DateTime.now();
        _colorIndex = user.notes?.colorIndex ?? 0;
      });
    });
  }

  void _onTextChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 2), () {
      notesType n = notesType(
        colorIndex: _colorIndex,
        lastSaved: DateTime.now(),
        text: text,
      );
      updateOwner('notes', n.toMap()); // Update Firestore here
      setState(() {
        lastSavedDateTime = n.lastSaved;
      });
      print('Text saved: $text');
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _changeBackgroundColor() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Choose Background Color'),
          children: _backgroundColor
              .map((color) => SimpleDialogOption(
                    child: Container(
                      color: color,
                      height: 50,
                      width: double.infinity,
                    ),
                    onPressed: () {
                      setState(() {
                        _colorIndex = _backgroundColor.indexOf(color);
                      });
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        backgroundColor: _appbarColor[_colorIndex],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: "Focus on editing area",
              onPressed: () {
                _focusNode.hasFocus
                    ? _focusNode.unfocus()
                    : FocusScope.of(context).requestFocus(_focusNode);
              },
            ),
            IconButton(
              icon: const Icon(Icons.color_lens),
              onPressed: _changeBackgroundColor,
            ),
            if (lastSavedDateTime != null)
              Text(
                'Last saved: ${DateFormat('yyyy-MM-dd HH:mm').format(lastSavedDateTime!)}',
              ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: _backgroundColor[_colorIndex]),
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextField(
            controller: _textEditingController,
            maxLines: null,
            focusNode: _focusNode,
            textCapitalization: TextCapitalization.sentences,
            onChanged: _onTextChanged,
            decoration: null,
            style: const TextStyle(
              fontSize: 19,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
