# Changelog

## [1.0.7] - 2025-01-27

### Fixed

- Fixed deprecated `textScaleFactor` usage by replacing with `textScaler.scale(1.0)`
- Updated deprecated `withOpacity()` calls to use `withValues(alpha: ...)` for better precision
- Replaced deprecated color properties (`color.red`, `color.green`, `color.blue`) with new `.r`, `.g`, `.b` properties
- Added `const` constructors for better performance in device dropdown
- Removed unreachable default clause in switch statement
- Fixed all linting issues and deprecated API usage across the codebase
- Improved code quality and performance optimizations

### Technical Improvements

- Updated to use latest Flutter APIs and best practices
- Enhanced type safety with proper null handling
- Improved performance with const constructors where applicable
- Resolved all 12 linting issues for clean codebase

## [1.0.4] - 2025-08-05

### Added

- Added demo GIF to README for better visualization

## [1.0.3] - 2024-08-04

### Fixed

- Fixed default device selection in dropdown to properly handle current screen size
- Resolved duplicate value issue in device dropdown
- Improved cross-platform compatibility
- Added proper null safety for device selection

## [0.1.0] - 2024-08-03

### Added

- Initial release of Flutter Responsive Debugger
- Floating draggable debug button
- Device simulation with preset configurations
- Support for phones, tablets, and desktop devices
- Orientation toggle (portrait/landscape)
- Font scale adjustment (0.5x to 3.0x)
- Layout bounds overlay for visual debugging
- Safe area simulation
- Platform override functionality
- Zoom control (0.5x to 2.0x)
- Custom size input
- Comprehensive test suite
- Example app demonstrating all features
- Responsive design utilities and extensions
- Export/import configuration functionality
- Debug-mode only safety checks

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-08-03

### Added

- Initial release of Flutter Responsive Debugger
- Floating draggable debug button
- Device simulation with preset configurations
- Support for phones, tablets, and desktop devices
- Orientation toggle (portrait/landscape)
- Font scale adjustment (0.5x to 3.0x)
- Layout bounds overlay for visual debugging
- Safe area simulation
- Platform override functionality
- Zoom control (0.5x to 2.0x)
- Custom size input
- Comprehensive test suite
- Example app demonstrating all features
- Responsive design utilities and extensions
- Export/import configuration functionality
- Debug-mode only safety checks

### Device Presets

- iPhone SE (3rd gen), iPhone 13/14, iPhone 13/14 Pro Max
- Pixel 7, Pixel 7 Pro, Samsung Galaxy S23
- iPad (10th gen), iPad Pro 11", iPad Pro 12.9", Pixel Tablet
- MacBook Air 13", MacBook Pro 14", Desktop 1080p/1440p

### Features

- Provider-based state management
- MediaQuery overrides for accurate simulation
- Draggable floating button with edge snapping
- Comprehensive debugger panel with all controls
- Layout bounds visualization
- Screen utilities and responsive extensions
- Breakpoint-based responsive design helpers
- Platform-specific behavior testing
