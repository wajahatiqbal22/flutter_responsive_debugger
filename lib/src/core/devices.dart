import 'package:flutter/material.dart';
import 'enums.dart';

/// Represents a device configuration for simulation
class DeviceConfig {
  final String name;
  final Size size;
  final double pixelRatio;
  final EdgeInsets safeArea;
  final DeviceCategory category;
  final DebugPlatform platform;

  const DeviceConfig({
    required this.name,
    required this.size,
    this.pixelRatio = 1.0,
    this.safeArea = EdgeInsets.zero,
    required this.category,
    required this.platform,
  });

  /// Create a copy with modified properties
  DeviceConfig copyWith({
    String? name,
    Size? size,
    double? pixelRatio,
    EdgeInsets? safeArea,
    DeviceCategory? category,
    DebugPlatform? platform,
  }) {
    return DeviceConfig(
      name: name ?? this.name,
      size: size ?? this.size,
      pixelRatio: pixelRatio ?? this.pixelRatio,
      safeArea: safeArea ?? this.safeArea,
      category: category ?? this.category,
      platform: platform ?? this.platform,
    );
  }

  /// Get landscape version of this device
  DeviceConfig get landscape {
    return copyWith(
      size: Size(size.height, size.width),
    );
  }
}

/// Predefined device configurations
class Devices {
  static const List<DeviceConfig> phones = [
    // iPhone devices
    DeviceConfig(
      name: 'iPhone SE (3rd gen)',
      size: Size(375, 667),
      pixelRatio: 2.0,
      safeArea: EdgeInsets.only(top: 20, bottom: 0),
      category: DeviceCategory.phone,
      platform: DebugPlatform.iOS,
    ),
    DeviceConfig(
      name: 'iPhone 13/14',
      size: Size(390, 844),
      pixelRatio: 3.0,
      safeArea: EdgeInsets.only(top: 47, bottom: 34),
      category: DeviceCategory.phone,
      platform: DebugPlatform.iOS,
    ),
    DeviceConfig(
      name: 'iPhone 13/14 Pro Max',
      size: Size(428, 926),
      pixelRatio: 3.0,
      safeArea: EdgeInsets.only(top: 47, bottom: 34),
      category: DeviceCategory.phone,
      platform: DebugPlatform.iOS,
    ),
    
    // Android devices
    DeviceConfig(
      name: 'Pixel 7',
      size: Size(412, 915),
      pixelRatio: 2.625,
      safeArea: EdgeInsets.only(top: 24, bottom: 0),
      category: DeviceCategory.phone,
      platform: DebugPlatform.android,
    ),
    DeviceConfig(
      name: 'Pixel 7 Pro',
      size: Size(412, 892),
      pixelRatio: 3.5,
      safeArea: EdgeInsets.only(top: 24, bottom: 0),
      category: DeviceCategory.phone,
      platform: DebugPlatform.android,
    ),
    DeviceConfig(
      name: 'Samsung Galaxy S23',
      size: Size(384, 854),
      pixelRatio: 2.75,
      safeArea: EdgeInsets.only(top: 24, bottom: 0),
      category: DeviceCategory.phone,
      platform: DebugPlatform.android,
    ),
  ];

  static const List<DeviceConfig> tablets = [
    // iPad devices
    DeviceConfig(
      name: 'iPad (10th gen)',
      size: Size(820, 1180),
      pixelRatio: 2.0,
      safeArea: EdgeInsets.only(top: 24, bottom: 0),
      category: DeviceCategory.tablet,
      platform: DebugPlatform.iOS,
    ),
    DeviceConfig(
      name: 'iPad Pro 11"',
      size: Size(834, 1194),
      pixelRatio: 2.0,
      safeArea: EdgeInsets.only(top: 24, bottom: 0),
      category: DeviceCategory.tablet,
      platform: DebugPlatform.iOS,
    ),
    DeviceConfig(
      name: 'iPad Pro 12.9"',
      size: Size(1024, 1366),
      pixelRatio: 2.0,
      safeArea: EdgeInsets.only(top: 24, bottom: 0),
      category: DeviceCategory.tablet,
      platform: DebugPlatform.iOS,
    ),
    
    // Android tablets
    DeviceConfig(
      name: 'Pixel Tablet',
      size: Size(1600, 2560),
      pixelRatio: 2.0,
      safeArea: EdgeInsets.only(top: 24, bottom: 0),
      category: DeviceCategory.tablet,
      platform: DebugPlatform.android,
    ),
  ];

  static const List<DeviceConfig> desktops = [
    DeviceConfig(
      name: 'MacBook Air 13"',
      size: Size(1440, 900),
      pixelRatio: 2.0,
      safeArea: EdgeInsets.zero,
      category: DeviceCategory.desktop,
      platform: DebugPlatform.macOS,
    ),
    DeviceConfig(
      name: 'MacBook Pro 14"',
      size: Size(1512, 982),
      pixelRatio: 2.0,
      safeArea: EdgeInsets.zero,
      category: DeviceCategory.desktop,
      platform: DebugPlatform.macOS,
    ),
    DeviceConfig(
      name: 'Desktop 1080p',
      size: Size(1920, 1080),
      pixelRatio: 1.0,
      safeArea: EdgeInsets.zero,
      category: DeviceCategory.desktop,
      platform: DebugPlatform.web,
    ),
    DeviceConfig(
      name: 'Desktop 1440p',
      size: Size(2560, 1440),
      pixelRatio: 1.0,
      safeArea: EdgeInsets.zero,
      category: DeviceCategory.desktop,
      platform: DebugPlatform.web,
    ),
  ];

  /// Get all devices grouped by category
  static Map<DeviceCategory, List<DeviceConfig>> get allDevices => {
    DeviceCategory.phone: phones,
    DeviceCategory.tablet: tablets,
    DeviceCategory.desktop: desktops,
  };

  /// Get all devices as a flat list
  static List<DeviceConfig> get allDevicesList => [
    ...phones,
    ...tablets,
    ...desktops,
  ];

  /// Find device by name
  static DeviceConfig? findByName(String name) {
    return allDevicesList.cast<DeviceConfig?>().firstWhere(
      (device) => device?.name == name,
      orElse: () => null,
    );
  }
}
