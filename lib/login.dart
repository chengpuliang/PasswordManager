import 'package:flutter/material.dart';
import 'package:password_manager/main.dart';
import 'package:password_manager/model.dart';
import 'package:password_manager/password_field.dart';
import 'package:password_manager/register.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "歡迎使用\n我的密碼庫",
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
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
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: () {
                        Model.instance.getAccountList().then((s) {
                          try {
                            final account =
                                s.firstWhere((e) => e.email == emailCtrl.text);
                            if (account.password == pwdCtrl.text) {
                              Model.instance.writeLastLogin(account.id);
                              Model.instance.currentAccount = account;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("登入成功")));
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (builder) => HomeWidget()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("登入失敗")));
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("登入失敗")));
                          }
                        });
                      },
                      style: ButtonStyle(
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                          fixedSize:
                              WidgetStateProperty.all(const Size(130, 50))),
                      child: const Text(
                        "登入",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegisterWidget()));
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.black12),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                          fixedSize:
                              WidgetStateProperty.all(const Size(130, 50))),
                      child: const Text(
                        "註冊帳號",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
