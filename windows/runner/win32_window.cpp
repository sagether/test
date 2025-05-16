﻿#include "win32_window.h"

#include <dwmapi.h>
#include <flutter_windows.h>
#include <windowsx.h>
#include <commctrl.h>

#pragma comment(lib, "comctl32.lib")

#include "resource.h"

namespace
{

/// Window attribute that enables dark mode window decorations.
///
/// Redefined in case the developer's machine has a Windows SDK older than
/// version 10.0.22000.0.
/// See: https://docs.microsoft.com/windows/win32/api/dwmapi/ne-dwmapi-dwmwindowattribute
#ifndef DWMWA_USE_IMMERSIVE_DARK_MODE
#define DWMWA_USE_IMMERSIVE_DARK_MODE 20
#endif

  constexpr const wchar_t kWindowClassName[] = L"FLUTTER_RUNNER_WIN32_WINDOW";

  /// Registry key for app theme preference.
  ///
  /// A value of 0 indicates apps should use dark mode. A non-zero or missing
  /// value indicates apps should use light mode.
  constexpr const wchar_t kGetPreferredBrightnessRegKey[] =
      L"Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize";
  constexpr const wchar_t kGetPreferredBrightnessRegValue[] = L"AppsUseLightTheme";

  // The number of Win32Window objects that currently exist.
  static int g_active_window_count = 0;

  using EnableNonClientDpiScaling = BOOL __stdcall(HWND hwnd);

  // Scale helper to convert logical scaler values to physical using passed in
  // scale factor
  int Scale(int source, double scale_factor)
  {
    return static_cast<int>(source * scale_factor);
  }

  // Dynamically loads the |EnableNonClientDpiScaling| from the User32 module.
  // This API is only needed for PerMonitor V1 awareness mode.
  void EnableFullDpiSupportIfAvailable(HWND hwnd)
  {
    HMODULE user32_module = LoadLibraryA("User32.dll");
    if (!user32_module)
    {
      return;
    }
    auto enable_non_client_dpi_scaling =
        reinterpret_cast<EnableNonClientDpiScaling *>(
            GetProcAddress(user32_module, "EnableNonClientDpiScaling"));
    if (enable_non_client_dpi_scaling != nullptr)
    {
      enable_non_client_dpi_scaling(hwnd);
    }
    FreeLibrary(user32_module);
  }

} // namespace

// Manages the Win32Window's window class registration.
class WindowClassRegistrar
{
public:
  ~WindowClassRegistrar() = default;

  // Returns the singleton registrar instance.
  static WindowClassRegistrar *GetInstance()
  {
    if (!instance_)
    {
      instance_ = new WindowClassRegistrar();
    }
    return instance_;
  }

  // Returns the name of the window class, registering the class if it hasn't
  // previously been registered.
  const wchar_t *GetWindowClass();

  // Unregisters the window class. Should only be called if there are no
  // instances of the window.
  void UnregisterWindowClass();

private:
  WindowClassRegistrar() = default;

  static WindowClassRegistrar *instance_;

  bool class_registered_ = false;
};

WindowClassRegistrar *WindowClassRegistrar::instance_ = nullptr;

const wchar_t *WindowClassRegistrar::GetWindowClass()
{
  if (!class_registered_)
  {
    WNDCLASS window_class{};
    window_class.hCursor = LoadCursor(nullptr, IDC_ARROW);
    window_class.lpszClassName = kWindowClassName;
    window_class.style = CS_HREDRAW | CS_VREDRAW;
    window_class.cbClsExtra = 0;
    window_class.cbWndExtra = 0;
    window_class.hInstance = GetModuleHandle(nullptr);
    window_class.hIcon = LoadIcon(window_class.hInstance, MAKEINTRESOURCE(IDI_APP_ICON));
    window_class.hbrBackground = nullptr;
    window_class.lpszMenuName = nullptr;
    window_class.lpfnWndProc = Win32Window::WndProc;
    RegisterClass(&window_class);
    class_registered_ = true;
  }
  return kWindowClassName;
}

void WindowClassRegistrar::UnregisterWindowClass()
{
  UnregisterClass(kWindowClassName, nullptr);
  class_registered_ = false;
}

Win32Window::Win32Window()
{
  ++g_active_window_count;
}

Win32Window::~Win32Window()
{
  --g_active_window_count;
  Destroy();
}

