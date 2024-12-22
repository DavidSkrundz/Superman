import SwiftSyntax
import SwiftSyntaxMacros
@_spi(ExperimentalLanguageFeatures)
import SyntaxEditor

public struct SuperMacro: BodyMacro {
	public static func expansion(of node: AttributeSyntax,
								 providingBodyFor declaration: some DeclSyntaxProtocol & WithOptionalCodeBlockSyntax,
								 in context: some MacroExpansionContext) throws -> [CodeBlockItemSyntax] {
		// Only allow Functions
		guard let funcDecl = declaration.as(FunctionDeclSyntax.self) else {
			throw Error.message("@Super only works on functions")
		}

		// Requires Function Body
		guard let funcBody = funcDecl.body else {
			throw Error.message("@Super only works on functions with bodies")
		}

		// Compute super call properties
		let funcArgs = funcDecl.signature.parameterClause.parameters
		let callArgs = funcArgs.map { argument in
			"\(argument.firstName): \(argument.secondName ?? argument.firstName)"
		}.joined(separator: ", ")
		let superSyntax: CodeBlockItemSyntax = "super.\(funcDecl.name)(\(raw: callArgs))"

		// Generate super call expression
		let superCall: FunctionCallExprSyntax
		switch superSyntax.item {
			case .expr(let expr):
				switch expr.as(ExprSyntaxEnum.self) {
					case .functionCallExpr(let functionCallExpr): superCall = functionCallExpr
					default: throw Error.message("@Super failed to create FunctionCallExprSyntax")
				}
			default: throw Error.message("@Super failed to create CodeBlockItemSyntax")
		}

		// Apply @Super transformation
		return Array(try VisitCodeBlock(superCall, funcBody).statements)
	}
}

extension SuperMacro: SyntaxEditor {
	public typealias Context = FunctionCallExprSyntax

	public static func VisitExpr(_ ctx: Context, _ syn: ExprSyntax) throws -> ExprSyntax {
		switch syn.as(ExprSyntaxEnum.self) {
			case .macroExpansionExpr(let syn):
				return try MapMacroExpansionExpr(ctx, syn)
			default:
				return try WalkExpr(ctx, syn)
		}
	}
}

extension SuperMacro {
	static func MapMacroExpansionExpr(_ ctx: Context, _ syn: MacroExpansionExprSyntax) throws -> ExprSyntax {
		guard syn.macroName.text == "super" else { return ExprSyntax(syn) }

		var funcIndex = ctx.arguments.startIndex
		let funcEnd = ctx.arguments.endIndex
		var macroIndex = syn.arguments.startIndex
		let macroEnd = syn.arguments.endIndex

		var newArgs = [LabeledExprSyntax]()
		while (funcIndex != funcEnd) && (macroIndex != macroEnd) {
			let funcArg = ctx.arguments[funcIndex]
			let macroArg = syn.arguments[macroIndex]

			var newArg = funcArg
			if funcArg.label?.tokenKind ?? .wildcard == macroArg.label?.tokenKind ?? .wildcard {
				newArg.expression = macroArg.expression
				funcIndex = ctx.arguments.index(after: funcIndex)
				macroIndex = syn.arguments.index(after: macroIndex)
			} else {
				funcIndex = ctx.arguments.index(after: funcIndex)
			}
			newArgs.append(newArg)
		}
		while funcIndex != funcEnd {
			let funcArg = ctx.arguments[funcIndex]
			newArgs.append(funcArg)
			funcIndex = ctx.arguments.index(after: funcIndex)
		}

		if macroIndex != funcEnd {
			throw Error.message("Too many arguments given to #super()")
		}

		var newFunc = ctx
		newFunc.arguments = LabeledExprListSyntax(newArgs)
		return ExprSyntax(newFunc)
	}
}
