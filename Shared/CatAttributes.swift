import ActivityKit
import Foundation

public struct CatAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var statusText: String

        public init(statusText: String = "OK ✅") {
            self.statusText = statusText
        }
    }

    public var title: String

    public init(title: String = "Island Test") {
        self.title = title
    }
}
