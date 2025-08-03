import 'package:flutter/material.dart';
import 'devices.dart';
import 'enums.dart';

/// Controls the state of the responsive debugger
class DebuggerController extends ChangeNotifier {
  bool _isVisible = true;
  bool _isPanelOpen = false;
  DeviceConfig? _selectedDevice;
  DebugOrientation _orientation = DebugOrientation.portrait;
  double _fontScale = 1.0;
  bool _showLayoutBounds = false;
  bool _simulateSafeArea = true;
  DebugPlatform? _platformOverride;
  double _zoomLevel = 1.0;
  Size? _customSize;

  // Getters
  bool get isVisible => _isVisible;
  bool get isPanelOpen => _isPanelOpen;
  DeviceConfig? get selectedDevice => _selectedDevice;
  
  /// Whether the current device is the default (actual screen size)
  bool get isDefaultDevice => _selectedDevice == null;
  DebugOrientation get orientation => _orientation;
  double get fontScale => _fontScale;
  bool get showLayoutBounds => _showLayoutBounds;
  bool get simulateSafeArea => _simulateSafeArea;
  DebugPlatform? get platformOverride => _platformOverride;
  double get zoomLevel => _zoomLevel;
  Size? get customSize => _customSize;

  /// Get the current effective device size considering orientation
  Size? get effectiveSize {
    if (_customSize != null) return _customSize;
    if (_selectedDevice == null) return null;
    
    final size = _selectedDevice!.size;
    return _orientation == DebugOrientation.landscape
        ? Size(size.height, size.width)
        : size;
  }

  /// Get the current effective safe area considering orientation
  EdgeInsets get effectiveSafeArea {
    if (!_simulateSafeArea || _selectedDevice == null) {
      return EdgeInsets.zero;
    }
    
    final safeArea = _selectedDevice!.safeArea;
    return _orientation == DebugOrientation.landscape
        ? EdgeInsets.only(
            left: safeArea.top,
            right: safeArea.bottom,
            top: safeArea.left,
            bottom: safeArea.right,
          )
        : safeArea;
  }

  /// Toggle debugger visibility
  void toggleVisibility() {
    _isVisible = !_isVisible;
    notifyListeners();
  }

  /// Show the debugger
  void show() {
    _isVisible = true;
    notifyListeners();
  }

  /// Hide the debugger
  void hide() {
    _isVisible = false;
    _isPanelOpen = false;
    notifyListeners();
  }

  /// Toggle the debug panel
  void togglePanel() {
    _isPanelOpen = !_isPanelOpen;
    notifyListeners();
  }

  /// Open the debug panel
  void openPanel() {
    _isPanelOpen = true;
    notifyListeners();
  }

  /// Close the debug panel
  void closePanel() {
    _isPanelOpen = false;
    notifyListeners();
  }

  /// Set the selected device
  /// Sets the current device configuration
  /// If [device] is null, resets to the default (actual screen size)
  void setDevice(DeviceConfig? device) {
    if (device == _selectedDevice) return;
    _selectedDevice = device;
    _customSize = null; // Clear custom size when selecting a preset
    notifyListeners();
  }
  
  /// Resets to the default device (actual screen size)
  void resetToDefault() {
    setDevice(null);
  }

  /// Set custom screen size
  void setCustomSize(Size size) {
    _customSize = size;
    _selectedDevice = null; // Clear device when using custom size
    notifyListeners();
  }

  /// Set orientation
  void setOrientation(DebugOrientation orientation) {
    _orientation = orientation;
    notifyListeners();
  }

  /// Toggle orientation
  void toggleOrientation() {
    _orientation = _orientation == DebugOrientation.portrait
        ? DebugOrientation.landscape
        : DebugOrientation.portrait;
    notifyListeners();
  }

  /// Set font scale
  void setFontScale(double scale) {
    _fontScale = scale.clamp(0.5, 3.0);
    notifyListeners();
  }

  /// Set font scale from preset
  void setFontScalePreset(FontScalePreset preset) {
    setFontScale(preset.scale);
  }

  /// Toggle layout bounds visibility
  void toggleLayoutBounds() {
    _showLayoutBounds = !_showLayoutBounds;
    notifyListeners();
  }

  /// Set layout bounds visibility
  void setShowLayoutBounds(bool show) {
    _showLayoutBounds = show;
    notifyListeners();
  }

  /// Toggle safe area simulation
  void toggleSafeArea() {
    _simulateSafeArea = !_simulateSafeArea;
    notifyListeners();
  }

  /// Set safe area simulation
  void setSimulateSafeArea(bool simulate) {
    _simulateSafeArea = simulate;
    notifyListeners();
  }

  /// Set platform override
  void setPlatformOverride(DebugPlatform? platform) {
    _platformOverride = platform;
    notifyListeners();
  }

  /// Clear platform override
  void clearPlatformOverride() {
    _platformOverride = null;
    notifyListeners();
  }

  /// Set zoom level
  void setZoomLevel(double zoom) {
    _zoomLevel = zoom.clamp(0.5, 2.0);
    notifyListeners();
  }

  /// Reset all settings to defaults
  void reset() {
    _selectedDevice = null;
    _orientation = DebugOrientation.portrait;
    _fontScale = 1.0;
    _showLayoutBounds = false;
    _simulateSafeArea = true;
    _platformOverride = null;
    _zoomLevel = 1.0;
    _customSize = null;
    notifyListeners();
  }

  /// Get current configuration as a map (for export/import)
  Map<String, dynamic> toJson() {
    return {
      'selectedDevice': _selectedDevice?.name,
      'orientation': _orientation.name,
      'fontScale': _fontScale,
      'showLayoutBounds': _showLayoutBounds,
      'simulateSafeArea': _simulateSafeArea,
      'platformOverride': _platformOverride?.name,
      'zoomLevel': _zoomLevel,
      'customSize': _customSize != null 
          ? {'width': _customSize!.width, 'height': _customSize!.height}
          : null,
    };
  }

  /// Load configuration from a map (for export/import)
  void fromJson(Map<String, dynamic> json) {
    if (json['selectedDevice'] != null) {
      _selectedDevice = Devices.findByName(json['selectedDevice']);
    }
    
    if (json['orientation'] != null) {
      _orientation = DebugOrientation.values.firstWhere(
        (o) => o.name == json['orientation'],
        orElse: () => DebugOrientation.portrait,
      );
    }
    
    _fontScale = (json['fontScale'] as num?)?.toDouble() ?? 1.0;
    _showLayoutBounds = json['showLayoutBounds'] as bool? ?? false;
    _simulateSafeArea = json['simulateSafeArea'] as bool? ?? true;
    _zoomLevel = (json['zoomLevel'] as num?)?.toDouble() ?? 1.0;
    
    if (json['platformOverride'] != null) {
      _platformOverride = DebugPlatform.values.cast<DebugPlatform?>().firstWhere(
        (p) => p?.name == json['platformOverride'],
        orElse: () => null,
      );
    }
    
    if (json['customSize'] != null) {
      final sizeData = json['customSize'] as Map<String, dynamic>;
      _customSize = Size(
        (sizeData['width'] as num).toDouble(),
        (sizeData['height'] as num).toDouble(),
      );
    }
    
    notifyListeners();
  }
}
