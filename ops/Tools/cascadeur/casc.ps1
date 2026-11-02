# casc.ps1 - drive the Cascadeur GUI from PowerShell. Dot-source this.
# Built for S30 from the recipe proven in S29_CASCADEUR_GUI_REACHED.md.

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

if (-not ("CascWin" -as [type])) {
Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Text;
public class CascWin {
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int n);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
  [DllImport("user32.dll")] public static extern bool SetCursorPos(int x, int y);
  [DllImport("user32.dll")] public static extern bool GetCursorPos(out POINT p);
  [DllImport("user32.dll")] public static extern void mouse_event(uint f, int dx, int dy, uint d, IntPtr e);
  [DllImport("user32.dll")] public static extern void keybd_event(byte vk, byte scan, uint f, IntPtr e);
  [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetWindowTextW(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc cb, IntPtr p);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetClassNameW(IntPtr h, StringBuilder s, int n);
  public delegate bool EnumProc(IntPtr h, IntPtr p);
  [StructLayout(LayoutKind.Sequential)] public struct RECT { public int Left, Top, Right, Bottom; }
  [StructLayout(LayoutKind.Sequential)] public struct POINT { public int X, Y; }
  public const uint LEFTDOWN=0x0002, LEFTUP=0x0004, RIGHTDOWN=0x0008, RIGHTUP=0x0010;
  public const uint MIDDLEDOWN=0x0020, MIDDLEUP=0x0040, WHEEL=0x0800, MOVE=0x0001;
}
"@
}

$global:CascPid = 0
$global:CascHwnd = [IntPtr]::Zero

function Get-Casc {
  $p = Get-Process -Name cascadeur* -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -ne 0 } | Select-Object -First 1
  if ($null -eq $p) { return $null }
  $global:CascPid = $p.Id
  $global:CascHwnd = $p.MainWindowHandle
  return $p
}

function Focus-Casc {
  if ($global:CascHwnd -eq [IntPtr]::Zero) { Get-Casc | Out-Null }
  [CascWin]::ShowWindow($global:CascHwnd, 3) | Out-Null   # SW_MAXIMIZE
  [CascWin]::SetForegroundWindow($global:CascHwnd) | Out-Null
  Start-Sleep -Milliseconds 250
}

function Get-CascRect {
  if ($global:CascHwnd -eq [IntPtr]::Zero) { Get-Casc | Out-Null }
  $r = New-Object CascWin+RECT
  [CascWin]::GetWindowRect($global:CascHwnd, [ref]$r) | Out-Null
  return $r
}

# Capture the Cascadeur window (or a sub-rect of it, in WINDOW coordinates) to a PNG.
function Shot-Casc {
  param([string]$Path, [int]$X=-1, [int]$Y=-1, [int]$W=-1, [int]$H=-1, [double]$Scale=1.0)
  $r = Get-CascRect
  $sx = $r.Left; $sy = $r.Top; $sw = $r.Right - $r.Left; $sh = $r.Bottom - $r.Top
  if ($X -ge 0) { $sx = $r.Left + $X; $sy = $r.Top + $Y; $sw = $W; $sh = $H }
  $bmp = New-Object System.Drawing.Bitmap($sw, $sh)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.CopyFromScreen($sx, $sy, 0, 0, (New-Object System.Drawing.Size($sw, $sh)))
  $g.Dispose()
  if ($Scale -ne 1.0) {
    $nw = [int]($sw * $Scale); $nh = [int]($sh * $Scale)
    $small = New-Object System.Drawing.Bitmap($nw, $nh)
    $g2 = [System.Drawing.Graphics]::FromImage($small)
    $g2.InterpolationMode = 'HighQualityBicubic'
    $g2.DrawImage($bmp, 0, 0, $nw, $nh)
    $g2.Dispose(); $bmp.Dispose(); $bmp = $small
  }
  $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
  Write-Output ("SHOT {0} window=({1},{2}) size={3}x{4}" -f $Path, $r.Left, $r.Top, ($r.Right-$r.Left), ($r.Bottom-$r.Top))
}

# Click at WINDOW-relative coordinates.
function Click-Casc {
  param([int]$X, [int]$Y, [string]$Button='left', [int]$Count=1, [int]$SettleMs=350)
  $r = Get-CascRect
  [CascWin]::SetCursorPos($r.Left + $X, $r.Top + $Y) | Out-Null
  Start-Sleep -Milliseconds 90
  for ($i=0; $i -lt $Count; $i++) {
    if ($Button -eq 'right') {
      [CascWin]::mouse_event([CascWin]::RIGHTDOWN,0,0,0,[IntPtr]::Zero)
      Start-Sleep -Milliseconds 45
      [CascWin]::mouse_event([CascWin]::RIGHTUP,0,0,0,[IntPtr]::Zero)
    } elseif ($Button -eq 'middle') {
      [CascWin]::mouse_event([CascWin]::MIDDLEDOWN,0,0,0,[IntPtr]::Zero)
      Start-Sleep -Milliseconds 45
      [CascWin]::mouse_event([CascWin]::MIDDLEUP,0,0,0,[IntPtr]::Zero)
    } else {
      [CascWin]::mouse_event([CascWin]::LEFTDOWN,0,0,0,[IntPtr]::Zero)
      Start-Sleep -Milliseconds 45
      [CascWin]::mouse_event([CascWin]::LEFTUP,0,0,0,[IntPtr]::Zero)
    }
    if ($Count -gt 1) { Start-Sleep -Milliseconds 70 }
  }
  Start-Sleep -Milliseconds $SettleMs
}

