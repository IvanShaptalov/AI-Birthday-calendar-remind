import Foundation

public class StorageConfiguration {
    static let storage = UserDefaults(suiteName: "group.aiBirthday")
    
    // MARK: - Model
    static let mainEvent = "aiBirthday.mainEvents"
    
    // MARK: - App rate
    static let ratedBefore = "aiBirthday.ratedBefore"
    static let appVersion = "aiBirthday.appVersion"
    
    // MARK: - Check launching
    static let launchedBefore = "aiBirhday.launchedBefore"
}
