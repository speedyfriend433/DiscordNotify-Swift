import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var notificationTitle = ""
    @State private var notificationBody = ""

    var body: some View {
        VStack {
            TextField("Notification Title", text: $notificationTitle)
                .padding()

            TextField("Notification Body", text: $notificationBody)
                .padding()

            Button("Show Notification") {
                requestNotificationAuthorization()
            }
            .padding()
        }
    }

    private func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if success {
                scheduleNotification()
            } else if let error = error {
                print("Error requesting notification authorization: \(error)")
            }
        }
    }

    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.body = notificationBody
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}