import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_debugger/flutter_responsive_debugger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveDebugger(
      enabled: kDebugMode, // Only enabled in debug mode for safety
      child: MaterialApp(
        title: 'Responsive Debugger Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const ExampleHomePage(),
      ),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Debugger Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Flutter Responsive Debugger!',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This example demonstrates how the debugger helps you test responsive layouts across different screen sizes.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Screen info section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Screen Info',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Screen Size',
                        '${MediaQuery.of(context).size.width.toInt()} × ${MediaQuery.of(context).size.height.toInt()}'),
                    _buildInfoRow(
                        'Device Pixel Ratio',
                        MediaQuery.of(context)
                            .devicePixelRatio
                            .toStringAsFixed(2)),
                    _buildInfoRow(
                        'Text Scale Factor',
                        MediaQuery.of(context)
                            .textScaleFactor
                            .toStringAsFixed(2)),
                    _buildInfoRow('Platform', Theme.of(context).platform.name),
                    _buildInfoRow(
                        'Orientation', MediaQuery.of(context).orientation.name),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Responsive layout examples
            Text(
              'Responsive Layout Examples',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Grid that adapts to screen size
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getIconForIndex(index),
                              size: 32,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Item ${index + 1}',
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 24),

            // Instructions
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'How to Use',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                        '1. Look for the floating blue button (📱) on the screen'),
                    const SizedBox(height: 4),
                    const Text(
                        '2. Tap it to open the responsive debugger panel'),
                    const SizedBox(height: 4),
                    const Text('3. Try different device presets and settings'),
                    const SizedBox(height: 4),
                    const Text('4. Watch how the layout adapts in real-time'),
                    const SizedBox(height: 4),
                    const Text(
                        '5. Enable "Show Layout Bounds" to visualize widget boundaries'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Feature showcase
            Text(
              'Features to Try',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFeatureChip('📱 Device Presets', Colors.blue),
                _buildFeatureChip('🔄 Orientation Toggle', Colors.green),
                _buildFeatureChip('🔤 Font Scale', Colors.orange),
                _buildFeatureChip('📐 Layout Bounds', Colors.red),
                _buildFeatureChip('🛡️ Safe Area', Colors.purple),
                _buildFeatureChip('🖥️ Platform Override', Colors.teal),
                _buildFeatureChip('🔍 Zoom Control', Colors.indigo),
                _buildFeatureChip('📏 Custom Size', Colors.pink),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Use the responsive debugger button to test layouts!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: const Icon(Icons.help_outline),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontFamily: 'monospace')),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String label, Color color) {
    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }

  IconData _getIconForIndex(int index) {
    const icons = [
      Icons.home,
      Icons.favorite,
      Icons.star,
      Icons.settings,
      Icons.person,
      Icons.notifications,
    ];
    return icons[index % icons.length];
  }
}
