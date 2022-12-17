# ScreenOrientation
Set screen orientation and resolution

To install module to your system copy file to: C:\Windows\System32\WindowsPowerShell\v1.0\Modules\<<FileName>>
Then open PowerShell console in this destination and enter command: Install-Module -Name <<FileName>>

Then the module is installed, and you can easily use it in console from every place.

In PowerShell: Set-ScreenResolution -DeviceID 1 -Rotation 0 -Width 1920 -Height 1080

Or if You want change only orientation: Set-ScreenResolution -DeviceID 1 -Rotation 1
            
```python
ARGUMENTS:  -Width : Desired Width in pixels 
            -Height : Desired Height in pixels
            -Rotation : Orientation of screen: 0 (Landscape), 1(Portrait), 2(Reverse-landscape), 3(Reverse-portrait)
            -DeviceID : DeviceID of the monitor to be changed. DeviceID
                        starts with 1 representing your first monitor.  
                        For Laptops, the built-in display is usually 1.
                        Check your settings to see correct numeration of monitors.
            ```
