import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/debugger_controller.dart';
import '../core/devices.dart';
import '../core/enums.dart';

/// The main debug panel with all controls
class DebuggerPanel extends StatelessWidget {
  const DebuggerPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DebuggerController>(
      builder: (context, controller, _) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.phone_android, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text(
                          'Responsive Debugger',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: controller.reset,
                          icon: const Icon(Icons.refresh),
                          tooltip: 'Reset all settings',
                        ),
                      ],
                    ),
                  ),
                  
                  const Divider(height: 1),
                  
                  // Controls
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildDeviceSection(controller),
                        const SizedBox(height: 24),
                        _buildOrientationSection(controller),
                        const SizedBox(height: 24),
                        _buildFontScaleSection(controller),
                        const SizedBox(height: 24),
                        _buildOptionsSection(controller),
                        const SizedBox(height: 24),
                        _buildPlatformSection(controller),
                        const SizedBox(height: 24),
                        _buildZoomSection(controller),
                        const SizedBox(height: 24),
                        _buildCustomSizeSection(controller),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDeviceSection(DebuggerController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Device Presets',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<DeviceConfig?>(
          value: controller.selectedDevice,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          hint: const Text('Select a device'),
          items: [
            const DropdownMenuItem<DeviceConfig?>(
              value: null,
              child: Text('No device simulation'),
            ),
            ...Devices.allDevicesList.map((device) {
              return DropdownMenuItem<DeviceConfig>(
                value: device,
                child: Text('${device.name} (${device.size.width.toInt()}×${device.size.height.toInt()})'),
              );
            }),
          ],
          onChanged: controller.setDevice,
        ),
        if (controller.selectedDevice != null) ...[
          const SizedBox(height: 8),
          Text(
            'Platform: ${controller.selectedDevice!.platform.name}',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget _buildOrientationSection(DebuggerController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Orientation',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SegmentedButton<DebugOrientation>(
          segments: const [
            ButtonSegment(
              value: DebugOrientation.portrait,
              label: Text('Portrait'),
              icon: Icon(Icons.stay_current_portrait),
            ),
            ButtonSegment(
              value: DebugOrientation.landscape,
              label: Text('Landscape'),
              icon: Icon(Icons.stay_current_landscape),
            ),
          ],
          selected: {controller.orientation},
          onSelectionChanged: (selection) {
            controller.setOrientation(selection.first);
          },
        ),
      ],
    );
  }

  Widget _buildFontScaleSection(DebuggerController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Font Scale',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              '${(controller.fontScale * 100).toInt()}%',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Slider(
          value: controller.fontScale,
          min: 0.5,
          max: 3.0,
          divisions: 25,
          onChanged: controller.setFontScale,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: FontScalePreset.values.map((preset) {
            final isSelected = (controller.fontScale - preset.scale).abs() < 0.01;
            return FilterChip(
              label: Text(preset.displayName),
              selected: isSelected,
              onSelected: (_) => controller.setFontScalePreset(preset),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOptionsSection(DebuggerController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Options',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('Show Layout Bounds'),
          subtitle: const Text('Display red borders around widgets'),
          value: controller.showLayoutBounds,
          onChanged: controller.setShowLayoutBounds,
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: const Text('Simulate Safe Area'),
          subtitle: const Text('Add device-specific safe areas'),
          value: controller.simulateSafeArea,
          onChanged: controller.setSimulateSafeArea,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildPlatformSection(DebuggerController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Platform Override',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<DebugPlatform?>(
          value: controller.platformOverride,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          hint: const Text('Use default platform'),
          items: [
            const DropdownMenuItem<DebugPlatform?>(
              value: null,
              child: Text('No override'),
            ),
            ...DebugPlatform.values.map((platform) {
              return DropdownMenuItem<DebugPlatform>(
                value: platform,
                child: Text(platform.name),
              );
            }),
          ],
          onChanged: controller.setPlatformOverride,
        ),
      ],
    );
  }

  Widget _buildZoomSection(DebuggerController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Zoom Level',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              '${(controller.zoomLevel * 100).toInt()}%',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Slider(
          value: controller.zoomLevel,
          min: 0.5,
          max: 2.0,
          divisions: 15,
          onChanged: controller.setZoomLevel,
        ),
      ],
    );
  }

  Widget _buildCustomSizeSection(DebuggerController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Custom Size',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Width',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                keyboardType: TextInputType.number,
                initialValue: controller.customSize?.width.toInt().toString() ?? '',
                onChanged: (value) {
                  final width = double.tryParse(value);
                  if (width != null && width > 0) {
                    final height = controller.customSize?.height ?? 800;
                    controller.setCustomSize(Size(width, height));
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Height',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                keyboardType: TextInputType.number,
                initialValue: controller.customSize?.height.toInt().toString() ?? '',
                onChanged: (value) {
                  final height = double.tryParse(value);
                  if (height != null && height > 0) {
                    final width = controller.customSize?.width ?? 400;
                    controller.setCustomSize(Size(width, height));
                  }
                },
              ),
            ),
          ],
        ),
        if (controller.customSize != null) ...[
          const SizedBox(height: 8),
          Text(
            'Custom: ${controller.customSize!.width.toInt()}×${controller.customSize!.height.toInt()}',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ],
    );
  }
}
