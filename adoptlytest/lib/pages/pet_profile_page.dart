import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/bookmarks_manager.dart';

class PetProfilePage extends StatefulWidget {
  final String name;
  final String species;
  final String breed;
  final String gender;
  final String age;
  final String size;
  final String behaviorTraits;
  final String compatibility;
  final String activityLevel;
  final String specialDiet;
  final String vaccinationStatus;
  final String email;
  final String phone;
  final String address;
  final String adoptionFee;
  final List<String> images;

  const PetProfilePage({
  Key? key,
  required this.name,
  required this.species,
  required this.breed,
  required this.gender,
  required this.age,
  required this.size,
  required this.behaviorTraits,
  required this.compatibility,
  required this.activityLevel,
  required this.specialDiet,
  required this.vaccinationStatus,
  required this.email,
  required this.phone,
  required this.address,required this.adoptionFee,
    required this.images,
  }) : super(key: key);

  @override
  _PetProfilePageState createState() => _PetProfilePageState();
}

class _PetProfilePageState extends State<PetProfilePage> {
  bool isBookmarked = false;

  void toggleBookmark(BuildContext context) {
    final petDetails = {
      'name': widget.name,
      'species': widget.species,
      'breed': widget.breed,
      'gender': widget.gender,
      'age': widget.age,
      'size': widget.size,
      'behaviorTraits': widget.behaviorTraits,
      'compatibility': widget.compatibility,
      'activityLevel': widget.activityLevel,
      'specialDiet': widget.specialDiet,
      'vaccinationStatus': widget.vaccinationStatus,
      'email': widget.email,
      'phone': widget.phone,
      'address': widget.address,
      'adoptionFee': widget.adoptionFee,
      'images': widget.images,
    };

    setState(() {
      if (BookmarksManager.isBookmarked(widget.name)) {
        BookmarksManager.removeBookmark(widget.name);
        isBookmarked = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.name} removed from bookmarks.')),
        );
      } else {
        BookmarksManager.addBookmark(petDetails);
        isBookmarked = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.name} added to bookmarks.')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text(
      'Pet Profile',
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
    backgroundColor: const Color(0xFFF5EAE6),
    elevation: 0,
    leading: const BackButton(color: Colors.black),
    actions: [
    IconButton( icon: Icon(
      isBookmarked ? Icons.favorite : Icons.favorite_border,
      color: Colors.red,
    ),
      onPressed: () => toggleBookmark(context),
    ),
    ],
      ),
      backgroundColor: const Color(0xFFF5EAE6),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageGallery(), // Display pet's image gallery
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Basic Information"),
                  _buildInfoRow("Name", widget.name),
                  _buildInfoRow("Species", widget.species),
                  _buildInfoRow("Breed", widget.breed),
                  _buildInfoRow("Gender", widget.gender),
                  _buildInfoRow("Age", widget.age),
                  _buildInfoRow("Size", widget.size),
                  const SizedBox(height: 20),
                  _buildSectionHeader("Personality and Temperament"),
                  _buildInfoRow("Behavior Traits", widget.behaviorTraits),
                  _buildInfoRow("Compatibility", widget.compatibility),
                  _buildInfoRow("Activity Level", widget.activityLevel),
                  const SizedBox(height: 20),
                  _buildSectionHeader("Health and Medical Details"),
                  _buildInfoRow("Special Diet", widget.specialDiet),
                  _buildInfoRow("Vaccination Status", widget.vaccinationStatus),
                  const SizedBox(height: 20),
                  _buildSectionHeader("Adoption Requirements"),
                  _buildInfoRow("Adoption Fee",
                      widget.adoptionFee.isEmpty ? "Not specified" : widget.adoptionFee),
                  const SizedBox(height: 20),
                  _buildSectionHeader("Contact Information"),
                  _buildInfoRow("Email", widget.email),
                  _buildInfoRow("Phone", widget.phone),
                  _buildInfoRow("Address", widget.address),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    return SizedBox(
        height: 250,
        child: widget.images.isNotEmpty
        ? PageView.builder(
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
      Uint8List imageBytes = base64Decode(widget.images[index]);return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.memory(
          imageBytes,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
        },
        )
            : const Center(
          child: Text("No images available"),
        ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
