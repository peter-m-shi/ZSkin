//
//  ZSSkinLoader.m
//  ZSSkinKit
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "ZSSkinLoader.h"
#import "ZSSkin.h"

@implementation ZSSkinLoader


+ (NSArray *)loadSkins
{
    NSBundle *skinsBundle = [ZSSkinLoader skinsBundle];
    NSArray *subFolders = [skinsBundle pathsForResourcesOfType:nil inDirectory:nil];
    NSMutableArray *skins = [NSMutableArray new];
    for (NSString *subFolder in subFolders)
    {
        ZSSkin *skin = [ZSSkinLoader loadSkin:subFolder];
        [skins addObject:skin];
    }
    return skins;
}


+ (ZSSkin *)loadSkin:(NSString *)path
{
    NSAssert(path, @"loadSkin path nil");

    ZSSkin *skin = [[ZSSkin alloc] init];

    skin.name = path.lastPathComponent;
    skin.path = path;
    skin.color = [[ZSColorSkin alloc] initWithDictionary:[ZSSkinLoader loadSkinConfig:skin.name config:@"color" type:@"plist"]];
    skin.font = [[ZSFontSkin alloc] initWithDictionary:[ZSSkinLoader loadSkinConfig:skin.name config:@"font" type:@"plist"]];
    skin.picture = [[ZSPictureSkin alloc] initWithPath:[NSString stringWithFormat:@"skins.bundle/%@/", skin.name]];

    return skin;
}


+ (NSDictionary *)loadSkinConfig:(NSString *)name config:(NSString *)config type:(NSString *)ext
{
    NSAssert(name, @"loadFontSkin name nil");
    NSAssert(config, @"loadFontSkin config nil");

    NSBundle *skinsBundle = [ZSSkinLoader skinsBundle];
    NSString *filePath = [skinsBundle pathForResource:config ofType:ext inDirectory:name];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];

    return dictionary;
}


#pragma mark - private function -


+ (NSBundle *)skinsBundle
{
    NSString *skinsBundlePath = [[NSBundle mainBundle] pathForResource:@"skins" ofType:@"bundle"];
    return [NSBundle bundleWithPath:skinsBundlePath];
}

@end
