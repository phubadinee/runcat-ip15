import WidgetKit
import SwiftUI
import ActivityKit

struct CatWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CatAttributes.self) { context in
            // MARK: - Lock Screen / Notification Banner
            LockScreenCatView(context: context)
                .activityBackgroundTint(Color.black.opacity(0.85))
                .activitySystemActionForegroundColor(Color.orange)

        } dynamicIsland: { context in
            // MARK: - Dynamic Island Layout (iPhone 15 / 15 Pro)
            DynamicIsland {
                // 1. Expanded Leading (กดค้างที่เกาะ - ด้านซ้าย)
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 8) {
                        AnimatedCatView(size: 32, speed: context.state.speedMultiplier)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(context.attributes.catName)
                                .font(.headline)
                                .foregroundColor(.white)
                            Text(context.state.statusMessage)
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.leading, 6)
                }

                // 2. Expanded Trailing (กดค้างที่เกาะ - ด้านขวา)
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 2) {
                        HStack(spacing: 4) {
                            Image(systemName: "battery.100")
                                .foregroundColor(.green)
                            Text("\(context.state.batteryLevel)%")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.white)
                        }
                        Text(String(format: "%.1fx สปีด", context.state.speedMultiplier))
                            .font(.caption2)
                            .foregroundColor(.orange)
                    }
                    .padding(.trailing, 6)
                }

                // 3. Expanded Bottom (กดค้างที่เกาะ - ด้านล่าง)
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Text("🐾 RunCat สำหรับ iPhone 15")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("iOS Live Activity")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 4)
                }

            } compactLeading: {
                // เกาะด้านซ้าย: น้องแมววิ่งดุ๊กดิ๊ก
                AnimatedCatView(size: 22, speed: context.state.speedMultiplier)
                    .padding(.leading, 4)

            } compactTrailing: {
                // เกาะด้านขวา: แสดง % แบตเตอรี่ หรือไอคอนรอยเท้า
                HStack(spacing: 2) {
                    Text("\(context.state.batteryLevel)%")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.green)
                    Text("🐾")
                        .font(.system(size: 10))
                }
                .padding(.trailing, 4)

            } minimal: {
                // กรณีมี 2 แอปแย่ง Dynamic Island: แสดงไอคอนแมวย่อส่วน
                AnimatedCatView(size: 18, speed: context.state.speedMultiplier)
            }
        }
    }
}

// MARK: - Animated Cat View (สลับเฟรม 0 ถึง 4 ด้วย PhaseAnimator)
struct AnimatedCatView: View {
    let size: CGFloat
    var speed: Double

    init(size: CGFloat = 24, speed: Double = 1.0) {
        self.size = size
        self.speed = max(0.2, speed)
    }

    var body: some View {
        PhaseAnimator([0, 1, 2, 3, 4]) { phase in
            Image("cat_\(phase)")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        } animation: { _ in
            .linear(duration: max(0.06, 0.14 / speed)).repeatForever(autoreverses: false)
        }
    }
}

// MARK: - Lock Screen View
struct LockScreenCatView: View {
    let context: ActivityViewContext<CatAttributes>

    var body: some View {
        HStack(spacing: 16) {
            AnimatedCatView(size: 40, speed: context.state.speedMultiplier)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(context.attributes.catName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Text("🔋 \(context.state.batteryLevel)%")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.green)
                }

                Text(context.state.statusMessage)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
        .padding(14)
    }
}
