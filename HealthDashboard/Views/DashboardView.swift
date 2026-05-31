import SwiftUI

struct DashboardView: View {
    private let stepData = MetricMockData.stepsTrend()
    private let heartRateData = MetricMockData.ecgWaveform()
    private let distanceData = MetricMockData.distanceTrend()

    private let stepBlue = Color(red: 0.52, green: 0.82, blue: 1.0)
    private let heartRed = Color(red: 1.0, green: 0.32, blue: 0.42)
    private let distanceGreen = Color(red: 0.18, green: 0.96, blue: 0.52)

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ambientBackground

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    Text("Sağlık Durumu")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                        .padding(.bottom, 4)

                    HealthMetricCard(
                        title: "Adım Sayısı",
                        value: "12,480",
                        iconName: "figure.walk",
                        themeColor: stepBlue,
                        chartData: stepData,
                        chartStyle: .gradientLine,
                        valueOnTrailing: true
                    )

                    HealthMetricCard(
                        title: "Kalp Atışı",
                        value: "68",
                        iconName: "heart.fill",
                        themeColor: heartRed,
                        chartData: heartRateData,
                        chartStyle: .ecgWave,
                        valueOnTrailing: false,
                        unit: "bpm"
                    )

                    HealthMetricCard(
                        title: "Mesafe",
                        value: "9.1",
                        iconName: "location.north.fill",
                        themeColor: distanceGreen,
                        chartData: distanceData,
                        chartStyle: .areaFill,
                        valueOnTrailing: false,
                        unit: "km"
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }

            healthFAB
                .padding(.trailing, 24)
                .padding(.bottom, 28)
        }
        .preferredColorScheme(.dark)
    }

    private var ambientBackground: some View {
        ZStack {
            Color(red: 0.04, green: 0.05, blue: 0.10)
                .ignoresSafeArea()

            Circle()
                .fill(Color(red: 0.95, green: 0.78, blue: 0.22).opacity(0.42))
                .frame(width: 280, height: 280)
                .blur(radius: 80)
                .offset(x: -120, y: -280)

            Circle()
                .fill(Color(red: 0.22, green: 0.45, blue: 0.95).opacity(0.48))
                .frame(width: 320, height: 320)
                .blur(radius: 90)
                .offset(x: 140, y: -120)

            Circle()
                .fill(Color(red: 0.55, green: 0.28, blue: 0.85).opacity(0.38))
                .frame(width: 360, height: 360)
                .blur(radius: 100)
                .offset(x: 60, y: 320)
        }
    }

    private var healthFAB: some View {
        Button {} label: {
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white.opacity(0.9))
                .frame(width: 48, height: 48)
                .glassSurface(cornerRadius: 14, borderOpacity: 0.25)
                .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
