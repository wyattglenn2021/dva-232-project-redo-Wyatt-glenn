import 'package:flutter/material.dart';
import '../textStyles.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailVerifyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
           AppBar(backgroundColor:  const Color.fromRGBO(245, 234, 230, 1,))
            ,
          Form(
            key: _formKey,
            child: Column(
              children: [
                SafeArea(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'Forgot Password',
                          style: textStyle(
                              context, FontWeight.bold, 0.08, Colors.black),
                        ),
                        pawImage(context, 0.3, 0.225),
                      ],
                    ),
                  ),
                ),
                const Row(
                  children: [
                    Text('Email Address',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: TextFormField(
                            controller: _emailVerifyController,
                            decoration: const InputDecoration(
                              hintText: 'Email Address',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a Email Address';
                              }

                              // if (value == nomatchingEmail. ) => Todo, fix a comparer to compare if there is such email adress.
                            }))
                  ],
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Todo send email resset mail to user if a valid email was given.
                      }
                    },
                    child: Text('Resset Password'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
