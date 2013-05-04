//
//  OMColorHelper.m
//  OMColorHelper
//
//  Created by Ole Zorn on 09/07/12.
//
//

#import "OMQuickHelpPlugin.h"
#import "JRSwizzle.h"
#import "ClassDumpedXcodeClasses.h"

#define kOMSuppressDashNotInstalledWarning	@"OMSuppressDashNotInstalledWarning"
#define kOMOpenInDashDisabled				@"OMOpenInDashDisabled"
#define kOMDashPlatformDetectionDisabled    @"OMDashPlatformDetectionDisabled"

@interface NSObject (OMSwizzledIDEQuickHelpActionManager)

- (void)om_openNavigableItemInDocumentationOrganizer:(IDENavigableItem*)tokenItem;
- (void)om_dashNotInstalledWarning;
- (BOOL)om_showDashForSearchString:(NSString *)searchString;

@end

@implementation NSObject (OMSwizzledIDEQuickHelpActionManager)

- (NSString*)om_searchStringForToken:(DSAToken*)token {
    if([@[@"instm", @"clm", @"instp"] containsObject:token.type]) {
        return [NSString stringWithFormat:@"%@ %@", token.scope, token.name];
    }
    else if([@[@"binding"] containsObject:token.type]) {
        // Docs for bindings are not readily accessible in Dash
        return nil;
        //return [NSString stringWithFormat:@"%@Bindings %@", token.scope, token.name];
    }
    else {
        return token.name;
    }
}

- (void)om_openNavigableItemInDocumentationOrganizer:(IDENavigableItem *)tokenItem {
    BOOL dashDisabled = [[NSUserDefaults standardUserDefaults] boolForKey:kOMOpenInDashDisabled];
    if(!dashDisabled) {
        DSAToken * token = tokenItem.representedObject;
        NSString * searchString = [self om_searchStringForToken:token];
        
        if([self om_showDashForSearchString:searchString]) {
            return;
        }
        
        // If we got here, we couldn't show Dash.
        [self om_dashNotInstalledWarning];
    }
    
    // Fall back to documentation browser
    [self om_openNavigableItemInDocumentationOrganizer:tokenItem];
}

- (void)om_dashNotInstalledWarning {
	//Show a warning that Dash is not installed:
	BOOL showNotInstalledWarning = ![[NSUserDefaults standardUserDefaults] boolForKey:kOMSuppressDashNotInstalledWarning];
	if (showNotInstalledWarning) {
		NSAlert *alert = [NSAlert alertWithMessageText:@"Dash not installed" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"It looks like the Dash app is not installed on your system. Please visit http://kapeli.com/dash/ to get it."];
		[alert setShowsSuppressionButton:YES];
		[alert runModal];
		if ([[alert suppressionButton] state] == NSOnState) {
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kOMSuppressDashNotInstalledWarning];
		}
	}
}

- (BOOL)om_showDashForSearchString:(NSString *)searchString
{
    if(!searchString) {
        return NO;
    }
    
    searchString = [self om_appendActiveSchemeKeyword:searchString];
	NSPasteboard *pboard = [NSPasteboard pasteboardWithUniqueName];
	[pboard setString:searchString forType:NSStringPboardType];
	return NSPerformService(@"Look Up in Dash", pboard);
}

- (NSArray *)om_dashDocSets {
    NSUserDefaults *defaults = [[[NSUserDefaults alloc] init] autorelease];
    [defaults addSuiteNamed:@"com.kapeli.dash"];
    [defaults synchronize];
    
    NSArray *docsets = [defaults objectForKey:@"docsets"];
    docsets = [docsets sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        BOOL obj1Enabled = [[obj1 objectForKey:@"isProfileEnabled"] boolValue];
        BOOL obj2Enabled = [[obj2 objectForKey:@"isProfileEnabled"] boolValue];
        if(obj1Enabled && !obj2Enabled)
        {
            return NSOrderedAscending;
        }
        else if(!obj1Enabled && obj2Enabled)
        {
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedSame;
        }
    }];
    
    [defaults removeSuiteNamed:@"com.kapeli.dash"];
    
    return docsets;
}

- (NSString*)om_keywordForPlatformNamed:(NSArray*)platformNames {
    for(NSDictionary *docset in [self om_dashDocSets]) {
        NSString *platform = [[docset objectForKey:@"platform"] lowercaseString];
        
        for(NSString * wantedPlatform in platformNames) {
            if([platform hasPrefix:wantedPlatform]) {
                NSString *keyword = [docset objectForKey:@"keyword"];
                return keyword.length ? keyword : platform;
            }
        }
    }

    return nil;
}

