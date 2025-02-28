import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5

    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Image(systemName: "book.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                    Text("Dzienniczek")
                        .font(Font.custom("Baskerville-Bold", size: 26))
                        .foregroundColor(.white)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.00
                    }
                }
                VStack {
                    Spacer()
                    Text("Stworzone przez: Marcin Seńko")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