bool Win32Window::Create(const std::wstring &title,
                         const Point &origin,
                         const Size &size)
{
  Destroy();

  const wchar_t *window_class =
      WindowClassRegistrar::GetInstance()->GetWindowClass();

  const POINT target_point = {static_cast<LONG>(origin.x),
                              static_cast<LONG>(origin.y)};
  HMONITOR monitor = MonitorFromPoint(target_point, MONITOR_DEFAULTTONEAREST);
  UINT dpi = FlutterDesktopGetDpiForMonitor(monitor);
  double scale_factor = dpi / 96.0;

  // 鑾峰彇灞忓箷灏哄
  int screen_width = GetSystemMetrics(SM_CXSCREEN);
  int screen_height = GetSystemMetrics(SM_CYSCREEN);

  // 璁＄畻绐楀彛灞呬腑浣嶇疆
  int window_width = Scale(size.width, scale_factor);
  int window_height = Scale(size.height, scale_factor);
  int window_x = (screen_width - window_width) / 2;
  int window_y = (screen_height - window_height) / 2;

  // 使用无边框但可调整大小的窗口样式
  DWORD window_style = WS_POPUP | WS_THICKFRAME | WS_SYSMENU | WS_MINIMIZEBOX | WS_MAXIMIZEBOX;

  HWND window = CreateWindow(
      window_class, title.c_str(), window_style,
      window_x, window_y,
      window_width, window_height,
      nullptr, nullptr, GetModuleHandle(nullptr), this);

  if (!window)
  {
    return false;
  }

  // 设置扩展窗口样式
  LONG ex_style = GetWindowLong(window, GWL_EXSTYLE);
  SetWindowLong(window, GWL_EXSTYLE, ex_style | WS_EX_APPWINDOW);

  // 设置DWM属性
  BOOL value = TRUE;
  DwmSetWindowAttribute(window, DWMWA_USE_IMMERSIVE_DARK_MODE, &value, sizeof(value));
  
  // 设置窗口圆角
  DWM_WINDOW_CORNER_PREFERENCE corner = DWMWCP_ROUND;
  DwmSetWindowAttribute(window, DWMWA_WINDOW_CORNER_PREFERENCE, &corner, sizeof(corner));

  // 设置非客户区域渲染策略
  DWMNCRENDERINGPOLICY ncrp = DWMNCRP_ENABLED;
  DwmSetWindowAttribute(window, DWMWA_NCRENDERING_POLICY, &ncrp, sizeof(ncrp));

  // 设置窗口边框颜色为深色
  COLORREF color = 0x00333333;
  DwmSetWindowAttribute(window, DWMWA_BORDER_COLOR, &color, sizeof(color));

  // 设置窗口Hit测试处理
  SetWindowLongPtr(window, GWLP_USERDATA, reinterpret_cast<LONG_PTR>(this));
  SetWindowSubclass(window, [](HWND hwnd, UINT msg, WPARAM wp, LPARAM lp, UINT_PTR, DWORD_PTR) -> LRESULT {
    switch (msg) {
      case WM_NCCALCSIZE: {
        if (wp == TRUE) {
          // 调整非客户区大小，使边框最小化
          NCCALCSIZE_PARAMS* params = reinterpret_cast<NCCALCSIZE_PARAMS*>(lp);
          params->rgrc[0].left += 1;
          params->rgrc[0].top += 1;
          params->rgrc[0].right -= 1;
          params->rgrc[0].bottom -= 1;
          return 0;
        }
        break;
      }
      case WM_NCHITTEST: {
        POINT pt = {GET_X_LPARAM(lp), GET_Y_LPARAM(lp)};
        ScreenToClient(hwnd, &pt);
        
        RECT rc;
        GetClientRect(hwnd, &rc);
        
        // 定义更窄的边框区域（4像素）
        const int border = 4;
        
        // 返回适当的命中测试值以支持窗口调整大小
        if (pt.y < border) {
          if (pt.x < border) return HTTOPLEFT;
          if (pt.x >= rc.right - border) return HTTOPRIGHT;
          return HTTOP;
        }
        if (pt.y >= rc.bottom - border) {
          if (pt.x < border) return HTBOTTOMLEFT;
          if (pt.x >= rc.right - border) return HTBOTTOMRIGHT;
          return HTBOTTOM;
        }
        if (pt.x < border) return HTLEFT;
        if (pt.x >= rc.right - border) return HTRIGHT;
        
        return HTCLIENT;
      }
    }
    return DefSubclassProc(hwnd, msg, wp, lp);
  }, 0, 0);

  // 更新窗口样式
  SetWindowPos(window, nullptr, 0, 0, 0, 0,
               SWP_FRAMECHANGED | SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_NOOWNERZORDER);

  // 娌夋蹈寮忔爣棰樻爮鐨勫熀鏈缃湪FlutterWindow::OnCreate涓畬鎴?  // 杩欓噷涓嶅啀閲嶅璁剧疆锛岄伩鍏嶅啿绐?
  UpdateTheme(window);

  return OnCreate();
}

