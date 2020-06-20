import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key key,
    @required this.label,
    @required this.node,
    @required this.controller,
    this.onTap,
    this.isObsecure = false,
    this.onVisibleTap,
    this.inputFormatters,
    this.keyboardType,
  }) : super(key: key);

  final String label;
  final FocusNode node;
  final TextEditingController controller;
  final bool isObsecure;
  final Function onTap;
  final Function onVisibleTap;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:8.0),
      child: TextFormField(
        onTap: onTap,
        obscureText: isObsecure,
        focusNode: node,
        controller: controller,
        validator: (val) {
          if (val.isEmpty) return tr('widgets.field.msg_empty', args:[label]);
          return null;
        },
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          alignLabelWithHint: true,
          labelText: label,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          suffixIcon: onVisibleTap != null
              ? InkWell(
                  onTap: onVisibleTap,
                  child: Icon(
                      isObsecure ? Icons.visibility_off : Icons.visibility))
              : null,
        ),
      ),
    );
  }
}
