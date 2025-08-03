import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/debugger_controller.dart';
import '../../core/enums.dart';

/// Professional orientation control component with toggle buttons
class OrientationControl extends StatelessWidget {
  const OrientationControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DebuggerController>(
      builder: (context, controller, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.screen_rotation, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  DebuggerSection.orientation.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildOrientationToggle(controller),
          ],
        );
      },
    );
  }

  Widget _buildOrientationToggle(DebuggerController controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: DebugOrientation.values.map((orientation) {
          final isSelected = controller.orientation == orientation;
          final isFirst = orientation == DebugOrientation.values.first;
          final isLast = orientation == DebugOrientation.values.last;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => controller.setOrientation(orientation),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green : Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: isFirst ? const Radius.circular(7) : Radius.zero,
                    bottomLeft: isFirst ? const Radius.circular(7) : Radius.zero,
                    topRight: isLast ? const Radius.circular(7) : Radius.zero,
                    bottomRight: isLast ? const Radius.circular(7) : Radius.zero,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getOrientationIcon(orientation),
                      size: 18,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      orientation.displayName,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getOrientationIcon(DebugOrientation orientation) {
    switch (orientation) {
      case DebugOrientation.portrait:
        return Icons.stay_current_portrait;
      case DebugOrientation.landscape:
        return Icons.stay_current_landscape;
    }
  }
}
