#!/bin/bash

# สคริปต์นี้จะตรวจสอบการติดตั้ง Java และ Maven บนระบบ Ubuntu
# หากการติดตั้งถูกต้อง จะแสดงข้อความว่า "Java & maven ready for build TB"
# หากไม่ถูกต้อง จะแสดงข้อความแจ้งข้อผิดพลาด

echo "🔍 กำลังตรวจสอบการติดตั้ง Java และ Maven..."

# กำหนดเวอร์ชันขั้นต่ำที่ต้องการ
REQUIRED_JAVA_VERSION=11
REQUIRED_MAVEN_VERSION=3.6.3

# ฟังก์ชันเปรียบเทียบเวอร์ชัน
version_ge() {
    # เปรียบเทียบเวอร์ชันแรกกับเวอร์ชันที่สอง
    # คืนค่า 0 หากเวอร์ชันแรก >= เวอร์ชันที่สอง
    # คืนค่า 1 หากเวอร์ชันแรก < เวอร์ชันที่สอง
    [ "$(printf '%s\n' "$2" "$1" | sort -V | head -n1)" = "$2" ]
}

# ตรวจสอบ Java
if command -v java >/dev/null 2>&1; then
    JAVA_VERSION_FULL=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
    # แยกเวอร์ชันหลัก
    JAVA_VERSION_MAJOR=$(echo "$JAVA_VERSION_FULL" | awk -F. '{print $1}')
    
    # หากเวอร์ชันแรกเป็น "1", หมายถึง Java 8 หรือก่อนหน้า
    if [ "$JAVA_VERSION_MAJOR" = "1" ]; then
        JAVA_VERSION_MAJOR=$(echo "$JAVA_VERSION_FULL" | awk -F. '{print $2}')
    fi

    echo "✅ พบ Java เวอร์ชัน $JAVA_VERSION_FULL"

    if version_ge "$JAVA_VERSION_MAJOR" "$REQUIRED_JAVA_VERSION"; then
        JAVA_OK=true
    else
        echo "❌ Java เวอร์ชันต้องเป็น $REQUIRED_JAVA_VERSION ขึ้นไป"
        JAVA_OK=false
    fi
else
    echo "❌ ไม่พบ Java ติดตั้งอยู่บนระบบ"
    JAVA_OK=false
fi

# ตรวจสอบ Maven
if command -v mvn >/dev/null 2>&1; then
    MAVEN_VERSION_FULL=$(mvn -version | awk '/Apache Maven/ {print $3}')
    echo "✅ พบ Maven เวอร์ชัน $MAVEN_VERSION_FULL"

    if version_ge "$MAVEN_VERSION_FULL" "$REQUIRED_MAVEN_VERSION"; then
        MAVEN_OK=true
    else
        echo "❌ Maven เวอร์ชันต้องเป็น $REQUIRED_MAVEN_VERSION ขึ้นไป"
        MAVEN_OK=false
    fi
else
    echo "❌ ไม่พบ Maven ติดตั้งอยู่บนระบบ"
    MAVEN_OK=false
fi

# ตรวจสอบผลลัพธ์ทั้งหมด
if [ "$JAVA_OK" = true ] && [ "$MAVEN_OK" = true ]; then
    echo "🎉 Java & maven ready for build TB"
    exit 0
else
    echo "⚠️ การติดตั้ง Java หรือ Maven ไม่ถูกต้อง กรุณาตรวจสอบและติดตั้งใหม่"
    exit 1
fi
