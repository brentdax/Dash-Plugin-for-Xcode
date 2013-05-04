//
//  IDEQuickHelpActionManager+OMSwizzled.m
//  OMQuickHelp
//
//  Created by Brent Royal-Gordon on 5/4/13.
//
//

#import "IDEQuickHelpActionManager+OMSwizzled.h"
#import "JRSwizzle.h"
#import "OMQuickHelpPlugin.h"

@implementation NSObject (OMSwizzledIDEQuickHelpActionManager)

+ (void)om_performIDEQuickHelpActionManagerSwizzle {
    [self jr_swizzleMethod:@selector(openNavigableItemInDocumentationOrganizer:) withMethod:@selector(om_openNavigableItemInDocumentationOrganizer:) error:NULL];
}

- (NSString*)om_searchStringForNameInToken:(DSAToken*)token {
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

- (NSString*)om_searchStringForToken:(DSAToken*)token {
    NSString * nameString = [self om_searchStringForNameInToken:token];
    NSString * keyword = nil;
    
    if([token.distributionName rangeOfString:@"OS X"].location != NSNotFound) {
        keyword = [self om_OSXKeyword];
    }
    else if([token.distributionName rangeOfString:@"iOS"].location != NSNotFound || [token.distributionName rangeOfString:@"iPhone"].location != NSNotFound) {
        keyword = [self om_iOSKeyword];
    }
    
    if(keyword && !OMQuickHelpPlugin.sharedQuickHelpPlugin.dashPlatformDetectionDisabled) {
        return [NSString stringWithFormat:@"%@:%@", [keyword stringByReplacingOccurrencesOfString:@":" withString:@""], nameString];
    }
    else {
        return nameString;
    }
}

- (void)om_openNavigableItemInDocumentationOrganizer:(IDENavigableItem *)tokenItem {
    BOOL dashDisabled = OMQuickHelpPlugin.sharedQuickHelpPlugin.openInDashDisabled;
    if([NSApp currentEvent].modifierFlags & NSShiftKeyMask) {
        dashDisabled = !dashDisabled;
    }
    
    if(!dashDisabled) {
        @try {
            DSAToken * token = tokenItem.representedObject;
            NSString * searchString = [self om_searchStringForToken:token];
            
            if([self om_showDashForSearchString:searchString]) {
                return;
            }
            // If we got here, we couldn't show Dash, but that could be because searchString is nil.
            else if(searchString) {
                [self om_dashNotInstalledWarning];
            }
        }
        @catch (NSException * exception) {
            NSLog(@"OMQuickHelpPlugin could not extract info from documentation token: %@", exception);
        }
    }
    
    // There are about three different ways we could have gotten here, but whatever the reason, we couldn't use Dash.
    // Fall back to the documentation browser instead.
    [self om_openNavigableItemInDocumentationOrganizer:tokenItem];
}

- (void)om_dashNotInstalledWarning {
	//Show a warning that Dash is not installed:
	BOOL showNotInstalledWarning = !OMQuickHelpPlugin.sharedQuickHelpPlugin.suppressDashNotInstalledWarning;
	if (showNotInstalledWarning) {
		NSAlert *alert = [NSAlert alertWithMessageText:@"Dash not installed" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"It looks like the Dash app is not installed on your system. Please visit http://kapeli.com/dash/ to get it."];
		[alert setShowsSuppressionButton:YES];
		[alert runModal];
		if ([[alert suppressionButton] state] == NSOnState) {
            OMQuickHelpPlugin.sharedQuickHelpPlugin.suppressDashNotInstalledWarning = YES;
		}
	}
}

- (BOOL)om_showDashForSearchString:(NSString *)searchString
{
    if(!searchString) {
        return NO;
    }
    
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

@end
