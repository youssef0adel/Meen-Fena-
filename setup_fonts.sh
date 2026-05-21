mkdir -p assets/fonts

# تحميل ملف الخط العربي من Google Fonts
curl -L -o assets/fonts/Handjet-Variable.ttf \
  "https://fonts.gstatic.com/s/handjet/v22/oY108eXHq7n1OnbQrOY_2FrEwYEMLlcdP1mCtZaLaTutCwcIhGZenU3Fgt0.woff2"

# الأفضل: تحميل الخط كامل من Google Fonts:
# https://fonts.google.com/specimen/Handjet
# اضغط Download family واستخرج الملفات في assets/fonts/