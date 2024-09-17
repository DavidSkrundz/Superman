import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(SupermanMacros)
import SupermanMacros

let testMacros: [String: Macro.Type] = [
	"SuperFirst": SuperFirstMacro.self,
	"SuperLast": SuperLastMacro.self,
]

final class QSLibsTests: XCTestCase {
	func testSuperFirst() throws {
		assertMacroExpansion("""
@SuperFirst
func function() {
    print()
}
""",
							 expandedSource: """
func function() {
    super.function()
    print()
}
""",
							 macros: testMacros)
	}

	func testSuperLast() throws {
		assertMacroExpansion("""
@SuperLast
func function() {
    print()
}
""",
							 expandedSource: """
func function() {
    print()
    return super.function()
}
""",
							 macros: testMacros)
	}

	func testSuperFirstArgs() throws {
		assertMacroExpansion("""
@SuperFirst
func function(_ b: Bool, i: Int, double d: Double) {
    print()
}
""",
							 expandedSource: """
func function(_ b: Bool, i: Int, double d: Double) {
    super.function(_ : b, i: i, double : d)
    print()
}
""",
							 macros: testMacros)
	}

	func testSuperLastArgs() throws {
		assertMacroExpansion("""
@SuperLast
func function(_ b: Bool, i: Int, double d: Double) {
    print()
}
""",
							 expandedSource: """
func function(_ b: Bool, i: Int, double d: Double) {
    print()
    return super.function(_ : b, i: i, double : d)
}
""",
							 macros: testMacros)
	}
}

#endif
