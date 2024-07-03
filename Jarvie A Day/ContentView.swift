//
//  ContentView.swift
//  Jarvie A Day
//
//  Created by Aiden Johnson on 7/3/24.
//

import SwiftUI

struct ContentView: View {
    @State private var Start: Bool = false
    @State private var Shaken: Bool = false
    
    @State private var CenterImage: String = "Gift Box"
    @State private var ImageOpacity = 1
    
    @State private var ButtonOpacity = 1
    
    @State private var ConfettiCount = 0
    
    var body: some View {
        VStack(spacing: 10, content: {
            Text("Jarvie A Day").bold().font(.system(size: 40))
            
            Spacer()
            
            Image(CenterImage)
                .resizable()
                .frame(width: 240, height: 240)
                .scaledToFit()
                .padding(40)
                .shadow(radius: 22)
                .offset(x: Start ? 30 : 0)
                .opacity(Double(ImageOpacity))
                
            Spacer()
            
            Button("Open") {
                
            }
            .foregroundColor(.white)
            .background(.blue)
            .cornerRadius(16.0)
        })
    }
}

#Preview {
    ContentView()
}
