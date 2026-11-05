import WidgetKit
import SwiftUI
import ActivityKit

struct CatWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CatAttributes.self) { context in
            // MARK: - Lock Screen Banner (หน้าจอตอนล็อคเครื่อง)
            HStack(spacing: 12) {
                Image(systemName: "star.fill")
                    .font(.title2)
                    .foregroundColor(.yellow)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Dynamic Island Test")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("ระบบ Live Activity บน iPhone 15 ทำงานแล้ว!")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(context.state.statusText)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.green)
            }
            .padding()
            .activityBackgroundTint(Color.black.opacity(0.85))

        } dynamicIsland: { context in
            // MARK: - Dynamic Island (iPhone 15)
            DynamicIsland {
                // ตอนกดแตะเกาะค้างไว้ (Expanded)
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("Dynamic Island")
                            .font(.headline)
                    }
                    .padding(.leading, 8)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text("SUCCESS ✅")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.green)
                        .padding(.trailing, 8)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    Text("🎉 ทดสอบสำเร็จ! Dynamic Island พร้อมใช้งาน")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }

            } compactLeading: {
                // เกาะฝั่งซ้าย: ดาวสีเหลืองเด่นชัด (SF Symbol ในตัวเครื่อง)
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .padding(.leading, 4)

            } compactTrailing: {
                // เกาะฝั่งขวา: คำว่า OK ✅ สีเขียว
                Text("OK ✅")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.green)
                    .padding(.trailing, 4)

            } minimal: {
                // ไอคอนมินิมอลเวลาโดนย่อ
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }
}
