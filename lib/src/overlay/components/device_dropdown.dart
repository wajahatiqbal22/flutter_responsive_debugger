import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/debugger_controller.dart';
import '../../core/devices.dart';
import '../../core/enums.dart';

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
                Text(
                  DebuggerSection.deviceSelection.displayName,
                  style: const TextStyle(
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

  Widget _buildDeviceDropdown(BuildContext context, DebuggerController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DeviceConfig>(
          value: controller.selectedDevice,
          hint: const Text('Select a device...'),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: _buildDropdownItems(),
          onChanged: (device) {
            if (device != null) {
              controller.setDevice(device);
            }
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<DeviceConfig>> _buildDropdownItems() {
    final List<DropdownMenuItem<DeviceConfig>> items = [];
    
    // Add default device option
    items.add(
      DropdownMenuItem<DeviceConfig>(
        value: null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.smartphone, size: 16, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'Device Default',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
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
                  'Recommended',
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
      DropdownMenuItem<DeviceConfig>(
        enabled: false,
        value: null,
        child: Container(
          height: 1,
          margin: const EdgeInsets.symmetric(vertical: 4),
          color: Colors.grey.shade200,
        ),
      ),
    );
    
    // Add category headers and devices
    for (final category in DeviceCategory.values) {
      final categoryDevices = _getDevicesForCategory(category);
      if (categoryDevices.isEmpty) continue;
      
      // Add category header
      items.add(
        DropdownMenuItem<DeviceConfig>(
          enabled: false,
          value: null,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Text(
                  category.icon,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                Text(
                  category.displayName.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      
      // Add devices in this category
      for (final device in categoryDevices) {
        items.add(
          DropdownMenuItem<DeviceConfig>(
            value: device,
            child: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          device.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${device.size.width.toInt()} × ${device.size.height.toInt()}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      
      // Add separator between categories (except for last category)
      if (category != DeviceCategory.values.last) {
        items.add(
          DropdownMenuItem<DeviceConfig>(
            enabled: false,
            value: null,
            child: Container(
              height: 1,
              margin: const EdgeInsets.symmetric(vertical: 4),
              color: Colors.grey.shade200,
            ),
          ),
        );
      }
    }
    
    return items;
  }

  List<DeviceConfig> _getDevicesForCategory(DeviceCategory category) {
    switch (category) {
      case DeviceCategory.phone:
        return Devices.phones;
      case DeviceCategory.tablet:
        return Devices.tablets;
      case DeviceCategory.desktop:
        return Devices.desktops;
      case DeviceCategory.custom:
        return []; // Custom devices would be handled separately
    }
  }

  Widget _buildDeviceInfo(DeviceConfig device) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: Colors.blue.shade700,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '${device.size.width.toInt()} × ${device.size.height.toInt()} • ${device.pixelRatio}x density',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.blue.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
