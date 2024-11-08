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


### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

    I wanted to make UIKIt and SwiftUI versions, so you can switch back and forth.

    Data loading, and being able to switch data easily and efficiently.
    
    If the data is done poorly, it'll be very difficult to do the UI so I consider it to be the most important part of the project

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
    
    5 hours

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

    RecipeController probably doesn't need to be used a singleton - it might be easier if several screens are using it.  UIKit version uses it as a singleton, SwiftUI does not.
    
    I probably could have made more tests but I was running out of time.

### Weakest Part of the Project: What do you think is the weakest part of your project?

    I'm not great at SwiftUI, but I did what I know and what I could google quickly :)  There are probably better ways to do some of the SwiftUI code

### External Code and Dependencies: Did you use any external code, libraries, or dependencies?

    None

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.

    Instead of saving images to disk, I used NSCache, which is not what you asked for, but it's not HTTP caching either (I dont think ??), so it's kind of the middle ground between the two - storing the data in memory.  The advantage is that it's very fast, the disadvantage is that when you close the app, it'll delete the cache.  Storing images to disk does give us another problem of needing to expire the images.  I've stored images to documents folder using FileManager before.  The server team gave me a field "imageLastUpdated" in the JSON so I'd know if I should delete the local image and get a new one or not.  I think there are ways of storing NSCache to disk and retrieving it later, but I haven't done that.  
