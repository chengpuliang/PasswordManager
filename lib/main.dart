import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(PasswordManagerApp());
}

class PasswordManagerApp extends StatelessWidget {
  const PasswordManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashWidget(),
    );
  }
}

class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key});

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => 
        LoginWidget()
      ));
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock, size: 100,),
            SizedBox(height: 20,),
            Text("我的密碼庫", style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)
          ],
        ),
      )
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("HELLO"),
    );
  }
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  bool pwdVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock, size: 100,),
              const SizedBox(height: 10,),
              const Text("歡迎使用\n我的密碼庫", style: TextStyle(fontSize: 30),textAlign: TextAlign.center,),
              const SizedBox(height: 10,),
              TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "帳號 (Email)"
                  ),
              ),
              TextField(
                  controller: pwdCtrl,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !pwdVisible,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "主密碼",
                    suffixIcon: InkWell(
                        splashColor: Colors.black54,
                        customBorder: const CircleBorder(),
                        onTapDown: (details) {},
                        child: GestureDetector(child: const Icon(Icons.visibility),onTapDown: (details) {
                        setState(() {
                          pwdVisible = true;
                        });
                      },onTapUp: (details) {
                        setState(() {
                          pwdVisible = false;
                        });
                      },)
                    ),
                    ),
              )
            ],
          ),
      ),
    );
  }
}