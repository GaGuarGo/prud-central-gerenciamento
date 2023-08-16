import 'dart:ui';
import 'package:flutter/material.dart';

class TextComposer extends StatefulWidget {
  TextComposer(this.sendMessage);

  final Function({String text}) sendMessage;

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final TextEditingController _controller = TextEditingController();

  bool _isComposing = false;

  void _reset() {
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  //int hora = Timestamp.now().microsecondsSinceEpoch;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              controller: _controller,
              decoration: InputDecoration(
                  focusColor: Colors.pink,
                  fillColor: Colors.pink,
                  hintText: 'Enviar menssagem',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink),
                  ),
                  prefixIcon: Icon(
                    Icons.message,
                    color: Colors.pink,
                  )),
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {
                widget.sendMessage(text: text);
                _reset();
              },
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.send,
                color: _isComposing ? Colors.pinkAccent : Colors.grey,
              ),
              onPressed: _isComposing
                  ? () {
                      widget.sendMessage(text: _controller.text);
                      _reset();
                    }
                  : null)
        ],
      ),
    );
  }
}
