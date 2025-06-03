import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PetDetailPage extends StatelessWidget {
  final Map<String, dynamic> pet;

  const PetDetailPage({Key? key, required this.pet}) : super(key: key);

  void _contactShelter(BuildContext context) async {
    final email = pet['email'] ?? '';
    final phone = pet['phone'] ?? '';

    if (email.isNotEmpty) {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {'subject': 'Inquiry about ${pet['name'] ?? 'a pet'}'},
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        return;
      }
    }

    if (phone.isNotEmpty) {
      final Uri phoneUri = Uri(scheme: 'tel', path: phone);

      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
        return;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No contact info available')),
    );
  }

  Future<void> _openShelterLocation(BuildContext context) async {
    final String? address = pet['shelterName'];

    if (address == null || address.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No shelter address available')),
      );
      return;
    }

    final String query = Uri.encodeComponent(address);

    // Try to open with gmaps
    final Uri geoUri = Uri.parse('geo:0,0?q=$query');

    if (await canLaunchUrl(geoUri)) {
      await launchUrl(geoUri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback to gmaps website in browser
      final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps')),
        );
      }
    }
  }


  Widget _buildInfoRow(String label, dynamic value) {
    if (value == null) return const SizedBox.shrink();

    String displayValue;
    if (value is List) {
      displayValue = value.join(', ');
      if (displayValue.isEmpty) return const SizedBox.shrink();
    } else if (value is String && value.trim().isEmpty) {
      return const SizedBox.shrink();
    } else {
      displayValue = value.toString();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(displayValue)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet['name'] ?? 'Pet Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Name
            Text(
              pet['name'] ?? 'No Name',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),

            // Basic Info
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Species', pet['species']),
            _buildInfoRow('Breed', pet['breed']),
            _buildInfoRow('Gender', pet['gender']),
            _buildInfoRow('Age', pet['age']),
            _buildInfoRow('Size', pet['size']),

            const SizedBox(height: 16),

            // Temperament
            Text(
              'Personality and Temperament',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Behavior Traits', pet['behaviorTraits']),
            _buildInfoRow('Good With Kids', pet['goodWithKids']),
            _buildInfoRow('Interacts With Other Pets', pet['interactsWithOtherPets']),
            _buildInfoRow('Compatibility', pet['compatibility']),
            _buildInfoRow('Activity Level', pet['activityLevel']),

            const SizedBox(height: 16),

            // Health
            Text(
              'Health and Medical Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Special Diet', pet['specialDiet']),
            _buildInfoRow('Vaccination Status', pet['vaccinationStatus']),

            const SizedBox(height: 16),

            // Adoption Info
            Text(
              'Adoption Requirements',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Adoption Fee', pet['adoptionFee']?.toString()),

            const SizedBox(height: 16),

            // Contact
            Text(
              'Contact Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Email', pet['email']),
            _buildInfoRow('Phone', pet['phone']),
            _buildInfoRow('Address', pet['address']),
            _buildInfoRow('Shelter', pet['shelterName']),

            const SizedBox(height: 24),

            // Optional Description
            if ((pet['description'] ?? '').toString().isNotEmpty) ...[
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(pet['description']),
              const SizedBox(height: 24),
            ],

            // Contact Button
            ElevatedButton.icon(
              icon: const Icon(Icons.contact_mail),
              label: const Text('Contact Shelter'),
              onPressed: () => _contactShelter(context),
            ),

            const SizedBox(height: 12),

            // Open Shelter Location Button
            ElevatedButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Open Shelter Location'),
              onPressed: () => _openShelterLocation(context),
            ),
          ],
        ),
      ),
    );
  }
}
