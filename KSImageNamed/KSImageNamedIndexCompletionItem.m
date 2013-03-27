//
//  KSImageNamedIndexCompletionItem.m
//  KSImageNamed
//
//  Created by Kent Sutherland on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KSImageNamedIndexCompletionItem.h"
#import <objc/runtime.h>

extern NSString * const KSSIncludeDirectoryInImageCompletionDefaultKey;


@interface KSImageNamedIndexCompletionItem () {
    NSString *_imageCompletionText;
    BOOL _imageIncludeExtension;
}
@end

@implementation KSImageNamedIndexCompletionItem

- (id)initWithFileURL:(NSURL *)fileURL includeExtension:(BOOL)includeExtension
{
    if ( (self = [super init]) ) {
        [self setFileURL:fileURL];
        
        _imageIncludeExtension = includeExtension;
        _imageCompletionText = [self _imageNamedText];
    }
    return self;
}

- (void)_fillInTheRest
{
    
}

- (long long)priority
{
    return 9999;
}

- (NSString *)fileName
{
    return [self _fileName];
}

- (NSString *)name
{
    return [self _fileName];
}

- (BOOL)notRecommended
{
    return NO;
}

- (DVTSourceCodeSymbolKind *)symbolKind
{
    return nil;
}

- (NSString *)completionText
{
    return _imageCompletionText;
}

- (NSString *)displayType
{
    return @"NSString *";
}

- (NSString *)displayText
{
    NSString *displayFormat = [self has2x] ? @"%@ (%@, 2x)" : @"%@ (%@)";
    NSString *string =[NSString stringWithFormat:displayFormat, [self _imageNamedText], [[self fileURL] pathExtension]];
    
    return string;
}

- (NSString *)_fileName
{
    NSString *fileName = [[self fileURL] lastPathComponent];
    
    if (!_imageIncludeExtension) {
        fileName = [fileName stringByDeletingPathExtension];
    }
    
    return fileName;
}

- (NSString *)_imageNamedText
{
    NSString *directory = [self directoryPath];
    directory = [directory length]? [directory stringByAppendingString:@"/"]: @"";
    return [NSString stringWithFormat:@"@\"%@%@\"", directory, [self _fileName]];
}

- (NSString *)directoryPath {
    if ([self isDirectoryPathIncluded]) {
        NSArray *pathComponents = [[self fileURL] pathComponents];
        return pathComponents[[pathComponents count] - 2];
    }
    else
        return nil;
}

- (BOOL)isDirectoryPathIncluded {
    return [[NSUserDefaults standardUserDefaults] boolForKey:KSSIncludeDirectoryInImageCompletionDefaultKey];
}

        


@end
