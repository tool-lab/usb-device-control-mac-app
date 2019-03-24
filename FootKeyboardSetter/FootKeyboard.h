//
//  FootKeyboard.h
//  FootKeyboardSetter
//
//  Created by Tool Labs on 2013/03/31.
//  Copyright 2013 Tool Labs
//

#import <Cocoa/Cocoa.h>
#import <IOKit/hid/IOHIDManager.h>

// USBデバイスのベンダーIDとプロダクトID
// USB device Vendor ID and Product ID
#define productID   0x003F
#define vendorID    0x04D8


@interface FootKeyboard : NSObject {
    bool            isConnected;    // デバイス接続ステータス : Device connection status
    IOHIDManagerRef hidManager;     // HIDマネージャ : HID Manager
    IOHIDDeviceRef  myUSBDevice;    // USBデバイス検索結果 : USB Devices search result
}
@property(readwrite) bool isConnected;


// 初期化
// Initialization
- (id) init;

// 接続されたデバイスの検知
// Connected device detection
- (void) NewDeviceDetection;

// デバイスの取り外し検知
// Device removal detection
- (void) DeviceRemoved;

// フットキーボードにデータ送信
// Send some data to the Foot Keyboard
- (void) SendDataToFootKeyboard;

// デバイス接続/取り外しのコールバック関数
// Callback functions for device connection and removal
static void DeviceRemovedCallback(void *context, IOReturn result, void *sender, IOHIDDeviceRef device);
static void DeviceAttachedCallback(void *context, IOReturn result, void *sender, IOHIDDeviceRef device);

@end
