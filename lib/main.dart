import 'dart:async';

import 'package:flutter/material.dart';
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
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text(Model.instance.currentAccount.name),
              subtitle: Text(Model.instance.currentAccount.email),
            ),
            const Divider(),
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
            const Divider(),
            ListTile(
              title: const Text(
                "登出",
                style: TextStyle(color: Colors.blueAccent),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (builder) => AlertDialog(
                          title: const Text("登出？"),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("取消")),
                            TextButton(
                                onPressed: () {
                                  Model.instance.writeLastLogin(-1);
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (builder) => LoginWidget()));
                                },
                                child: const Text(
                                  "登出",
                                  style: TextStyle(color: Colors.red),
                                ))
                          ],
                        ));
              },
            ),
            ListTile(
              title: const Text(
                "刪除帳號",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (builder) {
                      final pwdCtrl = TextEditingController();
                      final pwdConfirmCtrl = TextEditingController();
                      return AlertDialog(
                        title: const Text(
                          "刪除帳號？",
                          style: TextStyle(color: Colors.red),
                        ),
                        content: SizedBox(
                          width: 350,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("輸入主密碼來刪除此帳號\n刪除後將不可復原！"),
                                const SizedBox(
                                  height: 20,
                                ),
                                PasswordField(controller: pwdCtrl),
                                const SizedBox(
                                  height: 10,
                                ),
                                PasswordField(
                                  controller: pwdConfirmCtrl,
                                  hint: "確認主密碼",
                                )
                              ],
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("取消")),
                          TextButton(
                              onPressed: () async {
                                if (pwdCtrl.text != pwdConfirmCtrl.text ||
                                    Model.instance.currentAccount.password !=
                                        pwdCtrl.text) {
                                  showDialog(
                                      context: context,
                                      builder: (builder) => AlertDialog(
                                            title: Text((pwdCtrl.text !=
                                                    pwdConfirmCtrl.text)
                                                ? "密碼不相符"
                                                : "密碼不正確"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text("關閉"))
                                            ],
                                          ));
                                } else {
                                  Model.instance.accountList
                                      .remove(Model.instance.currentAccount);
                                  await Model.instance.saveAccountList();
                                  await Model.instance.writeLastLogin(-1);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("帳號已刪除，謝謝您的使用！")));
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (builder) => LoginWidget()));
                                }
                              },
                              child: const Text(
                                "刪除帳號",
                                style: TextStyle(color: Colors.red),
                              ))
                        ],
                      );
                    });
              },
            )
          ],
        ),
      ),
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
                            if (sort == Sort.custom) const Icon(Icons.check) else const SizedBox(width: 24,),
                            const SizedBox(
                              width: 10,
                            ),
                            const SizedBox(width:150 , child: Text("自訂排序")),
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
                              const Icon(Icons.check) else const SizedBox(width: 24,),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text("依名稱排序"),
                            if (sort == Sort.nameAsc || sort == Sort.nameDesc)
                            Expanded(
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon((sort == Sort.nameAsc) ? Icons.arrow_drop_up : Icons.arrow_drop_down)),
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
                              const Icon(Icons.check) else const SizedBox(width: 24,),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text("依建立時間排序"),
                            if (sort == Sort.timeAsc || sort == Sort.timeDesc)
                            Expanded(
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon((sort == Sort.timeAsc) ? Icons.arrow_drop_up : Icons.arrow_drop_down)),
                            ),
                          ],
                        ))
                  ])
        ],
      ),
      body: Column(),
    );
  }
}
