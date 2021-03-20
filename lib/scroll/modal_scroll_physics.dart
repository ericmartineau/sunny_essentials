import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ModalScrollPhysics extends ScrollPhysics {
  const ModalScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  double adjustPositionForNewDimensions(
      {required ScrollMetrics oldPosition,
      required ScrollMetrics newPosition,
      required bool isScrolling,
      required double velocity}) {
    if (newPosition.pixels <= 0) {
      return 0;
    }

    return super.adjustPositionForNewDimensions(
        oldPosition: oldPosition,
        newPosition: newPosition,
        isScrolling: isScrolling,
        velocity: velocity);
  }

  @override
  ModalScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ModalScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    if (position.pixels < 0) {
      return false;
    }
    return super.shouldAcceptUserOffset(position);
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    var newOffset = position.pixels + value;
    if (newOffset <= 0) {
      assert(() {
        if (value == position.pixels) {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary(
                '$runtimeType.applyBoundaryConditions() was called redundantly.'),
            ErrorDescription(
                'The proposed new position, $value, is exactly equal to the current position of the '
                'given ${position.runtimeType}, ${position.pixels}.\n'
                'The applyBoundaryConditions method should only be called when the value is '
                'going to actually change the pixels, otherwise it is redundant.'),
            DiagnosticsProperty<ScrollPhysics>(
                'The physics object in question was', this,
                style: DiagnosticsTreeStyle.errorProperty),
            DiagnosticsProperty<ScrollMetrics>(
                'The position object in question was', position,
                style: DiagnosticsTreeStyle.errorProperty)
          ]);
        }
        return true;
      }());
      if (value < position.pixels &&
          position.pixels <= position.minScrollExtent) {
        return value - position.pixels;
      }
      if (position.maxScrollExtent <= position.pixels &&
          position.pixels < value) {
        return value - position.pixels;
      }
      if (value < position.minScrollExtent &&
          position.minScrollExtent < position.pixels) {
        return value - position.minScrollExtent;
      }
      if (position.pixels < position.maxScrollExtent &&
          position.maxScrollExtent < value) {
        return value - position.maxScrollExtent;
      }
      return 0;
    } else {
      return super.applyBoundaryConditions(position, value);
    }
  }

  @override
  double carriedMomentum(double existingVelocity) {
    return super.carriedMomentum(existingVelocity);
  }
}
