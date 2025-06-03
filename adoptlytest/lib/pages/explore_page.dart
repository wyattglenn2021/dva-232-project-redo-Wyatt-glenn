import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petshelter/pages/pet_detail_page.dart';
import 'dart:convert';
import 'user_preferences.dart';
import '../models/pet.dart';
import 'matchmaking_algorithm.dart';
import 'matchmaking_page.dart';
import 'pet_profile_page.dart';

class ExplorePage extends StatefulWidget {
  final Function(Map<String, dynamic>) onBookmark;
  final bool isLoggedIn;

  const ExplorePage(
      {required this.onBookmark, required this.isLoggedIn, Key? key})
      : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  // Filters
  String? selectedActivityLevel;
  String? selectedAge;
  String? selectedGender;
  String? selectedSize;
  String? selectedSpecies;

  // Pets Data
  List<Map<String, dynamic>> allPets = [];
  List<Map<String, dynamic>> filteredPets = [];

  @override
  void initState() {
    super.initState();
    _fetchPets();
  }

  Future<void> _fetchPets() async {
    try {
      QuerySnapshot usersSnapshot =
      await FirebaseFirestore.instance.collection('shelters').get();

      List<Map<String, dynamic>> petsWithShelterNames = [];

      for (var userDoc in usersSnapshot.docs) {
        final shelterData = userDoc.data() as Map<String, dynamic>;

        if (shelterData['role'] == 'shelter') {
          final shelterName = shelterData['name'] ?? 'Unknown Shelter';
          final petsSnapshot = await userDoc.reference.collection('pets').get();

          for (var petDoc in petsSnapshot.docs) {
            final petData = petDoc.data() as Map<String, dynamic>;

            petsWithShelterNames.add({
              ...petData,
              'shelterName': shelterName,
            });
          }
        }
      }


      // Convert samplePets to Map format and add them to the list
      List<Map<String, dynamic>> samplePetsData = samplePets.map((pet) {
        return {
          'name': pet.name,
          'species': pet.species,
          'breed': pet.breed,
          'gender': pet.gender,
          'age': pet.age,
          'size': pet.size,
          'behaviorTraits': pet.behaviorTraits,
          'compatibility': pet.compatibility,
          'activityLevel': pet.activityLevel,
          'specialDiet': pet.specialDiet,
          'vaccinationStatus': pet.vaccinationStatus,
          'email': pet.email,
          'phone': pet.phone,
          'address': pet.address,
          'shelterName':
          "Sample Shelter", // Since sample pets aren't from Firebase
        };
      }).toList();

      setState(() {
        allPets = [...petsWithShelterNames, ...samplePetsData];
        filteredPets = allPets;
      });
    } catch (e) {
      print('Error fetching pets: $e');
    }
  }

