# AppConfig

A Swift package which makes it easy to have a set of app-wide properties which can be persisted and loaded to/from the filesystem (encoded as JSON).

Useful for applications on Linux, where (at the time of writing) [Foundation's UserDefaults don't work](https://github.com/apple/swift-corelibs-foundation/issues/4837).  I assume that this will be rectified in [The new Swift-based Foundation Project](https://github.com/apple/swift-foundation) 

> [!NOTE]  
> Fill this section out with examples as per below…
	
- Show how to add the package in SPM 
- Add example where an existing config file exists
- Add example where an existing config file doesn't exist, but a default config file exists'
- Add example where neither an existing config file exists nor a default config file exists. In this case we make defaults in code. 
