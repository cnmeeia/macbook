import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var pasteboard = NSPasteboard.general
    var lastChangeCount: Int
    
    override init() {
        self.lastChangeCount = pasteboard.changeCount
        super.init()
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // 创建状态栏图标
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.title = "📋"
        
        // 设置菜单
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "退出", action: #selector(quit), keyEquivalent: "q"))
        statusItem?.menu = menu
        
        // 启动定时器监控剪贴板
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkPasteboard()
        }
    }
    
    func checkPasteboard() {
        if pasteboard.changeCount != lastChangeCount {
            lastChangeCount = pasteboard.changeCount
            
            if let items = pasteboard.pasteboardItems {
                for item in items {
                    // 检查文本内容
                    if let text = item.string(forType: .string) {
                        print("新的剪贴板内容: \(text)")
                        
                        // 发送通知
                        let notification = NSUserNotification()
                        notification.title = "剪贴板已更新"
                        notification.informativeText = text.prefix(50) + (text.count > 50 ? "..." : "")
                        NSUserNotificationCenter.default.deliver(notification)
                    }
                }
            }
        }
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(self)
    }
} 