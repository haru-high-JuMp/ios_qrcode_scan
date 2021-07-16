//
//  UserInit.swift
//  CodeScan
//
//  Created by Haruki Mori on 2021/04/20.
//

import SwiftUI
import MessageUI

struct UserInit: View {
    
    @ObservedObject var initi = Init()
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("自身の社内メールアドレス")) {
                    TextField("自身の社内メールを入力してください！", text: $initi.useremail)
                }
                Section(header: Text("組長のメールアドレス")) {
                    TextField("組長の社内メールを入力してください！", text: $initi.GLemail)
                }
                Section(header: Text("両TLのメールアドレス")) {
                    TextField("TLの社内メールを入力してください！", text: $initi.TL1email)
                    TextField("TLの社内メールを入力してください！", text: $initi.TL2email)
                }
                /*
                Section {
                    Button(action: {
                        if MFMailComposeViewController.canSendMail() {
                            self.isShowingMailView.toggle()
                            
                        } else {
                            print("Can't send emails from this device")
                        }
                        if result != nil {
                            print("Result: \(String(describing: result))")
                        }
                    }) {
                        HStack {
                            Image(systemName: "envelope")
                            Text("結果を送信")
                        }
                    }
                    //.disabled(!MFMailComposeViewController.canSendMail())
                    .sheet(isPresented: $isShowingMailView) {
                        MailView(result: $result) { composer in
                            composer.setSubject("備品管理")
                            composer.setToRecipients([initi.useremail])
                            composer.setCcRecipients([initi.GLemail, initi.TL1email, initi.TL2email])
                        }
                    }
                }
                */
            }
            .navigationBarTitle("Home")
        }
    }
}

struct UserInit_Previews: PreviewProvider {
    static var previews: some View {
        UserInit()
    }
}
