import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/debugger_controller.dart';
import 'overlay/device_simulator.dart';
import 'overlay/floating_button.dart';
import 'overlay/layout_overlay.dart';

/// A developer-only overlay tool to interactively test Flutter app responsiveness
/// across different screen sizes, font scales, safe areas, and orientations.
///
/// Only runs in debug mode for safety.
class ResponsiveDebugger extends StatelessWidget {
  /// The child widget to wrap with debugging capabilities
  final Widget child;

  /// Whether the debugger is enabled (should only be true in debug mode)
  final bool enabled;

  const ResponsiveDebugger({
    super.key,
    required this.child,
    this.enabled = kDebugMode,
  });

  @override
  Widget build(BuildContext context) {
    // Safety check - only run in debug mode
    if (!enabled || !kDebugMode) {
      return child;
    }

    return ChangeNotifierProvider(
      create: (_) => DebuggerController(),
      child: Consumer<DebuggerController>(
        builder: (context, controller, _) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Stack(
              children: [
              // Main app wrapped with device simulation and optional layout bounds
              controller.showLayoutBounds
                  ? DeviceSimulator(
                      child: LayoutBoundsOverlay(child: child),
                    )
                  : DeviceSimulator(child: child),

              // Floating debug button
              const FloatingDebugButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}
