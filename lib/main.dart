import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

// 导入平台兼容层
import 'platform_imports.dart';
import 'models/user_state.dart';

// 仅在Windows平台导入Windows特定实现
import 'platform_windows.dart'
    if (dart.library.js) 'platform_stubs/platform_windows_stub.dart';

// 仅在macOS平台上导入macOS特定包
import 'package:macos_window_utils/macos_window_utils.dart'
    if (dart.library.js) 'platform_stubs/macos_window_utils_stub.dart';
import 'package:macos_window_utils/widgets/transparent_macos_sidebar.dart'
    if (dart.library.js) 'platform_stubs/transparent_macos_sidebar_stub.dart';

// 导入应用程序组件
import 'screens/login_screen.dart';
import 'utils/route_manager.dart';
import 'utils/toast_helper.dart';

void main() async {
  // 确保Flutter绑定初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 仅在macOS平台初始化窗口操作工具
  if (!kIsWeb && Platform.isMacOS) {
    await WindowManipulator.initialize();

    // 在macOS平台上，我们会在实际运行时使用真正的MacOSWindowUtils
    // 这里不直接调用API，避免编译错误
  } else {
    await initializeMacOSWindowUtils();
  }

  // 启动应用
  runApp(const MyApp());

  // Windows平台特定的窗口设置
  if (!kIsWeb && Platform.isWindows) {
    doWhenWindowReady(() {
      const initialSize = Size(1400, 900);
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.title = "Tains";
      appWindow.show();
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserState())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        // 使用全局导航键，用于在没有context的情况下显示toast和导航
        navigatorKey: RouteManager.navigatorKey,
        // 使用builder添加ToastificationConfigProvider
        builder: (context, child) {
          return ToastificationConfigProvider(
            config: const ToastificationConfig(
              alignment: Alignment.topCenter,
              itemWidth: 300,
              maxToastLimit: 1,
              maxTitleLines: 1,
              maxDescriptionLines: 3,
            ),
            child: child!,
          );
        },
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.transparent,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            },
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontFamily: 'System',
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            displayMedium: TextStyle(
              fontFamily: 'System',
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            displaySmall: TextStyle(
              fontFamily: 'System',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: TextStyle(
              fontFamily: 'System',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            titleLarge: TextStyle(
              fontFamily: 'System',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            bodyLarge: TextStyle(fontFamily: 'System', fontSize: 16),
            bodyMedium: TextStyle(fontFamily: 'System', fontSize: 14),
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.transparent,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            },
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontFamily: 'System',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            displayMedium: TextStyle(
              fontFamily: 'System',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            displaySmall: TextStyle(
              fontFamily: 'System',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            headlineMedium: TextStyle(
              fontFamily: 'System',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            titleLarge: TextStyle(
              fontFamily: 'System',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            bodyLarge: TextStyle(
              fontFamily: 'System',
              fontSize: 16,
              color: Colors.white,
            ),
            bodyMedium: TextStyle(
              fontFamily: 'System',
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
        initialRoute: '/',
        onGenerateRoute: RouteManager.generateRoute,
      ),
    );
  }
}
