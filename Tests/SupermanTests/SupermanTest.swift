import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(SupermanMacros)
import SupermanMacros

let testMacros: [String: Macro.Type] = [
	"Super": SuperMacro.self,
]

final class QSLibsTests: XCTestCase {
	func testSuper() throws {
		assertMacroExpansion("""
@Super
func function() {
    #super
    print()
    return #super()
}
""",
							 expandedSource: """
func function() {
    super.function()
    print()
    return super.function()
}
""",
							 macros: testMacros)
	}

	func testSuperArgs() throws {
		assertMacroExpansion("""
@Super
func function(_ b: Bool, i: Int, double d: Double) {
    #super
    #super(true)
    #super(false, i: 5)
    #super(double: 3.3)
    #super(true, i: 7, double: 9.9)
    print()
    return #super()
}
""",
							 expandedSource: """
func function(_ b: Bool, i: Int, double d: Double) {
    super.function(_ : b, i: i, double : d)
    super.function(_ : true, i: i, double : d)
    super.function(_ : false, i: 5, double : d)
    super.function(_ : b, i: i, double : 3.3)
    super.function(_ : true, i: 7, double : 9.9)
    print()
    return super.function(_ : b, i: i, double : d)
}
""",
							 macros: testMacros)
	}
}

#endif
