import 'package:flutter/material.dart';

class AddPwdItemWidget extends StatefulWidget {
  const AddPwdItemWidget({super.key});

  @override
  State<AddPwdItemWidget> createState() => _AddPwdItemWidgetState();
}

class _AddPwdItemWidgetState extends State<AddPwdItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("新增項目"),
        actions: [TextButton(onPressed: () {}, child: const Text("儲存"))],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
