import 'package:flutter/material.dart';

class CroppedCardBorder extends ShapeBorder {
  const CroppedCardBorder({
    required this.borderRadius,
    required this.holeSize,
    this.offset = Offset.zero,
    this.side = BorderSide.none,
  });

  final Radius borderRadius;
  final Offset offset;
  final BorderSide side;
  final double holeSize;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      _getPath(rect);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side != BorderSide.none) {
      canvas.drawPath(
        _getPath(rect),
        side.toPaint(),
      );
    }
  }

  Path _getPath(Rect rect) {
    return Path.combine(
      PathOperation.difference,
      Path()..addRRect(RRect.fromRectAndRadius(rect, borderRadius)),
      Path()
        ..addOval(Rect.fromCircle(
          center: Offset(0, rect.height) + offset,
          radius: holeSize,
        )),
    );
  }

  @override
  ShapeBorder scale(double t) => this;
}
