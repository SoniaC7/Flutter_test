
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators{

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose(){ //dispose objects that are removed from the widget tree
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(
            _email, _password); //variables dels getters
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop(); //si tot va be ja no volem veure la pagina de sign in
    } on FirebaseAuthException catch(e){
      showExceptionAlertDialog(
          context,
          title: 'Sign in failed',
          exception: e, //perq no surti firebaseauth error
      );
    } finally{ //sempre s'executara
      setState(() {
        _isLoading = false;
      });
    }
  }
  void _emailEditingComplete(){
    final newFocus = widget.emailValidator.isValid(_email)
    ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus); //pq quan cliquem enter al acabar d'escriure el email passem al password fiedl
  }

  void _toggleFormType(){
    setState(() { //change from sign in to register and viceversa
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn ? EmailSignInFormType.register : EmailSignInFormType.signIn;
    });
    _emailController.clear(); //perq el text de email i password s'esborri si canviem de sign in a register
    _passwordController.clear();
  }
  List<Widget> _buildChildren(){
    final primaryText = _formType == EmailSignInFormType.signIn ? 'Sign in' : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signIn ? 'Need an account? Register' : 'Have an account? Sign in';

    bool submitEnabled = widget.emailValidator.isValid(_email) && widget.passwordValidator.isValid(_password) && !_isLoading;


    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),

      SizedBox(height: 8.0),
      FormSubmitButton(
          text: primaryText,
          onPressed: submitEnabled ? _submit : null,
      ),
      SizedBox(height: 8.0),
      FlatButton( //mes petit que raised button
        onPressed: !_isLoading ? _toggleFormType : null,
        child: Text(secondaryText),
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    bool showErrorText = _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: _isLoading == false,
      ),
      obscureText: true, //perq no es vegi la contrasenya escrita
      textInputAction: TextInputAction.done, //quan cliquem return ja fa el sign in
      onChanged: (password) => _updateState(),
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com', //describe what the input text is for
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
        enabled: _isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress, //pq apareixi el @
      textInputAction: TextInputAction.next, //pq quan cliquem retorn anem al password
      onChanged: (email) => _updateState(),
      onEditingComplete: _emailEditingComplete,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, //perq tots els children ocupin tot l'ample de la columna
        mainAxisSize: MainAxisSize.min, //how much space should be occupied , si poses min es quedara el minim d'espai per posar tot el que necessitem
        children: _buildChildren(),
      ),
    );
  }

  void _updateState(){
    setState(() {});
  }
}
