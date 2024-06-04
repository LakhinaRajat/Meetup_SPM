import Foundation

extension Bundle {
    public var appName: String { getInfo("CFBundleName")  }
    public var displayName: String {getInfo("CFBundleDisplayName")}
    public var language: String {getInfo("CFBundleDevelopmentRegion")}
    public var identifier: String {getInfo("CFBundleIdentifier")}
    public var appBuild: String { getInfo("CFBundleVersion") }
    public var appVersionLong: String { getInfo("CFBundleShortVersionString") }
    public var appVersionShort: String { getInfo("CFBundleShortVersion") }
    fileprivate func getInfo(_ str: String) -> String { infoDictionary?[str] as? String ?? "⚠️" }
}

extension Dictionary {
    
    func stringifyDictionary() -> String {
        if let jsonStr = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
            let str = String(data: jsonStr, encoding: .utf8) {
            return str
        } else {
            return ""
        }
    }
    
    func jsonString() -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            return String(data: jsonData, encoding: .utf8) ?? ""
        } catch {
            print("Error converting dictionary to JSON string: \(error)")
            return ""
        }
    }
}
