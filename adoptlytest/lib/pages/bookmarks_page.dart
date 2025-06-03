import 'package:flutter/material.dart';
import 'pet_profile_page.dart';
import '../models/bookmarks_manager.dart';

class BookmarksPage extends StatefulWidget {
  final List<Map<String, dynamic>> bookmarkedPets; // Accept bookmarkedPets

  const BookmarksPage({Key? key, required this.bookmarkedPets})
      : super(key: key);

  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  Widget build(BuildContext context) {
// Use the bookmarkedPets list from the widget
    final bookmarks = widget.bookmarkedPets;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Pets',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: bookmarks.isEmpty
          ? const Center(
              child: Text(
                "No pets bookmarked yet!",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          : ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final pet = bookmarks[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetProfilePage(
                          name: pet['name'],
                          species: pet['species'] ?? 'Unknown',
                          breed: pet['breed'] ?? 'Unknown',
                          gender: pet['gender'] ?? 'Unknown',
                          age: pet['age'] ?? 'Unknown',
                          size: pet['size'] ?? 'Unknown',
                          behaviorTraits: pet['behaviorTraits'] ?? 'Unknown',
                          compatibility: pet['compatibility'] ?? 'Unknown',
                          activityLevel: pet['activityLevel'] ?? 'Unknown',
                          specialDiet: pet['specialDiet'] ?? 'Unknown',
                          vaccinationStatus:
                              pet['vaccinationStatus'] ?? 'Unknown',
                          email: pet['email'] ?? 'Unknown',
                          phone: pet['phone'] ?? 'Unknown',
                          address: pet['address'] ?? 'Unknown',
                          adoptionFee: pet['adoptionFee'] ?? 'Unknown',
                          images: pet['images'] ?? ['assets/default_image.png'],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(15),
                          ),
                          child: Image.asset(
                            pet['images']?[0] ?? 'assets/default_image.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.image,
                                size: 120,
                              ); // Placeholder for failed image
                            },
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pet['name'] ?? 'Unknown',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  pet['species'] ?? 'Unknown Species',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon:
                                const Icon(Icons.favorite, color: Colors.pink),
                            onPressed: () {
// Remove from bookmarks
                              setState(() {
                                widget.bookmarkedPets.removeAt(index);
                              });
                            },
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
