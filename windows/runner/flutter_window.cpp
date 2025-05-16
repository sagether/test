#include "flutter_window.h"

#include <optional>
#include <dwmapi.h>

#pragma comment(lib, "dwmapi.lib")

#include "flutter/generated_plugin_registrant.h"

// 定义DWM_WINDOW_CORNER_PREFERENCE枚举（如果编译器没有定义）
#ifndef DWMWCP_ROUND
enum DWM_WINDOW_CORNER_PREFERENCE
{
  DWMWCP_DEFAULT = 0,
  DWMWCP_DONOTROUND = 1,
  DWMWCP_ROUND = 2,
  DWMWCP_ROUNDSMALL = 3
};
#endif

// 定义DWMWA_WINDOW_CORNER_PREFERENCE（如果编译器没有定义）
#ifndef DWMWA_WINDOW_CORNER_PREFERENCE
#define DWMWA_WINDOW_CORNER_PREFERENCE 33
#endif

// 定义DWMWA_MICA_EFFECT（如果编译器没有定义）
#ifndef DWMWA_MICA_EFFECT
#define DWMWA_MICA_EFFECT 1029
#endif

// 定义Acrylic效果
#ifndef DWMWA_SYSTEMBACKDROP_TYPE
#define DWMWA_SYSTEMBACKDROP_TYPE 38
#endif

// 背景类型
enum SYSTEMBACKDROP_TYPE
{
  SYSTEMBACKDROP_NONE = 0,
  SYSTEMBACKDROP_MICA = 1,    // 云母效果
  SYSTEMBACKDROP_ACRYLIC = 2, // 亚克力效果
  SYSTEMBACKDROP_TABBED = 3   // 选项卡效果
};

FlutterWindow::FlutterWindow(const flutter::DartProject &project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate()
{
  if (!Win32Window::OnCreate())
  {
    return false;
  }

  // 移除窗口默认背景色设置，因为我们要使用完全透明
  SetClassLongPtr(GetHandle(), GCLP_HBRBACKGROUND, (LONG_PTR) nullptr);

  // 强制使用深色模式
  BOOL enable_dark_mode = TRUE;
  DwmSetWindowAttribute(GetHandle(), DWMWA_USE_IMMERSIVE_DARK_MODE,
                        &enable_dark_mode, sizeof(enable_dark_mode));

  // 设置圆角窗口
  DWM_WINDOW_CORNER_PREFERENCE corner_preference = DWMWCP_ROUND;
  DwmSetWindowAttribute(GetHandle(), DWMWA_WINDOW_CORNER_PREFERENCE,
                        &corner_preference, sizeof(corner_preference));

  // 实现完全沉浸式标题栏
  MARGINS margins = {0, 0, 0, 1}; // 只扩展顶部区域
  DwmExtendFrameIntoClientArea(GetHandle(), &margins);

  // 启用标题栏自定义绘制
  BOOL enable = TRUE;
  DwmSetWindowAttribute(GetHandle(), DWMWA_ALLOW_NCPAINT, &enable, sizeof(enable));

  // 设置标题栏为透明
  int ncrp = 2; // DWMNCRP_ENABLED
  DwmSetWindowAttribute(GetHandle(), DWMWA_NCRENDERING_POLICY, &ncrp, sizeof(ncrp));

  // 尝试设置亚克力效果（更明显的毛玻璃效果）
  int backdropType = SYSTEMBACKDROP_ACRYLIC;
  HRESULT hr = DwmSetWindowAttribute(GetHandle(), DWMWA_SYSTEMBACKDROP_TYPE,
                                     &backdropType, sizeof(backdropType));

  // 如果亚克力效果失败，尝试使用Mica效果
  if (FAILED(hr))
  {
    backdropType = SYSTEMBACKDROP_MICA;
    DwmSetWindowAttribute(GetHandle(), DWMWA_SYSTEMBACKDROP_TYPE,
                          &backdropType, sizeof(backdropType));

    // 如果系统不支持新的API，使用旧的Mica API
    BOOL enable_mica = TRUE;
    DwmSetWindowAttribute(GetHandle(), DWMWA_MICA_EFFECT,
                          &enable_mica, sizeof(enable_mica));
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view())
  {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]()
                                                      { this->Show(); });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy()
{
  if (flutter_controller_)
  {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept
{
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_)
  {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result)
    {
      return *result;
    }
  }

  switch (message)
  {
  case WM_FONTCHANGE:
    flutter_controller_->engine()->ReloadSystemFonts();
    break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
