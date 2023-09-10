import 'dart:async';
import 'dart:math';

import 'package:collector_dash/generated/assets.gen.dart';
import 'package:collector_dash/src/canvas/player.dart';
import 'package:collector_dash/src/mixins/key_handler.dart';
import 'package:collector_dash/src/utils/constants.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late StreamSubscription keyPressStreamSubscription;
  Offset playerOffset = Offset.zero;
  double multiplexer = 20;
  int score = 0;
  bool isLeft = false;
  bool isRight = false;
  bool isAvailable = false;
  late double height = 0, width = 0;
  final _random = Random();
  late Offset coinOffset;

  @override
  void initState() {
    final double physicalHeight = WidgetsBinding
        .instance.platformDispatcher.views.first.physicalSize.height;
    final double physicalWidth = WidgetsBinding
        .instance.platformDispatcher.views.first.physicalSize.width;
    final double devicePixelRatio =
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    height = physicalHeight / devicePixelRatio;
    width = physicalWidth / devicePixelRatio;
    getNewOffset();

    keyPressStreamSubscription =
        Const.onKeyPress!.stream.listen(keyPressHandler);
    super.initState();
  }

  @override
  void dispose() {
    keyPressStreamSubscription.cancel();
    super.dispose();
  }

  void getNewOffset() {
    double dx = _random.nextInt(width.toInt() - 1).toDouble();
    double dy = _random.nextInt(height.toInt() - 1).toDouble();
    if (dx < 200) dx = 200;
    if (dx > width) dx = width - 200;
    if (dy < 200) dy = 200;
    if (dy > height) dy = height - 200;
    coinOffset = Offset(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    if (isAvailable) {
      isAvailable = false;
      getNewOffset();
    }
    String image = Assets.images.game.dashCenter.path;
    if (isLeft) {
      image = Assets.images.game.dashLeft.path;
    } else if (isRight) {
      image = Assets.images.game.dashRight.path;
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Text(
              "Score: $score",
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 100),
                top: playerOffset.dy,
                left: playerOffset.dx,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(40),
                    ),
                    border: Border.all(
                      width: 3,
                      color: Colors.green,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Image.asset(
                    image,
                    height: 100,
                    width: 100,
                  ),
                ),
              ),
            ],
          ),
          CustomPaint(
            painter: Player(
              offset: coinOffset,
            ),
          ),
        ],
      ),
    );
  }

  void keyPressHandler(KeyboardData data) {
    if (data.event == KeyboardEventType.up ||
        data.code == KeyCode.none ||
        data.offset == Offset.zero) {
      setState(() {
        isLeft = false;
        isRight = false;
      });
      return;
    }
    setState(() {
      double dx = data.offset.dx * multiplexer;
      double dy = data.offset.dy * multiplexer;
      if (dx > 0) {
        isLeft = false;
        isRight = true;
      } else if (dx < 0) {
        isLeft = true;
        isRight = false;
      } else {
        isLeft = false;
        isRight = false;
      }

      print(dx);
      print(width);

      Offset tempOffset = Offset(playerOffset.dx + dx, playerOffset.dy + dy);

      double newDx = tempOffset.dx;
      double newDy = tempOffset.dy;

      if (newDx + 100 > width) newDx = width - 100;
      if (newDx < 0) newDx = 0;
      if (newDy + 100 > height) newDy = height - 100;
      if (newDy < 0) newDy = 0;

      playerOffset = Offset(newDx, newDy);

      if (isCollision(playerOffset, coinOffset)) {
        score += 10;
        isAvailable = true;
      }
    });
  }

  bool isCollision(Offset point, Offset radius) {
    double playerDx = playerOffset.dx;
    double playerDy = playerOffset.dy;
    double coinDx = coinOffset.dx;
    double coinDy = coinOffset.dy;

    // double distance = (playerOffset - coinOffset).distance;

    return checkCollision(
      TDObject(playerDx, playerDy, 100, 100),
      TDObject(coinDx, coinDy, 6, 6),
    );
  }

  bool checkCollision(TDObject rect1, TDObject rect2) {
    return rect1.x < rect2.x + rect2.w &&
        rect1.x + rect1.w > rect2.x &&
        rect1.y < rect2.y + rect2.h &&
        rect1.y + rect1.h > rect2.y;
  }
}

class TDObject {
  double x;
  double y;
  double h;
  double w;

  TDObject(this.x, this.y, this.h, this.w);
}
