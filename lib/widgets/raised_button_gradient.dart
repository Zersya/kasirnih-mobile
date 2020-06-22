import 'package:flutter/material.dart';

class RaisedButtonGradient extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final BorderRadiusGeometry borderRadius;
  final double width;
  final double height;
  final Function onPressed;

  const RaisedButtonGradient({
    Key key,
    @required this.child,
    this.gradient,
    this.borderRadius,
    this.width = double.infinity,
    this.height = 50.0,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Gradient defaultGradient = gradient;
    if (gradient == null) {
      defaultGradient = LinearGradient(
        colors: <Color>[
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.secondary,
        ],
      );
    }
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: defaultGradient,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500],
              offset: Offset(0.0, 1.5),
              blurRadius: 1.5,
            ),
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}
