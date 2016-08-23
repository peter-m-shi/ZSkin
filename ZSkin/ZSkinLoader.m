//
//  ZSkinLoader.m
//  ZSkin
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "ZSkinLoader.h"
#import "ZSkin.h"

#define KDefaultSkinFolderName @"BuiltInSkins"
#define KExtendSkinFolderName @"Skins"

@interface ZSkinLoader()

@property (nonatomic) NSString *builtInSkinsFolderPath;

@end

@implementation ZSkinLoader

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.builtInSkinsFolderPath = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath],KDefaultSkinFolderName];
        self.extendSkinFolderPath = [NSString stringWithFormat:@"%@/Library/Caches/%@",NSHomeDirectory(),KExtendSkinFolderName];
    }

    return self;
}


- (NSArray *)loadSkins
{
    NSMutableArray *skins = [[NSMutableArray alloc] init];
    //load skin from built-in path,default in the main bundle
    [skins addObjectsFromArray:[self loadSkinsFromPath:self.builtInSkinsFolderPath]];
    //load skin from extend path,etc download from network
    [skins addObjectsFromArray:[self loadSkinsFromPath:self.extendSkinFolderPath]];
    return skins;
}

- (NSArray *)loadSkinsFromPath:(NSString *)path
{
    NSDirectoryEnumerator* enumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    NSString *file;
    NSMutableArray *skins = [NSMutableArray new];
    while (file = [enumerator nextObject])
    {
        if ([[file pathExtension] hasSuffix:@"bundle"])
        {
            ZSkin *skin = [[ZSkin alloc] init];
            skin.path = [NSString stringWithFormat:@"%@/%@",path,file];
            skin.builtIn = [[path lastPathComponent] isEqualToString:KDefaultSkinFolderName];
            [skins addObject:skin];
        }
    }
    return skins;
}

#pragma mark - private function -

#pragma mark - utility function -

@end