bool Win32Window::Show()
{
  return ShowWindow(window_handle_, SW_SHOWNORMAL);
}

// static
LRESULT CALLBACK Win32Window::WndProc(HWND const window,
                                      UINT const message,
                                      WPARAM const wparam,
                                      LPARAM const lparam) noexcept
{
  if (message == WM_NCCREATE)
  {
    auto window_struct = reinterpret_cast<CREATESTRUCT *>(lparam);
    SetWindowLongPtr(window, GWLP_USERDATA,
                     reinterpret_cast<LONG_PTR>(window_struct->lpCreateParams));

    auto that = static_cast<Win32Window *>(window_struct->lpCreateParams);
    EnableFullDpiSupportIfAvailable(window);
    that->window_handle_ = window;
  }
  else if (Win32Window *that = GetThisFromHandle(window))
  {
    return that->MessageHandler(window, message, wparam, lparam);
  }

  return DefWindowProc(window, message, wparam, lparam);
}

LRESULT
Win32Window::MessageHandler(HWND hwnd,
                            UINT const message,
                            WPARAM const wparam,
                            LPARAM const lparam) noexcept
{
  switch (message)
  {
  case WM_DESTROY:
    window_handle_ = nullptr;
    Destroy();
    if (quit_on_close_)
    {
      PostQuitMessage(0);
    }
    return 0;

  case WM_DPICHANGED:
  {
    auto newRectSize = reinterpret_cast<RECT *>(lparam);
    LONG newWidth = newRectSize->right - newRectSize->left;
    LONG newHeight = newRectSize->bottom - newRectSize->top;

    SetWindowPos(hwnd, nullptr, newRectSize->left, newRectSize->top, newWidth,
                 newHeight, SWP_NOZORDER | SWP_NOACTIVATE);

    return 0;
  }
  case WM_SIZE:
  {
    RECT rect = GetClientArea();
    if (child_content_ != nullptr)
    {
      // Size and position the child window.
      MoveWindow(child_content_, rect.left, rect.top, rect.right - rect.left,
                 rect.bottom - rect.top, TRUE);
    }
    return 0;
  }

  case WM_ACTIVATE:
    if (child_content_ != nullptr)
    {
      SetFocus(child_content_);
    }
    return 0;

  case WM_DWMCOLORIZATIONCOLORCHANGED:
    UpdateTheme(hwnd);
    return 0;
  }

  return DefWindowProc(window_handle_, message, wparam, lparam);
}

void Win32Window::Destroy()
{
  OnDestroy();

  if (window_handle_)
  {
    DestroyWindow(window_handle_);
    window_handle_ = nullptr;
  }
  if (g_active_window_count == 0)
  {
    WindowClassRegistrar::GetInstance()->UnregisterWindowClass();
  }
}

Win32Window *Win32Window::GetThisFromHandle(HWND const window) noexcept
{
  return reinterpret_cast<Win32Window *>(
      GetWindowLongPtr(window, GWLP_USERDATA));
}

void Win32Window::SetChildContent(HWND content)
{
  child_content_ = content;
  SetParent(content, window_handle_);
  RECT frame = GetClientArea();

  MoveWindow(content, frame.left, frame.top, frame.right - frame.left,
             frame.bottom - frame.top, true);

  SetFocus(child_content_);
}

RECT Win32Window::GetClientArea()
{
  RECT frame;
  GetClientRect(window_handle_, &frame);
  return frame;
}

HWND Win32Window::GetHandle()
{
  return window_handle_;
}

void Win32Window::SetQuitOnClose(bool quit_on_close)
{
  quit_on_close_ = quit_on_close;
}

bool Win32Window::OnCreate()
{
  // No-op; provided for subclasses.
  return true;
}

void Win32Window::OnDestroy()
{
  // No-op; provided for subclasses.
}

void Win32Window::UpdateTheme(HWND const window)
{
  DWORD light_mode;
  DWORD light_mode_size = sizeof(light_mode);
  LSTATUS result = RegGetValue(HKEY_CURRENT_USER, kGetPreferredBrightnessRegKey,
                               kGetPreferredBrightnessRegValue,
                               RRF_RT_REG_DWORD, nullptr, &light_mode,
                               &light_mode_size);

  if (result == ERROR_SUCCESS)
  {
    BOOL enable_dark_mode = light_mode == 0;
    DwmSetWindowAttribute(window, DWMWA_USE_IMMERSIVE_DARK_MODE,
                          &enable_dark_mode, sizeof(enable_dark_mode));
  }
}
