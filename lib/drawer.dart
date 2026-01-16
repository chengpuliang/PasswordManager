import 'package:flutter/material.dart';
import 'package:password_manager/login.dart';
import 'package:password_manager/model.dart';
import 'package:password_manager/password_field.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                                                    Navigator.of(context).pop(),
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
    );
  }
}
