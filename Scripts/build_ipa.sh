#!/bin/bash

set -e

# ==========================================
# KingiOS IPA Builder
# ==========================================

CONFIGURATION="${1:-release}"

if [ "$CONFIGURATION" = "release" ]; then
    XCODE_CONFIGURATION="Release"
else
    XCODE_CONFIGURATION="Debug"
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cd "$ROOT"

PROJECT="$ROOT/KingiOS.xcodeproj"
SCHEME="KingiOS"

BUILD_DIR="$ROOT/build"
DERIVED_DATA="$BUILD_DIR/DerivedData"
IPA="$BUILD_DIR/KingiOS.ipa"

echo "=========================================="
echo "           KingiOS IPA Builder"
echo "=========================================="
echo ""
echo "Configuration: $XCODE_CONFIGURATION"
echo "Project:       $PROJECT"
echo "Scheme:        $SCHEME"
echo ""

# ==========================================
# Check project
# ==========================================

if [ ! -d "$PROJECT" ]; then
    echo "ERROR: KingiOS.xcodeproj was not found."
    echo ""
    echo "Generating project with XcodeGen..."
    
    if command -v xcodegen >/dev/null 2>&1; then
        xcodegen generate
    else
        echo "ERROR: XcodeGen is not installed."
        exit 1
    fi
fi

if [ ! -d "$PROJECT" ]; then
    echo "ERROR: Could not find or generate KingiOS.xcodeproj."
    exit 1
fi

# ==========================================
# Clean old build
# ==========================================

echo ""
echo "=========================================="
echo "Cleaning previous build"
echo "=========================================="

rm -rf "$BUILD_DIR"

mkdir -p "$BUILD_DIR"

# ==========================================
# Show available schemes
# ==========================================

echo ""
echo "=========================================="
echo "Checking Xcode project"
echo "=========================================="

xcodebuild \
    -project "$PROJECT" \
    -list

# ==========================================
# Build application
# ==========================================

echo ""
echo "=========================================="
echo "Building KingiOS.app"
echo "=========================================="

xcodebuild \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -configuration "$XCODE_CONFIGURATION" \
    -sdk iphoneos \
    -destination "generic/platform=iOS" \
    -derivedDataPath "$DERIVED_DATA" \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO \
    build

# ==========================================
# Locate application
# ==========================================

echo ""
echo "=========================================="
echo "Locating KingiOS.app"
echo "=========================================="

APP_SOURCE="$DERIVED_DATA/Build/Products/${XCODE_CONFIGURATION}-iphoneos/KingiOS.app"

if [ ! -d "$APP_SOURCE" ]; then

    echo "ERROR: KingiOS.app was not found."

    echo ""
    echo "Searching for .app files..."

    find "$BUILD_DIR" \
        -name "*.app" \
        -type d \
        -print

    exit 1
fi

echo ""
echo "Found application:"
echo "$APP_SOURCE"

# ==========================================
# Prepare Payload
# ==========================================

echo ""
echo "=========================================="
echo "Preparing IPA Payload"
echo "=========================================="

PAYLOAD="$BUILD_DIR/Payload"

rm -rf "$PAYLOAD"

mkdir -p "$PAYLOAD"

cp -R "$APP_SOURCE" "$PAYLOAD/KingiOS.app"

# ==========================================
# Verify application
# ==========================================

if [ ! -d "$PAYLOAD/KingiOS.app" ]; then
    echo "ERROR: Failed to copy KingiOS.app."
    exit 1
fi

echo ""
echo "Application prepared:"
ls -lah "$PAYLOAD/KingiOS.app"

# ==========================================
# Create IPA
# ==========================================

echo ""
echo "=========================================="
echo "Creating IPA"
echo "=========================================="

cd "$BUILD_DIR"

rm -f "$IPA"

zip -qry "$IPA" Payload

# ==========================================
# Verify IPA
# ==========================================

if [ ! -f "$IPA" ]; then
    echo ""
    echo "ERROR: IPA creation failed."
    exit 1
fi

echo ""
echo "=========================================="
echo "IPA CREATED SUCCESSFULLY"
echo "=========================================="

echo ""
echo "File:"
echo "$IPA"

echo ""
echo "Size:"
ls -lh "$IPA"

echo ""
echo "Contents:"
unzip -l "$IPA"

echo ""
echo "=========================================="
echo "              COMPLETE"
echo "=========================================="
