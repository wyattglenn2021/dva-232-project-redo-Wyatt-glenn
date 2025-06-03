import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> _fetchUserData() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Get the current user
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    // Fetch user data from Firestore
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(currentUser.uid).get();

    if (!userDoc.exists) {
      throw Exception("User data not found");
    }

    return userDoc.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No user data found."));
          }

          final userData = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Icon
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Account Information Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Account Information",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text("First Name: ${userData['firstName']}"),
                        const SizedBox(height: 4),
                        Text("Last Name: ${userData['lastName']}"),
                        const SizedBox(height: 4),
                        Text("Email: ${userData['email']}"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Manage Adoptions Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(48, 63, 81, 1),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/adoptionManagement',
                        arguments: 'user',
                      );
                    },
                    child: const Text(
                      "Manage Adoptions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Log Out Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(249, 163, 136, 1),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainApp(role: null),
                        ),
                        (route) => false, 
                      );
                    },
                    child: const Text(
                      "Log Out",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
