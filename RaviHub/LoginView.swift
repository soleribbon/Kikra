//
//  LoginView.swift
//  RaviHub
//
//  Created by Ravi  on 3/27/23.
//

import SwiftUI

import AuthenticationServices

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            HStack{
                Text("Kikra")
                    .fontWeight(.bold)
                    .font(Font.custom("IBMPlexSansHebrew-Bold", size: 50))
                
                Spacer()
                
                .font(Font.custom("IBMPlexSansHebrew-Regular", size: 12))
                .foregroundColor(.gray)
                
                
            }.padding(20)
            Spacer()
            Image(colorScheme == .dark ? "LOGINLOGODARK" : "LOGINLOGOLIGHT")
                .resizable()
                .scaledToFit()
            
            Text("Reliable sales tracking at your fingertips") .font(Font.custom("IBMPlexSansHebrew-Bold", size: 25))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            
            ZStack {
                Image("LOGINBOTTOM")
                    .resizable()
                    .ignoresSafeArea()
                    .frame(minHeight: 0, maxHeight: .infinity)
                
                VStack {
                    Spacer()
                    SignInWithAppleButton(
                        onRequest: { request in
                            print(request)
                        },
                        onCompletion: { result in
                            print(result)
                        }
                    )
                    .frame(width: UIScreen.main.bounds.size.width * 0.7, height: UIScreen.main.bounds.size.height * 0.07)
                    .cornerRadius(50)
                    .signInWithAppleButtonStyle(colorScheme == .light ? .white : .black)
                    Spacer().frame(height: 100)
                
                }
                
                   

            
            }

        }.background(.orange)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
