import 'package:flutter/material.dart';
import '../../Services/mock_service.dart';
import '../message/message.dart';

class ConversationListPage extends StatefulWidget {
  final int userId;

  ConversationListPage({required this.userId});

  @override
  _ConversationListPageState createState() => _ConversationListPageState();
}

class _ConversationListPageState extends State<ConversationListPage> {
  late Future<List<Map<String, dynamic>>> _conversations;
  final MockService mockService = MockService();

  @override
  void initState() {
    super.initState();
    _conversations = mockService.loadConversations(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversas', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF161922),
      ),
      backgroundColor: Color(0xFF1D1F33),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _conversations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar conversas'));
          } else if (snapshot.hasData) {
            var conversations = snapshot.data!;
            return ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                var conversation = conversations[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    conversation['userName'],
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessagesPage(userId: widget.userId, chatId: conversation['userId']),
                      ),
                    );
                  },
                );
              },
            );
          }
          return Center(child: Text('Nenhuma conversa encontrada'));
        },
      ),
    );
  }
}