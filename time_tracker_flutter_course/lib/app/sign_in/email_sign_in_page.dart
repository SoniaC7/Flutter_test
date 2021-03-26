import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //inherits configuration from primarySwatch colors.indigo, barra d'adalt
        title: Text('Sign In'),
        elevation: 2.0, //shadow beneath app bar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
              child: EmailSignInForm(),
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade200, //podem utilizar Colors.grey[200]
    );
  }
}
