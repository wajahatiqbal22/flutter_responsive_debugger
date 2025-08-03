import 'package:flutter/material.dart';
import 'package:flutter_responsive_debugger/src/core/debugger_controller.dart';
import 'package:flutter_responsive_debugger/src/overlay/floating_button.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_responsive_debugger/flutter_responsive_debugger.dart';

void main() {
  group('ResponsiveDebugger', () {
    testWidgets('shows child when disabled', (WidgetTester tester) async {
      const testChild = Text('Test App');

      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveDebugger(
            enabled: false,
            child: testChild,
          ),
        ),
      );

      expect(find.text('Test App'), findsOneWidget);
      expect(find.byType(FloatingDebugButton), findsNothing);
    });

    testWidgets('shows debug overlay when enabled',
        (WidgetTester tester) async {
      const testChild = Text('Test App');

      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveDebugger(
            enabled: true,
            child: testChild,
          ),
        ),
      );

      expect(find.text('Test App'), findsOneWidget);
      expect(find.byType(FloatingDebugButton), findsOneWidget);
    });
  });

  group('DebuggerController', () {
    late DebuggerController controller;

    setUp(() {
      controller = DebuggerController();
    });

    test('initial state is correct', () {
      expect(controller.isVisible, false);
      expect(controller.isPanelOpen, false);
      expect(controller.selectedDevice, null);
      expect(controller.orientation, DebugOrientation.portrait);
      expect(controller.fontScale, 1.0);
      expect(controller.showLayoutBounds, false);
      expect(controller.simulateSafeArea, true);
      expect(controller.platformOverride, null);
      expect(controller.zoomLevel, 1.0);
    });

    test('toggleVisibility works correctly', () {
      expect(controller.isVisible, false);

      controller.toggleVisibility();
      expect(controller.isVisible, true);

      controller.toggleVisibility();
      expect(controller.isVisible, false);
    });

    test('setDevice works correctly', () {
      final device = Devices.phones.first;

      controller.setDevice(device);
      expect(controller.selectedDevice, device);
      expect(controller.customSize, null);
    });

    test('setCustomSize works correctly', () {
      const customSize = Size(400, 600);

      controller.setCustomSize(customSize);
      expect(controller.customSize, customSize);
      expect(controller.selectedDevice, null);
    });

    test('setOrientation works correctly', () {
      controller.setOrientation(DebugOrientation.landscape);
      expect(controller.orientation, DebugOrientation.landscape);
    });

    test('toggleOrientation works correctly', () {
      expect(controller.orientation, DebugOrientation.portrait);

      controller.toggleOrientation();
      expect(controller.orientation, DebugOrientation.landscape);

      controller.toggleOrientation();
      expect(controller.orientation, DebugOrientation.portrait);
    });

    test('setFontScale clamps values correctly', () {
      controller.setFontScale(0.1); // Below minimum
      expect(controller.fontScale, 0.5);

      controller.setFontScale(5.0); // Above maximum
      expect(controller.fontScale, 3.0);

      controller.setFontScale(1.5); // Valid value
      expect(controller.fontScale, 1.5);
    });

    test('effectiveSize works correctly with device', () {
      final device = Devices.phones.first;
      controller.setDevice(device);

      expect(controller.effectiveSize, device.size);

      controller.setOrientation(DebugOrientation.landscape);
      expect(controller.effectiveSize,
          Size(device.size.height, device.size.width));
    });

    test('effectiveSize works correctly with custom size', () {
      const customSize = Size(400, 600);
      controller.setCustomSize(customSize);

      expect(controller.effectiveSize, customSize);
    });

    test('reset works correctly', () {
      // Set some non-default values
      controller.setDevice(Devices.phones.first);
      controller.setOrientation(DebugOrientation.landscape);
      controller.setFontScale(1.5);
      controller.setShowLayoutBounds(true);
      controller.setSimulateSafeArea(false);
      controller.setPlatformOverride(DebugPlatform.iOS);
      controller.setZoomLevel(1.5);

      // Reset
      controller.reset();

      // Check all values are back to defaults
      expect(controller.selectedDevice, null);
      expect(controller.orientation, DebugOrientation.portrait);
      expect(controller.fontScale, 1.0);
      expect(controller.showLayoutBounds, false);
      expect(controller.simulateSafeArea, true);
      expect(controller.platformOverride, null);
      expect(controller.zoomLevel, 1.0);
      expect(controller.customSize, null);
    });

    test('toJson and fromJson work correctly', () {
      // Set some values
      final device = Devices.phones.first;
      controller.setDevice(device);
      controller.setOrientation(DebugOrientation.landscape);
      controller.setFontScale(1.5);
      controller.setShowLayoutBounds(true);
      controller.setPlatformOverride(DebugPlatform.iOS);

      // Export to JSON
      final json = controller.toJson();

      // Create new controller and import
      final newController = DebuggerController();
      newController.fromJson(json);

      // Check values match
      expect(newController.selectedDevice?.name, device.name);
      expect(newController.orientation, DebugOrientation.landscape);
      expect(newController.fontScale, 1.5);
      expect(newController.showLayoutBounds, true);
      expect(newController.platformOverride, DebugPlatform.iOS);
    });
  });

  group('Devices', () {
    test('findByName works correctly', () {
      final device = Devices.findByName('iPhone 13/14');
      expect(device, isNotNull);
      expect(device!.name, 'iPhone 13/14');

      final nonExistent = Devices.findByName('NonExistent Device');
      expect(nonExistent, null);
    });

    test('allDevicesList contains all devices', () {
      final allDevices = Devices.allDevicesList;
      expect(allDevices.length, greaterThan(0));
      expect(allDevices, contains(isA<DeviceConfig>()));
    });

    test('device categories are correct', () {
      for (final device in Devices.phones) {
        expect(device.category, DeviceCategory.phone);
      }

      for (final device in Devices.tablets) {
        expect(device.category, DeviceCategory.tablet);
      }

      for (final device in Devices.desktops) {
        expect(device.category, DeviceCategory.desktop);
      }
    });
  });

  group('DeviceConfig', () {
    test('copyWith works correctly', () {
      const original = DeviceConfig(
        name: 'Test Device',
        size: Size(400, 600),
        category: DeviceCategory.phone,
        platform: DebugPlatform.android,
      );

      final modified = original.copyWith(
        name: 'Modified Device',
        size: const Size(500, 700),
      );

      expect(modified.name, 'Modified Device');
      expect(modified.size, const Size(500, 700));
      expect(modified.category, DeviceCategory.phone); // Unchanged
      expect(modified.platform, DebugPlatform.android); // Unchanged
    });

    test('landscape property works correctly', () {
      const device = DeviceConfig(
        name: 'Test Device',
        size: Size(400, 600),
        category: DeviceCategory.phone,
        platform: DebugPlatform.android,
      );

      final landscape = device.landscape;
      expect(landscape.size, const Size(600, 400));
      expect(landscape.name, 'Test Device'); // Other properties unchanged
    });
  });
}
