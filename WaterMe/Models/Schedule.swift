import Foundation

struct Schedule: Codable {
    var startTime: Date
    var endTime: Date
    var reminderInterval: TimeInterval // Stored in seconds
    var followUpInterval: TimeInterval // Stored in seconds
} 