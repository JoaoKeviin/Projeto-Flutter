import 'dart:convert';
import 'package:flutter/services.dart';

class MockService {
  Future<Map<String, dynamic>> loadMockData() async {
    final String response = await rootBundle.loadString('assets/mock_data.json');
    print('Dados carregados: $response'); // Log para verificar o carregamento
    final data = json.decode(response);
    return data;
  }

  Future<Map<String, dynamic>> loadUserData(int userId) async {
    final data = await loadMockData();
    List<dynamic> users = data['user'] ?? [];
    return users.firstWhere((user) => user['id'] == userId, orElse: () => {});
  }

  Future<List<Map<String, dynamic>>> loadUserPosts(int userId) async {
    final data = await loadMockData();
    List<dynamic> posts = data['posts'] ?? [];
    return posts.where((post) => post['userId'] == userId).map((post) => Map<String, dynamic>.from(post)).toList();
  }

 Future<List<Map<String, dynamic>>> loadMessages(int userId, int chatId) async {
  final data = await loadMockData();
  List<dynamic> messages = data['messages'] ?? [];
  
  return messages.where((msg) => 
    (msg['fromUserId'] == userId && msg['toUserId'] == chatId) || 
    (msg['fromUserId'] == chatId && msg['toUserId'] == userId)
  ).map((msg) => Map<String, dynamic>.from(msg)).toList();
}

 Future<List<Map<String, dynamic>>> loadConversations(int userId) async {
  final data = await loadMockData();
  List<dynamic> messages = data['messages'] ?? [];
  List<dynamic> users = data['user'] ?? [];

  // Coletar ids únicos de usuários que têm conversas com o usuário atual
  var conversationUserIds = messages.where((message) =>
    message['fromUserId'] == userId || message['toUserId'] == userId
  ).map((message) =>
    message['fromUserId'] == userId ? message['toUserId'] : message['fromUserId']
  ).toSet();

  // Criar lista de conversas com detalhes do usuário
  return conversationUserIds.map((id) {
    var user = users.firstWhere((user) => user['id'] == id, orElse: () => null);
    return {
      'userId': user != null ? user['id'] : null,
      'userName': user != null ? user['name'] : 'Desconhecido',
    };
  }).where((conversation) => conversation['userId'] != null).toList();
}

}