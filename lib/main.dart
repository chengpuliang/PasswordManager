import 'dart:async';

import 'package:flutter/material.dart';
import 'package:password_manager/login.dart';
import 'package:password_manager/model.dart';

void main() {
  runApp(const PasswordManagerApp());
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
    Timer(const Duration(seconds: 3), () {
      Model.instance.getLastLogin().then((id) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          if (id == -1) {
            return LoginWidget();
          } else {
            return HomeWidget();
          }
        }));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock,
            size: 100,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "我的密碼庫",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          )
        ],
      ),
    ));
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
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text(Model.instance.currentAccount.name),
              subtitle: Text(Model.instance.currentAccount.email),
            ),
            ListTile(
              title: const Text("匯出密碼"),
              onTap: () {
                Model.instance.writeLastLogin(-1);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (builder) => LoginWidget()));
              },
            ),
            ListTile(
              title: const Text("匯入密碼"),
              onTap: () {
                Model.instance.writeLastLogin(-1);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (builder) => LoginWidget()));
              },
            ),
            ListTile(
              title: const Text("登出"),
              onTap: () {
                Model.instance.writeLastLogin(-1);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (builder) => LoginWidget()));
              },
            ),
            ListTile(
              title: const Text(
                "刪除帳號",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Model.instance.writeLastLogin(-1);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (builder) => LoginWidget()));
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("我的密碼庫"),
      ),
      body: Column(),
    );
  }
}
