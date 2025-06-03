import 'package:flutter/material.dart';

class AdoptionFormPage extends StatefulWidget {
  @override
  _AdoptionFormPageState createState() => _AdoptionFormPageState();
}

class _AdoptionFormPageState extends State<AdoptionFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dayStayController = TextEditingController();
  final TextEditingController nightStayController = TextEditingController();
  final TextEditingController petCareController = TextEditingController();
  final TextEditingController adoptionReasonController = TextEditingController();

  // State variables
  String? rentOrOwn;
  String? landlordApproval;
  List<String> householdMembers = [];
  String? hasAllergies;
  String? petAloneHours;
  String? trainingTime;
  String? outdoorSpace;
  String? preparedForCommitment;
  String? financialAbility;
  String? willingToTrain;

  bool _validateForm() {
    if (_formKey.currentState!.validate()) {
      if (rentOrOwn == null ||
          (rentOrOwn == "Rent" && landlordApproval == null) ||
          householdMembers.isEmpty ||
          hasAllergies == null ||
          petAloneHours == null ||
          trainingTime == null ||
          outdoorSpace == null ||
          preparedForCommitment == null ||
          financialAbility == null ||
          willingToTrain == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all required fields.")),
        );
        return false;
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Adoption Form',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: const BackButton(color: Colors.black),
        backgroundColor: const Color(0xFFF5EAE6),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5EAE6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader("Adopter Information"),
              _buildTextField("Full Name", fullNameController, required: true),
              const SizedBox(height: 16),
              _buildTextField("Email Address", emailController, required: true, email: true),
              const SizedBox(height: 16),
              _buildTextField("Phone Number", phoneController, required: true, phone: true),
              const SizedBox(height: 16),
              _buildTextField("Address", addressController, required: true),
              const SizedBox(height: 24),

              _sectionHeader("Household Information"),
              const Text(
                "Do you rent or own your home?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _choiceRow(["Rent", "Own"], rentOrOwn, (value) {
                setState(() => rentOrOwn = value);
              }),
              if (rentOrOwn == "Rent") ...[
                const SizedBox(height: 16),
                _dropdownField(
                  "If you rent, do you have landlord approval to have pets?",
                  ["Yes", "No"],
                  landlordApproval,
                      (value) {
                    setState(() => landlordApproval = value);
                  },
                ),
              ],
              const SizedBox(height: 16),
              _multiChoiceRow([
                "Adults",
                "Children (under 12)",
                "Teens (12–18)"
              ], householdMembers, "Who lives in your household?"),
              const SizedBox(height: 16),
              _dropdownField(
                "Does anyone in your household have allergies to animals?",
                ["Yes", "No"],
                hasAllergies,
                    (value) {
                  setState(() => hasAllergies = value);
                },
              ),
              const SizedBox(height: 24),

              _sectionHeader("Pet Care Information"),
              _buildTextField("Where will the pet stay during the day?", dayStayController, required: true),
              const SizedBox(height: 16),
              _buildTextField("Where will the pet sleep?", nightStayController, required: true),
              const SizedBox(height: 16),
              _dropdownField("How many hours will the pet be alone daily?", ["0-2", "2-4", "4-6", "6+"], petAloneHours, (value) {
                setState(() => petAloneHours = value);
              }),
              const SizedBox(height: 16),
              _buildTextField("Who will be primarily responsible for the pet’s care?", petCareController, required: true),
              const SizedBox(height: 24),

              _sectionHeader("Lifestyle"),
              _dropdownField("How much time can you dedicate to training and exercise daily?", ["Minimal (1–2 hours)", "Moderate (3–4 hours)", "High (5+ hours)"], trainingTime, (value) {
                setState(() => trainingTime = value);
              }),
              const SizedBox(height: 16),
              _dropdownField("What type of outdoor space do you have?", ["None", "Balcony", "Shared Yard", "Private Yard"], outdoorSpace, (value) {
                setState(() => outdoorSpace = value);
              }),
              const SizedBox(height: 24),

              _sectionHeader("Commitment"),
              _dropdownField("Are you prepared for 10–15+ years of pet care?", ["Yes", "No"], preparedForCommitment, (value) {
                setState(() => preparedForCommitment = value);
              }),
              const SizedBox(height: 16),
              _dropdownField("Are you financially able to care for a pet (food, vet bills, etc.)?", ["Yes", "No"], financialAbility, (value) {
                setState(() => financialAbility = value);
              }),
              const SizedBox(height: 16),
              _dropdownField("Are you willing to house train a pet?", ["Yes", "No"], willingToTrain, (value) {
                setState(() => willingToTrain = value);
              }),
              const SizedBox(height: 16),
              _buildTextField("Why do you want to adopt this pet?", adoptionReasonController, required: true, maxLines: 5),
              const SizedBox(height: 24),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_validateForm()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Form submitted successfully!")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade200,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.black, fontSize: 16),
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

  Widget _buildTextField(String label, TextEditingController controller, {bool required = false, bool email = false, bool phone = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "$label${required ? " *" : ""}",
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      maxLines: maxLines,
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return "This field is required.";
        }
        if (email && value != null && !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}").hasMatch(value)) {
          return "Enter a valid email address.";
        }
        if (phone && value != null && !RegExp(r"^\+?[0-9]{7,15}").hasMatch(value)) {
          return "Enter a valid phone number.";
        }
        return null;
      },
    );
  }

  Widget _dropdownField(String label, List<String> items, String? selectedValue, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "$label *",
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      value: selectedValue,
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "This field is required.";
        }
        return null;
      },
    );
  }

  Widget _choiceRow(List<String> options, String? selectedValue, ValueChanged<String> onSelect) {
    return Row(
      children: options
          .map((option) => Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: selectedValue == option ? Colors.grey : Colors.white,
            side: const BorderSide(color: Colors.black),
          ),
          onPressed: () => onSelect(option),
          child: Text(option, style: const TextStyle(color: Colors.black)),
        ),
      ))
          .toList(),
    );
  }

  Widget _multiChoiceRow(List<String> options, List<String> selectedValues, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 10,
          children: options
              .map((option) => FilterChip(
            label: Text(option),
            selected: selectedValues.contains(option),
            onSelected: (isSelected) {
              setState(() {
                if (isSelected) {
                  selectedValues.add(option);
                } else {
                  selectedValues.remove(option);
                }
              });
            },
          ))
              .toList(),
        ),
      ],
    );
  }
}
