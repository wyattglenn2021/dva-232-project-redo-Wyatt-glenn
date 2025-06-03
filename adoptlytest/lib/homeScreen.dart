import 'package:flutter/material.dart';
import 'textStyles.dart';

class Options {
  final String options;
  final String routename;

  const Options({required this.options, required this.routename});
}

@override
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
   
    List<Options> options = [
      const Options(options: 'Explore', routename: 'ExplorePage'),
      const Options(options: 'Sign up', routename: 'CreateAccount'),
      const Options(options: 'Login', routename: 'LoginPage'),
      const Options(options: 'PetMaking', routename: 'CreateAdoptionPage'),
      const Options(options: 'AdoptionForm', routename: 'PetMaking'),
      
      
      const Options(options: 'This is For Debbuging', routename: '/adoptionManagement'),
      const Options(options: 'shelterProfile', routename: '/shelterProfile'),
      const Options(options: 'userProfile', routename: '/userProfile'),
      const Options(options: 'PetMaking2', routename: 'PetMaking'),
      const Options(options: 'AdoptionForm2', routename: 'PetMaking'),
    ];


    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              pawImage(context, 0.2, 0.125),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: SafeArea(
                  child: Text(
                    'Welcome \n To \n Adoptly',
                    style:
                        textStyle(context, FontWeight.bold, 0.08, Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Column(
                    children: options
                        .map(
                          (option) => SizedBox(
                            width: screenWidth * 0.6,
                            child: ElevatedButton(
                              onPressed: () {
                                (
                                  Navigator.pushNamed(
                                      context, option.routename),
                                ); // Save the answer and go to the next question
                              },
                              child: Text(option.options),
                            ),
                          ),
                        )
                        .toList(),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
