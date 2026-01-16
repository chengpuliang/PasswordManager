import 'dart:convert';
import 'dart:io';

class Account {
  final int id;
  final String name;
  final String email;
  final String password;
  const Account(
      {required this.id,
      required this.name,
      required this.email,
      required this.password});

  Map<String, dynamic> toMap() =>
      {"id": id, "name": name, "email": email, "password": password};

  factory Account.fromMap(Map<String, dynamic> m) => Account(
      id: m['id'], name: m['name'], email: m['email'], password: m['password']);
}

class PasswordItem {
  final String itemName;
  final String userName;
  final String password;
  final String url;
  final String createdTime;
  const PasswordItem(
      {required this.itemName,
      required this.userName,
      required this.password,
      required this.url,
      required this.createdTime});

  Map<String, dynamic> toMap() => {
        "itemName": itemName,
        "userName": userName,
        "password": password,
        "url": url,
        "createdTime": createdTime
      };

  factory PasswordItem.fromMap(Map<String, dynamic> m) => PasswordItem(
      itemName: m["itemName"],
      userName: m["userName"],
      password: m["password"],
      url: m["url"],
      createdTime: m["createdTime"]);
}

enum Sort { custom, nameAsc, nameDesc, timeAsc, timeDesc }

class Model {
  Model._();

  final appDataPath = "/data/data/com.example.password_manager";
  final List<Account> accountList = [];
  final List<PasswordItem> pwdItemList = [];
  Account currentAccount =
      const Account(id: 0, name: "", email: "email", password: "password");

  Future<int> getLastLogin() async {
    final file = File("$appDataPath/LastLoginId.txt");
    if (!await file.exists()) {
      return -1;
    }
    return int.parse(await file.readAsString());
  }

  Future writeLastLogin(int id) async {
    final file = File("$appDataPath/LastLoginId.txt");
    await file.writeAsString(id.toString());
  }

  Future<List<Account>> getAccountList() async {
    final file = File("$appDataPath/Accounts.json");
    if (!await file.exists()) {
      return [];
    }
    List<dynamic> json = jsonDecode(await file.readAsString());
    accountList
      ..clear()
      ..addAll(json.map((t) => Account.fromMap(t)));
    return accountList;
  }

  Future<void> saveAccountList() async {
    final file = File("$appDataPath/Accounts.json");
    await file
        .writeAsString(jsonEncode(accountList.map((t) => t.toMap()).toList()));
  }

  Future<List<PasswordItem>> getPwdItemList() async {
    final file = File("$appDataPath/Passwords.json");
    if (!await file.exists()) {
      return [];
    }
    List<dynamic> json = jsonDecode(await file.readAsString());
    pwdItemList
      ..clear()
      ..addAll(json.map((t) => PasswordItem.fromMap(t)));
    return pwdItemList;
  }

  Future<void> savePwdItemList() async {
    final file = File("$appDataPath/Passwords.json");
    await file
        .writeAsString(jsonEncode(pwdItemList.map((t) => t.toMap()).toList()));
  }

  static final instance = Model._();
}
