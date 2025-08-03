/// Supported platform types for simulation
enum DebugPlatform {
  android('Android', 'android'),
  iOS('iOS', 'ios'),
  macOS('macOS', 'macos'),
  web('Web', 'web'),
  windows('Windows', 'windows'),
  linux('Linux', 'linux');

  const DebugPlatform(this.displayName, this.identifier);
  
  final String displayName;
  final String identifier;
}

/// Device orientation options
enum DebugOrientation {
  portrait('Portrait', 'portrait'),
  landscape('Landscape', 'landscape');

  const DebugOrientation(this.displayName, this.identifier);
  
  final String displayName;
  final String identifier;
}

/// Predefined device categories
enum DeviceCategory {
  phone('Phone', 'phone', '📱'),
  tablet('Tablet', 'tablet', '📱'),
  desktop('Desktop', 'desktop', '🖥️'),
  custom('Custom', 'custom', '⚙️');

  const DeviceCategory(this.displayName, this.identifier, this.icon);
  
  final String displayName;
  final String identifier;
  final String icon;
}

/// Font scale presets
enum FontScalePreset {
  small(0.8, 'Small', 'small'),
  normal(1.0, 'Normal', 'normal'),
  large(1.2, 'Large', 'large'),
  extraLarge(1.4, 'Extra Large', 'extra_large'),
  huge(1.6, 'Huge', 'huge'),
  accessibility(2.0, 'Accessibility', 'accessibility');

  const FontScalePreset(this.scale, this.displayName, this.identifier);
  
  final double scale;
  final String displayName;
  final String identifier;
}

/// Control panel sections for organization
enum DebuggerSection {
  deviceSelection('Device Selection', 'device_selection'),
  orientation('Orientation', 'orientation'),
  fontScale('Font Scale', 'font_scale'),
  visualOptions('Visual Options', 'visual_options'),
  platformOverride('Platform Override', 'platform_override'),
  customSettings('Custom Settings', 'custom_settings');

  const DebuggerSection(this.displayName, this.identifier);
  
  final String displayName;
  final String identifier;
}

/// Visual debugging options
enum VisualDebugOption {
  layoutBounds('Layout Bounds', 'layout_bounds', '🔲'),
  safeArea('Safe Area', 'safe_area', '🛡️'),
  zoom('Zoom Level', 'zoom', '🔍');

  const VisualDebugOption(this.displayName, this.identifier, this.icon);
  
  final String displayName;
  final String identifier;
  final String icon;
}
