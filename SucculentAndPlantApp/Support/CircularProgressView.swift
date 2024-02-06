import SwiftUI

enum CircularProgressViewSize { case small, large }

struct CircularProgressView: View {
    let progress: Double
    let color: Color
    let size: CircularProgressViewSize
    let showProgress: Bool
    var animationDuration: Double = 1.0  // Duration for animation

    @State private var animatedProgress: CGFloat = 0

    var body: some View {
        ZStack {
            if showProgress {
                Text("\(String(format: "%.\(size == .large ? "2" : "0")f", animatedProgress * 100))%")
                    .font(size == .large ? .title3.bold() : .caption.bold())
                    .foregroundColor(color)
            }
            
            Circle()
                .stroke(
                    color.opacity(0.5),
                    lineWidth: size == .large ? 22.0 : 12.0
                )
            
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: size == .large ? 22.0 : 12.0,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: animationDuration / 100, repeats: true) { timer in
                        if animatedProgress < CGFloat(progress) {
                            animatedProgress += CGFloat(progress) / 100
                        } else {
                            timer.invalidate()
                        }
                    }
                }
        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.69, color: Color(uiColor: .systemGreen), size: .small, showProgress: true)
            .frame(width: 50, height: 50)
    }
}
