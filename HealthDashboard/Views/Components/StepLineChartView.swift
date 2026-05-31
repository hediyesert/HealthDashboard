import SwiftUI

struct StepLineChartView: View {
    let values: [Double]

    private let gradientColors: [Color] = [
        Color(red: 1.0, green: 0.82, blue: 0.18),
        Color(red: 1.0, green: 0.58, blue: 0.14),
        Color(red: 1.0, green: 0.32, blue: 0.48),
        Color(red: 0.82, green: 0.28, blue: 1.0),
        Color(red: 0.28, green: 0.62, blue: 1.0),
        Color(red: 0.22, green: 0.88, blue: 0.98),
        Color(red: 0.28, green: 0.95, blue: 0.55)
    ]

    var body: some View {
        GeometryReader { geo in
            let points = normalizedPoints(in: geo.size)
            let smooth = catmullRomSpline(points: points, samplesPerSegment: 14)
            let curve = linePath(through: smooth)
            let fill = areaPath(line: smooth, height: geo.size.height)

            ZStack {
                fill.fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.4, green: 0.7, blue: 1.0).opacity(0.22),
                            Color(red: 0.6, green: 0.3, blue: 0.9).opacity(0.06),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                curve
                    .stroke(
                        LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round)
                    )
                    .blur(radius: 4)
                    .opacity(0.4)

                curve
                    .stroke(
                        LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing),
                        style: StrokeStyle(lineWidth: 3.2, lineCap: .round, lineJoin: .round)
                    )

                ForEach(Array(points.enumerated()), id: \.offset) { index, point in
                    let ringColor = color(at: CGFloat(index) / CGFloat(max(points.count - 1, 1)))

                    Circle()
                        .fill(Color.white)
                        .frame(width: 9, height: 9)
                        .overlay(
                            Circle()
                                .stroke(ringColor, lineWidth: 2.2)
                        )
                        .position(point)
                }
            }
        }
        .frame(height: 92)
    }

    private func normalizedPoints(in size: CGSize) -> [CGPoint] {
        guard !values.isEmpty else { return [] }

        let minV = values.min() ?? 0
        let maxV = values.max() ?? 1
        let range = max(maxV - minV, 1)
        let paddingX: CGFloat = 6
        let paddingY: CGFloat = 14
        let usableW = size.width - paddingX * 2
        let usableH = size.height - paddingY * 2

        return values.enumerated().map { index, value in
            let x = paddingX + usableW * CGFloat(index) / CGFloat(values.count - 1)
            let normalized = (value - minV) / range
            let y = size.height - paddingY - usableH * CGFloat(normalized)
            return CGPoint(x: x, y: y)
        }
    }

    private func color(at progress: CGFloat) -> Color {
        let clamped = min(max(progress, 0), 1)
        let scaled = clamped * CGFloat(gradientColors.count - 1)
        let lower = Int(floor(scaled))
        let upper = min(lower + 1, gradientColors.count - 1)
        let fraction = scaled - CGFloat(lower)
        return blend(gradientColors[lower], gradientColors[upper], fraction: fraction)
    }

    private func blend(_ a: Color, _ b: Color, fraction: CGFloat) -> Color {
        let uiA = UIColor(a)
        let uiB = UIColor(b)
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        uiA.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        uiB.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        let t = fraction
        return Color(
            red: Double(r1 + (r2 - r1) * t),
            green: Double(g1 + (g2 - g1) * t),
            blue: Double(b1 + (b2 - b1) * t)
        )
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

    private func areaPath(line: [CGPoint], height: CGFloat) -> Path {
        var path = linePath(through: line)
        guard let last = line.last, let first = line.first else { return path }
        path.addLine(to: CGPoint(x: last.x, y: height))
        path.addLine(to: CGPoint(x: first.x, y: height))
        path.closeSubpath()
        return path
    }

    private func catmullRomSpline(points: [CGPoint], samplesPerSegment: Int) -> [CGPoint] {
        guard points.count >= 2 else { return points }

        var result: [CGPoint] = []
        let extended = [
            points.first!,
            points.first!
        ] + points + [
            points.last!,
            points.last!
        ]

        for index in 1..<(extended.count - 2) {
            let p0 = extended[index - 1]
            let p1 = extended[index]
            let p2 = extended[index + 1]
            let p3 = extended[index + 2]

            for step in 0..<samplesPerSegment {
                let t = CGFloat(step) / CGFloat(samplesPerSegment)
                result.append(catmullPoint(p0: p0, p1: p1, p2: p2, p3: p3, t: t))
            }
        }
        result.append(points.last!)
        return result
    }

    private func catmullPoint(p0: CGPoint, p1: CGPoint, p2: CGPoint, p3: CGPoint, t: CGFloat) -> CGPoint {
        let t2 = t * t
        let t3 = t2 * t

        let x = 0.5 * (
            (2 * p1.x) +
            (-p0.x + p2.x) * t +
            (2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x) * t2 +
            (-p0.x + 3 * p1.x - 3 * p2.x + p3.x) * t3
        )
        let y = 0.5 * (
            (2 * p1.y) +
            (-p0.y + p2.y) * t +
            (2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) * t2 +
            (-p0.y + 3 * p1.y - 3 * p2.y + p3.y) * t3
        )
        return CGPoint(x: x, y: y)
    }
}
