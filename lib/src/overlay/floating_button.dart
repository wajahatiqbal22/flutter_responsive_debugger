import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/debugger_controller.dart';
import 'components/device_dropdown.dart';
import 'components/font_scale_control.dart';
import 'components/orientation_control.dart';
import 'components/platform_control.dart';
import 'components/visual_options_control.dart';

/// A draggable floating button that toggles the responsive debugger panel
class FloatingDebugButton extends StatefulWidget {
  const FloatingDebugButton({super.key});

  @override
  State<FloatingDebugButton> createState() => _FloatingDebugButtonState();
}

class _FloatingDebugButtonState extends State<FloatingDebugButton> {
  Offset _position = const Offset(20, 100);
  bool _isDragging = false;
  bool _showFallback = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<DebuggerController>(
      builder: (context, controller, _) {
        if (!controller.isVisible) return const SizedBox.shrink();

        return Stack(
          children: [
            // Main floating button
            Positioned(
              left: _position.dx,
              top: _position.dy,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: GestureDetector(
                  onPanStart: (_) => _isDragging = true,
                  onPanUpdate: (details) {
                    setState(() {
                      _position += details.delta;

                      // Keep button within screen bounds
                      final size = MediaQuery.of(context).size;
                      _position = Offset(
                        _position.dx.clamp(0, size.width - 56),
                        _position.dy.clamp(0, size.height - 56),
                      );
                    });
                  },
                  onPanEnd: (_) {
                    _isDragging = false;
                    // Snap to edges for better UX
                    _snapToEdge(context);
                  },
                  onTap: () {
                    if (!_isDragging) {
                      _showDebugPanel(context);
                    }
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: controller.isPanelOpen
                          ? Colors.orange
                          : Colors.purple,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: const Color.fromRGBO(255, 255, 255, 0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.3),
                          blurRadius: _isDragging ? 8 : 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      controller.isPanelOpen
                          ? Icons.close
                          : Icons.phone_android,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),

            // Full debugger panel overlay
            if (_showFallback)
              Positioned.fill(
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Scaffold(
                    backgroundColor: Colors.black54,
                    body: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.8,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // Header
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 0.5)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.phone_android,
                                      color: Colors.blue),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Responsive Debugger',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _showFallback = false;
                                      });
                                      context
                                          .read<DebuggerController>()
                                          .closePanel();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Icon(Icons.close,
                                          color: Colors.white, size: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Controls
                            const Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DeviceDropdown(),
                                    SizedBox(height: 20),
                                    OrientationControl(),
                                    SizedBox(height: 20),
                                    FontScaleControl(),
                                    SizedBox(height: 20),
                                    VisualOptionsControl(),
                                    SizedBox(height: 20),
                                    PlatformControl(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _snapToEdge(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2;

    setState(() {
      // Snap to left or right edge based on current position
      if (_position.dx < centerX) {
        _position = Offset(20, _position.dy);
      } else {
        _position = Offset(size.width - 76, _position.dy);
      }
    });
  }

  void _showDebugPanel(BuildContext context) {
    final controller = context.read<DebuggerController>();

    if (controller.isPanelOpen) {
      controller.closePanel();
      return;
    }

    controller.openPanel();

    // Show the panel directly in our state instead of using showModalBottomSheet
    setState(() {
      _showFallback = true;
    });
  }
}
