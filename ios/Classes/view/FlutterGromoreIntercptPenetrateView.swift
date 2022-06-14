//
//  FlutterGromoreIntercptPenetrateView.swift
//  flutter_gromore
//
//  Created by Anand on 2022/6/13.
//

/// 用于拦截点击穿透
class FlutterGromoreIntercptPenetrateView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if let overlay = getFlutterOverlayView() {
            // 在窗口的点击位置
            let windowPoint: CGPoint = convert(point, to: Utils.getVC().view)
            // 点击位置在 PlatformView 被遮盖时形成的 FlutterOverlayView 上时阻断点击穿透
            // TODO: PlatformView 被遮盖一部分时无法被正常点击（形成了 FlutterOverlayView）
            if overlay.frame.contains(windowPoint) {
                return false
            }
        }
        return true
    }
    
    //    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    //        if !isUserInteractionEnabled || isHidden || alpha < 0.01 {
    //            return nil
    //        }
    //
    //        return super.hitTest(point, with: event)
    //    }
    
    /// 获取 PlatformView 渲染的 FlutterOverlayView 视图
    /// 当 PlatformView 被 Widget 覆盖时，FlutterOverlayView 会进行绘制
    private func getFlutterOverlayView() -> UIView? {
        // PlatformView 渲染后的层级：FlutterView -> ChildClippingView -> FlutterTouchInterceptingView -> 当前视图
        // FlutterOverlayView 和 ChildClippingView 同级
        if let views = superview?.superview?.superview?.subviews {
            for view in views.reversed() {
                if String(describing: view).contains("FlutterOverlayView") {
                    return view
                }
            }
        }
        return nil
    }
}
