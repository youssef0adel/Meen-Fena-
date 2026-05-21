#!/bin/bash

# إنشاء مجلدات الأيقونات
mkdir -p android/app/src/main/res/mipmap-{hdpi,mdpi,xhdpi,xxhdpi,xxxhdpi}

# استخدام Python لإنشاء PNG بسيط (متاح على Codemagic)
python3 << 'EOF'
import struct, zlib

def create_png(width, height, color):
    def chunk(chunk_type, data):
        c = chunk_type + data
        return struct.pack('>I', len(data)) + c + struct.pack('>I', zlib.crc32(c) & 0xffffffff)
    
    header = b'\x89PNG\r\n\x1a\n'
    ihdr = chunk(b'IHDR', struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0))
    
    raw = b''
    for y in range(height):
        raw += b'\x00' + bytes(color) * width
    
    idat = chunk(b'IDAT', zlib.compress(raw))
    iend = chunk(b'IEND', b'')
    
    return header + ihdr + idat + iend

# أحجام الأيقونات
sizes = {
    'mdpi': 48,
    'hdpi': 72,
    'xhdpi': 96,
    'xxhdpi': 144,
    'xxxhdpi': 192
}

# لون أحمر غامق (8B0000)
color = (139, 0, 0)

for density, size in sizes.items():
    path = f'android/app/src/main/res/mipmap-{density}/ic_launcher.png'
    png = create_png(size, size, color)
    with open(path, 'wb') as f:
        f.write(png)
    print(f'Created {path} ({size}x{size})')

print('Icons created successfully!')
EOF