//
//  FootKeyboardAppDelegate.h
//  FootKeyboardSetter
//
//  Created by Tool Labs on 2013/03/31.
//  Copyright 2013 Tool Labs
//

#import <Cocoa/Cocoa.h>
#import "FootKeyboard.h"

@interface FootKeyboardAppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSTextField *pnpStatus;            // USBデバイス接続ステータス   : USB device plan and play connection status
    IBOutlet NSButton    *toggleLEDButton;      // LED On-Off制御ボタン      : LED On-Off control button
    FootKeyboard         *footKeyboardDevice;   // フットキーボードインスタンス : FootKayboard instance
}
@property (assign) IBOutlet NSWindow *window;

// LED OnOff制御セレクタ : Selector for On-Off controlling LED
- (IBAction)ToggleLEDButtonPressed:(id)sender;

// メインウインドウ更新セレクタ : Selector for updating main window
- (void) UpdateAppWindow;

@end

