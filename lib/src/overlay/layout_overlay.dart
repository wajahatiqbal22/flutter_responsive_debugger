import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Overlays red borders on widgets to visualize layout bounds
class LayoutBoundsOverlay extends StatelessWidget {
  final Widget child;

  const LayoutBoundsOverlay({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return _LayoutBoundsWidget(child: child);
  }
}

/// Internal widget that applies layout bounds visualization
class _LayoutBoundsWidget extends SingleChildRenderObjectWidget {
  const _LayoutBoundsWidget({required Widget child}) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderLayoutBounds();
  }
}

/// Custom render object that draws borders around widgets
class _RenderLayoutBounds extends RenderProxyBox {
  @override
  void paint(PaintingContext context, Offset offset) {
    // Paint the child first
    super.paint(context, offset);

    // Draw border around this widget
    final paint = Paint()
      ..color = const Color.fromRGBO(244, 67, 54, 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final rect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      size.width,
      size.height,
    );

    context.canvas.drawRect(rect, paint);
  }
}

/// Widget that can be used to manually add layout bounds to specific widgets
class LayoutBorderOverlay extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final double borderWidth;

  const LayoutBorderOverlay({
    super.key,
    required this.child,
    this.borderColor = Colors.red,
    this.borderWidth = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor.withAlpha((0.7 * 255).round()),
          width: borderWidth,
        ),
      ),
      child: child,
    );
  }
}

/// Extension to easily add layout bounds to any widget
extension LayoutBoundsExtension on Widget {
  /// Wraps this widget with a layout bounds overlay
  Widget withLayoutBounds({
    Color borderColor = Colors.red,
    double borderWidth = 0.5,
  }) {
    return LayoutBorderOverlay(
      borderColor: borderColor,
      borderWidth: borderWidth,
      child: this,
    );
  }
}
