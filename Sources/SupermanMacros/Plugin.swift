import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SupermanPlugin: CompilerPlugin {
	let providingMacros: [Macro.Type] = [
		SuperMacro.self,
	]
}
