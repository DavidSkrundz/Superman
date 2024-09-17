import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxMacros

@main
struct SupermanPlugin: CompilerPlugin {
	let providingMacros: [Macro.Type] = [
		SuperFirstMacro.self,
		SuperLastMacro.self,
	]
}

public struct SuperFirstMacro: BodyMacro {
	public static func expansion(of node: AttributeSyntax,
								 providingBodyFor declaration: some DeclSyntaxProtocol & WithOptionalCodeBlockSyntax,
								 in context: some MacroExpansionContext) throws -> [CodeBlockItemSyntax] {
		// Only allow Functions
		guard let funcDecl = declaration.as(FunctionDeclSyntax.self) else {
			throw Error.message("@SuperFirst only works on functions")
		}

		// Only allow Void Functions
		guard funcDecl.signature.returnClause?.type.as(IdentifierTypeSyntax.self)?.name.text != "Void" else {
			throw Error.message("@SuperFirst only works on Void functions")
		}

		// Requires Function Body
		guard let funcBody = funcDecl.body else {
			throw Error.message("@SuperFirst only works on functions with bodies")
		}

		let arguments = funcDecl.signature.parameterClause.parameters
		let callArgs = arguments.map { argument in
			"\(argument.firstName): \(argument.secondName ?? argument.firstName)"
		}.joined(separator: ", ")

		return ["super.\(funcDecl.name)(\(raw: callArgs))"] + Array(funcBody.statements)
	}
}

public struct SuperLastMacro: BodyMacro {
	public static func expansion(of node: AttributeSyntax,
								 providingBodyFor declaration: some DeclSyntaxProtocol & WithOptionalCodeBlockSyntax,
								 in context: some MacroExpansionContext) throws -> [CodeBlockItemSyntax] {
		// Only allow Functions
		guard let funcDecl = declaration.as(FunctionDeclSyntax.self) else {
			throw Error.message("@SuperLast only works on functions")
		}

		// Requires Function Body
		guard let funcBody = funcDecl.body else {
			throw Error.message("@SuperLast only works on functions with bodies")
		}

		let arguments = funcDecl.signature.parameterClause.parameters
		let callArgs = arguments.map { argument in
			"\(argument.firstName): \(argument.secondName ?? argument.firstName)"
		}.joined(separator: ", ")

		return Array(funcBody.statements) + ["return super.\(funcDecl.name)(\(raw: callArgs))"]
	}
}
