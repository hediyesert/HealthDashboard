import SwiftUI

struct VisualEffectBlur: View {
    var material: UIBlurEffect.Style

    var body: some View {
        Representable(material: material)
            .accessibilityHidden(true)
    }
}

extension VisualEffectBlur {
    struct Representable: UIViewRepresentable {
        var material: UIBlurEffect.Style

        func makeUIView(context: Context) -> UIVisualEffectView {
            UIVisualEffectView(effect: UIBlurEffect(style: material))
        }

        func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
            uiView.effect = UIBlurEffect(style: material)
        }
    }
}

extension View {
    func glassSurface(cornerRadius: CGFloat = 22, borderOpacity: Double = 0.22) -> some View {
        background(
            ZStack {
                Color.white.opacity(0.06)
                VisualEffectBlur(material: .systemUltraThinMaterialDark)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(Color.white.opacity(borderOpacity), lineWidth: 1)
        )
    }
}
