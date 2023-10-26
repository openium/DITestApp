@attached(member, names: arbitrary)
public macro Inject<T>(_: () -> T) = #externalMacro(module: "DependencyInjectionMacroImpl", type: "InjectMemberMacro")
