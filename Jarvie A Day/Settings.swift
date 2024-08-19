import SwiftUI
import UserNotifications

struct SettingsView: View {
    @State private var selectedTime: Date = Date()
    
    @AppStorage("dailyNoti") private var dailyNoti: Bool = true
    @AppStorage("selectedTime") private var storedTime: Double = Date().timeIntervalSince1970
    
    init() {
        let initialTime = Date(timeIntervalSince1970: storedTime)
        _selectedTime = State(initialValue: initialTime)
    }
    
    var body: some View {
        VStack {
            Text("Settings").bold().font(.system(size: 40))
            
            Toggle("Daily Notifications", isOn: $dailyNoti) .onChange(of: dailyNoti) {
                if !dailyNoti {
                    // Remove any existing queued notifications
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                }
            }
            
            if dailyNoti {
                DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .onChange(of: selectedTime) {
                        
                        storedTime = selectedTime.timeIntervalSince1970
                        scheduleNotification(for: selectedTime, keepExisting: false, title: "Jarvie says", body: "\"It's time to check on my daily picture!\"")
                    }
            }
            
            Spacer()
        }
        .padding(20)
        .navigationTitle("Settings")
    }
    
    private func scheduleNotification(for date: Date, keepExisting: Bool, title: String, body: String) {
        
        if (!keepExisting) {
            // Remove existing notifications
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        // Create notification
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // Add it to the notification queue
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
