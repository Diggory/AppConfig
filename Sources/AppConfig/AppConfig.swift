import Foundation
import AnyCodable


/// Stores app configuration properties.  Can load and save them to file.
public class AppConfig {
	public init(configFileName: String, configDictionary: [String : AnyCodable] = [String: AnyCodable]()) {
		self.configFileName = configFileName
		self.configDictionary = configDictionary
	}
	
	///	Folder where the config file is stored on disc.  n.b. the default (/etc/) is only available to Root.
	public var configDirectoryString = "/etc/"
	///	The name of the config file on disc (without file extension)
	var configFileName: String

	///	Our storage object
	var configDictionary = [String: AnyCodable]()
	
	//	Subscripting
	public subscript(key: String) -> Codable? {
		get {
			configDictionary[key]
		}
	
		set(optionalNewValue) {
			let newValue = optionalNewValue!
			print("AppConfig: set[\(key):\(newValue)]")
			configDictionary[key] = AnyCodable(newValue)
		}
	}

	///	Writes the config out to flie as JSON
	public func persistConfigToFilesystem() -> Bool {
		print("persisting appConfig to disc.")
		let path = configDirectoryString + configFileName + ".json"
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		do {
			let url = URL(fileURLWithPath: path)
			let data = try encoder.encode(configDictionary)
			try data.write(to: url, options: [.atomic])
		} catch {
			print("Could not write appConfig JSON to: \(path) - \( error)")
			return false
		}
		return true
	}
	
	///	Loads config from filesystem
	public func loadConfigFromFilesystem() -> Bool {
		let importPath = configDirectoryString + configFileName + ".json"
		print("loading config from filesystem \(importPath)")
		var importedConfigDictonary: [String: AnyCodable]
		do {
			if let importedJsonData = try String(contentsOfFile: importPath).data(using: .utf8) {
				importedConfigDictonary = try JSONDecoder().decode([String: AnyCodable].self, from: importedJsonData)
			} else {
				print("ERROR: AppConfig: could not convert string to JSON \(importPath)")
				return false
			}
		} catch {
			print("ERROR: AppConfig: Could not load config from JSON - \(importPath) - \(error)")
			return false
		}
		//	We should now have a valid config instance.
		self.configDictionary = importedConfigDictonary
		
		return true
	}

}
