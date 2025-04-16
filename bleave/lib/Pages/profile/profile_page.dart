import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../widgets/feed_post.dart';
import '../../Services/storage_service.dart';
import '../../Services/mock_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<Map<String, dynamic>>? _userData;
  Future<List<Map<String, dynamic>>>? _userPosts;
  final MockService mockService = MockService();
  final StorageService _storageService = StorageService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final userId = await _storageService.getUserId();
    if (userId != null) {
      _userData = mockService.loadUserData(userId);
      _userPosts = mockService.loadUserPosts(userId);
    }
    setState(() {
      _isLoading = false; // Atualiza o estado de carregamento
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFF161922),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFF161922),
      body: FutureBuilder(
        future: Future.wait([_userData!, _userPosts!]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Erro: ${snapshot.error}');
            return Center(child: Text('Erro ao carregar dados'));
          } else if (snapshot.hasData) {
            var userData = snapshot.data![0];
            var userPosts = snapshot.data![1] as List<Map<String, dynamic>>;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                ProfileHeader(
                  name: userData['name'] ?? 'Nome não encontrado',
                  username: userData['username'] ?? 'Username não encontrado',
                  followers: userData['followers'] ?? 0,
                  following: userData['following'] ?? 0,
                ),
                ...userPosts.map((postData) => FeedPost(
                  content: postData['content'],
                  username: userData['username'],
                  userPhotoUrl: "https://via.placeholder.com/150",
                  likes: postData['likes'],
                  comments: postData['comments'],
                )).toList(),
              ],
            );
          }
          return Center(child: Text('Nenhum dado encontrado'));
        },
      ),
    );
  }
}