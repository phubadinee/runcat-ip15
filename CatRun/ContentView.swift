import SwiftUI
import ActivityKit

struct ContentView: View {
    @State private var currentActivity: Activity<CatAttributes>? = nil
    @State private var isRunning = false
    @State private var catSpeed: Double = 1.0
    @State private var catName: String = "Mimi Cat"
    @State private var currentBattery: Int = 100
    @State private var autoSyncBattery: Bool = true
    
    // สถานะ Permission & แจ้งเตือน
    @State private var liveActivitiesEnabled: Bool = true
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""

    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Permission Warning Box (ถ้ายังไม่ได้เปิดใน Settings)
                    if !liveActivitiesEnabled {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.yellow)
                                Text("ยังไม่ได้เปิดสิทธิ์ Live Activities")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            Text("ระบบ iOS ไม่อนุญาตให้แสดงบน Dynamic Island กรุณาไปที่:\nSettings (การตั้งค่า) > RunCat > เปิด 'อนุญาตกิจกรรมสด (Live Activities)'")
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.red.opacity(0.85))
                        .cornerRadius(16)
                    }

                    // MARK: - Cat Preview Card
                    VStack(spacing: 12) {
                        AnimatedCatPreview(speed: catSpeed)
                            .frame(height: 90)
                            .padding(.top, 10)

                        Text(catName)
                            .font(.title2)
                            .bold()

                        HStack(spacing: 16) {
                            Label("\(currentBattery)%", systemImage: "battery.100")
                                .foregroundColor(.green)
                            Label(String(format: "%.1fx", catSpeed), systemImage: "speedometer")
                                .foregroundColor(.orange)
                        }
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Color.secondary.opacity(0.12))
                        .clipShape(Capsule())
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(20)

                    // MARK: - Action Buttons
                    VStack(spacing: 12) {
                        if !isRunning {
                            Button(action: startCatActivity) {
                                Label("🚀 ปล่อยแมวขึ้น Dynamic Island", systemImage: "arrow.up.circle.fill")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.orange)
                        } else {
                            Button(action: stopCatActivity) {
                                Label("🛑 หยุดและเก็บแมวลงเกาะ", systemImage: "stop.circle.fill")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                        }
                    }

                    // MARK: - Instruction Hint
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "hand.tap.fill")
                            .font(.title3)
                            .foregroundColor(.orange)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("สำคัญมาก: เมื่อกดปล่อยแมวแล้ว")
                                .font(.footnote)
                                .bold()
                            Text("ให้ **ปัดหน้าจอกลับไปที่หน้าโฮม (Home Screen)** หรือลองกดล็อคหน้าจอ คุณจะเห็นน้องแมววิ่งอยู่บน Dynamic Island ทันที (ขณะอยู่ในแอป Dynamic Island จะยังไม่แสดง)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(16)

                    // MARK: - Controls & Settings
                    VStack(alignment: .leading, spacing: 16) {
                        Text("ตั้งค่าการทำงาน")
                            .font(.headline)

                        // Cat Name Input
                        VStack(alignment: .leading, spacing: 6) {
                            Text("ชื่อน้องแมว")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            TextField("ชื่อน้องแมว", text: $catName)
                                .textFieldStyle(.roundedBorder)
                        }

                        // Speed Slider
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("ความเร็วในการวิ่ง")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(String(format: "%.1fx", catSpeed))
                                    .font(.caption)
                                    .bold()
                            }
                            Slider(value: $catSpeed, in: 0.5...3.0, step: 0.1)
                                .tint(.orange)
                                .onChange(of: catSpeed) {
                                    updateLiveActivity()
                                }
                        }

                        // Auto Sync Battery
                        Toggle(isOn: $autoSyncBattery) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("ปรับสปีดตามแบตเตอรี่จริง")
                                    .font(.body)
                                Text("แบตเยอะวิ่งไว แบตน้อยวิ่งช้าลง")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .tint(.orange)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(20)
                }
                .padding()
            }
            .navigationTitle("RunCat 🐾")
            .alert(alertTitle, isPresented: $showAlert) {
                Button("เข้าใจแล้ว", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .onAppear {
                setupBatteryMonitoring()
                checkPermission()
                checkExistingActivity()
            }
            .onReceive(timer) { _ in
                refreshBattery()
                checkPermission()
                if isRunning {
                    updateLiveActivity()
                }
            }
        }
    }

    // MARK: - Logic & Checks
    private func checkPermission() {
        liveActivitiesEnabled = ActivityAuthorizationInfo().areActivitiesEnabled
    }

    private func setupBatteryMonitoring() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        refreshBattery()
    }

    private func refreshBattery() {
        let level = UIDevice.current.batteryLevel
        if level >= 0 {
            currentBattery = Int(level * 100)
            if autoSyncBattery {
                catSpeed = max(0.5, Double(currentBattery) / 40.0)
            }
        }
    }

    private func checkExistingActivity() {
        if let existing = Activity<CatAttributes>.activities.first {
            currentActivity = existing
            isRunning = true
        }
    }

    private func startCatActivity() {
        checkPermission()
        guard liveActivitiesEnabled else {
            alertTitle = "⚠️ Live Activities ยังไม่เปิดใช้งาน"
            alertMessage = "กรุณาไปที่ การตั้งค่า (Settings) บน iPhone > เลื่อนหาแอป RunCat > เปิดสิทธิ์ 'Live Activities (กิจกรรมสด)'"
            showAlert = true
            return
        }

        let attributes = CatAttributes(catName: catName)
        let contentState = CatAttributes.ContentState(
            speedMultiplier: catSpeed,
            batteryLevel: currentBattery,
            statusMessage: "กำลังวิ่งบน iPhone 15"
        )

        do {
            let activity = try Activity.request(
                attributes: attributes,
                content: .init(state: contentState, staleDate: nil)
            )
            currentActivity = activity
            isRunning = true

            alertTitle = "🚀 ปล่อยแมวขึ้น Dynamic Island แล้ว!"
            alertMessage = "ตอนนี้ให้น้องแมวเริ่มทำงานแล้ว ให้คุณปัดหน้าจอเพื่อ 'กลับไปหน้าโฮม (Home Screen)' หรือกดล็อคหน้าจอ คุณจะเห็นน้องแมววิ่งอยู่บนเกาะด้านบนทันทีครับ"
            showAlert = true
        } catch {
            alertTitle = "เกิดข้อผิดพลาดในการเริ่ม"
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }

    private func updateLiveActivity() {
        guard let activity = currentActivity else { return }
        let updatedState = CatAttributes.ContentState(
            speedMultiplier: catSpeed,
            batteryLevel: currentBattery,
            statusMessage: autoSyncBattery ? "วิ่งตามแบตเตอรี่" : "วิ่งความเร็วคงที่"
        )

        Task {
            await activity.update(.init(state: updatedState, staleDate: nil))
        }
    }

    private func stopCatActivity() {
        guard let activity = currentActivity else {
            isRunning = false
            return
        }

        Task {
            await activity.end(dismissalPolicy: .immediate)
            await MainActor.run {
                currentActivity = nil
                isRunning = false
            }
        }
    }
}

// MARK: - UI Preview Component for In-App Screen
struct AnimatedCatPreview: View {
    let speed: Double

    var body: some View {
        PhaseAnimator([0, 1, 2, 3, 4]) { phase in
            Image("cat_\(phase)")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
        } animation: { _ in
            .linear(duration: max(0.06, 0.14 / speed)).repeatForever(autoreverses: false)
        }
    }
}
