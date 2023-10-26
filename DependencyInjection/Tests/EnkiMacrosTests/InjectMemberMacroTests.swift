//
//  InjectableExtensionMacroTests.swift
//  
//
//  Created by Richard Bergoin on 18/10/2023.
//

import DependencyInjectionMacroImpl
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class InjectMemberMacroTests: XCTestCase {

    private let macros = ["Inject": InjectMemberMacro.self]

    func testInject() {
        assertMacroExpansion(
            """
            public protocol ProvisionDeviceUseCaseProtocol: AnyObject {}
            public final class ProvisionDeviceUseCase: ProvisionDeviceUseCaseProtocol {}

            @Inject({ ProvisionDeviceUseCase() as ProvisionDeviceUseCaseProtocol })
            extension InjectedValues {}
            """,
        expandedSource:
            """
            public protocol ProvisionDeviceUseCaseProtocol: AnyObject {}
            public final class ProvisionDeviceUseCase: ProvisionDeviceUseCaseProtocol {}
            extension InjectedValues {

                private struct ProvisionDeviceUseCaseKey: InjectionKey {

                    static var currentValue: ProvisionDeviceUseCaseProtocol = ProvisionDeviceUseCase()
                }

                public var provisionDeviceUseCase: ProvisionDeviceUseCaseProtocol {
                    get { Self[ProvisionDeviceUseCaseKey.self] }
                    set { Self[ProvisionDeviceUseCaseKey.self] = newValue }
                }}
            """,
        macros: macros,
        indentationWidth: .spaces(4)
        )
    }

    func testInjectWithSingleton() {
        assertMacroExpansion(
            """
            public protocol ProvisionDeviceUseCaseProtocol: AnyObject {}
            public final class ProvisionDeviceUseCase: ProvisionDeviceUseCaseProtocol {
                static let shared = ProvisionDeviceUseCase()
            }

            @Inject({ ProvisionDeviceUseCase.shared as ProvisionDeviceUseCaseProtocol })
            extension InjectedValues {}
            """,
        expandedSource:
            """
            public protocol ProvisionDeviceUseCaseProtocol: AnyObject {}
            public final class ProvisionDeviceUseCase: ProvisionDeviceUseCaseProtocol {
                static let shared = ProvisionDeviceUseCase()
            }
            extension InjectedValues {

                private struct ProvisionDeviceUseCaseKey: InjectionKey {

                    static var currentValue: ProvisionDeviceUseCaseProtocol = ProvisionDeviceUseCase.shared
                }

                public var provisionDeviceUseCase: ProvisionDeviceUseCaseProtocol {
                    get { Self[ProvisionDeviceUseCaseKey.self] }
                    set { Self[ProvisionDeviceUseCaseKey.self] = newValue }
                }}
            """,
        macros: macros,
        indentationWidth: .spaces(4)
        )
    }

}
