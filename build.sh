#!/bin/bash
set -e

# Install Flutter
FLUTTER_VERSION="3.35.7"
FLUTTER_DIR="$HOME/flutter"

if [ ! -d "$FLUTTER_DIR" ]; then
  echo "Installing Flutter $FLUTTER_VERSION..."
  git clone --branch "$FLUTTER_VERSION" --depth 1 https://github.com/flutter/flutter.git "$FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"
flutter --version

# Enable web support
flutter config --enable-web

# Get dependencies
flutter pub get

# Build for web (release mode) with WasmGC
flutter build web --wasm --release

echo "Build complete. Output in build/web"