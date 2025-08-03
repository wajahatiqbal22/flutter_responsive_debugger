import 'package:flutter/material.dart';
import '../core/devices.dart';
import '../core/enums.dart';

/// Utility functions for screen size calculations and device detection
class ScreenUtils {
  /// Calculate device pixel ratio based on screen size and platform
  static double calculatePixelRatio(Size size, DebugPlatform platform) {
    // Default pixel ratios by platform
    switch (platform) {
      case DebugPlatform.iOS:
        if (size.width <= 375) return 2.0; // iPhone SE, regular iPhones
        if (size.width <= 414) return 3.0; // iPhone Pro models
        return 2.0; // iPads
      case DebugPlatform.android:
        if (size.width <= 360) return 2.0; // Small Android phones
        if (size.width <= 412) return 2.75; // Medium Android phones
        return 3.0; // Large Android phones
      case DebugPlatform.web:
      case DebugPlatform.windows:
      case DebugPlatform.linux:
        return 1.0; // Desktop platforms
      case DebugPlatform.macOS:
        return 2.0; // Retina displays
    }
  }

  /// Get aspect ratio for a given size
  static double getAspectRatio(Size size) {
    return size.width / size.height;
  }

  /// Check if size represents a phone form factor
  static bool isPhone(Size size) {
    final aspectRatio = getAspectRatio(size);
    return size.width < 600 && (aspectRatio > 0.4 && aspectRatio < 0.8);
  }

  /// Check if size represents a tablet form factor
  static bool isTablet(Size size) {
    final aspectRatio = getAspectRatio(size);
    return size.width >= 600 && size.width < 1200 && 
           (aspectRatio > 0.6 && aspectRatio < 1.5);
  }

  /// Check if size represents a desktop form factor
  static bool isDesktop(Size size) {
    return size.width >= 1200;
  }

  /// Get device category based on size
  static DeviceCategory getDeviceCategory(Size size) {
    if (isDesktop(size)) return DeviceCategory.desktop;
    if (isTablet(size)) return DeviceCategory.tablet;
    return DeviceCategory.phone;
  }

  /// Calculate safe area for a given device configuration
  static EdgeInsets calculateSafeArea(
    DeviceConfig device,
    DebugOrientation orientation,
  ) {
    final safeArea = device.safeArea;
    
    if (orientation == DebugOrientation.landscape) {
      return EdgeInsets.only(
        left: safeArea.top,
        right: safeArea.bottom,
        top: safeArea.left,
        bottom: safeArea.right,
      );
    }
    
    return safeArea;
  }

  /// Get breakpoints for responsive design
  static Map<String, double> get breakpoints => {
    'xs': 0,      // Extra small devices
    'sm': 576,    // Small devices
    'md': 768,    // Medium devices
    'lg': 992,    // Large devices
    'xl': 1200,   // Extra large devices
    'xxl': 1400,  // Extra extra large devices
  };

  /// Get current breakpoint for a given width
  static String getCurrentBreakpoint(double width) {
    if (width >= breakpoints['xxl']!) return 'xxl';
    if (width >= breakpoints['xl']!) return 'xl';
    if (width >= breakpoints['lg']!) return 'lg';
    if (width >= breakpoints['md']!) return 'md';
    if (width >= breakpoints['sm']!) return 'sm';
    return 'xs';
  }

  /// Check if current size matches a breakpoint
  static bool isBreakpoint(Size size, String breakpoint) {
    final bp = breakpoints[breakpoint];
    if (bp == null) return false;
    
    return size.width >= bp;
  }

  /// Get density-independent pixels (dp) from logical pixels
  static double logicalToDP(double logical, double pixelRatio) {
    return logical * pixelRatio;
  }

  /// Get logical pixels from density-independent pixels (dp)
  static double dpToLogical(double dp, double pixelRatio) {
    return dp / pixelRatio;
  }

  /// Calculate optimal font size for a given screen size
  static double getOptimalFontSize(Size size, double baseFontSize) {
    final category = getDeviceCategory(size);
    
    switch (category) {
      case DeviceCategory.phone:
        return baseFontSize * 0.9;
      case DeviceCategory.tablet:
        return baseFontSize * 1.1;
      case DeviceCategory.desktop:
        return baseFontSize * 1.2;
      case DeviceCategory.custom:
        return baseFontSize;
    }
  }

  /// Get recommended padding for a given screen size
  static EdgeInsets getRecommendedPadding(Size size) {
    final category = getDeviceCategory(size);
    
    switch (category) {
      case DeviceCategory.phone:
        return const EdgeInsets.all(16);
      case DeviceCategory.tablet:
        return const EdgeInsets.all(24);
      case DeviceCategory.desktop:
        return const EdgeInsets.all(32);
      case DeviceCategory.custom:
        return const EdgeInsets.all(16);
    }
  }

  /// Check if device has a notch (simplified heuristic)
  static bool hasNotch(DeviceConfig device) {
    return device.safeArea.top > 24; // Typical status bar height
  }

  /// Get device orientation from size
  static DebugOrientation getOrientationFromSize(Size size) {
    return size.width > size.height 
        ? DebugOrientation.landscape 
        : DebugOrientation.portrait;
  }

  /// Rotate size for orientation change
  static Size rotateSize(Size size, DebugOrientation orientation) {
    final currentOrientation = getOrientationFromSize(size);
    
    if (currentOrientation == orientation) {
      return size;
    }
    
    return Size(size.height, size.width);
  }
}
