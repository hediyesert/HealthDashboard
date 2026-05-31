import SwiftUI

struct DistanceAreaChartView: View {
    let values: [Double]

    private let lineColor = Color(red: 0.10, green: 0.98, blue: 0.50)
    private let glowColor = Color(red: 0.0, green: 1.0, blue: 0.42)

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
                            lineColor.opacity(0.78),
                            glowColor.opacity(0.32),
                            lineColor.opacity(0.02)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                curve
                    .stroke(glowColor, style: StrokeStyle(lineWidth: 6.5, lineCap: .round, lineJoin: .round))
                    .blur(radius: 5)
                    .opacity(0.45)

                curve
                    .stroke(lineColor, style: StrokeStyle(lineWidth: 2.6, lineCap: .round, lineJoin: .round))
            }
            .shadow(color: glowColor.opacity(0.55), radius: 10, x: 0, y: 0)
        }
        .frame(height: 84)
    }

    private func normalizedPoints(in size: CGSize) -> [CGPoint] {
        guard !values.isEmpty else { return [] }

        let minV = values.min() ?? 0
        let maxV = values.max() ?? 1
        let range = max(maxV - minV, 0.5)
        let paddingX: CGFloat = 4
        let paddingY: CGFloat = 10
        let usableW = size.width - paddingX * 2
        let usableH = size.height - paddingY * 2

        return values.enumerated().map { index, value in
            let x = paddingX + usableW * CGFloat(index) / CGFloat(values.count - 1)
            let normalized = (value - minV) / range
            let y = size.height - paddingY - usableH * CGFloat(normalized)
            return CGPoint(x: x, y: y)
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
        let extended = [points.first!, points.first!] + points + [points.last!, points.last!]

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
