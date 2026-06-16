# King iOS

Transform your iPhone with the power of Android.

King iOS is a custom Android-like experience that runs on your iPhone. It provides a familiar Android interface with features like Dynamic Island, custom gestures, Liquid Glass effects, and King PC mode for connecting to external displays.

## Features

- **Dynamic Swipe** - Android-style gesture navigation (swipe up for home, hold for app switcher)
- **Dynamic Island** - Interactive pill-shaped overlay for notifications and controls
- **Liquid Glass** - Customizable transparency and frosting effects
- **Custom Boot Screen** - Animated "King iOS" boot sequence with loading bar
- **King PC** - Use your iPhone as a secondary screen or connect to other devices
- **APK Support** - Install Android applications
- **Settings Integration** - Full settings panel with Liquid Glass and Features management
- **Custom Wallpapers** - Dynamic backgrounds with upload support

## Requirements

- iOS 16.0+
- iPhone XS or newer (for full feature support)
- Apple Developer account (for sideloading)
- Mac with Xcode 15+ (for building from source)

## Quick Start

### Option 1: Download IPA (Recommended)

1. Go to the [Releases](https://github.com/KingiOS/KingiOS-IPA/releases) page
2. Download the latest `KingiOS.ipa`
3. Sideload using AltStore, SideLoadly, or similar tool
4. Trust the developer certificate in Settings > General > VPN & Device Management
5. Open King iOS from your home screen

### Option 2: Build from Source

```bash
# Install XcodeGen (if not already installed)
brew install xcodegen

# Clone the repository
git clone https://github.com/KingiOS/KingiOS-IPA.git
cd KingiOS-IPA

# Generate Xcode project
xcodegen generate

# Build IPA
chmod +x Scripts/build_ipa.sh
./Scripts/build_ipa.sh release

# The IPA will be at: build/KingiOS.ipa
```

## Building from Windows

Use the King iOS Windows Desktop App:
1. Launch the King iOS application
2. Select "Emily on iPhone"
3. Download the IPA from the GitHub page
4. Sideload to your device using AltStore or SideLoadly

## License

This project is licensed under the MIT License.