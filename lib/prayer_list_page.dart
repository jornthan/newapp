import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PrayerListPage extends StatelessWidget {
  final String? currentEmail = FirebaseAuth.instance.currentUser?.email;

  bool get isAdmin => currentEmail == 'admin@example.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('기도부탁 명단')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('prayers')
              .orderBy('timestamp', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

            final docs = snapshot.data!.docs;

            return Table(
              border: TableBorder.all(),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(1.6),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(2.5),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.yellow[100]),
                  children: [
                    _headerCell('이름'),
                    _headerCell('전도대상자'),
                    _headerCell('관계'),
                    _headerCell('소개'),
                  ],
                ),
                ...docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return TableRow(
                    children: [
                      _textCell(data['name']),
                      _textCell(data['target']),
                      _textCell(data['relation']),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(child: Text(data['intro'] ?? '')),
                            if (isAdmin || data['writer'] == currentEmail) ...[
                              IconButton(
                                icon: Icon(Icons.edit, size: 16),
                                onPressed: () => _showEditDialog(context, doc.id, data),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, size: 16, color: Colors.red),
                                onPressed: () => _confirmDelete(context, doc.id),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList()
              ],
            );
          },
        ),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add),
        tooltip: '기도제목 추가',
      )
          : null,
    );
  }

  Widget _headerCell(String text) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)));

  Widget _textCell(String? text) =>
      Padding(padding: const EdgeInsets.all(8.0), child: Text(text ?? ''));

  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final targetController = TextEditingController();
    final relationController = TextEditingController();
    final introController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('🙏 기도제목 추가'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: '이름')),
              TextField(controller: targetController, decoration: InputDecoration(labelText: '전도대상자 이름')),
              TextField(controller: relationController, decoration: InputDecoration(labelText: '관계')),
              TextField(controller: introController, decoration: InputDecoration(labelText: '소개'), maxLines: 3),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('취소')),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('prayers').add({
                'name': nameController.text.trim(),
                'target': targetController.text.trim(),
                'relation': relationController.text.trim(),
                'intro': introController.text.trim(),
                'timestamp': FieldValue.serverTimestamp(),
              });
              Navigator.pop(context);
            },
            child: Text('등록'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, String docId, Map<String, dynamic> data) {
    final nameController = TextEditingController(text: data['name']);
    final targetController = TextEditingController(text: data['target']);
    final relationController = TextEditingController(text: data['relation']);
    final introController = TextEditingController(text: data['intro']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('✏️ 기도제목 수정'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: '이름')),
              TextField(controller: targetController, decoration: InputDecoration(labelText: '전도대상자 이름')),
              TextField(controller: relationController, decoration: InputDecoration(labelText: '관계')),
              TextField(controller: introController, decoration: InputDecoration(labelText: '소개'), maxLines: 3),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('취소')),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('prayers').doc(docId).update({
                'name': nameController.text.trim(),
                'target': targetController.text.trim(),
                'relation': relationController.text.trim(),
                'intro': introController.text.trim(),
              });
              Navigator.pop(context);
            },
            child: Text('수정'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('삭제 확인'),
        content: Text('정말 이 기도제목을 삭제하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('취소')),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('prayers').doc(docId).delete();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('삭제되었습니다.')));
            },
            child: Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
