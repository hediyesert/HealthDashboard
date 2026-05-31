import Foundation

struct HealthDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

enum MetricChartStyle {
    case gradientLine
    case ecgWave
    case areaFill
}

struct MetricMockData {
    static func generateMockData(baseValue: Double, variance: Double, points: Int = 7) -> [HealthDataPoint] {
        let calendar = Calendar.current
        let now = Date()

        return (0..<points).map { index in
            let date = calendar.date(byAdding: .day, value: -index, to: now) ?? now
            let randomVariance = Double.random(in: -variance...variance)
            return HealthDataPoint(date: date, value: max(0, baseValue + randomVariance))
        }.reversed()
    }

    /// Referans görseldeki dalgalı adım eğrisi
    static func stepsTrend() -> [HealthDataPoint] {
        let values: [Double] = [8400, 7200, 9100, 7800, 10200, 8900, 12480]
        return datedPoints(values: values)
    }

    static func distanceTrend() -> [HealthDataPoint] {
        let values: [Double] = [3.8, 4.6, 5.4, 6.1, 7.0, 8.0, 9.1]
        return datedPoints(values: values)
    }

    static func ecgWaveform() -> [HealthDataPoint] {
        datedPoints(values: [68], intervalHours: 1)
    }

    private static func datedPoints(values: [Double], intervalHours: Int = 24) -> [HealthDataPoint] {
        let calendar = Calendar.current
        let now = Date()
        let count = values.count

        return values.enumerated().map { index, value in
            let offset = count - 1 - index
            let date = calendar.date(byAdding: .hour, value: -offset * intervalHours, to: now) ?? now
            return HealthDataPoint(date: date, value: value)
        }
    }
}
