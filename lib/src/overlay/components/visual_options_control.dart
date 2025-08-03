import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/debugger_controller.dart';
import '../../core/enums.dart';

/// Professional visual debugging options control
class VisualOptionsControl extends StatelessWidget {
  const VisualOptionsControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DebuggerController>(
      builder: (context, controller, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.visibility, size: 16, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  DebuggerSection.visualOptions.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildVisualOptions(controller),
          ],
        );
      },
    );
  }

  Widget _buildVisualOptions(DebuggerController controller) {
    return Column(
      children: [
        _buildOptionTile(
          option: VisualDebugOption.layoutBounds,
          isEnabled: controller.showLayoutBounds,
          onToggle: controller.toggleLayoutBounds,
          color: Colors.red,
        ),
        const SizedBox(height: 8),
        _buildOptionTile(
          option: VisualDebugOption.safeArea,
          isEnabled: controller.simulateSafeArea,
          onToggle: controller.toggleSafeArea,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildOptionTile({
    required VisualDebugOption option,
    required bool isEnabled,
    required VoidCallback onToggle,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isEnabled ? Color.fromRGBO(color.red, color.green, color.blue, 0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isEnabled ? color : Colors.grey.shade300,
            width: isEnabled ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isEnabled ? color : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                option.icon,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isEnabled ? Colors.grey.shade800 : Colors.grey.shade700,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    _getOptionDescription(option),
                    style: TextStyle(
                      fontSize: 11,
                      color: isEnabled ? Colors.grey.shade600 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isEnabled,
              onChanged: (_) => onToggle(),
              activeColor: color,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }

  String _getOptionDescription(VisualDebugOption option) {
    switch (option) {
      case VisualDebugOption.layoutBounds:
        return 'Show red borders around widgets';
      case VisualDebugOption.safeArea:
        return 'Simulate device notches and safe areas';
      case VisualDebugOption.zoom:
        return 'Adjust zoom level for better visibility';
    }
  }
}
