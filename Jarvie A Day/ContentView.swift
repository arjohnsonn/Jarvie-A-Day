//
//  ContentView.swift
//  Jarvie A Day
//
//  Created by Aiden Johnson on 7/3/24.
//

import SwiftUI
import ConfettiSwiftUI
import UserNotifications

struct ContentView: View {
    @State private var start: Bool = false
    @State private var shaken: Bool = false
    @State private var isShaking: Bool = false
    
    @State private var centerImage: String = "Gift Box"
    @State private var imageOpacity = 1
    @State private var buttonOpacity = 1
    
    @State private var confettiCount = 0
    
    @State private var displayAlert: Bool = false
    
    static var maxImages = 2
    let images = (1...maxImages).map { String($0) }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10, content: {
                Text("Jarvie A Day").bold().font(.system(size: 40))
                
                Spacer()
                
                Image(centerImage)
                    .resizable()
                    .frame(width: 240, height: 240)
                    .scaledToFit()
                    .padding(40)
                    .shadow(radius: 22)
                    .offset(x: start ? 30 : 0)
                    .opacity(Double(imageOpacity))
                    .offset(x: isShaking ? 20 : 0)
                    .confettiCannon(counter: $confettiCount, num: 100)
                    
                Spacer()
                
                Button("Open") {
                    reveal()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(24.0)
                .bold()
                .font(.system(size: 25))
                .opacity(Double(buttonOpacity))
            }
            )
            .navigationBarItems(trailing: NavigationLink(destination: SettingsView()) {
                Image(systemName: "gear")
                    .imageScale(.large)
            })
        }
        .onAppear {
            requestNotificationAuthorization()
        }
        .alert(isPresented: $displayAlert) {
            Alert(
                title: Text("Notice"),
                message: Text("Please re-enable notifications in Settings to receive daily notifications."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func reveal() {
        openPress()
    }
    
    func changeImage() {
        if let randomImage = images.randomElement() {
            centerImage = randomImage
        }
    }
    
    public func requestNotificationAuthorization() {
        // Ask for notification permissions
           UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
               
               if let error = error {
                   print("Error requesting notification authorization: \(error.localizedDescription)")
               }
               
               if !granted {
                   displayAlert = true
               }
           }
       }
    
    func openPress() {
        withAnimation(Animation.linear(duration: 0.1).repeatCount(40, autoreverses: true)) {
            isShaking = true
          }
          
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(Animation.linear(duration: 2.0)) {
                imageOpacity = 0
                buttonOpacity = 0
            }
        }
          
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isShaking = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            changeImage()
            
            withAnimation(Animation.linear(duration: 0.5)) {
                imageOpacity = 1
            }
            
            confettiCount += 1
        }
    }
}

#Preview {
    ContentView()
}
