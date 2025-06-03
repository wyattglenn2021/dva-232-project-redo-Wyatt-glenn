import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'welcome_page.dart';
import 'AccountStuff/login.dart';
import 'pages/home_page.dart';
import 'pages/explore_page.dart';
import 'pages/shelter_listing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isFirstLaunch = true;
  User? _user;
  String? _role;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
    _checkLoggedInStatus();
  }

  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenWelcome = prefs.getBool('hasSeenWelcomePage') ?? false;

    setState(() {
      _isFirstLaunch = !hasSeenWelcome;
    });
  }

  Future<void> _setFirstLaunchComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenWelcomePage', true);
  }

  Future<void> _checkLoggedInStatus() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        _user = user;
        _role = userDoc['role'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
return MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    scaffoldBackgroundColor: const Color.fromRGBO(245, 234, 230, 1),
    useMaterial3: true,
  ),
  home: _isFirstLaunch
      ? WelcomePage(
          onContinue: () async {
            await _setFirstLaunchComplete();
            setState(() {
              _isFirstLaunch = false;
            });
          },
        )
      : MainApp(role: _user == null ? null : _role),
  onGenerateRoute: (settings) {
    if (settings.name == '/listingManagement') {
      final shelterId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => ShelterListingsPage(shelterId: shelterId),
      );
    }

    if (settings.name == '/explore') {
      final isLoggedIn = _user != null;
      return MaterialPageRoute(
        builder: (context) => ExplorePage(
          onBookmark: (pet) {
            if (!isLoggedIn) {
              Navigator.pushNamed(context, '/login');
            }
          },
          isLoggedIn: isLoggedIn,
        ),
      );
    }

    if (settings.name == '/login') {
      return MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
    }

    return null;
  },
);

}
}

