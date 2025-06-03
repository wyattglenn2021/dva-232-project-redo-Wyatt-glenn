import 'package:flutter/material.dart';
import '../textStyles.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordVerifyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Form key to manage form validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            AppBar(backgroundColor:  const Color.fromRGBO(245, 234, 230, 1,))
            ,
                SafeArea(
                  child: Center(
                    child: Text(
                      'Create Account',
                      style: textStyle(
                          context, FontWeight.bold, 0.1, Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 1, // Ensuring equal distribution
                      child: TextFormField(
                        controller: firstNameController,
                        decoration: const InputDecoration(
                          hintText: 'First name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: lastNameController,
                        decoration: const InputDecoration(
                          hintText: 'Last name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Phone Number',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
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
                    if (value.length < 6) {
                      return 'Phone number should be at least 6 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text('Email Address',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                TextFormField(
                    controller: emailAddressController,
                    decoration: const InputDecoration(
                      hintText: 'Email Address',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      //Logic to check  if the email address is correct from database?
                    }),
                const SizedBox(
                  height: 20,
                ),
                const Text('Password',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (passwordController.text !=
                          passwordVerifyController.text) {
                        return 'Passwords does not match';
                      }
                      if (value == null || value.isEmpty) {
                        return 'Cannot be empty';
                      }
                      //Logic to check  if the email address is correct from database?
                    }),
                const Text('Confirm Password',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                TextFormField(
                    controller: passwordVerifyController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (passwordController.text !=
                          passwordVerifyController.text) {
                        return 'Passwords does not match';
                      }
                      if (value == null || value.isEmpty) {
                        return 'Cannot be empty';
                      }

                      //Logic to check  if the email address is correct from database?
                    }),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Implement create account logic here
                      }
                    },
                    child: const Text('Create Account'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    emailAddressController.dispose();
    passwordController.dispose();
    passwordVerifyController.dispose();
    super.dispose();
  }
}
