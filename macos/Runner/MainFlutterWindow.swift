import Cocoa
import FlutterMacOS
import macos_window_utils

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
      // 在创建视图控制器之前设置窗口属性
      self.titleVisibility = .hidden
      self.titlebarAppearsTransparent = true
      self.styleMask.insert(.fullSizeContentView)
      
      // 设置窗口背景为透明，避免白色闪烁
      self.backgroundColor = .clear
      self.isOpaque = false
      self.hasShadow = true
      
      // 强制使用深色模式
      self.appearance = NSAppearance(named: .darkAqua)
      
      // 设置窗口层级
      self.level = .normal
      
      // 设置窗口最小尺寸和初始大小
      self.minSize = NSSize(width: 1400, height: 900)
      
      // 创建一个合适的窗口框架，居中显示
      let screenSize = NSScreen.main?.visibleFrame ?? NSRect.zero
      let windowSize = NSSize(width: 1400, height: 900)
      let originX = (screenSize.width - windowSize.width) / 2 + screenSize.origin.x
      let originY = (screenSize.height - windowSize.height) / 2 + screenSize.origin.y
      let windowFrame = NSRect(x: originX, y: originY, width: windowSize.width, height: windowSize.height)
      
      let macOSWindowUtilsViewController = MacOSWindowUtilsViewController()
      
      // 设置视图控制器的背景为透明
      macOSWindowUtilsViewController.view.wantsLayer = true
      macOSWindowUtilsViewController.view.layer?.backgroundColor = CGColor.clear
      
      self.contentViewController = macOSWindowUtilsViewController
      self.setFrame(windowFrame, display: true)
      
      /* Initialize the macos_window_utils plugin */
      MainFlutterWindowManipulator.start(mainFlutterWindow: self)

      RegisterGeneratedPlugins(registry: macOSWindowUtilsViewController.flutterViewController)

    super.awakeFromNib()
  }
  
  // 覆盖此方法以确保窗口大小调整时不会出现白色拖影
  override func setFrame(_ frameRect: NSRect, display flag: Bool) {
    super.setFrame(frameRect, display: flag)
    self.invalidateShadow()
    self.contentView?.needsDisplay = true
  }
  
  // 确保窗口可以成为第一响应者
  override var canBecomeKey: Bool {
    return true
  }
  
  // 确保窗口可以成为主窗口
  override var canBecomeMain: Bool {
    return true
  }
  
  // 确保事件能够正确传递
  override func sendEvent(_ event: NSEvent) {
    super.sendEvent(event)
    
    // 对于鼠标点击事件，确保视图能获取焦点
    if event.type == .leftMouseDown || event.type == .rightMouseDown {
      if let contentViewController = self.contentViewController as? MacOSWindowUtilsViewController {
        // 获取Flutter视图控制器并设置为第一响应者
        let flutterVC = contentViewController.flutterViewController
        let flutterView = flutterVC.view
        if self.firstResponder != flutterView {
          self.makeFirstResponder(flutterView)
        }
      }
    }
  }
}
