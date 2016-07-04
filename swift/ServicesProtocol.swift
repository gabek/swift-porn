protocol Greeter {
  func sayHello(request: HelloRequest, ((response: HelloReply -> Void)?) = nil)
}