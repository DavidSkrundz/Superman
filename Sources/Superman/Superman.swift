@attached(body)
public macro SuperFirst() = #externalMacro(module: "SupermanMacros", type: "SuperFirstMacro")

@attached(body)
public macro SuperLast() = #externalMacro(module: "SupermanMacros", type: "SuperLastMacro")
