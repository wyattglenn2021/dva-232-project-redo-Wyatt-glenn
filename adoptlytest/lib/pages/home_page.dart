import 'package:flutter/material.dart';
import 'explore_page.dart';
import 'bookmarks_page.dart';
import 'user_profile.dart';
import 'shelter_profile.dart';
import 'adoption_page.dart';
import '../AccountStuff/login.dart';

class MainApp extends StatefulWidget {
  final String? role; 

  const MainApp({required this.role, Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  
  final List<Map<String, dynamic>> _bookmarkedPets = [];

  late final List<Widget> _pages;
  late final List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();
    _setupPages();
  }

  void _setupPages() {
    if (widget.role == 'user') {
      _pages = [
        ExplorePage(
          onBookmark: _addToBookmarks,
          isLoggedIn: true,
        ),
        BookmarksPage(bookmarkedPets: _bookmarkedPets),
        const UserProfilePage(),
      ];
      _navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Bookmarks'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ];
    } else if (widget.role == 'shelter') {
      _pages = [
        ExplorePage(
          onBookmark: (pet) {}, 
          isLoggedIn: true,
        ),
         CreateAdoptionPage(),
        const ShelterProfilePage(),
      ];
      _navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Add Pet'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ];
    } else {
      // Pages for not logged-in user
      _pages = [
        ExplorePage(
          onBookmark: (pet) {
            Navigator.pushReplacementNamed(context, '/login'); 
          },
          isLoggedIn: false,
        ),
         LoginPage(),
      ];
      _navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login'),
      ];
    }
  }

  void _addToBookmarks(Map<String, dynamic> pet) {
    setState(() {
      if (!_bookmarkedPets.contains(pet)) {
        _bookmarkedPets.add(pet);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${pet['name']} added to favorites!')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _navItems,
      ),
    );
  }
}
