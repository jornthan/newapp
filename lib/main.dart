import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'prayer_list_page.dart'; // lib/ 안에 있는 경우





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase App',
      home: AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> handleLoginById() async {
    final userId = _idController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw '등록되지 않은 사용자 ID입니다.';
      }

      final email = userDoc['email'];

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainPage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ID 로그인")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: _idController, decoration: InputDecoration(labelText: 'ID')),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: '비밀번호'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: handleLoginById, child: Text('로그인')),
          ],
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String nickname = '';

  @override
  void initState() {
    super.initState();
    _loadNickname();
  }

  Future<void> _loadNickname() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        setState(() {
          nickname = query.docs.first['nickname'] ?? '사용자';
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: Text('메인 페이지')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 👤 사용자 카드
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.deepPurple,
                      child: Text(
                        nickname.isNotEmpty ? nickname[0] : '?',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        '환영합니다, $nickname님!',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // 🧭 버튼 카드
            Expanded(
              child: ListView(
                children: [
                  _menuCard(
                    icon: Icons.group,
                    title: '등록된 친구 목록',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PostListPage())),
                  ),
                  _menuCard(
                    icon: Icons.person_add,
                    title: '친구등록',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UploadPage())),
                  ),
                  _menuCard(
                    icon: Icons.favorite,
                    title: '기도부탁 명단',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PrayerListPage())),
                  ),
                  _menuCard(
                    icon: Icons.logout,
                    title: '로그아웃',
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AuthPage()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard({required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, size: 30, color: Colors.deepPurple),
        title: Text(title, style: TextStyle(fontSize: 16)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}



class PostListPage extends StatefulWidget {
  @override
  _PostListPageState createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String? currentEmail;

  @override
  void initState() {
    super.initState();
    currentEmail = FirebaseAuth.instance.currentUser?.email;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.1), end: Offset.zero).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _canDelete(Map<String, dynamic> data) {
    return data['author'] == currentEmail || currentEmail == "admin@example.com";
  }

  void _confirmDelete(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('삭제 확인'),
        content: Text('정말 이 게시글을 삭제하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('취소')),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('삭제 완료')));
            },
            child: Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('등록된 친구 목록')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 3,
                    child: ListTile(
                      title: Text(data['name'] ?? ''),
                      subtitle: Text(data['mbti'] ?? ''),
                      leading: CircleAvatar(
                        backgroundImage: data['photoUrl'] != null && data['photoUrl'] != ''
                            ? NetworkImage(data['photoUrl'])
                            : null,
                        child: data['photoUrl'] == null || data['photoUrl'] == ''
                            ? Icon(Icons.person)
                            : null,
                      ),
                      trailing: _canDelete(data)
                          ? IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, doc.id),
                      )
                          : null,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PostDetailPage(postId: doc.id)),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}



class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final _nameController = TextEditingController();
  final _personalityController = TextEditingController();
  final _mbtiController = TextEditingController();
  final _foodController = TextEditingController();
  final _hobbyController = TextEditingController();
  final _subjectController = TextEditingController();
  final _datingController = TextEditingController();
  final _colorController = TextEditingController();
  final _commonController = TextEditingController();
  final _locationController = TextEditingController();
  final _dreamController = TextEditingController();
  final _goalController = TextEditingController(text: "친구를 더 잘 알아가기");
  final _noteController = TextEditingController();

  XFile? _selectedImage;
  String? _photoUrl;

  /// ✅ 사진 선택 및 권한 처리
  Future<void> _pickImage() async {
    final status = await Permission.photos.request(); // or storage for Android < 13
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사진 접근 권한이 필요합니다.')),
      );
      return;
    }

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = picked;
      });
    }
  }

  /// ✅ 업로드 처리
  Future<void> uploadFriendProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 정보가 없습니다.')),
      );
      return;
    }

    try {
      String photoUrl = '';
      if (_selectedImage != null) {
        final file = File(_selectedImage!.path);
        if (await file.exists()) {
          final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
          final ref = FirebaseStorage.instance.ref().child('uploads/$fileName');
          final uploadTask = await ref.putFile(file);
          if (uploadTask.state == TaskState.success) {
            photoUrl = await ref.getDownloadURL();
          } else {
            throw '이미지 업로드 실패';
          }
        }
      }

      await FirebaseFirestore.instance.collection('posts').add({
        'name': _nameController.text.trim(),
        'personality': _personalityController.text.trim(),
        'mbti': _mbtiController.text.trim(),
        'food': _foodController.text.trim(),
        'hobby': _hobbyController.text.trim(),
        'subject': _subjectController.text.trim(),
        'dating': _datingController.text.trim(),
        'color': _colorController.text.trim(),
        'common': _commonController.text.trim(),
        'location': _locationController.text.trim(),
        'dream': _dreamController.text.trim(),
        'goal': _goalController.text.trim(),
        'note': _noteController.text.trim(),
        'photoUrl': photoUrl,
        'author': user.email,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('친구가 등록되었습니다.')));
      Navigator.pop(context);
    } catch (e) {
      print('🔥 업로드 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('등록 실패: $e')));
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('친구등록')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField('이름', _nameController),
            _buildTextField('성격', _personalityController),
            _buildTextField('MBTI', _mbtiController),
            _buildTextField('좋아하는 음식', _foodController),
            _buildTextField('취미/특기', _hobbyController),
            _buildTextField('좋아하는 과목', _subjectController),
            _buildTextField('이성친구 유무', _datingController),
            _buildTextField('좋아하는 색깔', _colorController),
            _buildTextField('나와의 공통점', _commonController),
            _buildTextField('사는 곳', _locationController),
            _buildTextField('장래희망(직업)', _dreamController),
            _buildTextField('활동 목표', _goalController),
            _buildTextField('관찰 메모', _noteController, maxLines: 4),
            SizedBox(height: 12),
            _selectedImage == null
                ? Text("선택된 사진 없음")
                : Image.file(File(_selectedImage!.path), height: 100),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('사진 선택'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadFriendProfile,
              child: Text('등록'),
            ),
            SizedBox(height: 80), // 하단 여백
          ],
        ),
      ),
    );
  }
}


