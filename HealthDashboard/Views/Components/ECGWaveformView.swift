import SwiftUI

/// Referans görseldeki neon EKG çizgisi — Canvas ile keskin QRS spike'ları
struct ECGWaveformView: View {
    private let lineCore = Color(red: 1.0, green: 0.26, blue: 0.36)
    private let lineHot = Color(red: 1.0, green: 0.14, blue: 0.30)
    private let baselineColor = Color(red: 1.0, green: 0.22, blue: 0.32)

    /// Tek kalp atımı: düz çizgi → P → QRS spike → T → dinlenme
    private static let heartbeat: [CGFloat] = [
        0.50, 0.50, 0.50, 0.50,
        0.508, 0.528, 0.548, 0.532, 0.50,
        0.478, 0.438, 0.498, 0.97, 0.26, 0.42, 0.498, 0.50,
        0.518, 0.558, 0.618, 0.592, 0.548, 0.518, 0.50,
        0.50, 0.50, 0.50, 0.50, 0.50
    ]

    private var samples: [CGFloat] {
        Array(repeating: Self.heartbeat, count: 5).flatMap { $0 }
    }

    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            let midY = size.height * 0.54
            let points = plotPoints(in: size, midY: midY)
            let waveform = linePath(through: points)

            ZStack {
                RadialGradient(
                    colors: [
                        lineHot.opacity(0.38),
                        lineHot.opacity(0.14),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 4,
                    endRadius: max(size.width, size.height) * 0.62
                )

                Path { path in
                    path.move(to: CGPoint(x: 0, y: midY))
                    path.addLine(to: CGPoint(x: size.width, y: midY))
                }
                .stroke(baselineColor.opacity(0.28), lineWidth: 0.9)

                waveform
                    .stroke(lineHot, style: StrokeStyle(lineWidth: 8, lineCap: .butt, lineJoin: .miter))
                    .blur(radius: 8)
                    .opacity(0.5)

                waveform
                    .stroke(lineHot, style: StrokeStyle(lineWidth: 4.2, lineCap: .butt, lineJoin: .miter))
                    .blur(radius: 3)
                    .opacity(0.88)

                waveform
                    .stroke(lineCore, style: StrokeStyle(lineWidth: 1.7, lineCap: .square, lineJoin: .miter))
            }
        }
        .frame(height: 78)
    }

    private func plotPoints(in size: CGSize, midY: CGFloat) -> [CGPoint] {
        let amplitude = size.height * 0.44
        let count = samples.count
        let xStep = size.width / CGFloat(count - 1)

        return samples.enumerated().map { index, value in
            CGPoint(
                x: CGFloat(index) * xStep,
                y: midY - (value - 0.5) * amplitude * 2
            )
        }
    }

    private func linePath(through points: [CGPoint]) -> Path {
        var path = Path()
        guard let first = points.first else { return path }
        path.move(to: first)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        return path
    }
}
