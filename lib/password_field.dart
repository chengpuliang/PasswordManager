import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  const PasswordField({super.key, required this.controller, this.hint = "主密碼"});
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool pwdVisible = false;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: !pwdVisible,
      obscuringCharacter: "*",
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: widget.hint,
        suffixIcon: InkWell(
            splashColor: Colors.black54,
            customBorder: const CircleBorder(),
            onTapDown: (details) {},
            child: GestureDetector(
              child: const Icon(Icons.visibility),
              onTapDown: (details) {
                setState(() {
                  pwdVisible = true;
                });
              },
              onTapUp: (details) {
                setState(() {
                  pwdVisible = false;
                });
              },
              onLongPressUp: () => {
                setState(() {
                  pwdVisible = false;
                })
              },
              onLongPressCancel: () => {
                setState(() {
                  pwdVisible = false;
                })
              },
            )),
      ),
    );
  }
}
