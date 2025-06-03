import 'package:flutter/material.dart';
import '../textStyles.dart';

//Defining Store answer.
//Defining Store answer.
class Question {
  final String question;
  final List<String> options;

  Question({
    required this.question,
    required this.options,
  });
}

class PetMaking extends StatefulWidget {
  @override
  _PetMaking createState() => _PetMaking();
}

class _PetMaking extends State<PetMaking> {
  int _currentIndexTracker = 0;
  List<String> _saveAnswer = [];
  List<Question> questions = [
    Question(
      question:
          'How active would your ideal pet be', //ACtiity-Level Trait  => Activity
      options: ['Low', 'Medium', 'High'],
    ),
    Question(
      question: 'What size would your ideal pet be', //Size Trait => Size
      options: ['Small', 'Medium', 'Large'],
    ),
    Question(
      question: 'What is ur living Space currently?', //Living space Trait =>
      options: [
        'Small Apartment',
        'Medium Apartment',
        'Big Apartment',
        'Large house with a yard'
      ],
    ),
    Question(
      question:
          'How much time are you spending at home?', //Working from home? CAn change to how much time do you have for your pet. trait  => Not sure
      options: ['2-4 hours a day.', '4-6 hours a day.', 'More'],
    ),
    Question(
      question:
          'What is your experience with pets', //Some animals require experience, trait. => Difficulty.
      options: [
        'Beginner',
        'Intermediate(some experience)',
        'Advanced (experiencedw ith challenging pets)'
      ],
    ),
    Question(
      question: 'Would you prefer your pet to be.',
      options: [
        'Under a year',
        'Young (1-3 years)',
        'Adult (4-7 years)',
        'Senior (8+ years)'
      ],
    ),
  ];

  void _questionAnswer(String selectedAnswer) {
    setState(() {
      if (_saveAnswer.length > _currentIndexTracker) {
        _saveAnswer[_currentIndexTracker] = selectedAnswer;
      } else {
        _saveAnswer.add(selectedAnswer);
      }
      if (_currentIndexTracker < questions.length - 1) {
        _currentIndexTracker++;
      }
      //Edit this, to do what you want it to do, after the quiz has been answered
      //Edit this, to do what you want it to do, after the quiz has been answered
      if (_currentIndexTracker + 1 >= questions.length) {
        Navigator.pushNamed(context, 'StartScreen');
      }
      //Edit this, to do what you want it to do, after the quiz has been answered
      //Edit this, to do what you want it to do, after the quiz has been answered
    });
  }

  void ressetQuiz() {
    setState(() {
      _saveAnswer.clear();
      _currentIndexTracker = 0;
    });
  }

  void _goBack() {
    if (_currentIndexTracker > 0) {
      setState(() {
        _currentIndexTracker--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //   bool HasUserFilledForM= false;//Some way to see if user has filled in the form yet.
    //  bool IsUserLoggedIn = true; // Is user logged in?

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
          child: Column(
        children: [
          const SizedBox(height: 40),
          pawImage(context, 0.4, 0.1),
          Text(
            'Adoptly',
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            questions[_currentIndexTracker].question,
            style: TextStyle(fontSize: screenWidth * 0.05),
          ),
          Column(
            children: questions[_currentIndexTracker]
                .options
                .map(
                  (option) => SizedBox(
                    width: screenWidth * 0.6,
                    child: ElevatedButton(
                      onPressed: () {
                        _questionAnswer(
                            option); // Save the answer and go to the next question
                      },
                      child: Text(option),
                    ),
                  ),
                )
                .toList(),
          ),
          if (_currentIndexTracker > 0)
            ElevatedButton(
              onPressed: () {
                _goBack();
              },
              child: const Text('Previous question'),
            ),
          const SizedBox(height: 40),
          SizedBox(
            width: screenWidth * 0.6,
            child: ElevatedButton(
              onPressed: () {
                ressetQuiz();
                Navigator.pushNamed(context, 'StartScreen');
              },
              child: const Text('Return'),
            ),
          ),

          //Debugging purposes. Text('Question ${_currentIndexTracker + 1} / ${questions.length} Debugging purposes'),
        ],
      )),
    );
  }
}

//What is missing is, Check if user is logged in >> prompt user to login. >> user is logged in send back here.?
// Has user already completed a petmaking form? If both conditions are met, go to petmaking algoritm.
