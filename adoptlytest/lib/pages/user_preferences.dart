import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'matchmaking_algorithm.dart';
import 'matchmaking_page.dart';

class UserPreferencesForm extends StatefulWidget {
  @override
  _UserPreferencesFormState createState() => _UserPreferencesFormState();
}

class _UserPreferencesFormState extends State<UserPreferencesForm> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String? preferredSpecies;
  String? preferredActivityLevel;
  String? preferredAge;
  List<String> selectedTraits = [];
  bool hasKids = false;
  bool hasOtherPets = false;

  void _savePreferences() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User not logged in.')),
      );
      return;
    }

    try {
      // Save preferences to Firestore
      final preferences = {
        'preferredSpecies': preferredSpecies,
        'preferredActivityLevel': preferredActivityLevel,
        'preferredAge': preferredAge,
        'userPreferredTraits': selectedTraits,
        'hasKids': hasKids,
        'hasOtherPets': hasOtherPets,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set({'preferences': preferences}, SetOptions(merge: true));

      // Fetch matches using matchmaking algorithm
      final algorithm = MatchmakingAlgorithm(userPreferences: preferences);
      final matches = await algorithm.findTopMatches();

      // Navigate to Matchmaking Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MatchmakingPage(matches: matches),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving preferences: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adoptly Matchmaking'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Preferred Species',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: preferredSpecies,
                items: ['Dog', 'Cat', 'Bird', 'Other']
                    .map((species) => DropdownMenuItem(
                          value: species,
                          child: Text(species),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => preferredSpecies = value),
                decoration: const InputDecoration(hintText: 'Select species'),
                validator: (value) => value == null ? 'Please select a species' : null,
              ),
              const SizedBox(height: 16),

              const Text(
                'Activity Level',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: preferredActivityLevel,
                items: ['Low', 'Medium', 'High']
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => preferredActivityLevel = value),
                decoration: const InputDecoration(hintText: 'Select activity level'),
                validator: (value) => value == null ? 'Please select an activity level' : null,
              ),
              const SizedBox(height: 16),

              const Text(
                'Preferred Age',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: preferredAge,
                items: ['Young (0-3)', 'Adult (3-6)', 'Senior (9+)']
                    .map((age) => DropdownMenuItem(
                          value: age,
                          child: Text(age),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => preferredAge = value),
                decoration: const InputDecoration(hintText: 'Select age group'),
                validator: (value) => value == null ? 'Please select an age group' : null,
              ),
              const SizedBox(height: 16),

              const Text(
                'Behavior Traits',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 10,
                children: ['Friendly', 'Shy', 'Independent', 'Playful', 'Affectionate']
                    .map((trait) => FilterChip(
                          label: Text(trait),
                          selected: selectedTraits.contains(trait),
                          onSelected: (isSelected) {
                            setState(() {
                              isSelected
                                  ? selectedTraits.add(trait)
                                  : selectedTraits.remove(trait);
                            });
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),

              CheckboxListTile(
                title: const Text('I have kids'),
                value: hasKids,
                onChanged: (value) => setState(() => hasKids = value ?? false),
              ),
              CheckboxListTile(
                title: const Text('I have other pets'),
                value: hasOtherPets,
                onChanged: (value) => setState(() => hasOtherPets = value ?? false),
              ),
              const SizedBox(height: 16),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(249, 163, 136, 1),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: _savePreferences,
                  child: const Text(
                    'Get my purfect match!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
