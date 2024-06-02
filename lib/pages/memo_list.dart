// lib/pages/memo_list.dart

import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/memo.dart';
import 'memo_page.dart';

class MemoList extends StatefulWidget {
  const MemoList({super.key});

  @override
  MemoListState createState() => MemoListState();
}

class MemoListState extends State<MemoList> {
  List<Memo> _memos = [];

  @override
  void initState() {
    super.initState();
    _getMemoList();
  }

  Future<void> _createMemo() async {
    final newMemo = Memo(title: 'New Memo', content: '');
    final id = await DatabaseHelper().insertMemo(newMemo);
    final createdMemo =
        (await DatabaseHelper().getMemos()).firstWhere((memo) => memo.id == id);
    if (!mounted) return;
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

  Future<void> _deleteMemo(int id) async {
    await DatabaseHelper().deleteMemo(id);
    _getMemoList();
  }

  Future<void> _confirmDeleteMemo(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Memo'),
          content: const Text('Are you sure you want to delete this memo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirm == true) {
      await _deleteMemo(id);
    }
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
            title: Text(memo.title),
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
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDeleteMemo(memo.id!),
            ),
            onLongPress: () => _confirmDeleteMemo(memo.id!),
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
