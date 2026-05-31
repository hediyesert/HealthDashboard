import SwiftUI

struct MetricChartView: View {
    let data: [HealthDataPoint]
    let themeColor: Color
    let style: MetricChartStyle

    var body: some View {
        switch style {
        case .gradientLine:
            StepLineChartView(values: data.map(\.value))
        case .ecgWave:
            ECGWaveformView()
        case .areaFill:
            DistanceAreaChartView(values: data.map(\.value))
        }
    }
}
