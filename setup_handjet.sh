#!/bin/bash

echo "🎭 تحميل خط Handjet للعبة مين فينا؟"
echo "======================================"

mkdir -p assets/fonts

echo "📥 تحميل Handjet..."
# التحميل من Google Fonts API
curl -L -o assets/fonts/Handjet-Variable.ttf \
  "https://github.com/google/fonts/raw/main/ofl/handjet/Handjet%5Bwght%5D.ttf" \
  2>/dev/null && echo "✅ تم تحميل الخط بنجاح!" || {
    echo "❌ فشل التحميل التلقائي"
    echo ""
    echo "حمل الخط يدوياً من:"
    echo "https://fonts.google.com/specimen/Handjet"
    echo ""
    echo "استخرج الملفات وضعها في: assets/fonts/"
    echo "وأعد تسمية الملف إلى: Handjet-Variable.ttf"
  }

echo ""
echo "======================================"
echo "🎉 جاهز للتشغيل!"
echo "  flutter clean && flutter pub get && flutter run"