### Steps to Run the App

Just run the app in xcode on any simulator or device.

The current state uses SwiftUI, but you can easily switch it.

UIKit: 

    UI/UIKit/AppDelegate.swift - make sure "@main" IS NOT commented out    
    UI/SwiftUI/FetchRecipesApp.swift - make sure "@main" IS commented out
    Build Settings, find key "Info.plist File", make sure it is "Info-UIKit.swift"
    Delete the app from the device
    Run the app from xcode

SwiftUI: 

    UI/UIKit/AppDelegate.swift - make sure "@main" IS commented out    
    UI/SwiftUI/FetchRecipesApp.swift - make sure "@main" IS NOT commented out
    Build Settings, find key "Info.plist File", make sure it is "Info-SwiftUI.swift"
    Delete the app from the device
    Run the app from xcode
