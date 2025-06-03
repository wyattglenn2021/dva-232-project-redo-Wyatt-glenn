import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pet_detail_page.dart';

class MatchmakingPage extends StatefulWidget {
  final List<Map<String, dynamic>> matches;

  const MatchmakingPage({required this.matches, Key? key}) : super(key: key);

  @override
  _MatchmakingPageState createState() => _MatchmakingPageState();
}

class _MatchmakingPageState extends State<MatchmakingPage> {
  List<Map<String, dynamic>> bookmarkedPets = [];

  Future<void> _addToFavorites(Map<String, dynamic> pet) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User not logged in.')),
      );
      return;
    }

    try {
      final userDoc = FirebaseFirestore.instance.collection('shelters').doc(userId);

      final existingBookmarks = await userDoc.get();
      List<Map<String, dynamic>> favorites =
      List<Map<String, dynamic>>.from(existingBookmarks.data()?['bookmarkedPets'] ?? []);

      if (favorites.any((favPet) => favPet['name'] == pet['name'])) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${pet['name']} is already in your favorites.')),
        );
        return;
      }

      favorites.add(pet);
      await userDoc.update({'bookmarkedPets': favorites});

      setState(() {
        bookmarkedPets.add(pet);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${pet['name']} added to favorites!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding to favorites: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Matches'),
        backgroundColor: Colors.white,
      ),
      body: widget.matches.isEmpty
          ? const Center(child: Text('No matches found.'))
          : ListView.builder(
        itemCount: widget.matches.length,
        itemBuilder: (context, index) {
          final pet = widget.matches[index];
          final score = pet['compatibilityScore'];
          final percentage = ((score / 100) * 100).toStringAsFixed(1);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PetDetailPage(pet: pet)),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  pet['images'] != null && pet['images'].isNotEmpty
                      ? Image.memory(
                    base64Decode(pet['images'][0]),
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    height: 150,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.pets, size: 50, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet['name'] ?? 'Unknown',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Match: $percentage%',
                          style: const TextStyle(color: Colors.green, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Species: ${pet['species'] ?? 'Unknown'}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Age: ${pet['age'] ?? 'Unknown'}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF9A388),
                            minimumSize: const Size(double.infinity, 40),
                          ),
                          onPressed: () => _addToFavorites(pet),
                          icon: const Icon(Icons.favorite, color: Colors.white),
                          label: const Text(
                            'Add to Favorites',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
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
