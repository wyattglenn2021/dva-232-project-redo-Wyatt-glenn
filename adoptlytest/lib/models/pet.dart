class Pet {
  final String name;
  final String species;
  final String breed;
  final String gender;
  final String age;
  final String size;
  final List<String> behaviorTraits;
  final List<String> compatibility;
  final String activityLevel;
  final String specialDiet;
  final String vaccinationStatus;
  final String email;
  final String phone;
  final String address;

  Pet({
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
    required this.address,
  });
}

// Sample Pet Data
List<Pet> samplePets = [
  Pet(
    name: "Buddy",
    species: "Dog",
    breed: "Golden Retriever",
    gender: "Male",
    age: "2 years",
    size: "Large",
    behaviorTraits: ["Friendly", "Loyal", "Energetic"],
    compatibility: ["Good with kids", "Good with other dogs"],
    activityLevel: "High",
    specialDiet: "None",
    vaccinationStatus: "Up to date",
    email: "buddy@petadoption.com",
    phone: "123-456-7890",
    address: "123 Pet Street, Dogtown, USA",
  ),
  Pet(
    name: "Luna",
    species: "Cat",
    breed: "Siamese",
    gender: "Female",
    age: "3 years",
    size: "Medium",
    behaviorTraits: ["Affectionate", "Vocal", "Playful"],
    compatibility: ["Good with other cats", "Good for apartment living"],
    activityLevel: "Medium",
    specialDiet: "Grain-free",
    vaccinationStatus: "Up to date",
    email: "luna@petadoption.com",
    phone: "987-654-3210",
    address: "456 Meow Lane, Catville, USA",
  ),
  Pet(
    name: "Charlie",
    species: "Dog",
    breed: "Beagle",
    gender: "Male",
    age: "1 year",
    size: "Medium",
    behaviorTraits: ["Curious", "Friendly", "High Energy"],
    compatibility: ["Good with kids", "Good with active owners"],
    activityLevel: "High",
    specialDiet: "None",
    vaccinationStatus: "Up to date",
    email: "charlie@petadoption.com",
    phone: "555-123-4567",
    address: "789 Woof Road, Barktown, USA",
  ),
  Pet(
    name: "Daisy",
    species: "Rabbit",
    breed: "Holland Lop",
    gender: "Female",
    age: "6 months",
    size: "Small",
    behaviorTraits: ["Calm", "Social", "Gentle"],
    compatibility: ["Good with kids", "Good with calm pets"],
    activityLevel: "Low",
    specialDiet: "Fresh greens required",
    vaccinationStatus: "Not required",
    email: "daisy@petadoption.com",
    phone: "321-987-6543",
    address: "101 Bunny Blvd, Hopville, USA",
  ),
  Pet(
    name: "Max",
    species: "Dog",
    breed: "Labrador Retriever",
    gender: "Male",
    age: "4 years",
    size: "Large",
    behaviorTraits: ["Obedient", "Loving", "Energetic"],
    compatibility: ["Good with kids", "Good with other dogs"],
    activityLevel: "Medium",
    specialDiet: "High protein",
    vaccinationStatus: "Up to date",
    email: "max@petadoption.com",
    phone: "789-654-3210",
    address: "202 Fetch Street, Playtown, USA",
  ),
  Pet(
    name: "Brodie",
    species: "Dog",
    breed: "Labrador Retriever",
    gender: "Male",
    age: "2 years",
    size: "Medium",
    behaviorTraits: ["Obedient", "Loving", "Energetic"],
    compatibility: ["Good with kids", "Good with other dogs"],
    activityLevel: "Medium",
    specialDiet: "High protein",
    vaccinationStatus: "Up to date",
    email: "max@petadoption.com",
    phone: "789-654-3210",
    address: "202 Fetch Street, Playtown, USA",
  ),
];
