import 'package:collector_dash/src/utils/constants.dart';
import 'package:flutter/services.dart';

enum KeyCode {
  none, up, right, down, left
}

class KeyboardData {
  KeyCode code;
  Offset offset;
  KeyboardEventType event;
  KeyboardData(this.event, this.code, this.offset);
}

enum KeyboardEventType {
  repeat, up, down
}

mixin KeyHandler {
  bool isStillUp = false;
  bool isStillDown = false;
  bool isStillLeft = false;
  bool isStillRight = false;

  bool keyHandler(KeyEvent event) {
    final key = event.logicalKey;
    KeyCode? code;
    KeyboardEventType? eventType;

    if (event is KeyDownEvent) {
      code = _getKeyCode(key, event);
      eventType = KeyboardEventType.down;
    } else if (event is KeyUpEvent) {
      code = _getKeyCode(key, event);
      eventType = KeyboardEventType.up;
    } else if (event is KeyRepeatEvent) {
      code = _getKeyCode(key, event);
      eventType = KeyboardEventType.repeat;
    }

    if(code != null) {
      double dx = 0, dy = 0;
      if(code == KeyCode.up) {
        if(isStillUp) dy = -1;
        if(isStillLeft) dx = -1;
        if(isStillRight) dx = 1;
      } else if(code == KeyCode.down) {
        if(isStillDown) dy = 1;
        if(isStillLeft) dx = -1;
        if(isStillRight) dx = 1;
      } else if(code == KeyCode.left) {
        if(isStillLeft) dx = -1;
        if(isStillUp) dy = -1;
        if(isStillDown) dy = 1;
      } else if(code == KeyCode.right) {
        if(isStillRight) dx = 1;
        if(isStillUp) dy = -1;
        if(isStillDown) dy = 1;
      }
      Offset offset = Offset(dx, dy);
      // if (kDebugMode) {
      //   print("KEY ==> $code ==> $isStillUp ==> $isStillDown ==> $isStillLeft ==> $isStillRight ==> $offset");
      // }
      Const.onKeyPress?.add(KeyboardData(eventType!, code, offset));
    }

    return false;
  }

  KeyCode _getKeyCode(LogicalKeyboardKey key, KeyEvent event) {
    switch (key) {
      case LogicalKeyboardKey.arrowUp:
        if(event is KeyDownEvent) isStillUp = true;
        if(event is KeyUpEvent) isStillUp = false;
        return KeyCode.up;
      case LogicalKeyboardKey.arrowDown:
        if(event is KeyDownEvent) isStillDown = true;
        if(event is KeyUpEvent) isStillDown = false;
        return KeyCode.down;
      case LogicalKeyboardKey.arrowLeft:
        if(event is KeyDownEvent) isStillLeft = true;
        if(event is KeyUpEvent) isStillLeft = false;
        return KeyCode.left;
      case LogicalKeyboardKey.arrowRight:
        if(event is KeyDownEvent) isStillRight = true;
        if(event is KeyUpEvent) isStillRight = false;
        return KeyCode.right;
    }

    return KeyCode.none;
  }
}