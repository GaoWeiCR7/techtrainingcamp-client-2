import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Theme {

  /**
   * 登录界面，定义渐变的颜色
   */

  static const LinearGradient primaryGradient = const LinearGradient(
    colors: [Colors.white, Colors.white10],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}