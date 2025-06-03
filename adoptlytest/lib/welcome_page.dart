import 'package:flutter/material.dart';
import 'AccountStuff/login.dart';
import 'AccountStuff/create_account.dart';

class WelcomePage extends StatelessWidget {
  final VoidCallback onContinue;

  const WelcomePage({required this.onContinue, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/loginPaw.png',
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              const SizedBox(height: 20),
              Text(
                'Welcome to Adoptly!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.height * 0.05,
                  color: const Color.fromRGBO(48, 63, 81, 1),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(48, 63, 81, 1),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: onContinue,
                child: const Text(
                  'Explore Pets',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(249, 163, 136, 1),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateAccount()),
                  );
                },
                child: const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text(
                  'Already have an account? Log in instead.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(48, 63, 81, 1),
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
