//
//  ZSkinLoader.h
//  ZSkin
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZSkin;

/**
 *  ZSkinLoader
 */
@interface ZSkinLoader : NSObject

@property (nonatomic) NSString *extendSkinFolderPath;

/**
 *  Load skins in default folder
 *
 *  This will not load configratures and resources of all the skins
 *  until it be loaded by @selectore(load) of ZSkin
 *
 *  @return array
 */
- (NSArray *)loadSkins;

@end