- (NSString*)om_iOSKeyword {
    return [self om_keywordForPlatformNamed:@[ @"iphone", @"ios" ]];
}

- (NSString*)om_OSXKeyword {
    return [self om_keywordForPlatformNamed:@[ @"macosx", @"osx" ]];
}

- (NSString *)om_appendActiveSchemeKeyword:(NSString *)searchString
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:kOMDashPlatformDetectionDisabled])
    {
        @try { // I don't trust myself with this swizzling business
            id windowController = [[NSApp keyWindow] windowController];
            id workspace = [windowController valueForKey:@"_workspace"];
            id runContextManager = [workspace valueForKey:@"runContextManager"];
            id activeDestination = [runContextManager valueForKey:@"_activeRunDestination"];
            NSString *destination = [activeDestination valueForKey:@"targetIdentifier"];
            
            if(destination && [destination isKindOfClass:[NSString class]] && destination.length)
            {
                destination = [destination lowercaseString];
                BOOL iOS = [destination hasPrefix:@"iphone"] || [destination hasPrefix:@"ipad"] || [destination hasPrefix:@"ios"];
                BOOL mac = [destination hasPrefix:@"mac"] || [destination hasPrefix:@"osx"];

                NSString *foundKeyword;
                    
                if(iOS) {
                    foundKeyword = [self om_iOSKeyword];
                }
                else if(mac) {
                    foundKeyword = [self om_OSXKeyword];
                }
                
                if(foundKeyword) {
                    searchString = [[[foundKeyword stringByReplacingOccurrencesOfString:@":" withString:@""] stringByAppendingString:@":"] stringByAppendingString:searchString];
                }
            }
        }
        @catch (NSException *exception) { }
    }
    return searchString;
}

@end

@implementation OMQuickHelpPlugin

+ (void)pluginDidLoad:(NSBundle *)plugin
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        Class IDEQuickHelpActionManager = NSClassFromString(@"IDEQuickHelpActionManager");
		if (IDEQuickHelpActionManager != NULL) {
			[IDEQuickHelpActionManager jr_swizzleMethod:@selector(openNavigableItemInDocumentationOrganizer:) withMethod:@selector(om_openNavigableItemInDocumentationOrganizer:) error:NULL];
		}
		[[self alloc] init];
	});
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
			NSMenuItem *toggleDashItem = [dashMenu addItemWithTitle:@"Enable Dash Quick Help" action:@selector(toggleOpenInDashEnabled:) keyEquivalent:@""];
            [toggleDashItem setTarget:self];
            NSMenuItem *togglePlatformDetection = [dashMenu addItemWithTitle:@"Enable Dash Platform Detection" action:@selector(toggleDashPlatformDetection:) keyEquivalent:@""];
            [togglePlatformDetection setTarget:self];
			[[editMenuItem submenu] addItem:dashMenuItem];
		}
	}
	return self;
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
	if ([menuItem action] == @selector(toggleOpenInDashEnabled:)) {
		if ([[NSUserDefaults standardUserDefaults] boolForKey:kOMOpenInDashDisabled]) {
			[menuItem setState:NSOffState];
		} else {
			[menuItem setState:NSOnState];
		}
	}
    else if([menuItem action] == @selector(toggleDashPlatformDetection:)) {
		if ([[NSUserDefaults standardUserDefaults] boolForKey:kOMDashPlatformDetectionDisabled]) {
			[menuItem setState:NSOffState];
		} else {
			[menuItem setState:NSOnState];
		}
	}
	return YES;
}

- (void)toggleOpenInDashEnabled:(id)sender
{
	BOOL disabled = [[NSUserDefaults standardUserDefaults] boolForKey:kOMOpenInDashDisabled];
	[[NSUserDefaults standardUserDefaults] setBool:!disabled forKey:kOMOpenInDashDisabled];
}

- (void)toggleDashPlatformDetection:(id)sender
{
    BOOL disabled = [[NSUserDefaults standardUserDefaults] boolForKey:kOMDashPlatformDetectionDisabled];
	[[NSUserDefaults standardUserDefaults] setBool:!disabled forKey:kOMDashPlatformDetectionDisabled];
}

@end
