import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';
import '../models/user_state.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class RouteManager {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget page;

    switch (settings.name) {
      case '/':
        page = FutureBuilder(
          future:
              Provider.of<UserState>(
                settings.arguments as BuildContext? ??
                    navigatorKey.currentContext!,
                listen: false,
              ).checkLoginStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: const SizedBox(
                  height: 26,
                  width: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              );
            }

            if (snapshot.data == true) {
              return const HomeScreen();
            } else {
              return const LoginScreen();
            }
          },
        );
        break;

      case '/login':
        page = const LoginScreen();
        break;

      case '/home':
        page = const HomeScreen();
        break;

      default:
        page = Scaffold(body: Center(child: Text('未找到路由: ${settings.name}')));
    }

    // 统一使用fade效果
    return PageTransition(
      type: PageTransitionType.fade,
      child: page,
      settings: settings,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );
  }

  // 全局导航器key，用于在没有context的情况下进行导航
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}
