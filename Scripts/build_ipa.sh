#!/bin/bash
# King iOS IPA Build Script
# Requires: macOS + Xcode 15+ or XcodeGen
# Usage: ./Scripts/build_ipa.sh [release|debug]

set -e

SCHEME="KingiOS"
CONFIGURATION="${1:-release}"
BUILD_DIR="./build"
ARCHIVE_PATH="$BUILD_DIR/KingiOS.xcarchive"
IPA_OUTPUT="$BUILD_DIR/KingiOS.ipa"

echo "🏗 Building King iOS IPA ($CONFIGURATION)..."

# Clean
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Generate Xcode project using XcodeGen (if available)
if command -v xcodegen &> /dev/null; then
    echo "📐 Generating Xcode project with XcodeGen..."
    xcodegen generate
fi

# Build and archive
echo "🔨 Building $SCHEME ($CONFIGURATION)..."
xcodebuild -project "KingiOS.xcodeproj" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -archivePath "$ARCHIVE_PATH" \
    -sdk iphoneos \
    ARCHS="arm64" \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO \
    clean archive

# Export IPA
echo "📦 Exporting IPA..."
xcodebuild -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportPath "$BUILD_DIR" \
    -exportOptionsPlist <(cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>development</string>
    <key>signingStyle</key>
    <string>manual</string>
    <key>signingCertificate</key>
    <string>-</string>
    <key>stripSwiftSymbols</key>
    <true/>
</dict>
</plist>
EOF
    )

# Verify IPA
if [ -f "$BUILD_DIR/$SCHEME.ipa" ]; then
    mv "$BUILD_DIR/$SCHEME.ipa" "$IPA_OUTPUT"
    echo "✅ IPA built successfully: $IPA_OUTPUT"
    echo "📏 Size: $(du -h "$IPA_OUTPUT" | cut -f1)"
else
    echo "❌ IPA build failed"
    exit 1
fi