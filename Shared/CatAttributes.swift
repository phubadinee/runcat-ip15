import ActivityKit
import Foundation

public struct CatAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var speedMultiplier: Double
        public var batteryLevel: Int
        public var statusMessage: String

        public init(speedMultiplier: Double = 1.0, batteryLevel: Int = 100, statusMessage: String = "กำลังวิ่ง...") {
            self.speedMultiplier = speedMultiplier
            self.batteryLevel = batteryLevel
            self.statusMessage = statusMessage
        }
    }

    public var catName: String

    public init(catName: String = "RunCat") {
        self.catName = catName
    }
}
