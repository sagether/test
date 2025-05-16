import Cocoa
import FlutterMacOS
import macos_window_utils

// 直接在这里定义CustomVisualEffectView类，避免导入问题
class CustomVisualEffectView: NSVisualEffectView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    private func setup() {
        // 设置视觉效果
        self.material = .windowBackground
        self.state = .active
        self.blendingMode = .behindWindow
        
        // 确保视图在窗口大小调整时立即更新
        self.wantsLayer = true
        self.autoresizingMask = [.width, .height]
        
        // 禁用渐变效果，避免调整大小时的白色闪烁
        self.layer?.actions = ["bounds": NSNull(), "position": NSNull(), "frame": NSNull()]
        
        // 确保背景完全透明
        self.layer?.backgroundColor = NSColor.clear.cgColor
        
        // 注册窗口大小变化通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowDidResize(_:)),
            name: NSWindow.didResizeNotification,
            object: nil
        )
        
        // 重要：设置为不接收鼠标事件，让事件传递到下层视图
        // 注意：allowsVibrancy是只读属性，不能直接设置
        self.isHidden = false
    }
    
    @objc private func windowDidResize(_ notification: Notification) {
        if let window = notification.object as? NSWindow, window == self.window {
            // 立即更新视图
            self.needsDisplay = true
            self.layer?.setNeedsDisplay()
        }
    }
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        
        // 确保视图大小与窗口内容视图大小一致
        if let window = self.window, let contentView = window.contentView {
            self.frame = contentView.bounds
        }
    }
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        
        // 立即更新所有子视图
        self.needsDisplay = true
        for subview in self.subviews {
            subview.needsDisplay = true
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        // 确保绘制时没有白色闪烁
        self.layer?.backgroundColor = NSColor.clear.cgColor
        super.draw(dirtyRect)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 设置视图的外观为深色
    override var appearance: NSAppearance? {
        get {
            return NSAppearance(named: .darkAqua)
        }
        set {}
    }
    
    // 重要：确保鼠标事件能够穿透此视图
    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
    
    // 确保视图不会成为第一响应者
    override var acceptsFirstResponder: Bool {
        return false
    }
}

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
  
  override func applicationDidFinishLaunching(_ notification: Notification) {
    // 强制应用使用深色模式
    NSApp.appearance = NSAppearance(named: .darkAqua)
    
    // 确保应用启动时窗口属性已经设置好
    if let window = NSApplication.shared.windows.first as? MainFlutterWindow {
      window.titleVisibility = .hidden
      window.titlebarAppearsTransparent = true
      window.styleMask.insert(.fullSizeContentView)
      
      // 设置窗口背景为透明
      window.backgroundColor = .clear
      window.isOpaque = false
      
      // 强制窗口使用深色模式
      window.appearance = NSAppearance(named: .darkAqua)
      
      // 添加自定义视觉效果视图作为背景
      if let contentView = window.contentView {
        let visualEffectView = CustomVisualEffectView(frame: contentView.bounds)
        contentView.addSubview(visualEffectView, positioned: .below, relativeTo: nil)
        
        // 确保窗口大小为1400x900
        let screenSize = NSScreen.main?.visibleFrame ?? NSRect.zero
        let windowSize = NSSize(width: 1400, height: 900)
        let originX = (screenSize.width - windowSize.width) / 2 + screenSize.origin.x
        let originY = (screenSize.height - windowSize.height) / 2 + screenSize.origin.y
        let windowFrame = NSRect(x: originX, y: originY, width: windowSize.width, height: windowSize.height)
        window.setFrame(windowFrame, display: true)
      }
    }
    super.applicationDidFinishLaunching(notification)
  }
  
  override func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if !flag {
      for window in NSApplication.shared.windows {
        window.makeKeyAndOrderFront(self)
      }
    }
    return true
  }
}
