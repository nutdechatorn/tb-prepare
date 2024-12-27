#!/bin/bash

# สคริปต์นี้จะติดตั้ง OpenJDK 17 และ Apache Maven 3.8.8 บน Ubuntu
# ตรวจสอบให้แน่ใจว่าคุณรันสคริปต์นี้ด้วยสิทธิ์ของผู้ใช้ที่มีสิทธิ์ sudo

echo "🔄 เริ่มกระบวนการติดตั้ง Java และ Maven สำหรับ ThingsBoard CE"

# 1. อัพเดตแพ็กเกจลิสต์และติดตั้งแพ็กเกจพื้นฐาน
echo "📦 อัพเดตแพ็กเกจลิสต์และติดตั้งแพ็กเกจพื้นฐาน..."
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y wget curl unzip git

# 2. ติดตั้ง OpenJDK 17
echo "☕ ติดตั้ง OpenJDK 17..."
sudo apt install -y openjdk-17-jdk

# ตรวจสอบการติดตั้ง Java
JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
echo "✅ ตรวจสอบ Java เวอร์ชัน: $JAVA_VERSION"

# 3. ติดตั้ง Git (หากยังไม่ได้ติดตั้ง)
echo "🐙 ติดตั้ง Git..."
sudo apt install -y git

# ตรวจสอบการติดตั้ง Git
GIT_VERSION=$(git --version)
echo "✅ ตรวจสอบ Git เวอร์ชัน: $GIT_VERSION"

# 4. ติดตั้ง Apache Maven 3.8.8
echo "📦 ติดตั้ง Apache Maven 3.8.8..."

# กำหนดเวอร์ชันของ Maven ที่ต้องการ
MAVEN_VERSION=3.8.8
MAVEN_DIR=/opt/apache-maven-$MAVEN_VERSION
MAVEN_TAR=apache-maven-$MAVEN_VERSION-bin.tar.gz
MAVEN_DOWNLOAD_URL=https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/$MAVEN_TAR

# ดาวน์โหลด Maven
cd /tmp
wget $MAVEN_DOWNLOAD_URL

# แตกไฟล์
sudo tar -xzvf $MAVEN_TAR -C /opt

# สร้าง symbolic link สำหรับ Maven
sudo ln -sfn /opt/apache-maven-$MAVEN_VERSION /opt/maven

# ลบไฟล์ tar.gz หลังจากติดตั้งเสร็จ
rm -f $MAVEN_TAR

# 5. ตั้งค่าตัวแปรสิ่งแวดล้อม
echo "🛠️ ตั้งค่าตัวแปรสิ่งแวดล้อม JAVA_HOME และ MAVEN_HOME..."

# สร้างไฟล์โปรไฟล์สำหรับ Java
sudo bash -c 'cat <<EOL > /etc/profile.d/jdk.sh
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-arm64
export PATH=\$JAVA_HOME/bin:\$PATH
EOL'

# สร้างไฟล์โปรไฟล์สำหรับ Maven
sudo bash -c 'cat <<EOL > /etc/profile.d/maven.sh
export MAVEN_HOME=/opt/maven
export PATH=\$MAVEN_HOME/bin:\$PATH
EOL'

# ทำให้สคริปต์เหล่านี้สามารถรันได้
sudo chmod +x /etc/profile.d/jdk.sh
sudo chmod +x /etc/profile.d/maven.sh

# โหลดโปรไฟล์ใหม่

cd\

source /etc/profile.d/jdk.sh
source /etc/profile.d/maven.sh

# 6. ตรวจสอบการติดตั้ง Maven
MAVEN_VERSION_INSTALLED=$(mvn -version | awk '/Apache Maven/ {print $3}')
echo "✅ ตรวจสอบ Maven เวอร์ชัน: $MAVEN_VERSION_INSTALLED"

# ตรวจสอบว่า JAVA_HOME และ MAVEN_HOME ถูกตั้งค่าอย่างถูกต้อง
echo "📂 ตรวจสอบตัวแปรสิ่งแวดล้อม..."
echo "JAVA_HOME: $JAVA_HOME"
echo "MAVEN_HOME: $MAVEN_HOME"

echo "🎉 การติดตั้ง Java และ Maven เสร็จสมบูรณ์แล้ว! คุณพร้อมที่จะ Build โปรแกรม ThingsBoard CE ได้แล้ว."

# แนะนำให้รีสตาร์ทเทอร์มินัลหรือระบบ
echo "🔔 แนะนำ: รีสตาร์ทเทอร์มินัลหรือระบบเพื่อให้การตั้งค่ามีผลสมบูรณ์."
