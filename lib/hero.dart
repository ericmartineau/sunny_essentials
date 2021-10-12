import 'package:flutter/widgets.dart';

extension SunnyWidgetHeroExtensions on Widget {
  Widget hero(String? heroTag) {
    return heroTag == null ? this : Hero(tag: heroTag, child: this);
  }
}
