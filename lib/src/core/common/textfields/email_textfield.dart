import 'package:flutter/material.dart';

import '../../constants/assets.dart';
import 'textfield_prefix_icon.dart';

class EmailTextfield extends StatefulWidget {
  final String initialText;
  final Function(String text) onChanged;
  final String? Function(String text) validationCheck;
  final String hintText;
  final String labelText;
  final int? maxLines;
  const EmailTextfield({
    this.maxLines = 1,
    required this.onChanged,
    this.hintText = "",
    this.labelText = "Email",
    this.initialText = "",
    required this.validationCheck,
    super.key,
  });

  @override
  State<EmailTextfield> createState() => _EmailTextfieldState();
}

class _EmailTextfieldState extends State<EmailTextfield> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    _controller.text = widget.initialText;
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
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Form(
          key: _formKey,
          child: TextFormField(
            onTap: () {
              _focusNode.requestFocus();
            },
            onTapOutside: (event) {
              _focusNode.unfocus();
            },
            focusNode: _focusNode,
            maxLines: widget.maxLines,
            controller: _controller,
            style: Theme.of(context).textTheme.bodyMedium,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              //prefixIconConstraints: ,
              //constraints: BoxConstraints(minHeight: constraints.maxHeight),
              hintText: widget.hintText,
              labelText: widget.labelText,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: TextfieldPrefixIcon(
                  assetName: Assets.email,
                  height: 20,
                  width: 20,
                ),
              ),
            ),
            onChanged: (value) {
              widget.onChanged(value);
              _formKey.currentState?.validate();
            },
            validator: (value) {
              if (value == null) {
                return null;
              }
              return widget.validationCheck(value!);
            },
          ),
        ),
      ),
    );
  }
}
