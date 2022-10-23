import 'package:bintang_timur/dashboard/pos/cart_provider.dart';
import 'package:bintang_timur/dashboard/pos/counter_provider.dart';
import 'package:bintang_timur/screens/splash_screen.dart';
import 'package:bintang_timur/widget/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => Counter(),
    ),
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
    ),
  ], child: const MyApp()));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, child) => MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
      designSize: const Size(1080, 2340),
    );
  }
}
