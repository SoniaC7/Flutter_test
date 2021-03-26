import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton{
  SocialSignInButton({
    @required String assetName, //necesstiem si o si el assetName , posem @required perq el ompilador ens avisi si no l'hem posat
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,

  }) : super(
    child: Row( //per tenir 2 widgets a la mateixa fila
      mainAxisAlignment: MainAxisAlignment.spaceBetween, //per separa la foto del text
      children: [
        Image.asset(assetName),
        Text(
            text,
            style: TextStyle(
              color:textColor,
              fontSize: 15.0,
            ),
        ),
        Opacity( //hack
            opacity: 0.0, //la imatge desapareix
            child: Image.asset(assetName)
        ), //si posem la mateixa imatge el text es queda al centre gracies a spacebetwwen, ara hem d'amagar la foto
      ],
    ),
    color: color,
    height: 40.0,
    onPressed: onPressed,

  );
}