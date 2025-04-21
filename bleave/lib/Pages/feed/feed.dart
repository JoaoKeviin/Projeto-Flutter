import 'package:flutter/material.dart';
import '../../Services/mock_service.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late Future<List<Map<String, dynamic>>> _posts;
  final MockService mockService = MockService();

  @override
  void initState() {
    super.initState();
    _posts = _loadPosts();
  }

  Future<List<Map<String, dynamic>>> _loadPosts() async {
    final data = await mockService.loadMockData();
    List<dynamic> posts = data['posts'] ?? [];
    List<dynamic> users = data['user'] ?? [];

    return posts.map<Map<String, dynamic>>((post) {
      var user = users.firstWhere((u) => u['id'] == post['userId'], orElse: () => <String, dynamic>{});
      return {
        'userName': user['name'] ?? 'Desconhecido',
        'userUsername': user['username'] ?? '@desconhecido',
        ...Map<String, dynamic>.from(post),
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF161922),
        title: Text('Feed', style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Color(0xFF1D1F33),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Erro ao carregar posts: ${snapshot.error}');
            return Center(child: Text('Erro ao carregar posts'));
          } else if (snapshot.hasData) {
            var posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                var post = posts[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  color: Color(0xFF1E1E2C),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              child: Icon(Icons.person, color: Colors.white),
                              backgroundColor: Colors.grey,
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(post['userName'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                Text(post['userUsername'], style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.more_vert, color: Colors.white),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(post['content'], style: TextStyle(color: Colors.white70)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.favorite, color: Colors.red),
                                SizedBox(width: 4),
                                Text('${post['likes']}', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.comment, color: Colors.white),
                                SizedBox(width: 4),
                                Text('75 comentários', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            Icon(Icons.share, color: Colors.white),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: Text('Nenhum post encontrado'));
        },
      ),
    );
  }
}