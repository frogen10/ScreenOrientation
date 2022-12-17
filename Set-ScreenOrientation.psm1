# ------------------------------------------------------------------------ 
# NAME: Set-ScreenOrientation.psm1 
# AUTHOR: Łukasz Ryndak (https://github.com/frogen10) 
# DATE: Dec. 17, 2022 
# 
# DESCRIPTION: Sets the Screen Resolution and Orientation of the specified monitor.  
#              Uses Pinvoke and ChangeDisplaySettingsEx Win32API to 
#              make the changes. Written in C# and executed in PowerShell.  
# 
# KEYWORDS: PInvoke, height, width, pixels, Resolution, Orientation, Win32 API,  
#           Mulitple Monitor, display 
# 
# ARGUMENTS: -Width : Desired Width in pixels 
#            -Height : Desired Height in pixels
#		 -Rotation : Orientation of screen: 0 (Landscape), 1(Portrait), 2(Reverse-landscape), 3(Reverse-portrait)
#            -DeviceID : DeviceID of the monitor to be changed. DeviceID  
#                        starts with 1 representing your first monitor.  
#                        For Laptops, the built-in display is usually 1.
#				 Check your settings to see correct numeration of monitors.
# 
# EXAMPLE-1: Set-ScreenResolution -DeviceID 1 -Rotation 0 -Width 1920 -Height 1080
# EXAMPLE-2: Set-ScreenResolution -DeviceID 1 -Rotation 1
# 
# ACKNOWLEDGEMENTS: Many thanks to Timothy Mui for providing the original 
#                   code for a screen resolution changer for device.
#                   Timothy Mui (https://github.com/timmui)
#
# ------------------------------------------------------------------------ 
Function Set-ScreenResolution {  
param (
[Parameter(Mandatory=$true,  
           Position = 3)]  
[int]  
$DeviceID,
[Parameter(Mandatory=$true,  
           Position = 0)]  
[int]  
$Rotation,
[Parameter(Mandatory=$false,  
           Position = 1)]  
[int]  
$Width,  

[Parameter(Mandatory=$false,  
           Position = 2)]  
[int]  
$Height
) 
$Code = @" 
using System;  
using System.Runtime.InteropServices;  

namespace Resolution  
{  
    [Flags()] 
    public enum DisplayDeviceStateFlags : int 
    { 
        /// <summary>The device is part of the desktop.</summary> 
        AttachedToDesktop = 0x1, 
        MultiDriver = 0x2, 
        /// <summary>The device is part of the desktop.</summary> 
        PrimaryDevice = 0x4, 
        /// <summary>Represents a pseudo device used to mirror application drawing for remoting or other purposes.</summary> 
        MirroringDriver = 0x8, 
        /// <summary>The device is VGA compatible.</summary> 
        VGACompatible = 0x10, 
        /// <summary>The device is removable; it cannot be the primary display.</summary> 
        Removable = 0x20, 
        /// <summary>The device has more display modes than its output devices support.</summary> 
        ModesPruned = 0x8000000, 
        Remote = 0x4000000, 
        Disconnect = 0x2000000 
    } 

    [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Ansi)] 
    public struct DISPLAY_DEVICE  
    { 
        [MarshalAs(UnmanagedType.U4)] 
        public int cb; 
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst=32)] 
        public string DeviceName; 
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst=128)] 
        public string DeviceString; 
        [MarshalAs(UnmanagedType.U4)] 
        public DisplayDeviceStateFlags StateFlags; 
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst=128)] 
        public string DeviceID; 
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst=128)] 
        public string DeviceKey; 
    } 

    [Flags()] 
    public enum ChangeDisplaySettingsFlags : uint 
    { 
        CDS_NONE = 0, 
        CDS_UPDATEREGISTRY = 0x00000001, 
        CDS_TEST = 0x00000002, 
        CDS_FULLSCREEN = 0x00000004, 
        CDS_GLOBAL = 0x00000008, 
        CDS_SET_PRIMARY = 0x00000010, 
        CDS_VIDEOPARAMETERS = 0x00000020, 
        CDS_ENABLE_UNSAFE_MODES = 0x00000100, 
        CDS_DISABLE_UNSAFE_MODES = 0x00000200, 
        CDS_RESET = 0x40000000, 
        CDS_RESET_EX = 0x20000000, 
        CDS_NORESET = 0x10000000 
    } 

    [StructLayout(LayoutKind.Sequential)]  
    public struct DEVMODE  
    {  
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]  
        public string dmDeviceName;  
        public short dmSpecVersion;  
        public short dmDriverVersion;  
        public short dmSize;  
        public short dmDriverExtra;  
        public int dmFields;

		public int dmPositionX;
		public int dmPositionY;		

        public int dmOrientation;  
        public int    dmDisplayFixedOutput;
		public short  dmColor;
		public short  dmDuplex;
		public short  dmYResolution;
		public short  dmTTOption;
		public short  dmCollate; 
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]  
        public string dmFormName;  
        public short dmLogPixels;  
        public short dmBitsPerPel;  
        public int dmPelsWidth;  
        public int dmPelsHeight;  
        public int dmPosition; 

        public int dmDisplayFlags;  
        public int dmDisplayFrequency;  

        public int dmICMMethod;  
        public int dmICMIntent;  
        public int dmMediaType;  
        public int dmDitherType;  
        public int dmReserved1;  
        public int dmReserved2;  

        public int dmPanningWidth;  
        public int dmPanningHeight;  
    };  

    [Flags()] 
    public enum DISP_CHANGE : int 
    { 
        SUCCESSFUL = 0, 
        RESTART = 1, 
        FAILED = -1, 
        BADMODE = -2, 
        NOTUPDATED = -3, 
        BADFLAGS = -4, 
        BADPARAM = -5, 
        BADDUALVIEW = -6 
    } 

    public class User_32  
    {  
        [DllImport("user32.dll")] 
        public static extern bool EnumDisplayDevices(string lpDevice, uint iDevNum, ref DISPLAY_DEVICE lpDisplayDevice, uint dwFlags); 
        [DllImport("user32.dll")]  
        public static extern int EnumDisplaySettingsEx(string lpszDeviceName, int iModeNum, ref DEVMODE lpDevMode, uint dwFlags); 
        [DllImport("user32.dll")] 
        public static extern int ChangeDisplaySettingsEx(string lpszDeviceName, ref DEVMODE lpDevMode, IntPtr hwnd, ChangeDisplaySettingsFlags dwflags, IntPtr lParam); 

        public const int ENUM_CURRENT_SETTINGS = -1;  
    }  



    public class ScreenResolution  
    { 
        // Arguments
		// int rotation : orientation
        // int width : Desired Width in pixels 
        // int height : Desired Height in pixels 
        // int deviceIDIn : DeviceID of the monitor to be changed. DeviceID starts with 0 representing your first   
        //                  monitor. For Laptops, the built-in display is usually 0.  

        static public string ChangeResolution(int deviceIDIn, int rotation, int width, int height) 
        {  
			Console.WriteLine("{0}, {1}, {2}, {3}",deviceIDIn, rotation, width, height);
            //Basic Error Check 
            uint deviceID = 0; 
            if (deviceIDIn < 1){ 
                deviceID = 0; 
            } 
            else 
            { 
                deviceID = (uint) (deviceIDIn-1); 
            } 

            DISPLAY_DEVICE d = new DISPLAY_DEVICE();  
            d.cb = Marshal.SizeOf(d); 

            DEVMODE dm = GetDevMode(); 

            User_32.EnumDisplayDevices(null, deviceID, ref d, 1); //Get Device Information 

            // Print Device Information 
            Console.WriteLine("DeviceName: {0} \nDeviceString: {1}\nDeviceID: {2}\nDeviceKey {3}\nStateFlags {4}\n", d.DeviceName, d.DeviceString, d.DeviceID, d.DeviceKey, d.StateFlags);  

            //Attempt to change settings 
            if (0 != User_32.EnumDisplaySettingsEx ( d.DeviceName, User_32.ENUM_CURRENT_SETTINGS, ref dm, 0))  
            {  
				Console.WriteLine("{0}, {1}", dm.dmPelsWidth, dm.dmPelsHeight);
				if( width != 0 || height != 0 )
				{
					Console.WriteLine("{0}, {1}", width, height);
					dm.dmPelsWidth = width;  
					dm.dmPelsHeight = height;
					
				}
				else
				{ 
					Console.WriteLine("Only rotation from {0} to {1}",dm.dmOrientation, rotation  );
					if(dm.dmOrientation % 2 != rotation % 2)
					{
						int temp = dm.dmPelsHeight;
						dm.dmPelsHeight = dm.dmPelsWidth;
						dm.dmPelsWidth = temp;
					}
					
				}
				dm.dmOrientation = rotation;
				Console.WriteLine("{0}, {1}", dm.dmPelsWidth, dm.dmPelsHeight);
                int iRet = User_32.ChangeDisplaySettingsEx( d.DeviceName, ref dm, IntPtr.Zero, ChangeDisplaySettingsFlags.CDS_TEST, IntPtr.Zero);  

                if (iRet == (int) DISP_CHANGE.FAILED)  
                {  
                    return "Unable To Process Your Request. Sorry For This Inconvenience.";  
                }  
                else  
                {  
                    iRet = User_32.ChangeDisplaySettingsEx(d.DeviceName, ref dm, IntPtr.Zero, ChangeDisplaySettingsFlags.CDS_UPDATEREGISTRY, IntPtr.Zero); 

                    switch (iRet)  
                    {  
                        case (int) DISP_CHANGE.SUCCESSFUL:  
                            {  
                                return "Success";  
                            }  
                        case (int) DISP_CHANGE.RESTART:  
                            {  
                                return "You Need To Reboot For The Change To Happen.\n If You Feel Any Problem After Rebooting Your Machine\nThen Try To Change Resolution In Safe Mode.";  
                            }  
                        default:  
                            {  
                                return "Failed To Change The Resolution.";  
                            }  
                    }  

                }  

            }  
            else  
            {  
                return "Failed To Change The Resolution.";  
            }  
        }  

        private static DEVMODE GetDevMode()  
        {  
            DEVMODE dm = new DEVMODE();  
            dm.dmDeviceName = new String(new char[32]);  
            dm.dmFormName = new String(new char[32]);  
            dm.dmSize = (short)Marshal.SizeOf(dm);  
            return dm;  
        }  
    }  
}  
"@ 
Add-Type $Code 
[Resolution.ScreenResolution]::ChangeResolution($DeviceID, $rotation, $width, $height)  
}
