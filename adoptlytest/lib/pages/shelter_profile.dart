import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class ShelterProfilePage extends StatelessWidget {
  const ShelterProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shelter Profile"),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text("Error loading profile. Please try again."),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

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
                        Text("Name: ${data['name'] ?? 'N/A'}"),
                        const SizedBox(height: 4),
                        Text("Email: ${data['email'] ?? 'N/A'}"),
                        const SizedBox(height: 4),
                        Text("Phone: ${data['phone'] ?? 'N/A'}"),
                        const SizedBox(height: 4),
                        Text("Address: ${data['address'] ?? 'N/A'}"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Manage Listings Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(48, 63, 81, 1),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () {
                      final shelterId = FirebaseAuth.instance.currentUser?.uid;
                      if (shelterId != null) {
                        Navigator.pushNamed(
                          context,
                          '/listingManagement',
                          arguments: shelterId, 
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error: Shelter ID not found')),
                        );
                      }
                    },
                    child: const Text(
                      "Manage Listings",
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
