import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pet_profile_page.dart';

class CreateAdoptionPage extends StatefulWidget {
  @override
  _CreateAdoptionPageState createState() => _CreateAdoptionPageState();
}

class _CreateAdoptionPageState extends State<CreateAdoptionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  // Form controllers
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController speciesController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController specialDietController = TextEditingController();
  final TextEditingController adoptionFeeController = TextEditingController();

  // State variables
  String? selectedGender;
  String? selectedAge;
  String? selectedSize;
  String? selectedActivityLevel;
  List<String> selectedBehaviorTraits = [];
  bool isGoodWithKids = false;
  bool interactsWithOtherPets = false;
  String? vaccinationStatus;
  List<XFile>? _selectedImages = [];
  final List<String> _uploadedImageUrls = []; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Pet Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: const Color(0xFFF5EAE6),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader("Basic Information"),
              _buildTextField("Pet Name *", petNameController, required: true),
              _buildTextField("Species *", speciesController, required: true),
              _buildTextField("Breed", breedController),
              _spacer(),

              _sectionHeader("Gender"),
              _choiceRow(["Male", "Female"], selectedGender, (value) {
                setState(() => selectedGender = value);
              }),
              _spacer(),

              _sectionHeader("Age"),
              _choiceRow(["Young (0-3)", "Adult (3-6)", "Senior (9+)"], selectedAge, (value) {
                setState(() => selectedAge = value);
              }),
              _spacer(),

              _sectionHeader("Size"),
              _choiceRow(["Small", "Medium", "Large"], selectedSize, (value) {
                setState(() => selectedSize = value);
              }),
              _spacer(),

              _sectionHeader("Activity Level"),
              _choiceRow(["Low", "Medium", "High"], selectedActivityLevel, (value) {
                setState(() => selectedActivityLevel = value);
              }),
              _spacer(),

              _sectionHeader("Behavior Traits"),
              _buildTagButtons(
                ["Friendly", "Playful", "Affectionate", "Shy", "Independent"],
                selectedBehaviorTraits,
              ),
              _spacer(),

              _sectionHeader("Compatibility"),
              _buildCheckBox("Good with Kids", isGoodWithKids, (value) {
                setState(() => isGoodWithKids = value ?? false);
              }),
              _buildCheckBox("Interacts with Other Pets", interactsWithOtherPets, (value) {
                setState(() => interactsWithOtherPets = value ?? false);
              }),
              _spacer(),

              _sectionHeader("Health and Medical Details"),
              _buildTextField("Special Diet (Optional)", specialDietController),
              _spacer(),

              _sectionHeader("Vaccination Status"),
              _choiceRow(["Fully Vaccinated", "Not Vaccinated", "Unknown"], vaccinationStatus,
                  (value) {
                setState(() => vaccinationStatus = value);
              }),
              _spacer(),

              _sectionHeader("Pet Images"),
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _selectedImages == null || _selectedImages!.isEmpty
                      ? const Center(child: Text("Tap to upload images"))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                File(_selectedImages![index].path),
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                ),
              ),
              _spacer(),

              _sectionHeader("Adoption Fee"),
              _buildTextField("Adoption Fee (Optional)", adoptionFeeController),
              _spacer(),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(249, 163, 136, 1),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: _handleSubmit,
                  child: const Text(
                    "Submit",
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

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
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

  Widget _spacer() => const SizedBox(height: 20);

  Widget _buildTextField(String label, TextEditingController controller, {bool required = false, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: validator ??
              (value) {
            if (required && (value == null || value.isEmpty)) {
              return "This field is required.";
            }
            return null;
          },
    );
  }

  Widget _choiceRow(List<String> options, String? selectedValue, ValueChanged<String> onSelect) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((option) {
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: selectedValue == option ? Colors.grey : Colors.white,
            side: const BorderSide(color: Colors.black),
          ),
          onPressed: () => onSelect(option),
          child: Text(option, style: const TextStyle(color: Colors.black)),
        );
      }).toList(),
    );
  }

  Widget _buildTagButtons(List<String> options, List<String> selectedTags) {
    return Wrap(
      spacing: 10,
      children: options.map((option) {
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: selectedTags.contains(option) ? Colors.grey : Colors.white,
            side: const BorderSide(color: Colors.black),
          ),
          onPressed: () {
            setState(() {
              if (selectedTags.contains(option)) {
                selectedTags.remove(option);
              } else {
                selectedTags.add(option);
              }
            });
          },
          child: Text(option, style: const TextStyle(color: Colors.black)),
        );
      }).toList(),
    );
  }

  Widget _buildCheckBox(String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.black)),
      ],
    );
  }

  Future<void> _pickImages() async {
    final List<XFile>? pickedImages = await _imagePicker.pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        _selectedImages = pickedImages;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        for (var image in _selectedImages ?? []) {
          final bytes = await File(image.path).readAsBytes();
          _uploadedImageUrls.add(base64Encode(bytes));
        }

        final petData = {
          "name": petNameController.text,
          "species": speciesController.text,
          "breed": breedController.text,
          "gender": selectedGender ?? "Unknown",
          "age": selectedAge ?? "Unknown",
          "size": selectedSize ?? "Unknown",
          "activityLevel": selectedActivityLevel ?? "Unknown",
          "behaviorTraits": selectedBehaviorTraits,
          "goodWithKids": isGoodWithKids,
          "interactsWithOtherPets": interactsWithOtherPets,
          "specialDiet": specialDietController
              .text,
          "vaccinationStatus": vaccinationStatus ?? "Unknown",
          "adoptionFee": adoptionFeeController.text.isEmpty
              ? null
              : double.tryParse(adoptionFeeController.text),
          "images": _uploadedImageUrls, 
          "createdAt": FieldValue.serverTimestamp(),
        };

        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid == null) {
          throw Exception("User not logged in");
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('pets')
            .add(petData);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetProfilePage(
              name: petNameController.text,
              species: speciesController.text,
              breed: breedController.text,
              gender: selectedGender ?? "Unknown",
              age: selectedAge ?? "Unknown",
              size: selectedSize ?? "Unknown",
              activityLevel: selectedActivityLevel ?? "Unknown",
              behaviorTraits: selectedBehaviorTraits.join(", "),
              compatibility: (isGoodWithKids ? "Good with Kids, " : "") +
                  (interactsWithOtherPets ? "Interacts with Other Pets" : ""),
              specialDiet: specialDietController.text,
              vaccinationStatus: vaccinationStatus ?? "Unknown",
              adoptionFee: adoptionFeeController.text,
              email: FirebaseAuth.instance.currentUser?.email ?? "N/A",
              phone: FirebaseAuth.instance.currentUser?.phoneNumber ?? "N/A",
              address: "N/A",
              images: _uploadedImageUrls, 
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error creating profile: $e")),
        );
      }
    }
  }
}
