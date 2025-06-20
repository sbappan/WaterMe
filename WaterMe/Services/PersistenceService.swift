import Foundation

class PersistenceService {
    private let userDefaults = UserDefaults.standard
    private let scheduleKey = "schedule"

    func saveSchedule(_ schedule: Schedule) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(schedule) {
            userDefaults.set(encoded, forKey: scheduleKey)
        }
    }

    func loadSchedule() -> Schedule? {
        if let savedScheduleData = userDefaults.object(forKey: scheduleKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedSchedule = try? decoder.decode(Schedule.self, from: savedScheduleData) {
                return loadedSchedule
            }
        }
        return nil
    }
} 