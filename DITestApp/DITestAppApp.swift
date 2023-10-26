//
//  DITestAppApp.swift
//  DITestApp
//
//  Created by Richard Bergoin on 26/10/2023.
//

import DependencyInjection
import SwiftUI

@main
struct DITestAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

protocol SomeDepencyProtocol {}

// @Injectable // cannot still do extension with Peer Macro (see 
class SomeDepency: SomeDepencyProtocol {}

@Inject({ SomeDepency() as SomeDepencyProtocol })
extension InjectedValues {}
