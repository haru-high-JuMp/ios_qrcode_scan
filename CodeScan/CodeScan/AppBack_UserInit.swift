//
//  AppBack_UserInit.swift
//  CodeScan
//
//  Created by Haruki Mori on 2021/04/20.
//

import SwiftUI

class Init: ObservableObject {
    @Published var useremail: String {
        didSet {
            UserDefaults.standard.set(useremail, forKey: "useremail")
        }
    }

    @Published var GLemail: String {
        didSet {
            UserDefaults.standard.set(GLemail, forKey: "GLemail")
        }
    }
    
    @Published var TL1email: String {
        didSet {
            UserDefaults.standard.set(TL1email, forKey: "TL1email")
        }
    }
    
    @Published var TL2email: String {
        didSet {
            UserDefaults.standard.set(TL2email, forKey: "TL2email")
        }
    }
    
    init() {
        useremail = UserDefaults.standard.string(forKey: "useremail") ?? ""
        GLemail = UserDefaults.standard.string(forKey: "GLemail") ?? ""
        TL1email = UserDefaults.standard.string(forKey: "TL1email") ?? ""
        TL2email = UserDefaults.standard.string(forKey: "TL2email") ?? ""
    }
}
