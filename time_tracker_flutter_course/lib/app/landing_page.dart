import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'home_page.dart';

class LandingPage extends StatelessWidget {
 
/*  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {*/
/*  User _user; //ja no ho necessitem perq fem servir streams

  @override
  void initState() {
    super.initState(); //fer que es quedi logged in
    /*widget.auth.authStateChanges().listen((user) {
      print('uid: ${user?.uid}'); //? per si te null value, quan fem sign out
    });*/
    _updateUser(widget.auth.currentUser);
  }
  void _updateUser(User user){
    setState(() { //fara un rebuild
      _user = user;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false); //la funcio of busca un ancestor de tipus AuthProvider i aixi no hem d'anar passant auth a totes les funcions
    return StreamBuilder<User>(
        stream: auth.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.active){ //connectionstate ens dira si el stream ha coençat o no
              final user = snapshot.data; //data has type user perq el stream es type user
              if(user == null){
                return SignInPage();
              }
              return HomePage();
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
    );
  }
}
