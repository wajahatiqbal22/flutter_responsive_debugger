import 'package:flutter/material.dart';
import '../core/enums.dart';
import 'screen_utils.dart';

/// Extensions for Size class
extension SizeExtensions on Size {
  /// Get aspect ratio
  double get aspectRatio => ScreenUtils.getAspectRatio(this);
  
  /// Check if this is a phone size
  bool get isPhone => ScreenUtils.isPhone(this);
  
  /// Check if this is a tablet size
  bool get isTablet => ScreenUtils.isTablet(this);
  
  /// Check if this is a desktop size
  bool get isDesktop => ScreenUtils.isDesktop(this);
  
  /// Get device category
  DeviceCategory get category => ScreenUtils.getDeviceCategory(this);
  
  /// Get current breakpoint
  String get breakpoint => ScreenUtils.getCurrentBreakpoint(width);
  
  /// Check if matches a specific breakpoint
  bool matchesBreakpoint(String breakpoint) => 
      ScreenUtils.isBreakpoint(this, breakpoint);
  
  /// Get orientation from size
  DebugOrientation get orientation => 
      ScreenUtils.getOrientationFromSize(this);
  
  /// Rotate size
  Size rotate(DebugOrientation orientation) => 
      ScreenUtils.rotateSize(this, orientation);
  
  /// Get recommended padding for this size
  EdgeInsets get recommendedPadding => 
      ScreenUtils.getRecommendedPadding(this);
  
  /// Get optimal font size for this screen
  double getOptimalFontSize(double baseFontSize) => 
      ScreenUtils.getOptimalFontSize(this, baseFontSize);
}

/// Extensions for MediaQueryData
extension MediaQueryExtensions on MediaQueryData {
  /// Check if current size is phone
  bool get isPhone => size.isPhone;
  
  /// Check if current size is tablet
  bool get isTablet => size.isTablet;
  
  /// Check if current size is desktop
  bool get isDesktop => size.isDesktop;
  
  /// Get device category
  DeviceCategory get deviceCategory => size.category;
  
  /// Get current breakpoint
  String get breakpoint => size.breakpoint;
  
  /// Check if matches a specific breakpoint
  bool matchesBreakpoint(String breakpoint) => 
      size.matchesBreakpoint(breakpoint);
  
  /// Get recommended padding
  EdgeInsets get recommendedPadding => size.recommendedPadding;
  
  /// Get optimal font size
  double getOptimalFontSize(double baseFontSize) => 
      size.getOptimalFontSize(baseFontSize);
}

/// Extensions for BuildContext
extension ResponsiveExtensions on BuildContext {
  /// Get MediaQuery data
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  
  /// Get screen size
  Size get screenSize => mediaQuery.size;
  
  /// Get screen width
  double get screenWidth => screenSize.width;
  
  /// Get screen height
  double get screenHeight => screenSize.height;
  
  /// Check if current screen is phone
  bool get isPhone => screenSize.isPhone;
  
  /// Check if current screen is tablet
  bool get isTablet => screenSize.isTablet;
  
  /// Check if current screen is desktop
  bool get isDesktop => screenSize.isDesktop;
  
  /// Get device category
  DeviceCategory get deviceCategory => screenSize.category;
  
  /// Get current breakpoint
  String get breakpoint => screenSize.breakpoint;
  
  /// Check if matches a specific breakpoint
  bool matchesBreakpoint(String breakpoint) => 
      screenSize.matchesBreakpoint(breakpoint);
  
  /// Get recommended padding
  EdgeInsets get recommendedPadding => screenSize.recommendedPadding;
  
  /// Get optimal font size
  double getOptimalFontSize(double baseFontSize) => 
      screenSize.getOptimalFontSize(baseFontSize);
  
  /// Responsive value based on breakpoints
  T responsive<T>({
    T? xs,
    T? sm,
    T? md,
    T? lg,
    T? xl,
    T? xxl,
    required T fallback,
  }) {
    final bp = breakpoint;
    
    switch (bp) {
      case 'xxl':
        return xxl ?? xl ?? lg ?? md ?? sm ?? xs ?? fallback;
      case 'xl':
        return xl ?? lg ?? md ?? sm ?? xs ?? fallback;
      case 'lg':
        return lg ?? md ?? sm ?? xs ?? fallback;
      case 'md':
        return md ?? sm ?? xs ?? fallback;
      case 'sm':
        return sm ?? xs ?? fallback;
      case 'xs':
      default:
        return xs ?? fallback;
    }
  }
}

/// Extensions for Widget
extension WidgetExtensions on Widget {
  /// Add responsive padding based on screen size
  Widget responsivePadding(BuildContext context) {
    return Padding(
      padding: context.recommendedPadding,
      child: this,
    );
  }
  
  /// Show widget only on specific device categories
  Widget showOn({
    bool phone = true,
    bool tablet = true,
    bool desktop = true,
  }) {
    return Builder(
      builder: (context) {
        final category = context.deviceCategory;
        
        final shouldShow = switch (category) {
          DeviceCategory.phone => phone,
          DeviceCategory.tablet => tablet,
          DeviceCategory.desktop => desktop,
          DeviceCategory.custom => true,
        };
        
        return shouldShow ? this : const SizedBox.shrink();
      },
    );
  }
  
  /// Show widget only on specific breakpoints
  Widget showOnBreakpoint({
    bool xs = true,
    bool sm = true,
    bool md = true,
    bool lg = true,
    bool xl = true,
    bool xxl = true,
  }) {
    return Builder(
      builder: (context) {
        final bp = context.breakpoint;
        
        final shouldShow = switch (bp) {
          'xs' => xs,
          'sm' => sm,
          'md' => md,
          'lg' => lg,
          'xl' => xl,
          'xxl' => xxl,
          _ => true,
        };
        
        return shouldShow ? this : const SizedBox.shrink();
      },
    );
  }
}