  void _applyFilters() {
    setState(() {
      filteredPets = allPets.where((pet) {
        // Age parsing
        int? ageNumber;
        final ageStr = pet['age']?.toString().trim();
        if (ageStr != null && ageStr.isNotEmpty) {
          final match = RegExp(r'^\d+').firstMatch(ageStr);
          if (match != null) {
            ageNumber = int.tryParse(match.group(0)!);
          }
        }

        final ageMatches = selectedAge == null || (ageNumber != null && (
            (selectedAge == 'Young (0-3)' && ageNumber! >= 0 &&
                ageNumber <= 3) ||
                (selectedAge == 'Adult (3-6)' && ageNumber! > 3 &&
                    ageNumber <= 6) ||
                (selectedAge == 'Senior (9+)' && ageNumber! >= 9)
        ));

        final activityMatches = selectedActivityLevel == null ||
            pet['activityLevel'] == selectedActivityLevel;
        final genderMatches = selectedGender == null ||
            pet['gender'] == selectedGender;
        final sizeMatches = selectedSize == null || pet['size'] == selectedSize;
        final speciesMatches = selectedSpecies == null ||
            pet['species'] == selectedSpecies;

        return activityMatches && ageMatches && genderMatches && sizeMatches &&
            speciesMatches;
      }).toList();
    });
  }


  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) => SingleChildScrollView(
            controller: controller,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter Pets',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  _buildDropdownFilter(
                    label: 'Activity Level',
                    value: selectedActivityLevel,
                    items: ['Low', 'Medium', 'High'],
                    onChanged: (value) {
                      setState(() => selectedActivityLevel = value);
                    },
                  ),
                  _buildDropdownFilter(
                    label: 'Age',
                    value: selectedAge,
                    items: ['Young (0-3)', 'Adult (3-6)', 'Senior (9+)'],
                    onChanged: (value) {
                      setState(() => selectedAge = value);
                    },
                  ),
                  _buildDropdownFilter(
                    label: 'Gender',
                    value: selectedGender,
                    items: ['Male', 'Female'],
                    onChanged: (value) {
                      setState(() => selectedGender = value);
                    },
                  ),
                  _buildDropdownFilter(
                    label: 'Size',
                    value: selectedSize,
                    items: ['Small', 'Medium', 'Large'],
                    onChanged: (value) {
                      setState(() => selectedSize = value);
                    },
                  ),
                  _buildDropdownFilter(
                    label: 'Species',
                    value: selectedSpecies,
                    items: ['Dog', 'Cat', 'Bird', 'Other'],
                    onChanged: (value) {
                      setState(() => selectedSpecies = value);
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _applyFilters();
                        },
                        child: const Text('Apply Filters'),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedActivityLevel = null;
                            selectedAge = null;
                            selectedGender = null;
                            selectedSize = null;
                            selectedSpecies = null;
                            filteredPets = allPets;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Clear Filters'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }



  void _redirectToLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }

  Widget _buildDropdownFilter({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        value: value,
        onChanged: onChanged,
        items: items
            .map((item) =>
            DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ))
            .toList(),
      ),
    );
  }

  void _navigateToMatchmaking() async {
    print("Navigating to matchmaking...");

    Map<String, dynamic> userPreferences = {
      'preferredSpecies': selectedSpecies ?? 'Dog', // Default to 'Dog' if null
      'preferredSize': selectedSize ?? 'Medium', // Default size
      'preferredActivityLevel': selectedActivityLevel ?? 'Medium',
      'preferredAge': selectedAge ?? 'Young (0-3)', // Default age range
      'hasKids': false,
      'hasOtherPets': true,
      'userPreferredTraits': ['Friendly', 'Playful'],
    };

    print("User Preferences: $userPreferences");

    MatchmakingAlgorithm algorithm =
    MatchmakingAlgorithm(userPreferences: userPreferences);
    List<Map<String, dynamic>> topMatches = await algorithm.findTopMatches();

    print("Found ${topMatches.length} matches");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MatchmakingPage(matches: topMatches),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Pets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterModal,
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: _navigateToMatchmaking,
          ),
        ],
      ),
      body: filteredPets.isEmpty
          ? const Center(
        child: Text(
          'No pets found.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 14 / 15,
        ),
        padding: const EdgeInsets.all(10),
        itemCount: filteredPets.length,
        itemBuilder: (context, index) {
          final pet = filteredPets[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PetDetailPage(pet: pet),
                  ),
                );
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: pet['images'] != null &&
                        pet['images'].isNotEmpty
                        ? Image.memory(
                      base64Decode(pet['images'][0]),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                        : const Icon(Icons.pets,
                        size: 50, color: Colors.grey),
                  ),
                  ListTile(
                    title: Text(pet['name'] ?? 'Unknown'),
                    subtitle:
                    Text(pet['shelterName'] ?? 'Unknown Shelter'),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {
                        if (!widget.isLoggedIn) {
                          _redirectToLogin(context);
                        } else {
                          widget.onBookmark(pet);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: widget.isLoggedIn
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserPreferencesForm(),
            ),
          );
        },
        child: const Icon(Icons.pets),
      )
          : null,
    );
  }
}