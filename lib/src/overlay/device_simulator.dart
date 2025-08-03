import 'package:flutter/material.dart';
import 'package:flutter_responsive_debugger/flutter_responsive_debugger.dart';
import 'package:provider/provider.dart';

import '../core/debugger_controller.dart';
import 'layout_overlay.dart';

/// Wraps the app with device simulation capabilities
class DeviceSimulator extends StatelessWidget {
  final Widget child;

  const DeviceSimulator({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DebuggerController>(
      builder: (context, controller, _) {
        Widget simulatedChild = child;

        // Apply layout bounds overlay if enabled
        if (controller.showLayoutBounds) {
          simulatedChild = LayoutBoundsOverlay(child: simulatedChild);
        }

        // Apply zoom if not 1.0
        if (controller.zoomLevel != 1.0) {
          simulatedChild = Transform.scale(
            scale: controller.zoomLevel,
            child: simulatedChild,
          );
        }

        // Apply device simulation if a device is selected or custom size is set
        final effectiveSize = controller.effectiveSize;
        if (effectiveSize != null) {
          simulatedChild = _buildDeviceFrame(
            context,
            controller,
            simulatedChild,
            effectiveSize,
          );
        }

        // Apply MediaQuery overrides
        return _buildMediaQueryOverride(
          context,
          controller,
          simulatedChild,
        );
      },
    );
  }

  Widget _buildDeviceFrame(
    BuildContext context,
    DebuggerController controller,
    Widget child,
    Size deviceSize,
  ) {
    return Center(
      child: Container(
        width: deviceSize.width,
        height: deviceSize.height,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[400]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: child,
        ),
      ),
    );
  }

  Widget _buildMediaQueryOverride(
    BuildContext context,
    DebuggerController controller,
    Widget child,
  ) {
    final originalMediaQuery = MediaQuery.of(context);
    final effectiveSize = controller.effectiveSize;
    final effectiveSafeArea = controller.effectiveSafeArea;

    // Create modified MediaQueryData
    MediaQueryData modifiedData = originalMediaQuery;

    // Override size if device is selected
    if (effectiveSize != null) {
      modifiedData = modifiedData.copyWith(
        size: effectiveSize,
      );
    }

    // Override font scale
    if (controller.fontScale != 1.0) {
      modifiedData = modifiedData.copyWith(
        textScaler: TextScaler.linear(controller.fontScale),
      );
    }

    // Override safe area
    if (controller.simulateSafeArea && controller.selectedDevice != null) {
      modifiedData = modifiedData.copyWith(
        padding: effectiveSafeArea,
        viewInsets: EdgeInsets.zero,
        viewPadding: effectiveSafeArea,
      );
    }

    // Override platform if specified
    if (controller.platformOverride != null) {
      final targetPlatform = _getTargetPlatform(controller.platformOverride!);
      modifiedData = modifiedData.copyWith(
        platformBrightness:
            _getPlatformBrightness(controller.platformOverride!),
      );

      return Theme(
        data: Theme.of(context).copyWith(
          platform: targetPlatform,
        ),
        child: MediaQuery(
          data: modifiedData,
          child: child,
        ),
      );
    }

    return MediaQuery(
      data: modifiedData,
      child: child,
    );
  }

  TargetPlatform _getTargetPlatform(DebugPlatform platform) {
    switch (platform) {
      case DebugPlatform.android:
        return TargetPlatform.android;
      case DebugPlatform.iOS:
        return TargetPlatform.iOS;
      case DebugPlatform.macOS:
        return TargetPlatform.macOS;
      case DebugPlatform.windows:
        return TargetPlatform.windows;
      case DebugPlatform.linux:
        return TargetPlatform.linux;
      case DebugPlatform.web:
        return TargetPlatform.android; // Default to Android for web
    }
  }

  Brightness _getPlatformBrightness(DebugPlatform platform) {
    // You could customize this based on platform defaults
    return Brightness.light;
  }
}
