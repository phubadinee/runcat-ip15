import SwiftUI
import ActivityKit

struct ContentView: View {
    @State private var currentActivity: Activity<CatAttributes>? = nil
    @State private var isRunning = false
    @State private var liveActivitiesEnabled = true
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: isRunning ? "star.fill" : "iphone.gen3")
                        .font(.system(size: 64))
                        .foregroundColor(isRunning ? .yellow : .orange)
                        .padding(.top, 20)

                    Text("Dynamic Island Tester")
                        .font(.title)
                        .bold()

                    Text("เวอร์ชันทดสอบพื้นฐานสำหรับ iPhone 15")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Status Banner
                if isRunning {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title2)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("กำลังทำงานอยู่บน Dynamic Island! 🎉")
                                .font(.headline)
                            Text("👉 ให้ปัดกลับไปหน้า Home Screen หรือกดล็อคหน้าจอเพื่อดูดาวสีเหลือง ⭐")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.green.opacity(0.15))
                    .cornerRadius(16)
                } else {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                        Text("กดปุ่มด้านล่างเพื่อเริ่มการทดสอบ")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(16)
                }

                // Permission Warning
                if !liveActivitiesEnabled {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("⚠️ คำเตือน: สิทธิ์ Live Activities ปิดอยู่")
                            .font(.headline)
                            .foregroundColor(.red)
                        Text("กรุณาไปที่ การตั้งค่า (Settings) > RunCat > เปิด 'อนุญาตกิจกรรมสด (Live Activities)'")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(16)
                }

                Spacer()

                // Action Buttons
                VStack(spacing: 14) {
                    if !isRunning {
                        Button(action: startTest) {
                            HStack {
                                Image(systemName: "star.fill")
                                Text("🚀 เริ่มทดสอบ (ปล่อยดาวขึ้นเกาะ)")
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)
                    } else {
                        Button(action: stopTest) {
                            HStack {
                                Image(systemName: "stop.circle.fill")
                                Text("🛑 หยุดการทดสอบ")
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                }
                .padding(.bottom, 20)
            }
            .padding(24)
            .navigationTitle("Test Tool")
            .navigationBarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlert) {
                Button("เข้าใจแล้ว", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .onAppear {
                checkPermission()
                checkExisting()
            }
        }
    }

    private func checkPermission() {
        liveActivitiesEnabled = ActivityAuthorizationInfo().areActivitiesEnabled
    }

    private func checkExisting() {
        if let existing = Activity<CatAttributes>.activities.first {
            currentActivity = existing
            isRunning = true
        }
    }

    private func startTest() {
        checkPermission()
        guard liveActivitiesEnabled else {
            alertTitle = "⚠️ ยังไม่ได้เปิดสิทธิ์"
            alertMessage = "กรุณาเปิดสิทธิ์ Live Activities ใน Settings > RunCat ก่อนนะครับ"
            showAlert = true
            return
        }

        let attributes = CatAttributes(title: "Dynamic Island Test")
        let state = CatAttributes.ContentState(statusText: "OK ✅")

        do {
            let activity = try Activity.request(
                attributes: attributes,
                content: .init(state: state, staleDate: nil)
            )
            currentActivity = activity
            isRunning = true

            alertTitle = "⭐ เริ่มทำงานสำเร็จแล้ว!"
            alertMessage = "ตอนนี้ให้คุณ 'ปัดหน้าจอเพื่อกลับไปหน้าโฮม' หรือ 'กดปุ่มล็อคหน้าจอ' เดี๋ยวนี้เลยครับ! คุณจะเห็นดาวสีเหลือง ⭐ และข้อความ OK ✅ ขึ้นที่เกาะด้านบน"
            showAlert = true
        } catch {
            alertTitle = "เริ่มไม่สำเร็จ"
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }

    private func stopTest() {
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
