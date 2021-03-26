import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget { //all properties in statleswidget need to be final
  CustomRaisedButton({
    this.child,
    this.borderRadius: 10.0, //default value
    this.color,
    this.onPressed,
    this.height: 50.0,
});
  final Widget child;
  final Color color;
  final double borderRadius;
  final double height;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox( //per posar la property height i poder canviar-la
      height: height,
      child: RaisedButton(
          child: child,
          color: color,
          disabledColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius),
              )
          ),
          onPressed: onPressed, //onPressed function es de tipus VoidCallBack un tipus que es una funcio sense parametres i que no retorna res, per aixo tenim () no parametres i {} no implementation ni return//amb onPressed el button es enabled, onPressed es optional si el posem a null sera disabled
      ),
    );
  }
}
