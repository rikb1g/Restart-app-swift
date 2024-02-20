//
//  ContentView.swift
//  Restart
//
//  Created by Ricardo Sousa on 01/02/2024.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("onbording") var isOnboardingViewActive: Bool = true
    var body: some View {
        ZStack{
            if isOnboardingViewActive{
                OnbordingView()
            }else {
                HomeView()
            }
        }
    }
}

#Preview {
    ContentView()
}
