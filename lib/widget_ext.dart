import 'dart:ui';

import 'package:flutter/rendering.dart';

extension RectFromOffsetExt on Rect {
  Offset forAlignment(Alignment alignment) {
    switch (alignment.x.toInt()) {
      case 1:
        switch (alignment.y.toInt()) {
          case 1:
            return bottomRight;
          case -1:
            return topRight;
          case 0:
            return centerRight;
          default:
            throw StateError('Invalid y: ${alignment.y}');
        }
      case 0:
        switch (alignment.y.toInt()) {
          case 1:
            return topCenter;
          case -1:
            return bottomCenter;
          case 0:
            return center;
          default:
            throw StateError('Invalid y: ${alignment.y}');
        }
      case -1:
        switch (alignment.y.toInt()) {
          case 1:
            return bottomLeft;
          case -1:
            return topLeft;
          case 0:
            return centerLeft;
          default:
            throw StateError('Invalid y: ${alignment.y}');
        }
      default:
        throw StateError('Invalid y: ${alignment.x}');
    }
  }
}
