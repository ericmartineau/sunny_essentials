import 'package:flutter/widgets.dart';

abstract class WidgetDecorator {
  Widget build(BuildContext context, {required Widget child});
}

typedef WrapWidget = Widget Function(Widget widget);
