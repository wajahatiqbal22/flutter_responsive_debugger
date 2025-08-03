import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/debugger_controller.dart';
import '../../core/enums.dart';

/// Professional font scale control with preset chips and custom slider
class FontScaleControl extends StatelessWidget {
  const FontScaleControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DebuggerController>(
      builder: (context, controller, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.text_fields, size: 16, color: Colors.purple),
                    const SizedBox(width: 8),
                    Text(
                      DebuggerSection.fontScale.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purple.shade200),
                  ),
                  child: Text(
                    '${(controller.fontScale * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPresetChips(controller),
            const SizedBox(height: 12),
            _buildCustomSlider(controller),
          ],
        );
      },
    );
  }

  Widget _buildPresetChips(DebuggerController controller) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: FontScalePreset.values.map((preset) {
        final isSelected = (controller.fontScale - preset.scale).abs() < 0.01;
        return GestureDetector(
          onTap: () => controller.setFontScalePreset(preset),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? Colors.purple : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? Colors.purple : Colors.grey.shade300,
              ),
            ),
            child: Text(
              preset.displayName,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCustomSlider(DebuggerController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Custom Scale',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              Row(
                children: [
                  _buildScaleButton(
                    icon: Icons.remove,
                    onTap: () => controller.setFontScale(
                      (controller.fontScale - 0.1).clamp(0.5, 3.0),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildScaleButton(
                    icon: Icons.add,
                    onTap: () => controller.setFontScale(
                      (controller.fontScale + 0.1).clamp(0.5, 3.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Builder(
            builder: (context) => SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.purple,
                inactiveTrackColor: Colors.purple.shade100,
                thumbColor: Colors.purple,
                overlayColor: const Color.fromRGBO(156, 39, 176, 0.2),
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: controller.fontScale,
              min: 0.5,
              max: 3.0,
              divisions: 25,
                  onChanged: controller.setFontScale,
                ),
              ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '50%',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                '300%',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScaleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(
          icon,
          size: 14,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}
