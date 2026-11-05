# 🐾 RunCat สำหรับ iPhone 15 (Dynamic Island & Live Activity)

โปรเจกต์ iOS Native App และ Widget Extension สำหรับแสดงน้องแมววิ่งดุ๊กดิ๊กบน **Dynamic Island** และ **Lock Screen** ของ iPhone 15 พัฒนาด้วย **Swift, SwiftUI และ ActivityKit** รองรับการบิลด์จากคอมพิวเตอร์ **Windows** 100% โดยใช้ **GitHub Actions** และ **Sideloadly**

---

## 📂 โครงสร้างโปรเจกต์

```text
runcat-ip15/
├── .github/workflows/
│   └── build.yml               # สคริปต์ GitHub Actions สำหรับคอมไพล์เป็น .ipa ฟรี
├── CatRun/
│   ├── CatRunApp.swift         # จุดเริ่มต้นของ iOS App
│   ├── ContentView.swift       # หน้าจอควบคุม ปรับสปีด และปุ่มสั่งปล่อยแมว
│   ├── Info.plist              # ค่าคอนฟิก Permission (รองรับ Live Activities)
│   └── Assets.xcassets/        # ไอคอนแอป และสไปรต์ภาพแมววิ่ง 5 เฟรม
├── CatWidget/
│   ├── CatWidgetBundle.swift   # Bundle ของ Widget Extension
│   ├── CatWidgetLiveActivity.swift # หน้าตาบน Dynamic Island (Leading, Trailing, Expanded)
│   ├── Info.plist              # คอนฟิก WidgetKit Extension
│   └── Assets.xcassets/        # สไปรต์ภาพแมววิ่งสำหรับ Widget
├── Shared/
│   └── CatAttributes.swift     # Data Model ที่แชร์ระหว่าง App และ Dynamic Island
├── project.yml                 # สเปกสำหรับ XcodeGen (สร้าง .xcodeproj อัตโนมัติ)
└── README.md
```

---

## 🚀 วิธีเปิดใช้งานและรันบน iPhone 15 (ฉบับใช้งานบน Windows)

### 1. เปิดโค้ดด้วย Antigravity IDE
* ใน Antigravity IDE ให้ไปที่เมนู **File > Open Folder...**
* เลือกโฟลเดอร์:
  ```text
  C:\Users\Lenovo Legion\.gemini\antigravity\scratch\runcat-ip15
  ```
* คุณสามารถแก้ไขโค้ด Swift ปรับความเร็ว หรือเปลี่ยนรูปน้องแมวได้ตามใจชอบ

---

### 2. นำโค้ดขึ้น GitHub เพื่อสั่งให้ระบบ Cloud บิลด์แอป (.ipa) ให้ฟรี

1. เปิด Terminal หรือ PowerShell ในโฟลเดอร์ `runcat-ip15`:
   ```bash
   git init
   git add .
   git commit -m "Initial commit RunCat iPhone 15"
   ```
2. สร้าง Repository ใหม่บน GitHub ของคุณ (ตั้งชื่อว่า `runcat-ip15`)
3. เชื่อมโยงและ Push ขึ้น GitHub:
   ```bash
   git remote add origin https://github.com/<YOUR_USERNAME>/runcat-ip15.git
   git branch -M main
   git push -u origin main
   ```
4. เข้าไปที่หน้าแท็บ **Actions** ใน GitHub Repo ของคุณ:
   * คุณจะเห็น Workflow **"Build CatRun iOS"** กำลังทำงาน
   * ใช้เวลาประมาณ 2-3 นาที เมื่อเสร็จแล้วจะมีไฟล์ Artifact ชื่อ **`CatRun-iPhone15-DynamicIsland`** ให้กดดาวน์โหลด จะได้ไฟล์ `CatRun.ipa` มาที่คอมของคุณ

---

### 3. ติดตั้งลง iPhone 15 ผ่านโปรแกรม Sideloadly (บน Windows)

1. ดาวน์โหลดและติดตั้ง **[Sideloadly](https://sideloadly.io/)** บนคอมพิวเตอร์ Windows
2. เสียบ **iPhone 15** เข้ากับคอมผ่านสาย USB Type-C
3. เปิด Sideloadly:
   * ช่อง **iDevice**: จะแสดงชื่อ iPhone 15 ของคุณ
   * ช่อง **Apple ID**: กรอกอีเมล Apple ID ส่วนตัวของคุณ (ฟรี ไม่ต้องเสียเงินซื้อโปรแกรมนักพัฒนา)
   * ลากไฟล์ **`CatRun.ipa`** มาวางลงในช่อง **IPA icon**
   * กดปุ่ม **Start** แล้วรอจนแถบขึ้น 100% (Done)
4. **เปิดสิทธิ์บน iPhone 15 (ทำครั้งแรกครั้งเดียว):**
   * ไปที่ **Settings** > **Privacy & Security** > เลื่อนลงล่างสุดเปิด **Developer Mode** (เครื่องจะ Restart 1 รอบ)
   * ไปที่ **Settings** > **General** > **VPN & Device Management** > แตะที่ Apple ID ของคุณ แล้วกด **Trust**
5. เปิดแอป **RunCat** บนหน้าจอ iPhone 15 แล้วกดปุ่ม **"🚀 ปล่อยแมวขึ้น Dynamic Island"** ได้ทันที!

---

## 🎨 การปรับแต่งเพิ่มเติม (Customization)

* **เปลี่ยนความเร็ว/ท่าทาง:** เข้าไปแก้ที่ `CatRun/ContentView.swift` หรือ `CatWidget/CatWidgetLiveActivity.swift`
* **เปลี่ยนรูปแมว:** สามารถนำภาพ PNG ตัวการ์ตูนอื่นๆ (ขนาดแนะนำ 48x48 หรือ 64x64 พื้นหลังใส) ไปวางแทนที่ไฟล์ `cat_0.png` ถึง `cat_4.png` ใน `CatWidget/Assets.xcassets/` ได้เลย
