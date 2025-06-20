import Foundation

struct Schedule: Codable {
    var startTime: Date
    var endTime: Date
    var reminderInterval: TimeInterval // Stored in seconds
    var followUpInterval: TimeInterval // Stored in seconds
    
    var totalReminders: Int {
        guard reminderInterval > 0 else { return 0 }
        let totalDuration = endTime.timeIntervalSince(startTime)
        guard totalDuration >= 0 else { return 0 }
        return Int(totalDuration / reminderInterval) + 1
    }
} 