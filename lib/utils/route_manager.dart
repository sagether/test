import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../screens/login_screen.dart';
import '../services/user_provider.dart';
import '../widgets/platform_container.dart';
import 'package:provider/provider.dart';

class RouteManager {
  static const String loginRoute = '/';
  static const String homeRoute = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const LoginScreen(),
          settings: settings,
          duration: const Duration(milliseconds: 300),
        );
      case homeRoute:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const HomePage(),
          settings: settings,
          duration: const Duration(milliseconds: 300),
        );
      default:
        return PageTransition(
          type: PageTransitionType.fade,
          child: Scaffold(
            body: Center(child: Text('没有找到路由: ${settings.name}')),
          ),
          settings: settings,
          duration: const Duration(milliseconds: 300),
        );
    }
  }

  // 检查用户是否已登录并重定向到适当的页面
  static void checkAuthAndRedirect(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.isLoggedIn) {
      Navigator.of(context).pushReplacementNamed(homeRoute);
    } else {
      Navigator.of(context).pushReplacementNamed(loginRoute);
    }
  }
}

// 占位首页组件，实际应用中应该创建单独的文件
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return PlatformContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '欢迎回来，${userProvider.user?.name ?? "用户"}',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await userProvider.logout();
                  if (context.mounted) {
                    Navigator.of(
                      context,
                    ).pushReplacementNamed(RouteManager.loginRoute);
                  }
                },
                child: const Text('退出登录'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
