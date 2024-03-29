import Foundation
import AnyCodable


/// Stores app configuration properties.  Can read and save them to file.
///  Types to store must conform to Codable
public class AppConfig {
	
	///	A shorthand for the config dict
	public typealias AppConfigDict = [String: AnyCodable]
	
	public init(
		configDirectoryString: String = "/etc/",
		configFileName: String,
		configDictionary: AppConfigDict = AppConfigDict()
	) {
		self.configDirectoryString = configDirectoryString
		self.configFileName = configFileName
		self.configDictionary = AppConfigDict()
	}
	
	///	Folder where the config file is stored on disc.  n.b. the default (/etc/) is only available to Root.
	public var configDirectoryString = "/etc/"
	///	The name of the config file on disc (without file extension)
	var configFileName: String
	/// Should auto-save to file when a property is changed
	var shouldAutoSave = true
	
	///	Our storage object
	var configDictionary: AppConfigDict {
		willSet(newAppConfigDict) {
			//			print("configDictionary: didSet()")
			//	TODO: Debounce...  without losing saves.
			
			//	check that the value has changed
			if  newAppConfigDict ==  configDictionary{
				return
			}
		}
		didSet {
			if shouldAutoSave {
				//	FIXME: This doesn't work - and we end-up with an empty
				_ = self.persistConfigToFilesystem()
			}
		}
	}
	
	//	Subscripting
	///	Although the subscript accepts Types of Any - in practice they must in fact conform to Codable
	public subscript(key: String) -> Any? {
		get {
			configDictionary[key]?.value
		}
	
		set(optionalNewValue) {
			//	Should we allow to set nil?  Effectively clearing the stored value...
			guard optionalNewValue != nil else {
				print("Attempt to set nil")
				return
			}
			let newValue = optionalNewValue!
			print("AppConfig: set[\(key):\(newValue)]")
			configDictionary[key] = AnyCodable(newValue)
		}
	}
	
	
	//	TODO: Rename
	///	Sets the AppConfig file contents from a dictionary parameter
	public func setInitialConfigWhereNoDefaultsInFilesystem(initialProps: AppConfigDict) -> Bool {
		if !configDictionary.isEmpty {
			print("attempt to call \(#function) when configDictionary is not empty")
			return false
		}
		configDictionary = initialProps
		return true
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
	
	///	Loads the saved config - if not available on the filesystem then use defaults...
	public func loadConfigFromFilesystem() -> Bool {
		//	Config file already exists
		if (loadConfigFromFilesystemWithFilename(configFileName)) {
			return true
		}
		//	Try default config file
		if (loadDefaults()) {
			return true
		}

		//	We have neither a config file, nor a defaults file…
		return false
	}

	///	Loads default config from filesystem.  Default config is in the set folder and has the name ($configFileName_defaults.json)
	public func loadDefaults() -> Bool {
		print("Loading defaults...")
		return loadConfigFromFilesystemWithFilename(configFileName + "_defaults")
	}

	
	///	Loads config from filesystem given a specific filename in thte appropriate folder
	public func loadConfigFromFilesystemWithFilename(_ fileName: String) -> Bool {
		let importPath = configDirectoryString + fileName + ".json"
		print("loading config from filesystem \(importPath)")
		var importedConfigDictonary: [String: AnyCodable]
		do {
			if let importedJsonData = try String(contentsOfFile: importPath).data(using: .utf8) {
				importedConfigDictonary = try JSONDecoder().decode([String: AnyCodable].self, from: importedJsonData)
			} else {
				print("WARN: AppConfig: could not convert string to JSON \(importPath)")
				return false
			}
		} catch {
			print("WARN: AppConfig: Could not load config from JSON - \(importPath) - \(error)")
			return false
		}
		//	We should now have a valid config instance.
		self.configDictionary = importedConfigDictonary
		
		return true
	}

	

}
