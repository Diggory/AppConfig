import AppConfig

///	A type that does not conform to the Codable Protocol
struct NonCodableType {
	let aString: String
	let AnInt: Int
}

///	A type that does conform to Codable
struct MyCodableType: Codable {
	let aString: String
	let AnInt: Int
}

//	A simple executable which shows use of AppConfig

///	Name of our app
let appName = "TestApp"

//	Setup appConfig instance

///  Our test AppConfig Instance
var appConfig = AppConfig(configFileName: appName)
appConfig.configDirectoryString = "/tmp/"

//	Attempt to load the config from disc
if (!appConfig.loadConfigFromFilesystem()) {
	print("Unable to load app config from filesystem (neither from active config file, nor the defaults config file…)")
	print("Setting config from a hard-coded property")

	//	FIXME: This should be type-safe if possible.  Is it possible?  This is a K/V store....
	//	Maybe check keys from registration?  Currently open - all keys are valid...
	//	Maybe make the user register keys?  Sounds like the Windows Registry...
	if (!appConfig.setInitialConfigWhereNoDefaultsInFilesystem(initialProps: ["Bing": "Bong"])) {
		//	Technically this case should never happen in this specific closure as we have already checked for this case in loadConfigFromFilesystem()…
		print("Cannot set initial config - there appears to be an existing config in the filesytem.  Either a user generated one, or a default file....")
	}
}

///	Get a property from config store and print it out
func getPropertyForKey(key:String) {
	let retrievedConfigProperty = appConfig[key]
	print("\(key): \(retrievedConfigProperty ?? "No config property for key: \(key)")")
}

///	Set a property to config store and print it out
func setPropertyForKey(_ prop: Codable, key:String) {
	appConfig[key] = prop
	let retrievedConfigProperty = appConfig[key]
	print("\(key): \(retrievedConfigProperty ?? "No config prop for key: \(key)")")
}

///	String Propery
let testConfigPropertyKey = "testConfigPropertyKey"
getPropertyForKey(key: testConfigPropertyKey)
setPropertyForKey("I am a String Property", key: testConfigPropertyKey)

///	Int Propery
let testConfigPropertyKey2 = "testConfigPropertyKey2"
getPropertyForKey(key: testConfigPropertyKey2)
setPropertyForKey(42, key: testConfigPropertyKey2)

///	Non-codable Type Propery
let testConfigPropertyKey3 = "testConfigPropertyKey3"
getPropertyForKey(key: testConfigPropertyKey2)

//	Cannot set non-codable type.  This would be an error if we were to uncomment the line below.
//setPropertyForKey(NonCodableType(aString: "Foo", AnInt: 42), key: testConfigPropertyKey2)

//	Codable Type Propery
getPropertyForKey(key: testConfigPropertyKey3)
setPropertyForKey(MyCodableType(aString: "Foo", AnInt: 123), key: testConfigPropertyKey3)

//	Save the config to disc
if (!appConfig.persistConfigToFilesystem()) {
	print("Unable to save appConfig to disc")
}
