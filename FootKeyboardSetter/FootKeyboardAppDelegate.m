//
//  FootKeyboardAppDelegate.m
//  FootKeyboardSetter
//
//  Created by Tool Labs on 2013/03/31.
//  Copyright 2013 Tool Labs
//

#import <Cocoa/Cocoa.h>
#import "FootKeyboardAppDelegate.h"

@implementation FootKeyboardAppDelegate

// アプリケーション初期化
// Initialize the applicaton
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{    
    // FootKeyboardインスタンス生成
    // Generate FootKeyboard instance
    footKeyboardDevice = [[FootKeyboard alloc] init];

    // メインウインドウ更新用にタイマー0.1秒でRun Loop生成
    // Create run loop with timer 0.1 second
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1
													  target:self
													selector:@selector(UpdateAppWindow)
													userInfo:NULL
													 repeats:YES];
    
    // タイマーをRun Loopに設定
    // Set timer to run loop
    [runLoop addTimer:timer forMode:NSRunLoopCommonModes];
	[runLoop addTimer:timer forMode:NSEventTrackingRunLoopMode];
}


// LED On-Off制御ボタンが押されたときのアクション
// Action when Toggle LED button is pressed
- (IBAction)ToggleLEDButtonPressed:(id)sender {
    [footKeyboardDevice SendDataToFootKeyboard];
}


// メインウインドウの更新
// Update main window
- (void)UpdateAppWindow {
    // フットキーボードが接続されている場合の処理
    // If foot keyboard connected,
	if([footKeyboardDevice isConnected] == TRUE) {
        // LED On-Offボタンを有効化
		// Enable LED On-Off push button
		[toggleLEDButton setEnabled:TRUE];

		// デバイス接続ステータス表示
		// Show device connection status
		[pnpStatus setStringValue:@"Foot Keyboard is connected!"];
    }
    
    // フットキーボードが接続されていない場合の処理
	// If foot keyboard is not connected,
	else {
        // LED On-Offボタンを無効化
		// Disable LED On-Off push button
		[toggleLEDButton setEnabled:FALSE];
		
        // デバイス接続ステータス表示
		// Show device connection status
		[pnpStatus setStringValue:@"Device Not found..."];
	}
}


// 終了処理
- (void)dealloc
{
    [FootKeyboard release];
    [super dealloc];
}

@end
