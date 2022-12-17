# ScreenOrientation
Set screen orientation and resolution

The 'FileName' is "Set-ScreenOrientation" for me you can easily rename the file. 

To install module to your system you need to create folder to your .psm1 file:
```bash
mkdir C:\Windows\System32\WindowsPowerShell\v1.0\Modules\'FileName'
cd C:\Windows\System32\WindowsPowerShell\v1.0\Modules\'FileName'
```
To install module to your system copy file named 'FileName' to newly created Folder named 'FileName'.
Or if u have git installed:
```bash
git -clone https://github.com/frogen10/ScreenOrientation.git
```

Then open PowerShell console in this destination and enter command:
```bash
Install-Module -Name 'FileName'
```

Then the module is installed, and you can easily use it in console from every place.

In PowerShell:
```bash
Set-ScreenResolution -DeviceID 1 -Rotation 0 -Width 1920 -Height 1080
```


Or if You want change only orientation: 
```bash
Set-ScreenResolution -DeviceID 1 -Rotation 1
```
## Parameters:
```python
ARGUMENTS:  -Width : Desired Width in pixels 
            -Height : Desired Height in pixels
            -Rotation : Orientation of screen: 0 (Landscape), 1(Portrait), 2(Reverse-landscape), 3(Reverse-portrait)
            -DeviceID : DeviceID of the monitor to be changed. DeviceID
                        starts with 1 representing your first monitor.  
                        For Laptops, the built-in display is usually 1.
                        Check your settings to see correct numeration of monitors.
```
