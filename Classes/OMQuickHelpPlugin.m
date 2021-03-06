//
//  OMColorHelper.m
//  OMColorHelper
//
//  Created by Ole Zorn on 09/07/12.
//
//

#import "OMQuickHelpPlugin.h"
#import "IDEQuickHelpActionManager+OMSwizzled.h"

static OMQuickHelpPlugin * sharedPlugin = nil;

@implementation OMQuickHelpPlugin

+ (void)pluginDidLoad:(NSBundle *)plugin
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        [NSClassFromString(@"IDEQuickHelpActionManager") om_performIDEQuickHelpActionManagerSwizzle];
		sharedPlugin = [[self alloc] init];
	});
}

+ (OMQuickHelpPlugin *)sharedQuickHelpPlugin {
    return sharedPlugin;
}

- (id)init
{
	self  = [super init];
	if (self) {
		//TODO: It would be better to add this to the Help menu, but that seems to be populated from somewhere else...
		NSMenuItem *editMenuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
		if (editMenuItem) {
			[[editMenuItem submenu] addItem:[NSMenuItem separatorItem]];
			NSMenuItem *dashMenuItem = [[[NSMenuItem alloc] initWithTitle:@"Dash Integration" action:nil keyEquivalent:@""] autorelease];
            
            NSMenu *dashMenu = [[[NSMenu alloc] init] autorelease];
            [dashMenuItem setSubmenu:dashMenu];
            
			NSMenuItem *enableDashItem = [dashMenu addItemWithTitle:@"Use Dash for Quick Help Links" action:@selector(enableOpenInDash:) keyEquivalent:@""];
            [enableDashItem setTarget:self];
			NSMenuItem *disableDashItem = [dashMenu addItemWithTitle:@"Use Xcode Organizer for Quick Help Links" action:@selector(disableOpenInDash:) keyEquivalent:@""];
            [disableDashItem setTarget:self];
            
            [dashMenu addItem:[NSMenuItem separatorItem]];
            
            NSMenuItem *togglePlatformDetection = [dashMenu addItemWithTitle:@"Add Docset Keyword" action:@selector(toggleDashPlatformDetection:) keyEquivalent:@""];
            [togglePlatformDetection setTarget:self];
            
			[[editMenuItem submenu] addItem:dashMenuItem];
		}
	}
	return self;
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
	if ([menuItem action] == @selector(enableOpenInDash:)) {
		if (self.openInDashDisabled) {
			[menuItem setState:NSOffState];
		} else {
			[menuItem setState:NSOnState];
		}
	}
	else if ([menuItem action] == @selector(disableOpenInDash:)) {
		if (!self.openInDashDisabled) {
			[menuItem setState:NSOffState];
		} else {
			[menuItem setState:NSOnState];
		}
	}
    else if([menuItem action] == @selector(toggleDashPlatformDetection:)) {
		if (self.dashPlatformDetectionDisabled) {
			[menuItem setState:NSOffState];
		} else {
			[menuItem setState:NSOnState];
		}
        
        return !self.openInDashDisabled;
	}
	return YES;
}

- (void)enableOpenInDash:(id)sender {
    self.openInDashDisabled = NO;
}

- (void)disableOpenInDash:(id)sender {
    self.openInDashDisabled = YES;
}

- (void)toggleDashPlatformDetection:(id)sender {
    self.dashPlatformDetectionDisabled = !self.dashPlatformDetectionDisabled;
}

#define kOMSuppressDashNotInstalledWarning	@"OMSuppressDashNotInstalledWarning"
#define kOMOpenInDashDisabled				@"OMOpenInDashDisabled"
#define kOMDashPlatformDetectionDisabled    @"OMDashPlatformDetectionDisabled"

- (BOOL)openInDashDisabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kOMOpenInDashDisabled];
}

- (void)setOpenInDashDisabled:(BOOL)openInDashDisabled {
    [[NSUserDefaults standardUserDefaults] setBool:openInDashDisabled forKey:kOMOpenInDashDisabled];
}

- (BOOL)dashPlatformDetectionDisabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kOMDashPlatformDetectionDisabled];
}

- (void)setDashPlatformDetectionDisabled:(BOOL)dashPlatformDetectionDisabled {
    return [[NSUserDefaults standardUserDefaults] setBool:dashPlatformDetectionDisabled forKey:kOMDashPlatformDetectionDisabled];
}

- (BOOL)suppressDashNotInstalledWarning {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kOMSuppressDashNotInstalledWarning];
}

- (void)setSuppressDashNotInstalledWarning:(BOOL)suppressDashNotInstalledWarning {
    return [[NSUserDefaults standardUserDefaults] setBool:suppressDashNotInstalledWarning forKey:kOMSuppressDashNotInstalledWarning];
}

@end
