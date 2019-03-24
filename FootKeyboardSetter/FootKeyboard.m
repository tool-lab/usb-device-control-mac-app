//
//  FootKeyboard.m
//  FootKeyboardSetter
//
//  Created by Tool Labs on 2013/03/31.
//  Copyright 2013 Tool Labs
//

#import "FootKeyboard.h"

// USB IN/OUTバッファ定義
// USB IN/OUT buffer definition
unsigned char USBOUTBuffer[8];
unsigned char USBINBuffer[8];

// コールバック関数用に自分のインスタンスを格納するポインタ
// (コールバック関数の第一引数(context)はFootKeyboardAppDelegate)
// Pointer to save self instance for callback function
// (The first argument of callback function (context) is FootKeyboarAppDelegate)
void *selfInstance;

@implementation FootKeyboard
@synthesize isConnected;


// 初期化
// Initialization
- (id) init {
    // FootKeyboardインスタンス初期化
	// Initialize FootKeyboard instance
	if(!(self = [super init])) {
		NSLog(@"Failed to initialze FootKeyboard instance.");
		return nil;
	}
	
    // 接続ステータスをFALSEに設定
	// Set FALSE to connection status
	isConnected = FALSE;
	
    // コールバック関数用に自分のインスタンスポインタを格納
	// Save self instance pointer for callback functions
	selfInstance = self;
	
    // HID Managerの初期化
	// Initialize HID Manager
	hidManager = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDOptionsTypeNone);
	
    // デバイスマッチ辞書にFootKeyboardのVendor IDとProduct IDをセット
    // Set device matching dictionary with Vendor ID and Product ID
	NSMutableDictionary *deviceDictionary = [NSMutableDictionary dictionary];
	[deviceDictionary setObject:[NSNumber numberWithLong:productID]
						 forKey:[NSString stringWithCString:kIOHIDProductIDKey encoding:NSUTF8StringEncoding]];
	[deviceDictionary setObject:[NSNumber numberWithLong:vendorID]
						 forKey:[NSString stringWithCString:kIOHIDVendorIDKey encoding:NSUTF8StringEncoding]];
	IOHIDManagerSetDeviceMatching(hidManager, (CFMutableDictionaryRef)deviceDictionary);
	
    // HID Manageをオープン
	// Open HID Manager
	IOHIDManagerOpen(hidManager, kIOHIDOptionsTypeNone);
	
    // デバイス接続検知
	// New device detection
	[self NewDeviceDetection];
	
    return self;
}



// デバイス接続検知
// New Device Detection
- (void) NewDeviceDetection {
    // デバイスを検知してデータを送るだけなので、デフォルトモードでHID Manageを設定
    // Set default mode to HID manager since we only need device detection and sending data to the Foot Keyboard
	IOHIDManagerScheduleWithRunLoop(hidManager, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);

	// Vendor IDとProduct IDに一致するUSBデバイスリストを取得
    // Get current connected devices that match Vendor ID and Product ID
	NSSet *allDevices = (NSSet *)IOHIDManagerCopyDevices(hidManager);
	NSArray *myUSBDevices = [allDevices allObjects];

	// リストされたはじめのの1台を取得。1台のみのサポートとする
    // Get the first USB device in the list since we only support one device, not plural
    myUSBDevice = ([myUSBDevices count]) ? (IOHIDDeviceRef)[myUSBDevices objectAtIndex:0] : nil;
    
    // フットキーボードが接続されている場合
	// If the Foot Keyboard is connected,
	if(myUSBDevice) {
        // 接続ステータスをTRUEに設定
		// Set TRUE to connection status
		isConnected = TRUE;

		// デバイス取り外しのコールバック関数を登録
		// Register the callback functions to handle device removal
		IOHIDManagerRegisterDeviceRemovalCallback(hidManager, DeviceRemovedCallback, NULL);
		
        // デバイス接続検知のコールバック関数を解除
		// Unregister the callback function to handle device detection
        IOHIDManagerRegisterDeviceMatchingCallback(hidManager, NULL, NULL);
	}
    // フットキーボードが接続されていない場合
	// If the Foot Keyboard is not connected
	else {
		[self  DeviceRemoved];
	}
    
}


// デバイス取り外し検知
// Device removal detection
- (void) DeviceRemoved {
    // デバイスリストをクリアする
    // Clear the device list
	myUSBDevice = nil;

    // 接続ステータスをFALSEに設定
	// Set FALSE to connection status
	isConnected = FALSE;

	// デバイス取り外しのコールバック関数を解除
    // Unregister the callback function to handle device removal
    IOHIDManagerRegisterDeviceRemovalCallback(hidManager, NULL, NULL);

    // デバイス接続検知のコールバック関数を登録
    // Register the callback function to handle device detection
	IOHIDManagerRegisterDeviceMatchingCallback(hidManager, DeviceDetectedCallback, NULL);
}


// データをフットキーボードに送信
// USB Custom Demoは64バイト受信することになっているが、フットキーポードは8バイト予定なので8バイトにする
// デバイスが64バイト受信バッファに対して8バイト送ってもOKみたい
// Send data to the Foot Keyboard
// USB Custom Demo is to receive 64 bytes data, but sends eight bytes since we will use eight bytes packet for Foot Keyboard
// It seems to work to send eight bytes to the device that receiving buffer size is 64 bytes
- (void) SendDataToFootKeyboard {
    // HID USB Customデモでは0x80をLEDのトグルに使用しているので、0x80をUSBOutBuffer[0]にセット
    // Set 0x80 to USBOutBuffer[0] since HID USB Custom demo uses 0x80 to toggle LED
    USBOUTBuffer[0] = 0x80;

    // 残りのバイトを0xFFにセット
    // Set 0xFF to rest of the USBOutBuffer
    memset((void*)&USBOUTBuffer[1], 0xFF, 7);
    IOHIDDeviceSetReport(myUSBDevice, kIOHIDReportTypeOutput, 0, (uint8_t*)&USBOUTBuffer, 8);
}


// デバイス取り外しコールバック関数
// Device removal callback function
static void DeviceRemovedCallback(void *context, IOReturn result, void *sender, IOHIDDeviceRef device) {
	[(FootKeyboard *)selfInstance DeviceRemoved];
}

// デバイス接続検知コールバック関数
// Device detectin callback function
static void DeviceDetectedCallback(void *context, IOReturn result, void *sender, IOHIDDeviceRef device) {
	[(FootKeyboard *)selfInstance NewDeviceDetection];
}

@end
