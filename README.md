# AppConfig

A Swift package which makes it easy to have a set of app-wide properties which can be persisted and loaded to/from the filesystem (encoded as JSON).

Useful for applications on Linux, where (at the time of writing) [Foundation's UserDefaults don't work](https://github.com/apple/swift-corelibs-foundation/issues/4837).  I assume that this will be rectified in [The new Swift-based Foundation Project](https://github.com/apple/swift-foundation) 

> [!NOTE]  
> Fill this section out with examples as per below…
	
- Add example where an existing config file exists
- Add example where an existing config file doesn't exist, but a default config file exists
- Add example where neither an existing config file exists nor a default config file exists. In this case we make defaults in code. 


As this repo is public, I should _probably_ learn how to do tests…


## Adding AppConfig as a dependency to your package
You need to declare your dependency in your `Package.swift` manifest file in the `dependencies` array:

```
.package(url: "https://github.com/Diggory/AppConfig.git", from: "0.0.1"),
```

And also to your application/library target, add `"AppConfig"` to your `dependencies`, e.g. like this:

```
.target(name: "YourAppNameHere", dependencies: [
    .product(name: "AppConfig", package: "AppConfig")
],
```


e.g. in a full package manifest

```
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
