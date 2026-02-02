#!/bin/bash

# --- Automatic GitHub Release Script ---

set -e # Exit immediately if a command exits with a non-zero status.

echo "🚀 Starting Automatic Release Process..."

# 1. READ AND INCREMENT VERSION
# ==============================
if [ ! -f VERSION ]; then
    echo "Error: VERSION file not found!"
    exit 1
fi

CURRENT_VERSION=$(cat VERSION)
echo "Current version: $CURRENT_VERSION"

# Increment the last part of the version number
# V1.1.01 -> V1.1.02
BASE_VERSION=$(echo $CURRENT_VERSION | cut -d. -f1-2)
PATCH_VERSION=$(echo $CURRENT_VERSION | cut -d. -f3)
# Remove leading zeros to avoid octal interpretation, then increment
NEW_PATCH_VERSION=$((10#$PATCH_VERSION + 1))
# Format back to two digits
FORMATTED_PATCH=$(printf "%02d" $NEW_PATCH_VERSION)

NEW_VERSION="$BASE_VERSION.$FORMATTED_PATCH"
echo "New version will be: $NEW_VERSION"

# 2. RUN THE BUILD SCRIPT
# ========================
# This script cleans, builds the APK.
chmod +x ./scripts/deploy_apks.sh
./scripts/deploy_apks.sh

# 3. COMPRESS THE APK
# ========================
echo "📦 Compressing the APK for faster downloads..."
APK_PATH="deploy/production/app-prod-release.apk"
ZIP_PATH="deploy/production/Guardian_App_${NEW_VERSION}.zip"

if [ ! -f "$APK_PATH" ]; then
    echo "Error: APK not found at $APK_PATH"
    exit 1
fi

# Create the zip archive. The -j flag junks the path, so it doesn't store the folder structure.
zip -j "$ZIP_PATH" "$APK_PATH"

if [ $? -eq 0 ]; then
    echo "✅ APK successfully compressed to $ZIP_PATH"
else
    echo "❌ Failed to compress the APK."
    exit 1
fi

# 4. CREATE GITHUB RELEASE
# ========================
echo "📦 Creating GitHub Release for version $NEW_VERSION..."

# The artifact to be uploaded is now the ZIP file
ARTIFACT_PATH="$ZIP_PATH"

if [ ! -f "$ARTIFACT_PATH" ]; then
    echo "Error: Compressed artifact not found at $ARTIFACT_PATH"
    exit 1
fi

# Create the release and upload the compressed artifact
gh release create "$NEW_VERSION" --title "$NEW_VERSION" --notes "Automatic compressed release for version $NEW_VERSION." "$ARTIFACT_PATH"

if [ $? -eq 0 ]; then
    echo "✅ Successfully created GitHub release $NEW_VERSION and uploaded the compressed APK."
else
    echo "❌ Failed to create GitHub release."
    exit 1
fi

# 5. UPDATE LOCAL VERSION FILE FOR NEXT RUN
# =========================================
echo $NEW_VERSION > VERSION
echo "Updated VERSION file to $NEW_VERSION for the next release."


# 6. FINAL PUSH TO ORIGIN
# =======================
echo "Committing and pushing the updated VERSION file..."
git add VERSION
git commit -m "chore: Bump version to $NEW_VERSION"
git push origin main

if [ $? -eq 0 ]; then
    echo "✅ Successfully pushed version update to GitHub."
else
    echo "⚠️  Could not push the final version update. You might need to push it manually."
fi

echo "🎉 Automatic Release Process Finished Successfully!"
