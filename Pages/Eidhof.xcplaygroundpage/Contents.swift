import UIKit
import XCPlayground

struct App {
  let name: String
  let link: String
  
  init?(json: [String:AnyObject]) {
    guard let container = json["im:name"],
          let id = json["id"]
      else { return nil }
    
    guard let name = container["label"] as? String,
          let link = id["label"] as? String
      else { return nil }
    
    self.name = name
    self.link = link
  }
}

struct Feed {
  let entries: [App]?
  
  init?(json: [String:AnyObject]) {
    guard let entries = json["entry"] as? [App]
      else { print("failed parsing entries"); return nil }
    
    self.entries = entries
  }
}

struct TopApps {
  let feed: Feed?
  
  init?(json: [String:AnyObject]) {
    guard let feed = json["feed"] as? Feed
      else { print("failed parsing feed"); return nil }
    
    self.feed = feed
  }
}

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

DataManager.getTopAppsDataFromFileWithSuccess { (data) -> Void in
  var json: [String: AnyObject]!
  
  do {
    json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String: AnyObject]
  } catch {
    print(error)
    XCPlaygroundPage.currentPage.finishExecution()
  }
  
  guard let topApps = TopApps(json: json) else {
    print("Error initializing object")
    XCPlaygroundPage.currentPage.finishExecution()
  }

  guard let topTwentyFive = topApps.feed?.entries else {
    print("No such item")
    XCPlaygroundPage.currentPage.finishExecution()
  }
  
  for app in topTwentyFive {
    print(app.name)
  }
  
  XCPlaygroundPage.currentPage.finishExecution()
}
