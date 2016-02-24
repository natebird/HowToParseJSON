import UIKit
import XCPlayground

struct App: Decodable {
  let name: String
  let link: String
  
  init?(json: JSON) {
    guard let container: JSON = "im:name" <~~ json,
      let id: JSON = "id" <~~ json
      else { return nil }
    
    guard let name: String = "label" <~~ container,
      let link: String = "label" <~~ id
      else { return nil }
    
    self.name = name
    self.link = link
  }
}

struct TopApps: Decodable {
  let feed: Feed?
  init?(json: JSON) {
    feed = "feed" <~~ json
  }
}

struct Feed: Decodable {
  let entries: [App]?
  init?(json: JSON) {
    entries = "entry" <~~ json
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
  print(topApps)
  
  guard let topTwentyFive = topApps.feed?.entries else {
    print("No such item")
    XCPlaygroundPage.currentPage.finishExecution()
  }
  
  for app in topTwentyFive {
    print(app.name)
  }
  
  XCPlaygroundPage.currentPage.finishExecution()
}
