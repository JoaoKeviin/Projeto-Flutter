import 'package:bleave/Pages/feed/feed.dart';
import 'package:flutter/material.dart';
import '../../Services/storage_service.dart';
import '../Login/login_page.dart';
import '../../Pages/Profile/profile_page.dart';
import '../../Pages/messagelist/messagelist_page.dart'; 
import '../../Pages/post/post.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final StorageService _storageService = StorageService();
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    userId = await _storageService.getUserId();
    setState(() {});
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    if (userId == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Atualiza as opções de widget para incluir userId
    final List<Widget> widgetOptions = <Widget>[
      userId != null ? FeedPage() : CircularProgressIndicator(),
     userId != null ? PostPage(userId: userId!) : CircularProgressIndicator(),
      userId != null 
          ? ConversationListPage(userId: userId!) 
          : CircularProgressIndicator(),
      ProfilePage(),
    ];

    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Novo Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Mensagens',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Color(0xFF161922),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}