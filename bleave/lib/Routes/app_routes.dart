import 'package:flutter/material.dart';
import '../pages/login/login_page.dart';

class AppRoutes {
  static const String login = '/login';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => LoginPage(),
    };
  }
}