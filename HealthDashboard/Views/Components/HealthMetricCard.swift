import SwiftUI

struct HealthMetricCard: View {
    let title: String
    let value: String
    let iconName: String
    let themeColor: Color
    let chartData: [HealthDataPoint]
    let chartStyle: MetricChartStyle
    let valueOnTrailing: Bool
    let unit: String

    init(
        title: String,
        value: String,
        iconName: String,
        themeColor: Color,
        chartData: [HealthDataPoint],
        chartStyle: MetricChartStyle,
        valueOnTrailing: Bool,
        unit: String = ""
    ) {
        self.title = title
        self.value = value
        self.iconName = iconName
        self.themeColor = themeColor
        self.chartData = chartData
        self.chartStyle = chartStyle
        self.valueOnTrailing = valueOnTrailing
        self.unit = unit
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: iconName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(themeColor)
                    .shadow(color: themeColor.opacity(0.5), radius: 4)

                Text(title)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(themeColor)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.35))
            }

            MetricChartView(
                data: chartData,
                themeColor: themeColor,
                style: chartStyle
            )
            .padding(.vertical, 4)

            HStack(alignment: .lastTextBaseline, spacing: 4) {
                if valueOnTrailing { Spacer() }

                Text(value)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(themeColor)
                    .shadow(color: themeColor.opacity(0.7), radius: 12, x: 0, y: 0)

                if !unit.isEmpty {
                    Text(unit)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(themeColor.opacity(0.62))
                }

                if !valueOnTrailing { Spacer() }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            themeColor.opacity(0.35),
                            Color.white.opacity(0.12),
                            themeColor.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: themeColor.opacity(0.12), radius: 18, x: 0, y: 8)
        .shadow(color: .black.opacity(0.28), radius: 20, x: 0, y: 12)
    }

    @ViewBuilder
    private var cardBackground: some View {
        ZStack {
            Color.white.opacity(0.05)
            VisualEffectBlur(material: .systemUltraThinMaterialDark)

            if chartStyle == .ecgWave {
                RadialGradient(
                    colors: [
                        Color(red: 1.0, green: 0.12, blue: 0.25).opacity(0.18),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 20,
                    endRadius: 180
                )
            }
        }
    }
}
