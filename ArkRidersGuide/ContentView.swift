import SwiftUI

struct ContentView: View {
    @State private var hasInitialized = false

    private let service: APIServiceProtocol

    init(service: APIServiceProtocol? = nil) {
        self.service = service ?? APIService()
    }

    var body: some View {
        if hasInitialized {
            MainTabView(service: service)
        } else {
            SplashView {
                withAnimation {
                    hasInitialized = true
                }
            }
        }
    }
}

#Preview {
    ContentView(service: MockAPIService())
}
