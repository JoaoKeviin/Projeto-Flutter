import 'package:flutter/material.dart';

class FeedPost extends StatelessWidget {
  final String content;
  final String username;
  final String userPhotoUrl;
  final int likes;
  final int comments;

  FeedPost({
    required this.content,
    required this.username,
    required this.userPhotoUrl,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Remover temporariamente
                    // CircleAvatar(
                    //   backgroundImage: NetworkImage(userPhotoUrl),
                    //   radius: 20,
                    // ),
                    SizedBox(width: 8),
                    Text(username, style: TextStyle(color: Colors.white)),
                  ],
                ),
                Icon(Icons.more_vert, color: Colors.white),
              ],
            ),
            SizedBox(height: 12),
            Text(content, style: TextStyle(color: Colors.white70)),
            SizedBox(height: 12),
            // Remover temporariamente
            // Image.asset(
            //   'assets/images/post-image.png', // Verifique o caminho da imagem
            //   fit: BoxFit.cover,
            // ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.red),
                    SizedBox(width: 4),
                    Text("$likes", style: TextStyle(color: Colors.white)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.comment, color: Colors.white),
                    SizedBox(width: 4),
                    Text("$comments comentários", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}