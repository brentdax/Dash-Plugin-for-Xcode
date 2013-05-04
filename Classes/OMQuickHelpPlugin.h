//
//  OMColorHelper.h
//  OMColorHelper
//
//  Created by Ole Zorn on 09/07/12.
//
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface OMQuickHelpPlugin : NSObject {
	
}

+ (OMQuickHelpPlugin*)sharedQuickHelpPlugin;

- (void)enableOpenInDash:(id)sender;
- (void)disableOpenInDash:(id)sender;

- (void)toggleDashPlatformDetection:(id)sender;

@property (nonatomic,assign) BOOL openInDashDisabled;
@property (nonatomic,assign) BOOL dashPlatformDetectionDisabled;
@property (nonatomic,assign) BOOL suppressDashNotInstalledWarning;

@end
