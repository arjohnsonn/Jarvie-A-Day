import SwiftUI
import UserNotifications

struct SettingsView: View {
    @State private var selectedTime: Date = Date()
    
    @AppStorage("selectedTime") private var storedTime: Double = Date().timeIntervalSince1970
    
    init() {
        requestNotificationAuthorization()
        
        let initialTime = Date(timeIntervalSince1970: storedTime)
        _selectedTime = State(initialValue: initialTime)
    }
    
    var body: some View {
        VStack {
            Text("Settings").bold().font(.system(size: 40))
            
            DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .onChange(of: selectedTime) {
                    print(selectedTime)
                    storedTime = selectedTime.timeIntervalSince1970
                    scheduleNotification(for: selectedTime)
                }
            
            Spacer()
        }
        .padding(20)
        .navigationTitle("Settings")
    }
    
    private func requestNotificationAuthorization() {
           UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
               if let error = error {
                   print("Error requesting notification authorization: \(error.localizedDescription)")
               }
           }
       }
    
    private func scheduleNotification(for date: Date) {
        // Remove any existing notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Jarvie says"
        content.body = "\"It's time to check on my daily picture!\""
        content.sound = .default
        
        // Create a trigger based on the selected time
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
