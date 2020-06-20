import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  final bool withBackground;
  const CustomLoading({Key key, this.withBackground = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: withBackground ? Colors.black45 : Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
