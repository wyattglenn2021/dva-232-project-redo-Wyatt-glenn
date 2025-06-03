import 'package:flutter/material.dart';

class AdoptionManagementPage extends StatelessWidget {
  final String role; 

  const AdoptionManagementPage({required this.role, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adoption Management')),
      body: role == 'user' ? _buildUserAdoptions(context) : _buildShelterAdoptions(context),
    );
  }

  Widget _buildUserAdoptions(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text("Adoption for Max"),
          subtitle: const Text("Status: Pending"),
          trailing: ElevatedButton(
            onPressed: () {
            },
            child: const Text("Cancel"),
          ),
        ),
        // Add more user adoption items
      ],
    );
  }

Widget _buildShelterAdoptions(BuildContext context) {
  return ListView(
    children: [
      Container(
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
            // Left Column - Pet Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Pet image
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color.fromARGB(255, 218, 207, 219), 
                ),
                const SizedBox(height: 10),
                // Pet name and status
                const Text(
                  "Bella", // Pet name
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Status: Ongoing", // Pet status
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),

             // Right Column - Buttons and Icons
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
      ),
    ],
  );
}


}
