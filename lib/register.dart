import 'package:flutter/material.dart';
import 'package:password_manager/main.dart';
import 'package:password_manager/model.dart';
import 'package:password_manager/password_field.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  final pwdConfirmCtrl = TextEditingController();
  final emailReg = RegExp(
      "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+");
  bool pwdVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 50, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "註冊帳號",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "暱稱"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "帳號 (Email)"),
                ),
                const SizedBox(
                  height: 10,
                ),
                PasswordField(controller: pwdCtrl),
                const SizedBox(
                  height: 10,
                ),
                PasswordField(
                  controller: pwdConfirmCtrl,
                  hint: "確認主密碼",
                ),
              ],
            ),
          ),
          Expanded(
              child: Center(
            child: FilledButton(
              onPressed: () {
                if (emailCtrl.text.contains(" ") ||
                    pwdCtrl.text.contains(" ")) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Email、密碼不可包括空白字元")));
                  return;
                }
                if (emailCtrl.text.length > 30) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Email 不可超過30字元")));
                  return;
                }
                if (!emailReg.hasMatch(emailCtrl.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Email 格式不正確")));
                  return;
                }
                if (pwdCtrl.text.length > 15) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("密碼不可超過15字元")));
                  return;
                }
                if (pwdCtrl.text != pwdConfirmCtrl.text) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("密碼不相符")));
                  return;
                }
                Model.instance.getAccountList().then((s) {
                  try {
                    s.firstWhere((e) => e.email == emailCtrl.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("帳號 Email 已存在！")));
                  } catch (e) {
                    Model.instance.accountList.add(Account(
                        id: (s.lastOrNull?.id ?? -1) + 1,
                        name: nameCtrl.text,
                        email: emailCtrl.text,
                        password: pwdCtrl.text));
                    Model.instance.saveAccountList();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (builder) => HomeWidget()));
                  }
                });
              },
              style: ButtonStyle(
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
                  fixedSize: WidgetStateProperty.all(const Size(130, 50))),
              child: const Text(
                "註冊",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          )),
        ],
      ),
    ));
  }
}
