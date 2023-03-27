//
//  RaviHubApp.swift
//  RaviHub
//
//  Created by Ravi  on 3/22/23.
//

import SwiftUI

@main
struct RaviHubApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(StoreViewModel())
        }
    }
}

public struct Fonts {

    public static func ibmRegular(size: CGFloat) -> Font {
        return Font.custom("IBMPlexSansHebrew-Regular", size: size)
    }

    public static func ibmBold(size: CGFloat) -> Font {
        return Font.custom("IBMPlexSansHebrew-Bold", size: size)
    }

    public static func ibmSemiBold(size: CGFloat) -> Font {
        return Font.custom("IBMPlexSansHebrew-SemiBold", size: size)
    }
}



struct Previews_RaviHubApp_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Kikra")    .font(Font.custom("IBMPlexSansHebrew", size: 60))
                .fontWeight(.bold)
            
            Text("Kikra")
                .font(.custom("SF Display", size: 60))

        }
        
            

    }
}
