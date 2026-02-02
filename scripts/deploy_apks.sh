#!/bin/bash

# تعريف الألوان
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== بدء عملية النشر المحسنة (IDX Optimized) ===${NC}"

# 1. تنظيف البيئة (ضروري جداً لتوفير المساحة)
echo -e "${GREEN}1. Cleaning workspace to free space...${NC}"
flutter clean
rm -rf deploy
mkdir -p deploy

# 2. جلب المكتبات
echo -e "${GREEN}2. Fetching dependencies...${NC}"
flutter pub get

# 3. بناء نسخة الإنتاج
echo -e "${GREEN}3. Building Production APK...${NC}"
# استخدام flavor prod وملف main_prod.dart
flutter build apk --flavor prod -t lib/main_prod.dart --release

# التحقق من نجاح البناء
if [ ! -f "build/app/outputs/flutter-apk/app-prod-release.apk" ]; then
    echo "Error: Build failed! APK not found."
    exit 1
fi

# 4. نقل الملف إلى مجلد النشر
echo -e "${GREEN}4. Preparing deployment...${NC}"
mkdir -p deploy/production
cp build/app/outputs/flutter-apk/app-prod-release.apk deploy/production/app-prod-release.apk

echo -e "${GREEN}=== Build Successful! APK ready at deploy/production/app-prod-release.apk ===${NC}"