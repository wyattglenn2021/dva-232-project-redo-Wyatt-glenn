import 'package:cloud_firestore/cloud_firestore.dart';

class MatchmakingAlgorithm {
  final Map<String, dynamic> userPreferences;

  MatchmakingAlgorithm({required this.userPreferences});

  Future<List<Map<String, dynamic>>> findTopMatches() async {
    try {
      QuerySnapshot usersSnapshot =
      await FirebaseFirestore.instance.collection('shelters').get();

      List<Map<String, dynamic>> allPets = [];

      for (var userDoc in usersSnapshot.docs) {
        final shelterData = userDoc.data() as Map<String, dynamic>;
        final petsSnapshot = await userDoc.reference.collection('pets').get();

        for (var petDoc in petsSnapshot.docs) {
          final petData = petDoc.data() as Map<String, dynamic>;

          // Merge shelter info into pet data
          final petWithShelterInfo = {
            ...petData,
            'email': petData['email'] ?? '',
            'phone': petData['phone'] ?? '',
            'address': petData['address'] ?? '',
            'shelterName': shelterData['name'] ?? '',
          };

          allPets.add(petWithShelterInfo);
        }
      }

      print("Fetched ${allPets.length} pets from Firebase");

      if (allPets.isEmpty) return [];

      List<Map<String, dynamic>> scoredPets = allPets.map((pet) {
        int score = 0;

        // Soft match by giving points instead of filtering out
        if (pet['species'] == userPreferences['preferredSpecies']) score += 30;
        if (pet['size'] == userPreferences['preferredSize']) score += 20;
        if (pet['activityLevel'] == userPreferences['preferredActivityLevel']) score += 15;
        if (pet['age'] == userPreferences['preferredAge']) score += 10;
        if (userPreferences['hasKids'] == true && pet['goodWithKids'] == true) score += 10;
        if (userPreferences['hasOtherPets'] == true && pet['interactsWithOtherPets'] == true) score += 10;

        // Match behavior traits as bonus points
        List<String> petTraits = List<String>.from(pet['behaviorTraits'] ?? []);
        int matchedTraits = (userPreferences['userPreferredTraits'] as List<String>)
            .where((trait) => petTraits.contains(trait))
            .length;
        score += matchedTraits * 5;

        return {
          ...pet,
          'compatibilityScore': score,
        };
      }).toList();

      // Sort pets by descending compatibility score
      scoredPets.sort((a, b) => b['compatibilityScore'].compareTo(a['compatibilityScore']));

      print("Returning ${scoredPets.length} ranked matches");

      return scoredPets;
    } catch (e) {
      print("Error in matchmaking: $e");
      return [];
    }
  }
}
