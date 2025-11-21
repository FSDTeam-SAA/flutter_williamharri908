import 'package:flutter/material.dart';

import '../../constants/assets.dart';
import 'textfield_prefix_icon.dart';

class PasswordTextfield extends StatefulWidget {
  final Function(String text) onChanged;
  final String? Function(String text) validationCheck;
  final String hintText;
  final String labelText;

  final int maxLines;
  const PasswordTextfield({
    this.maxLines = 1,
    required this.onChanged,
    this.hintText = "",
    this.labelText = "Password",
    required this.validationCheck,
    super.key,
  });

  @override
  State<PasswordTextfield> createState() => _PasswordTextfieldState();
}

class _PasswordTextfieldState extends State<PasswordTextfield> {
  bool obscureState = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Form(
        key: _formKey,
        child: TextFormField(
          onTapOutside: (event) {
            _focusNode.unfocus();
          },
          focusNode: _focusNode,
          maxLines: widget.maxLines,
          controller: _controller,
          obscureText: obscureState,
          autofillHints: const [AutofillHints.password],
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            prefixIcon: TextfieldPrefixIcon(assetName: Assets.lock),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  obscureState = !obscureState;
                });
              },
              child: obscureState
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.visibility, color: Color(0xFF999999)),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.visibility_off,
                        color: Color(0xFF999999),
                      ),
                    ),
            ),
            //alignLabelWithHint: true,
            hintText: widget.hintText,
            label: Text(widget.labelText),
          ),
          onChanged: (value) {
            _formKey.currentState!.validate();
            widget.onChanged(value);
          },
          validator: (value) {
            return widget.validationCheck(value ?? "");
          },
        ),
      ),
    );
  }
}