# Drag from window-relative (X1,Y1) to (X2,Y2) with a smooth path.
function Drag-Casc {
  param([int]$X1,[int]$Y1,[int]$X2,[int]$Y2,[string]$Button='left',[int]$Steps=24,[int]$SettleMs=350)
  $r = Get-CascRect
  [CascWin]::SetCursorPos($r.Left + $X1, $r.Top + $Y1) | Out-Null
  Start-Sleep -Milliseconds 120
  $down = [CascWin]::LEFTDOWN; $up = [CascWin]::LEFTUP
  if ($Button -eq 'right') { $down = [CascWin]::RIGHTDOWN; $up = [CascWin]::RIGHTUP }
  if ($Button -eq 'middle') { $down = [CascWin]::MIDDLEDOWN; $up = [CascWin]::MIDDLEUP }
  [CascWin]::mouse_event($down,0,0,0,[IntPtr]::Zero)
  Start-Sleep -Milliseconds 90
  for ($i=1; $i -le $Steps; $i++) {
    $x = [int]($X1 + ($X2-$X1) * $i / $Steps)
    $y = [int]($Y1 + ($Y2-$Y1) * $i / $Steps)
    [CascWin]::SetCursorPos($r.Left + $x, $r.Top + $y) | Out-Null
    Start-Sleep -Milliseconds 16
  }
  Start-Sleep -Milliseconds 90
  [CascWin]::mouse_event($up,0,0,0,[IntPtr]::Zero)
  Start-Sleep -Milliseconds $SettleMs
}

function Wheel-Casc {
  param([int]$X,[int]$Y,[int]$Notches=3,[int]$SettleMs=300)
  $r = Get-CascRect
  [CascWin]::SetCursorPos($r.Left + $X, $r.Top + $Y) | Out-Null
  Start-Sleep -Milliseconds 80
  for ($i=0; $i -lt [Math]::Abs($Notches); $i++) {
    $d = 120; if ($Notches -lt 0) { $d = -120 }
    [CascWin]::mouse_event([CascWin]::WHEEL,0,0,[uint32]$d,[IntPtr]::Zero)
    Start-Sleep -Milliseconds 40
  }
  Start-Sleep -Milliseconds $SettleMs
}

function Keys-Casc {
  param([string]$Keys,[int]$SettleMs=300)
  Focus-Casc
  [System.Windows.Forms.SendKeys]::SendWait($Keys)
  Start-Sleep -Milliseconds $SettleMs
}

# Every top-level window belonging to the Cascadeur process (finds modals/dialogs).
function List-CascWindows {
  if ($global:CascPid -eq 0) { Get-Casc | Out-Null }
  $found = New-Object System.Collections.ArrayList
  $cb = [CascWin+EnumProc]{
    param($h,$p)
    $pid2 = 0
    [CascWin]::GetWindowThreadProcessId($h, [ref]$pid2) | Out-Null
    if ($pid2 -eq $global:CascPid) {
      $sb = New-Object System.Text.StringBuilder 512
      [CascWin]::GetWindowTextW($h, $sb, 512) | Out-Null
      $cn = New-Object System.Text.StringBuilder 256
      [CascWin]::GetClassNameW($h, $cn, 256) | Out-Null
      $r = New-Object CascWin+RECT
      [CascWin]::GetWindowRect($h, [ref]$r) | Out-Null
      $vis = [CascWin]::IsWindowVisible($h)
      [void]$found.Add([pscustomobject]@{
        Hwnd=$h; Title=$sb.ToString(); Class=$cn.ToString(); Visible=$vis
        L=$r.Left; T=$r.Top; W=($r.Right-$r.Left); H=($r.Bottom-$r.Top)
      })
    }
    return $true
  }
  [CascWin]::EnumWindows($cb, [IntPtr]::Zero) | Out-Null
  return $found
}

# Capture ANY hwnd's screen rect (for modal dialogs that sit outside the main window).
function Shot-Hwnd {
  param([IntPtr]$Hwnd,[string]$Path)
  $r = New-Object CascWin+RECT
  [CascWin]::GetWindowRect($Hwnd, [ref]$r) | Out-Null
  $w = $r.Right-$r.Left; $h = $r.Bottom-$r.Top
  $bmp = New-Object System.Drawing.Bitmap($w, $h)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.CopyFromScreen($r.Left, $r.Top, 0, 0, (New-Object System.Drawing.Size($w,$h)))
  $g.Dispose()
  $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
  Write-Output ("SHOT {0} at=({1},{2}) size={3}x{4}" -f $Path,$r.Left,$r.Top,$w,$h)
}
