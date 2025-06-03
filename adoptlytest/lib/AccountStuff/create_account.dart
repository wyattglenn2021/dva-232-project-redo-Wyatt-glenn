import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordVerifyController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  String? selectedRole; 
  bool _isLoading = false;

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Firebase Authentication: Create User
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailAddressController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Prepare user data
      Map<String, dynamic> userData = {
        'id': userCredential.user!.uid,
        'email': emailAddressController.text.trim(),
        'phone': phoneNumberController.text.trim(),
        'role': selectedRole,
        'createdAt': FieldValue.serverTimestamp(),
      };

      if (selectedRole == 'user') {
        userData.addAll({
          'firstName': firstNameController.text.trim(),
          'lastName': lastNameController.text.trim(),
        });
      } else if (selectedRole == 'shelter') {
        userData.addAll({
          'name': nameController.text.trim(),
          'address': addressController.text.trim(),
        });
      }

      // Firestore: Save User Data
      await _firestore.collection('users').doc(userCredential.user!.uid).set(userData);

      // Success Message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );

      // Navigate to Login or Home Screen
     Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => LoginPage(),
  ),
);
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.message}')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AppBar(
                backgroundColor: const Color.fromRGBO(245, 234, 230, 1),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Paw Image and Title
                    SafeArea(
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/loginPaw.png',
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.height * 0.125,
                            ),
                            Text(
                              'Create Account',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isLandscape ? 24 : 32,
                                color: const Color.fromRGBO(48, 63, 81, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Role Selection
                    const Text('Role', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('User'),
                            value: 'user',
                            groupValue: selectedRole,
                            onChanged: (value) {
                              setState(() => selectedRole = value);
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Shelter'),
                            value: 'shelter',
                            groupValue: selectedRole,
                            onChanged: (value) {
                              setState(() => selectedRole = value);
                            },
                          ),
                        ),
                      ],
                    ),
                    if (selectedRole == null)
                      const Text('Please select a role', style: TextStyle(color: Colors.red)),

                    const SizedBox(height: 16),

                    // Conditional Fields
                    if (selectedRole == 'user') ...[
                      const Text('First Name', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: firstNameController,
                        decoration: const InputDecoration(
                          hintText: 'First Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text('Last Name', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: lastNameController,
                        decoration: const InputDecoration(
                          hintText: 'Last Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ] else if (selectedRole == 'shelter') ...[
                      const Text('Shelter Name', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Shelter Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the shelter name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: addressController,
                        decoration: const InputDecoration(
                          hintText: 'Address',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the shelter address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Phone Number
                    const Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Phone number',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email Address
                    const Text('Email Address', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: emailAddressController,
                      decoration: const InputDecoration(
                        hintText: 'Email Address',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    const Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Confirm Password', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: passwordVerifyController,
                      obscureText                      : true,
                      decoration: const InputDecoration(
                        hintText: 'Confirm Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(48, 63, 81, 1),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        onPressed: _isLoading ? null : _createAccount,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
    emailAddressController.dispose();
    passwordController.dispose();
    passwordVerifyController.dispose();
    addressController.dispose();
    super.dispose();
  }
}

