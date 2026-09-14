import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveExample extends StatefulWidget {
  const AdaptiveExample({super.key});

  @override
  State<AdaptiveExample> createState() => _AdaptiveExampleState();
}

class _AdaptiveExampleState extends State<AdaptiveExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Checkbox.adaptive(value: true, onChanged: (value) {}),

          if (Platform.isIOS)
            CupertinoCheckbox(value: true, onChanged: (value) {})
          else
            Checkbox(value: true, onChanged: (value) {}),
        ],
      ),
    );
  }
}
