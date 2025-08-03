import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/debugger_controller.dart';
import '../../core/devices.dart';
import '../../core/enums.dart';

// Special key for the default device option
const String _defaultDeviceKey = 'DEFAULT_DEVICE';

// Extension to handle default device case
extension _DeviceConfigX on DeviceConfig? {
  String get dropdownKey => this?.name ?? _defaultDeviceKey;
}

/// A professional dropdown component for device selection
/// Organizes devices by category with proper visual hierarchy
class DeviceDropdown extends StatelessWidget {
  const DeviceDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DebuggerController>(
      builder: (context, controller, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.phone_android, size: 16, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Device',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildDeviceDropdown(context, controller),
            if (controller.selectedDevice != null) ...[
              const SizedBox(height: 8),
              _buildDeviceInfo(controller.selectedDevice!),
            ],
          ],
        );
      },
    );
  }

  Widget _buildDeviceDropdown(
      BuildContext context, DebuggerController controller) {
    // Get the current screen size for the default option
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.selectedDevice?.dropdownKey ?? _defaultDeviceKey,
          hint: const Text('Select a device...'),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: _buildDropdownItems(screenSize),
          onChanged: (String? newKey) {
            if (newKey == _defaultDeviceKey) {
              // Reset to default (current screen size)
              controller.setDevice(null);
            } else {
              // Find the selected device
              final device = _findDeviceByKey(newKey);
              if (device != null) {
                controller.setDevice(device);
              }
            }
          },
        ),
      ),
    );
  }

  // Find device by its dropdown key
  DeviceConfig? _findDeviceByKey(String? key) {
    if (key == null || key == _defaultDeviceKey) return null;
    return Devices.allDevicesList.firstWhere(
      (device) => device.dropdownKey == key,
      orElse: () => Devices.phones.first,
    );
  }

  List<DeviceConfig> _getDevicesForCategory(DeviceCategory category) {
    switch (category) {
      case DeviceCategory.phone:
        return Devices.phones;
      case DeviceCategory.tablet:
        return Devices.tablets;
      case DeviceCategory.desktop:
        return Devices.desktops;
      default:
        return [];
    }
  }

  List<DropdownMenuItem<String>> _buildDropdownItems(Size screenSize) {
    final items = <DropdownMenuItem<String>>[];

    // Add default device option
    items.add(
      DropdownMenuItem<String>(
        value: _defaultDeviceKey,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.smartphone, size: 16, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'Default (${screenSize.width.toInt()}×${screenSize.height.toInt()})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Text(
                  'Current Screen',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.blue.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Add separator
    items.add(
      const DropdownMenuItem<String>(
        enabled: false,
        value: '',
        child: Divider(height: 1, thickness: 1),
      ),
    );

    // Add category headers and devices
    for (final category in DeviceCategory.values) {
      final categoryDevices = _getDevicesForCategory(category);
      if (categoryDevices.isEmpty) continue;

      // Add category header
      items.add(
        DropdownMenuItem<String>(
          enabled: false,
          value: '',
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              category.displayName.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      );

      // Add devices in this category
      for (final device in categoryDevices) {
        items.add(
          DropdownMenuItem<String>(
            value: device.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
              child: Row(
                children: [
                  Icon(
                    _getDeviceIcon(device.platform),
                    size: 16,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${device.name} (${device.size.width.toInt()}×${device.size.height.toInt()})',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      // Add separator between categories
      items.add(
        const DropdownMenuItem<String>(
          enabled: false,
          value: '',
          child: Divider(height: 1, thickness: 1),
        ),
      );
    }

    return items;
  }

  IconData _getDeviceIcon(DebugPlatform platform) {
    switch (platform) {
      case DebugPlatform.android:
        return Icons.android;
      case DebugPlatform.iOS:
        return Icons.phone_iphone;
      case DebugPlatform.macOS:
        return Icons.desktop_mac;
      case DebugPlatform.windows:
        return Icons.desktop_windows;
      case DebugPlatform.linux:
        return Icons.desktop_windows_rounded;
      case DebugPlatform.web:
        return Icons.web;
      default:
        return Icons.device_unknown;
    }
  }

  Widget _buildDeviceInfo(DeviceConfig device) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50], // Using index operator for const color
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color:
                Colors.grey[200]!), // Using index operator with null assertion
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, size: 16, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                device.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem('Size',
                  '${device.size.width.toInt()}×${device.size.height.toInt()}'),
              _buildInfoItem(
                  'Pixel Ratio', '${device.pixelRatio.toStringAsFixed(1)}x'),
              _buildInfoItem('Platform', device.platform.name.toUpperCase()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
