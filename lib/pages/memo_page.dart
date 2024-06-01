// lib/pages/memo_page.dart

import 'package:flutter/material.dart';

class MemoPage extends StatefulWidget {
  final Map<String, dynamic> memo;

  const MemoPage({Key? key, required this.memo}) : super(key: key);

  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _contentController.text = widget.memo['content'];
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Memo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final content = _contentController.text;
              final title = content.split('\n').first;
              final updatedMemo = {
                'id': widget.memo['id'],
                'title': title,
                'content': content,
              };
              Navigator.pop(context, updatedMemo);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _contentController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: const InputDecoration(
            hintText: 'Enter your memo here...',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}