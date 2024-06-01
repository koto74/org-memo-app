// lib/pages/memo_list.dart

import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import 'memo_page.dart';

class MemoList extends StatefulWidget {
  const MemoList({super.key});

  @override
  _MemoListState createState() => _MemoListState();
}

class _MemoListState extends State<MemoList> {
  List<Map<String, dynamic>> _memos = [];

  @override
  void initState() {
    super.initState();
    _getMemoList();
  }

  Future<void> _createMemo() async {
    final newMemo = {
      'title': 'New Memo',
      'content': '',
    };
    final id = await DatabaseHelper().insertMemo(newMemo);
    final createdMemo = (await DatabaseHelper().getMemos())
        .firstWhere((memo) => memo['id'] == id);
    final updatedMemo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoPage(memo: createdMemo),
      ),
    );
    if (updatedMemo != null) {
      await DatabaseHelper().updateMemo(updatedMemo);
      _getMemoList();
    }
  }

  Future<void> _getMemoList() async {
    final memos = await DatabaseHelper().getMemos();
    setState(() {
      _memos = memos;
    });
  }

  Future<void> _deleteDatabase() async {
    await DatabaseHelper().deleteDatabase();
    setState(() {
      _memos = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteDatabase,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _memos.length,
        itemBuilder: (context, index) {
          final memo = _memos[index];
          return ListTile(
            title: Text(memo['title']),
            onTap: () async {
              final updatedMemo = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MemoPage(memo: memo),
                ),
              );
              if (updatedMemo != null) {
                await DatabaseHelper().updateMemo(updatedMemo);
                _getMemoList();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createMemo,
        tooltip: 'Create',
        child: const Icon(Icons.add),
      ),
    );
  }
}