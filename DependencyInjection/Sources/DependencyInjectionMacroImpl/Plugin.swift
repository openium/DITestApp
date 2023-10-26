#if canImport(SwiftCompilerPlugin)
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct Plugin: CompilerPlugin {

    let providingMacros: [Macro.Type] = [
        InjectMemberMacro.self
    ]
}
#endif
