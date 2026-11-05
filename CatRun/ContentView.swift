import SwiftUI
import ActivityKit

struct ContentView: View {
    @State private var currentActivity: Activity<CatAttributes>? = nil
    @State private var isRunning = false
    @State private var catSpeed: Double = 1.0
    @State private var catName: String = "Mimi Cat"
    @State private var currentBattery: Int = 100
    @State private var autoSyncBattery: Bool = true
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
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
                                .onChange(of: catSpeed) { _ in
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

                    // MARK: - Info Box for iPhone 15
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "iphone.gen3")
                            .font(.title2)
                            .foregroundColor(.orange)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("ออกแบบสำหรับ Dynamic Island บน iPhone 15")
                                .font(.footnote)
                                .bold()
                            Text("เมื่อกดปุ่มเริ่ม ให้ปัดแอปขึ้นไปหน้าโฮม คุณจะเห็นน้องแมววิ่งอยู่บนเกาะ Dynamic Island ด้านบนทันที")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(16)
                }
                .padding()
            }
            .navigationTitle("RunCat 🐾")
            .onAppear {
                setupBatteryMonitoring()
                checkExistingActivity()
            }
            .onReceive(timer) { _ in
                refreshBattery()
                if isRunning {
                    updateLiveActivity()
                }
            }
        }
    }

    // MARK: - Battery & ActivityKit Logic
    private func setupBatteryMonitoring() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        refreshBattery()
    }

    private func refreshBattery() {
        let level = UIDevice.current.batteryLevel
        if level >= 0 {
            currentBattery = Int(level * 100)
            if autoSyncBattery {
                // Map 0-100% to speed 0.5x - 2.5x
                catSpeed = max(0.5, Double(currentBattery) / 40.0)
            }
        }
    }

    private func checkExistingActivity() {
        // ตรวจสอบว่ามี Activity เดิมค้างอยู่หรือไม่
        if let existing = Activity<CatAttributes>.activities.first {
            currentActivity = existing
            isRunning = true
        }
    }

    private func startCatActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activities ไม่เปิดใช้งาน")
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
        } catch {
            print("Failed to start activity: \(error.localizedDescription)")
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
