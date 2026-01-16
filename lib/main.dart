import 'dart:async';

import 'package:flutter/material.dart';
import 'package:password_manager/add_item.dart';
import 'package:password_manager/drawer.dart';
import 'package:password_manager/login.dart';
import 'package:password_manager/model.dart';
import 'package:password_manager/password_field.dart';

void main() {
  runApp(const PasswordManagerApp());
}

class PasswordManagerApp extends StatelessWidget {
  const PasswordManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
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
  Sort sort = Sort.nameAsc;
  @override
  void initState() {
    Model.instance.getAccountList().then((s) {
      Model.instance.getLastLogin().then((b) {
        Model.instance.currentAccount = s.firstWhere((t) => t.id == b);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (builder) => AddPwdItemWidget())),
        child: const Icon(Icons.add),
      ),
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text("我的密碼庫"),
        actions: [
          PopupMenuButton(
              itemBuilder: (builder) => [
                    PopupMenuItem(
                        onTap: () {
                          sort = Sort.custom;
                        },
                        child: Row(
                          children: [
                            if (sort == Sort.custom)
                              const Icon(Icons.check)
                            else
                              const SizedBox(
                                width: 24,
                              ),
                            const SizedBox(
                              width: 10,
                            ),
                            const SizedBox(width: 150, child: Text("自訂排序")),
                          ],
                        )),
                    PopupMenuItem(
                        onTap: () {
                          if (sort == Sort.nameAsc) {
                            sort = Sort.nameDesc;
                          } else {
                            sort = Sort.nameAsc;
                          }
                        },
                        child: Row(
                          children: [
                            if (sort == Sort.nameAsc || sort == Sort.nameDesc)
                              const Icon(Icons.check)
                            else
                              const SizedBox(
                                width: 24,
                              ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text("依名稱排序"),
                            if (sort == Sort.nameAsc || sort == Sort.nameDesc)
                              Expanded(
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon((sort == Sort.nameAsc)
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down)),
                              ),
                          ],
                        )),
                    PopupMenuItem(
                        onTap: () {
                          if (sort == Sort.timeAsc) {
                            sort = Sort.timeDesc;
                          } else {
                            sort = Sort.timeAsc;
                          }
                        },
                        child: Row(
                          children: [
                            if (sort == Sort.timeAsc || sort == Sort.timeDesc)
                              const Icon(Icons.check)
                            else
                              const SizedBox(
                                width: 24,
                              ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text("依建立時間排序"),
                            if (sort == Sort.timeAsc || sort == Sort.timeDesc)
                              Expanded(
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon((sort == Sort.timeAsc)
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down)),
                              ),
                          ],
                        ))
                  ])
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100))),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "我的最愛",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Apple ID",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          "apple@gmail.com",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
