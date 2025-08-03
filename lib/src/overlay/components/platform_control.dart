import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/debugger_controller.dart';
import '../../core/enums.dart';

/// Professional platform override control component
class PlatformControl extends StatelessWidget {
  const PlatformControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DebuggerController>(
      builder: (context, controller, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.devices, size: 16, color: Colors.indigo),
                const SizedBox(width: 8),
                Text(
                  DebuggerSection.platformOverride.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildPlatformSelector(controller),
          ],
        );
      },
    );
  }

  Widget _buildPlatformSelector(DebuggerController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DebugPlatform?>(
          value: controller.platformOverride,
          hint: const Text('Use device default platform'),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: [
            const DropdownMenuItem<DebugPlatform?>(
              value: null,
              child: Row(
                children: [
                  Icon(Icons.smartphone, size: 16, color: Colors.grey),
                  SizedBox(width: 8),
                  Text('Device Default'),
                ],
              ),
            ),
            ...DebugPlatform.values.map((platform) {
              return DropdownMenuItem<DebugPlatform?>(
                value: platform,
                child: Row(
                  children: [
                    Icon(
                      _getPlatformIcon(platform),
                      size: 16,
                      color: Colors.indigo,
                    ),
                    const SizedBox(width: 8),
                    Text(platform.displayName),
                  ],
                ),
              );
            }),
          ],
          onChanged: (platform) {
            controller.setPlatformOverride(platform);
          },
        ),
      ),
    );
  }

  IconData _getPlatformIcon(DebugPlatform platform) {
    switch (platform) {
      case DebugPlatform.android:
        return Icons.android;
      case DebugPlatform.iOS:
        return Icons.phone_iphone;
      case DebugPlatform.macOS:
        return Icons.laptop_mac;
      case DebugPlatform.web:
        return Icons.web;
      case DebugPlatform.windows:
        return Icons.desktop_windows;
      case DebugPlatform.linux:
        return Icons.computer;
    }
  }
}
