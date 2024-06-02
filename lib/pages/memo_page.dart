// lib/pages/memo_page.dart

import 'package:flutter/material.dart';
import '../models/memo.dart';

class MemoPage extends StatefulWidget {
  final Memo memo;

  const MemoPage({super.key, required this.memo});

  @override
  MemoPageState createState() => MemoPageState();
}

class MemoPageState extends State<MemoPage> {
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _contentController.text = widget.memo.content;
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
              final updatedMemo = Memo(
                id: widget.memo.id,
                title: title,
                content: content,
              );
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
