import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'adoption_page.dart'; 

class ShelterListingsPage extends StatelessWidget {
  final String shelterId;

  const ShelterListingsPage({required this.shelterId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (shelterId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Shelter Listings')),
        body: const Center(
          child: Text(
            'Error: Invalid shelter ID. Please log in again.',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Shelter Listings')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(shelterId) 
            .collection('pets') 
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No pets listed.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateAdoptionPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add a Pet"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50), // Green button
                    ),
                  ),
                ],
              ),
            );
          }

          final pets = snapshot.data!.docs;

          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index].data() as Map<String, dynamic>;
              return _buildPetCard(context, pet);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateAdoptionPage(),
            ),
          );
        },
        backgroundColor: const Color.fromRGBO(249, 163, 136, 1),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPetCard(BuildContext context, Map<String, dynamic> pet) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 4.0, spreadRadius: 2.0),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Pet image
              CircleAvatar(
                radius: 40,
                backgroundImage: pet['images'] != null && pet['images'].isNotEmpty
                    ? MemoryImage(base64Decode(pet['images'][0]))
                    : null,
                backgroundColor: const Color.fromARGB(255, 218, 207, 219),
                child: pet['images'] == null || pet['images'].isEmpty
                    ? const Icon(Icons.pets, size: 40, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 10),
              // Pet name and status
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet['name'] ?? 'Unknown',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    pet['status'] ?? 'Available',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Application logic
                },
                icon: const Icon(Icons.assignment_turned_in),
                label: const Text("Applications"),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Edit pet logic
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit"),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Remove pet logic
                },
                icon: const Icon(Icons.delete),
                label: const Text("Remove"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

