import SwiftSyntax
import SwiftSyntaxMacros

public enum InjectMemberMacro: MemberMacro {

    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        guard let arguments = node.arguments?.as(LabeledExprListSyntax.self) else {
            throw CustomError.message("@Inject the macro does not have any arguments")
        }
        guard let arg1 = arguments.first?.as(LabeledExprSyntax.self),
              let closure = arg1.expression.as(ClosureExprSyntax.self),
              let firstStatement = closure.statements.first,
              let asStatement = firstStatement.item.as(AsExprSyntax.self)
        else {
            throw CustomError.message("@Inject macro should have a closure argument like { Some() as SomeProtocol }")
        }
        var className = ""
        if let theClassName = asStatement.expression.as(MemberAccessExprSyntax.self)?.base {
            className = "\(theClassName)"
        } else if let funcCall = asStatement.expression.as(FunctionCallExprSyntax.self),
                  let theClassName = funcCall.calledExpression.as(DeclReferenceExprSyntax.self)?.baseName {
            className = "\(theClassName)"
        } else {
            throw CustomError.message("@Inject unable to find class name in the first part of as statement")
        }

        let injectedVarName = "\(className)".firstLowercased

        let member = DeclSyntax(
        """
        private struct \(raw: className)Key: InjectionKey {

            static var currentValue: \(raw: asStatement.type)= \(raw: asStatement.expression)
        }

        public var \(raw: injectedVarName): \(raw: asStatement.type){
            get { Self[\(raw: className)Key.self] }
            set { Self[\(raw: className)Key.self] = newValue }
        }
        """
        )
        return [member]
    }
}

extension StringProtocol {
    
    var firstLowercased: String { prefix(1).lowercased() + dropFirst() }
}

enum CustomError: Error, CustomStringConvertible {
    case message(String)
    
    var description: String {
        switch self {
        case .message(let text):
            return text
        }
    }
}