class PostDetailPage extends StatefulWidget {
  final String postId;
  const PostDetailPage({required this.postId});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  Map<String, dynamic> data = {};
  late TextEditingController _goalController;
  late TextEditingController _noteController;
  String? currentEmail;

  @override
  void initState() {
    super.initState();
    _goalController = TextEditingController();
    _noteController = TextEditingController();
    currentEmail = FirebaseAuth.instance.currentUser?.email;
    _loadData();
  }

  Future<void> _loadData() async {
    final doc = await FirebaseFirestore.instance.collection('posts').doc(widget.postId).get();
    if (doc.exists) {
      final loadedData = doc.data()!;
      setState(() {
        data = loadedData;
        _goalController.text = loadedData['goal'] ?? '친구를 더 잘 알아가기';
        _noteController.text = loadedData['note'] ?? '';
      });
    }
  }

  Future<void> _saveEditableFields() async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
        'goal': _goalController.text.trim(),
        'note': _noteController.text.trim(),
        'editedAt': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('저장 완료')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('저장 실패: $e')));
    }
  }

  TableRow _row(String l1, String? v1, String l2, String? v2) {
    return TableRow(
      children: [
        Container(
          color: Colors.yellow[100],
          padding: EdgeInsets.all(8),
          child: Text(l1, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(padding: EdgeInsets.all(8), child: Text(v1 ?? '')),
        Container(
          color: Colors.yellow[100],
          padding: EdgeInsets.all(8),
          child: Text(l2, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(padding: EdgeInsets.all(8), child: Text(v2 ?? '')),
      ],
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 100,
            padding: EdgeInsets.all(8),
            color: Colors.yellow[100],
            child: Text(label),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey)),
              ),
              child: Text(value ?? ''),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isOwner = data['author'] == currentEmail || currentEmail == "admin@example.com";

    return Scaffold(
      backgroundColor: Color(0xFFE8F0FF),
      appBar: AppBar(
        title: Text('친구 관찰일지'),
        actions: [
          if (isOwner)
            IconButton(
              icon: Icon(Icons.edit),
              tooltip: '수정하기',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditPage(postId: widget.postId, originalData: data),
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            Text("친구 관찰일지", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),

            // 관찰 대상 + 목표
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _infoRow("관찰 대상", data['name']),
                  TextField(
                    controller: _goalController,
                    decoration: InputDecoration(labelText: '활동 목표'),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // 사진 영역
            Container(
              color: Colors.green[50],
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/character.png',
                      height: 100,
                      errorBuilder: (_, __, ___) =>
                          Icon(Icons.broken_image, size: 80),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        data['photoUrl'] != null && data['photoUrl'] != ''
                            ? Image.network(data['photoUrl'], height: 100)
                            : Icon(Icons.image_not_supported, size: 80),
                        SizedBox(height: 8),
                        Text("이곳에 사진을 부착하세요.", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // 테이블 정보
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Table(
                border: TableBorder.all(),
                columnWidths: {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(3),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(3),
                },
                children: [
                  _row('성격', data['personality'], 'MBTI', data['mbti']),
                  _row('좋아하는 음식', data['food'], '취미/특기', data['hobby']),
                  _row('좋아하는 과목', data['subject'], '이성친구 유무', data['dating']),
                  _row('나와의 공통점', data['common'], '좋아하는 색깔', data['color']),
                  _row('사는 곳', data['location'], '장래희망(직업)', data['dream']),
                ],
              ),
            ),

            SizedBox(height: 20),

            // 메모 입력
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(12),
              color: Colors.grey[100],
              width: double.infinity,
              child: TextField(
                controller: _noteController,
                maxLines: 5,
                decoration: InputDecoration.collapsed(
                  hintText: '친구를 관찰하며 느낀 점이나 계획을 적어보세요.',
                ),
              ),
            ),

            SizedBox(height: 20),

            // 저장 버튼 (optional)
            if (isOwner)
              ElevatedButton.icon(
                onPressed: _saveEditableFields,
                icon: Icon(Icons.save),
                label: Text('목표 및 메모 저장'),
              ),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}



class EditPage extends StatefulWidget {
  final String postId;
  final Map<String, dynamic> originalData;

  EditPage({required this.postId, required this.originalData});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController _nameController;
  late TextEditingController _personalityController;
  late TextEditingController _mbtiController;
  late TextEditingController _foodController;
  late TextEditingController _hobbyController;
  late TextEditingController _subjectController;
  late TextEditingController _datingController;
  late TextEditingController _colorController;
  late TextEditingController _commonController;
  late TextEditingController _locationController;
  late TextEditingController _dreamController;
  late TextEditingController _goalController;
  late TextEditingController _noteController;

  XFile? _newImage;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    final d = widget.originalData;
    _nameController = TextEditingController(text: d['name']);
    _personalityController = TextEditingController(text: d['personality']);
    _mbtiController = TextEditingController(text: d['mbti']);
    _foodController = TextEditingController(text: d['food']);
    _hobbyController = TextEditingController(text: d['hobby']);
    _subjectController = TextEditingController(text: d['subject']);
    _datingController = TextEditingController(text: d['dating']);
    _colorController = TextEditingController(text: d['color']);
    _commonController = TextEditingController(text: d['common']);
    _locationController = TextEditingController(text: d['location']);
    _dreamController = TextEditingController(text: d['dream']);
    _goalController = TextEditingController(text: d['goal'] ?? '친구를 더 잘 알아가기');
    _noteController = TextEditingController(text: d['note'] ?? '');
    _photoUrl = d['photoUrl'];
  }

  Future<void> updatePost() async {
    try {
      if (_newImage != null) {
        final file = File(_newImage!.path);
        if (!await file.exists()) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('선택한 이미지가 존재하지 않습니다.')));
          return;
        }

        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final ref = FirebaseStorage.instance.ref().child('uploads/$fileName');
        final snapshot = await ref.putFile(file);

        if (snapshot.state == TaskState.success) {
          _photoUrl = await ref.getDownloadURL();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('사진 업로드에 실패했습니다.')));
          return;
        }
      }

      await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
        'name': _nameController.text.trim(),
        'personality': _personalityController.text.trim(),
        'mbti': _mbtiController.text.trim(),
        'food': _foodController.text.trim(),
        'hobby': _hobbyController.text.trim(),
        'subject': _subjectController.text.trim(),
        'dating': _datingController.text.trim(),
        'color': _colorController.text.trim(),
        'common': _commonController.text.trim(),
        'location': _locationController.text.trim(),
        'dream': _dreamController.text.trim(),
        'goal': _goalController.text.trim(),
        'note': _noteController.text.trim(),
        'photoUrl': _photoUrl ?? widget.originalData['photoUrl'] ?? '',
        'editedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('수정이 완료되었습니다.')));
      Navigator.pop(context);
    } catch (e) {
      print('🔥 수정 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('수정 중 오류 발생: $e')));
    }
  }

  Widget _buildField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('게시물 수정')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildField('이름', _nameController),
            _buildField('성격', _personalityController),
            _buildField('MBTI', _mbtiController),
            _buildField('좋아하는 음식', _foodController),
            _buildField('취미/특기', _hobbyController),
            _buildField('좋아하는 과목', _subjectController),
            _buildField('이성친구 유무', _datingController),
            _buildField('좋아하는 색깔', _colorController),
            _buildField('나와의 공통점', _commonController),
            _buildField('사는 곳', _locationController),
            _buildField('장래희망(직업)', _dreamController),
            _buildField('활동 목표', _goalController),
            _buildField('관찰 메모', _noteController, maxLines: 4),
            SizedBox(height: 12),
            _newImage != null
                ? Image.file(File(_newImage!.path), height: 100)
                : (_photoUrl != null && _photoUrl!.isNotEmpty
                ? Image.network(_photoUrl!, height: 100)
                : Text('등록된 사진 없음')),
            ElevatedButton(
              onPressed: () async {
                final picker = ImagePicker();
                final picked = await picker.pickImage(source: ImageSource.gallery);
                if (picked != null) {
                  setState(() {
                    _newImage = picked;
                  });
                }
              },
              child: Text('사진 변경'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: updatePost, child: Text('수정 완료')),
          ],
        ),
      ),
    );
  }
}
