#  Generate Swift models and Service protocols from Protocol Buffer definition files focusing on the PORN (Protobuf + ObjectMapper + Realm + NSURLSession) stack.

This is a work in progress with the goal to offer Swift developers a lightweight option in getting the same benefits other platforms enjoy.

I started wanting to utilize the Protobuf + ObjectMapper + Realm + NSURLSession stack and generating the code around that to support it.  However each of these can be disabled independently.

Major Goals:

1. Generate Swift models that utilize the frameworks and libraries developers are already relying on such as Realm for database persistence, ObjectMapper for serialization and NSURLSession for networking.
2. Generate the service layer in form of a protocol that can be implemented and utilize the Request/Response models and filling in your own networking stack.
3. Turn any of the dependency features off for people who are not using them.


Take a proto definition such as
```
message Point {
  required int32 x = 1;
  required int32 y = 2;
  optional string label = 3;
}

message Line {
  required Point start = 1;
  required Point end = 2;
  optional string label = 3;
}

message Polyline {
  repeated Line line = 1;
  optional string label = 2;
}
```

and generate Swift code.

`$ ./generate.rb model test/test.proto`
```
// Autogenerated code from test/test.proto on Mon, July 04 2016.  DO NOT EDIT!

import Foundation
import RealmSwift
import ObjectMapper

class Point: object {
  dynamic var x: Int?
  dynamic var y: Int?
  dynamic var label: String?

  func mapping(map: Map) {
    x <- map["x"]
    y <- map["y"]
    label <- map["label"]
  }


  required convenience init?(_ map: Map) {
    self.init()
  }

}

class Line: object {
  dynamic var start: Point?
  dynamic var end: Point?
  dynamic var label: String?

  func mapping(map: Map) {
    start <- map["start"]
    end <- map["end"]
    label <- map["label"]
  }


  required convenience init?(_ map: Map) {
    self.init()
  }

}

class Polyline: object {
  dynamic var line: [Line]?
  dynamic var label: String?

  func mapping(map: Map) {
    line <- map["line"]
    label <- map["label"]
  }


  required convenience init?(_ map: Map) {
    self.init()
  }

}

```

And render a Swift protocol from a proto service definition.

```
syntax = "proto2";

// The greeter service definition.
service Greeter {
  // Sends a greeting
  rpc SayHello (HelloRequest) returns (HelloReply) {}
}

// The request message containing the user's name.
message HelloRequest {
  optional string name = 1;
}

// The response message containing the greetings
message HelloReply {
  optional string message = 1;
}

```
`$ ./generate.rb service ./test/service.proto`

generates

```
protocol Greeter {
  func sayHello(request: HelloRequest, ((response: HelloReply -> Void)?) = nil)
}
```


### Command Line Help
```
$ ./generate.rb
Commands:
  generate.rb help [COMMAND]         # Describe available commands or one specific command
  generate.rb model message.proto    # Generate Swift code from proto(s)
```

```
Usage:
  generate.rb model message.proto

Options:
  [--realm], [--no-realm]                # Enable generating models as a Realm object
                                         # Default: true
  [--objectmapper], [--no-objectmapper]  # Enable ObjectMapper deserialization
                                         # Default: true
  [--swiftpath=SWIFTPATH]                # Where Swift files should be generated
                                         # Default: ./swift
```

```
Usage:
  generate.rb service service.proto

Options:
  [--swiftpath=SWIFTPATH]  # Where Swift files should be generated
                           # Default: ./swift

Generate a Swift protocol from a service proto
```
