import Foundation

class PersistenceService {
    private let userDefaults = UserDefaults.standard
    private let progressKey = "dailyProgress"

    // MARK: - Progress Tracking
    
    private struct ProgressData: Codable {
        var completionCount: Int
        var lastUpdated: Date
    }

    func saveProgress(count: Int) {
        let progress = ProgressData(completionCount: count, lastUpdated: Date())
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(progress) {
            userDefaults.set(encoded, forKey: progressKey)
        }
    }

    func loadProgress() -> (count: Int, lastUpdated: Date)? {
        guard let savedProgressData = userDefaults.object(forKey: progressKey) as? Data else {
            return nil
        }
        let decoder = JSONDecoder()
        if let loadedProgress = try? decoder.decode(ProgressData.self, from: savedProgressData) {
            return (loadedProgress.completionCount, loadedProgress.lastUpdated)
        }
        return nil
    }

    func incrementCompletionCount() {
        var currentCount = 0
        if let progress = loadProgress() {
            currentCount = progress.count
        }
        saveProgress(count: currentCount + 1)
    }

    func resetCompletionCountIfNeeded() {
        guard let progress = loadProgress() else {
            saveProgress(count: 0)
            return
        }

        if !Calendar.current.isDateInToday(progress.lastUpdated) {
            saveProgress(count: 0)
        }
    }
} 