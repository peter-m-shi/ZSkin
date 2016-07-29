//
//  ZSkinLoader.m
//  ZSkin
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "ZSkinLoader.h"
#import "ZSkin.h"

#define KDefaultSkinFolderName @"Skins"

@interface ZSkinLoader()

@property (nonatomic) NSString *innerSkinsFolderPath;

@end

@implementation ZSkinLoader

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.skinFolderPath = [NSString stringWithFormat:@"%@/Library/Caches/%@/",NSHomeDirectory(),KDefaultSkinFolderName];
        self.innerSkinsFolderPath = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath],KDefaultSkinFolderName];
        [self checkSkinFolder];
    }

    return self;
}

- (void)checkSkinFolder
{
#ifdef DEBUG
    //To make the skin files always be latest when developing period
    [[NSFileManager defaultManager] removeItemAtPath:self.skinFolderPath error:nil];
#endif
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:self.skinFolderPath];
    if (!exists)
    {
        NSError *error;
        BOOL ret = [[NSFileManager defaultManager] copyItemAtPath:self.innerSkinsFolderPath toPath:self.skinFolderPath error:&error];
        if (!ret)
        {
            NSLog(@"copy skins folder to cache folder failed! %@",error);
        }
    }
}

- (NSArray *)loadSkins
{
    NSDirectoryEnumerator* enumerator = [[NSFileManager defaultManager] enumeratorAtPath:self.skinFolderPath];
    NSString *file;
    NSMutableArray *skins = [NSMutableArray new];
    while (file = [enumerator nextObject])
    {
        if ([[file pathExtension] hasSuffix:@"bundle"])
        {
            ZSkin *skin = [[ZSkin alloc] init];
            skin.name = [file stringByDeletingPathExtension];
            skin.path = [NSString stringWithFormat:@"%@%@",self.skinFolderPath,file];
            [skins addObject:skin];
        }
    }
    return skins;
}


- (void)loadSkin:(ZSkin *)skin
{
    if (!skin.color)
    {
        skin.color = [[ZColorSkin alloc] initWithDictionary:[self loadSkinContent:skin.name type:@"color"]];
    }
    if (!skin.font)
    {
        skin.font = [[ZFontSkin alloc] initWithDictionary:[self loadSkinContent:skin.name type:@"font"]];
    }
    if (!skin.image)
    {
        skin.image = [[ZImageSkin alloc] initWithPath:[NSString stringWithFormat:@"%@%@.bundle/",self.skinFolderPath,skin.name]];
    }
}


- (NSDictionary *)loadSkinContent:(NSString *)name type:(NSString *)type
{
    assert(name && type);
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.bundle/%@.plist",self.skinFolderPath,name,type];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];

    return dictionary;
}


#pragma mark - private function -

#pragma mark - utility function -

@end
