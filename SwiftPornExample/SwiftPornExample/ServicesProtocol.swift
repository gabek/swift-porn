// Autogenerated code from test/service.proto on Sat, July 09 2016.  DO NOT EDIT!
// {"swiftpath"=>"./SwiftPornExample/SwiftPornExample"}

import Foundation
import ObjectMapper

protocol DateTimeTest {
  func test(request: DateTimeRequest, completionHandler: ((DateTimeResponse? -> Void)?))
}

extension DateTimeTest {
  func test(request: DateTimeRequest, completionHandler: ((DateTimeResponse? -> Void)?) = nil) {
    let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    let url = NSURL(string: "http://date.jsontest.com/test")!
    let dataTask = defaultSession.dataTaskWithURL(url) {
      data, response, error in
        // Handle response
        let dateTimeResponse = Mapper<DateTimeResponse>().map(data?.utf8String())
        completionHandler?(dateTimeResponse)
      }
    dataTask.resume()
  }

}