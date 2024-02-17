# AppConfig

A Swift package which makes it easy to have a set of app-wide properties which can be persisted and loaded to/from the filesystem (encoded as JSON).

Useful for applications on Linux, where (at the time of writing) [Foundation's UserDefaults don't work](https://github.com/apple/swift-corelibs-foundation/issues/4837).  I assume that this will be rectified in [The new Swift-based Foundation Project](https://github.com/apple/swift-foundation) 

If you are targetting Apple's platforms, then you should probably use Foundation's [UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults) class instead of this package. [Hacking With Swift Example](https://www.hackingwithswift.com/read/12/2/reading-and-writing-basics-userdefaults) for using UserDefaults

---

> [!NOTE]  
> As this repo is public, I should _probably_ learn how to do tests…

---

## Adding AppConfig as a dependency to your package
You need to declare your dependency in your `Package.swift` manifest file in the `dependencies` array:

```swift
.package(url: "https://github.com/Diggory/AppConfig.git", from: "0.0.1"),
```

And also to your application/library target, add `"AppConfig"` to your `dependencies`, e.g. like this:

```swift
.target(name: "YourAppNameHere", dependencies: [
    .product(name: "AppConfig", package: "AppConfig")
],
```


e.g. in a full package manifest

```swift
// swift-tools-version: 5.7
import PackageDescription

let package = Package(
	name: "YourPackageNameHere",
	dependencies: [
		.package(url: "https://github.com/Diggory/AppConfig.git", from: "0.0.1"),
	],
	targets: [
		.executableTarget(
			name: "YourExecutableNameHere",
			dependencies: [
				.product(name: "AppConfig", package: "AppConfig")
			]),
	]
)
```
---
## Examples

### Setup
```swift
	// Import AppConfig to use it.
	import AppConfig
	
	//	The appConfig needs to know what your app name is, 
	//	so that it can store the config in the correctly named files.
	var appConfig = AppConfig(configFileName: "YourAppNameHere")
	
	//	In which folder should the config files be saved?  
	//	/etc is only available to root.  
	//	/tmp can be purged at any time (but can work for our examples).
	appConfig.configDirectoryString = "/tmp/"

```

### 1) An example where an existing working config file exists `/etc/YourAppName.json` or a default config file exists `/etc/YourAppName_defaults.json`

```swift
	//	Attempt to load the config from disc
	if (!appConfig.loadConfigFromFilesystem()) {
		print("Unable to load app config from filesystem (neither from active config file, nor the defaults config file…)")
	}
```

---

### 2) An example where neither an existing config file exists nor a default config file exists. In this case we make defaults in code. Useful in the failure case above.

```swift
	if (!appConfig.setInitialConfigWhereNoDefaultsInFilesystem(initialProps: ["Bing": "Bong"])) {
			print("Cannot set initial config - there appears to be an existing config in the filesytem.  Either a user generated one, or a default file....")
	}
```

### A combination of 1 and 2:

```swift
	//	Attempt to load the config from disc
	if (!appConfig.loadConfigFromFilesystem()) {
		print("Unable to load app config from filesystem (neither from active config file, nor the defaults config file…)")
		print("Setting config from a hard-coded property")
		if (!appConfig.setInitialConfigWhereNoDefaultsInFilesystem(initialProps: ["Bing": "Bong"])) {
			//	Technically this case should never happen in this specific closure as we have already checked for this case in loadConfigFromFilesystem()…
			print("Cannot set initial config - there appears to be an existing config in the filesytem.  Either a user generated one, or a default file....")
		}
	}
```


### Setting a property to the store 

```swift
	let key = "bing"
	appConfig[key] = "bang!"
```


### Getting a property from the store 

```swift
	let key = "bing"
	let retrievedConfigProperty = appConfig[key]
	print("\(key): \(retrievedConfigProperty ?? "No config property for key: \(key)")")
```

result:

```swift
bing: bang!
```

