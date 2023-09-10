import 'dart:async';

import 'package:collector_dash/src/mixins/key_handler.dart';
import 'package:collector_dash/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardStreamHandler extends StatefulWidget {
  const KeyboardStreamHandler({super.key, required this.child});
  final Widget child;

  @override
  State<KeyboardStreamHandler> createState() => _KeyboardStreamHandlerState();
}

class _KeyboardStreamHandlerState extends State<KeyboardStreamHandler> with KeyHandler {

  @override
  void initState() {
    super.initState();
    Const.onKeyPress = StreamController<KeyboardData>();
    ServicesBinding.instance.keyboard.addHandler(keyHandler);
  }

  @override
  void dispose() {
    Const.onKeyPress!.close();
    ServicesBinding.instance.keyboard.removeHandler(keyHandler);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
