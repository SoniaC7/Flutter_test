
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'email_sign_in_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;

  void _showSignInError(BuildContext context, Exception exception){
    if(exception is FirebaseAuthException && exception.code == 'ERROR_ABORTED_BY_USER'){
      return;
    }
    showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: exception,
    );
  }

  Future<void> _signInAnonymously (BuildContext context) async{
    try{
      setState(() => _isLoading = true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInAnonymously();
      //onSignIn(user); ara ja no hio neccesseties perq fas servir streams, fas aixo perq landing page tingui acces a userCredentials.user i el pugui utilitzar
    } on Exception catch(e){
      _showSignInError(context, e);
    } finally{
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async{
    try{
      setState(() => _isLoading = true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithGoogle();
      //onSignIn(user); ara ja no hio neccesseties perq fas servir streams, fas aixo perq landing page tingui acces a userCredentials.user i el pugui utilitzar
    } on Exception catch(e){
      _showSignInError(context, e);
    } finally{
      setState(() => _isLoading = false);
    }

  }

  void _signInWithEmail(BuildContext context){
    final auth = Provider.of<AuthBase>(context, listen: false);
    Navigator.of(context).push( //navigator es un widget per navegar en flutter, es un stack amb push i pop, fas push i pop de routes
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //inherits configuration from primarySwatch colors.indigo, barra d'adalt
        title: Text('Time Tracker'),
        elevation: 2.0, //shadow beneath app bar
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey.shade200, //podem utilizar Colors.grey[200]
    );
  }

  Widget _buildContent(BuildContext context) {
    //container 'hereda' de widget i el body necessita un widget, per canviar nom shift+F6, ara aquesta method es private perq te una _
    return Padding(
      //solament te una property: padding, aixi que hem de treure el color, tmb te child
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment
            .center, //fer que els rectangles estiguin centrats a la pantalla , verticalment
        crossAxisAlignment: CrossAxisAlignment
            .stretch, //perq els children, boxes de color orange i pink ocupin tota la width de la columna
        children: [
          /*Container(  container es molt general, ara anirem replaçant-los amb widgets mes especifics
            color: Colors.orange,
            child: SizedBox(
              //width: 100.0,
              height: 100.0,
            ),
          ),*/
          SizedBox(
              height: 50.0,
              child: _buildHeader(),
          ),
          SizedBox(
              height:
                  48.0), //espai entre container (rectangles de color) podem utilizar sizedbox si el padding sempre es el mateix
          /* Container( farem servir buttons en comptes de containers
            color: Colors.red,
            child: SizedBox(
              //width: 100.0, no s'esta aplicant perq estas fent servir crossaxisalignment
              height: 100.0,
            ),
          ),
          SizedBox(height: 8.0),
          Container(
            color: Colors.purple,
            child: SizedBox(
              //width: 100.0, no s'esta aplicant perq estas fent servir crossaxisalignment
              height: 100.0,
            ),
          ),*/
          /* RaisedButton( hem creat un CutomRaisedButton i ja  no fem servir el default
              child: Text(
                'Sign in with Google',
                style: TextStyle(color: Colors.black87, fontSize: 15.0),
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              )),
              onPressed:
                  _signInWithGoogle //() { }, onPressed function es de tipus VoidCallBack un tipus que es una funcio sense parametres i que no retorna res, per aixo tenim () no parametres i {} no implementation ni return//amb onPressed el button es enabled, onPressed es optional si el posem a null sera disabled
              ),
          SizedBox(height: 8.0),*/
          /*CustomRaisedButton(
            child: Row( //per tenir 2 widgets a la mateixa fila
              mainAxisAlignment: MainAxisAlignment.spaceBetween, //per separa la foto del text
              children: [
                Image.asset('images/images/google-logo.png'),
                Text('Sign in with Google'),
                Opacity( //hack
                  opacity: 0.0, //la imatge desapareix
                  child: Image.asset('images/images/google-logo.png')), //si posem la mateixa imatge el text es queda al centre gracies a spacebetwwen, ara hem d'amagar la foto
              ],
            ),
            color: Colors.white,
            onPressed: (){},
          ),*/

          SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
            assetName: 'images/images/google-logo.png',
            text: 'Sign in with Goggle',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: _isLoading ? null : () =>_signInWithGoogle(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
            assetName: 'images/images/facebook-logo.png',
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: () {},
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Sign in with email',
            textColor: Colors.white,
            color: Colors.teal.shade700,
            onPressed: _isLoading ? null : () => _signInWithEmail(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'or',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Go anonymous',
            textColor: Colors.black,
            color: Colors.lime.shade300,
            onPressed: _isLoading ? null : () =>_signInAnonymously(context) ,
          ),
        ], // Children
      ),
    );
  }

  Widget _buildHeader(){
    if(_isLoading){
      return Center(child: CircularProgressIndicator(),);
    }
    return Text(
        'Sign in',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 32.0,
          //fontWeight: FontWeight.bold, si cliquem ctrl+fontweight podem veure la documentacio i veure que w600 es semi-bold
          fontWeight: FontWeight.w600,
        ),
      );
  }
}
