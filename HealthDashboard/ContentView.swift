import SwiftUI

struct ContentView: View {
    var body: some View {
        // Uygulama açıldığında direkt olarak hazırladığımız Dashboard ekranı yüklenecek
        DashboardView()
    }
}

// Xcode Önizlemesi için
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
