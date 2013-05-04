//
//  ClassDumpedXcodeClasses.h
//  OMQuickHelp
//
//  Created by Brent Royal-Gordon on 5/3/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

// Via class-dump
// This is a subset of these classes' true interface.

@class DVTStackBacktrace, IDENavigableItemCoordinator, NSArray, NSImage, NSPredicate, NSString;

@interface IDENavigableItem : NSObject
{
    id _observationInfo;
    IDENavigableItemCoordinator *_coordinator;
    id _representedObject;
    IDENavigableItem *_parentItem;
    id _childItems;
    id _arrangedChildItems;
    NSPredicate *_filterPredicate;
    NSArray *_sortDescriptors;
    DVTStackBacktrace *_invalidationBacktrace;
    struct {
        unsigned int _childItemsNeedsUpdate:1;
        unsigned int _invalidatingChildItems:1;
        unsigned int _debug_8061745_shouldCaptureInvalidationBacktrace:1;
        unsigned int _observersRegisteredWithOldOrPriorOption:1;
        unsigned int _reserved:28;
    } _ideniFlags;
}

@property(readonly) id representedObject; // @synthesize representedObject=_representedObject;

// Remaining properties
@property(readonly) NSImage *image; // @dynamic image;
@property(readonly) NSString *name; // @dynamic name;

@end

@class IDEQuickHelpQueryResult;
@protocol DVTSourceExpressionSource;

@interface IDEQuickHelpActionManager : NSObject
{
    IDEQuickHelpQueryResult *_queryResult;
    id <DVTSourceExpressionSource> _sourceExpressionSource;
}

- (void)openNavigableItemInDocumentationOrganizer:(IDENavigableItem*)arg1;
- (IBAction)showDocumentation:(id)arg1;

@end

@interface DSAToken : NSManagedObject
{
    id _tokenIvars;
}

+ (id)descriptionForIDInformation:(id)arg1;
+ (id)tokenTypeCategoryForKey:(id)arg1 forLocalization:(id)arg2;
+ (id)standardizedLanguageForKey:(id)arg1;
- (id)URL;
- (id)url;
- (id)description;
- (id)tokenTypeCategory;
- (id)deprecationVersionStatementAsOfVersion:(id)arg1;
- (id)deprecationVersionStatement;
- (id)availabilityVersionStatement;
//- (id)availabilityInformationAsOfDistributionVersion:(CDStruct_6df46f26)arg1 forArchitectures:(id)arg2;
- (id)_lastRemovalStringForArchitectures:(id)arg1 fromRemovedVersions:(id)arg2;
- (id)mergedRelatedTokens;
- (id)relatedTokens;
- (id)distributionName;
- (id)removedAfterVersionString;
- (id)removedAfterVersions;
- (id)removedAfterVersion;
- (void)setRemovedAfterVersions:(id)arg1;
- (void)setRemovedAfterVersion:(id)arg1;
- (id)deprecatedInVersionString;
- (id)deprecatedInVersions;
- (id)deprecatedInVersion;
- (void)setDeprecatedInVersions:(id)arg1;
- (void)setDeprecatedInVersion:(id)arg1;
- (id)introducedInVersionString;
- (id)introducedInVersions;
- (id)introducedInVersion;
- (void)setIntroducedInVersions:(id)arg1;
- (void)setIntroducedInVersion:(id)arg1;
- (id)anchor;
- (void)setAnchor:(id)arg1;
- (id)filePath;
- (id)file;
- (void)setFile:(id)arg1;
- (id)relatedDocuments;
- (void)setRelatedDocuments:(id)arg1;
- (id)relatedSampleCode;
- (void)setRelatedSampleCode:(id)arg1;
- (id)relatedGroups;
- (void)setRelatedGroups:(id)arg1;
- (id)seeAlsoRelatedTokens;
- (void)setSeeAlsoRelatedTokens:(id)arg1;
- (id)deprecationSummaryAsHTML;
- (id)deprecationSummary;
- (void)setDeprecationSummary:(id)arg1;
- (id)declaredInFrameworkName;
- (id)declaredInHeaderURL;
- (id)declaredIn;
- (void)setDeclaredIn:(id)arg1;
- (id)returnValueAbstractAsHTML;
- (id)returnValueInfo;
- (void)setReturnValueInfo:(id)arg1;
- (id)parametersInfo;
- (void)setParametersInfo:(id)arg1;
- (id)declarationAsHTML;
- (id)declaration;
- (void)setDeclaration:(id)arg1;
- (id)abstractAsHTML;
- (id)abstract;
- (void)setAbstract:(id)arg1;
- (id)parentNode;
- (void)setParentNode:(id)arg1;
- (id)tokenName;
- (void)setTokenName:(id)arg1;
- (id)scope;
- (id)type;
- (id)apiLanguage;
- (id)name;
- (id)_metainfoCreatingIfMissing:(BOOL)arg1;
- (id)docSet;

@end
