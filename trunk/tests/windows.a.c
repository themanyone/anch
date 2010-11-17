/* windows.a.c is hereby released into the Public Domain
 * 
 * adapted from http://www.winprog.org/tutorial/simple_window.html
 * by Henry Kroll III, http://www.thenerdshow.com
 *
 * This program can be compiled by anch
 * and your regular compiler like so:
 * 
 * anch i686-pc-mingw32-gcc -m32 -mwindows windows.a.c -o windows.exe
 */
#include <windows.h>

const char g_szClassName[] = "myWindowClass"
// My Window Procedure
LRESULT CALLBACK myWndProc  HWND hwnd, UINT msg,
WPARAM wParam, LPARAM lParam
    switch  msg
        case WM_LBUTTONDOWN:
            char szFileName[MAX_PATH]
            HINSTANCE hInstance = GetModuleHandle  NULL
            GetModuleFileName  hInstance, szFileName, MAX_PATH
            MessageBox  hwnd, szFileName, "Thank you!",
            MB_OK | MB_ICONINFORMATION
            break

        case WM_DESTROY:
            PostQuitMessage  0
            break
        
        case WM_PASTE:
            DestroyWindow  hwnd
            break
        
        default:
            return DefWindowProc  hwnd, msg, wParam, lParam
    
    return 0

int WINAPI WinMain  HINSTANCE hInstance, HINSTANCE hPrevInstance,
LPSTR lpCmdLine, int nCmdShow
    WNDCLASSEX wc
    HWND hwnd
    MSG Msg
    // Subclass Default Window Structure (#32769)
    GetClassInfoEx  0,"#32769",&wc
    wc.cbSize           = sizeof  WNDCLASSEX
    wc.lpfnWndProc      = myWndProc
    wc.hInstance        = hInstance
    wc.lpszClassName    = g_szClassName        
    // Register it
    if  !RegisterClassEx(&wc)
        MessageBox  NULL, "RegisterClassEx Failed!", "Error!",
        MB_ICONEXCLAMATION | MB_OK
        return 0
    
    // Create a Window
    hwnd = CreateWindowEx  WS_EX_CLIENTEDGE,
    g_szClassName, "Window Title",
    WS_OVERLAPPEDWINDOW,
    CW_USEDEFAULT, CW_USEDEFAULT, 240, 120,
    NULL, NULL, hInstance, NULL
    if  hwnd == NULL
        MessageBox  NULL, "CreateWindowEx Failed!", "Error!",
        MB_ICONEXCLAMATION | MB_OK
        return 0

    ShowWindow  hwnd, nCmdShow
    UpdateWindow  hwnd
    // Main Message Loop
    while  GetMessage(&Msg, NULL, 0, 0) > 0
        TranslateMessage  &Msg
        DispatchMessage  &Msg
    
    return Msg.wParam
