import 'package:flutter/material.dart';
import '../../Services/mock_service.dart';

class MessagesPage extends StatefulWidget {
  final int userId;
  final int chatId;

  MessagesPage({required this.userId, required this.chatId});

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late Future<List<Map<String, dynamic>>> _messages;
  final MockService mockService = MockService();
  String chatUserName = 'Usuário';

  @override
  void initState() {
    super.initState();
    _loadMessagesAndChatUser();
  }

  Future<void> _loadMessagesAndChatUser() async {
    _messages = mockService.loadMessages(widget.userId, widget.chatId);
    var userData = await mockService.loadUserData(widget.chatId);
    setState(() {
      chatUserName = userData['name'] ?? 'Desconhecido';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatUserName, style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white), // Define a cor da seta
        backgroundColor: Color(0xFF161922),
      ),
      backgroundColor: Color(0xFF1D1F33),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _messages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar mensagens'));
          } else if (snapshot.hasData) {
            var messages = snapshot.data!;
            if (messages.isEmpty) {
              return Center(child: Text('Nenhuma mensagem encontrada'));
            }
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var message = messages[index];
                bool isSentByMe = message['fromUserId'] == widget.userId;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    leading: isSentByMe ? null : CircleAvatar(child: Icon(Icons.person)),
                    trailing: isSentByMe ? CircleAvatar(child: Icon(Icons.person)) : null,
                    title: Align(
                      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(
                        message['message'],
                        style: TextStyle(
                          color: isSentByMe ? Colors.blue : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Align(
                      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(
                        message['timestamp'],
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: Text('Nenhuma mensagem encontrada'));
        },
      ),
    );
  }
}