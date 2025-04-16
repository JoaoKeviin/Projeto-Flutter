import 'dart:convert';
import 'package:flutter/services.dart';

class MockService {
  Future<Map<String, dynamic>> loadMockData() async {
    final String response = await rootBundle.loadString('assets/mock_data.json');
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
    return posts.where((post) => post['userId'] == userId).map((post) => post as Map<String, dynamic>).toList();
  }
}