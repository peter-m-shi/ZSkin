//
//  ZSSkinLoader.h
//  ZSSkinKit
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZSSkin;

@interface ZSSkinLoader : NSObject

@property (nonatomic) NSString *skinFolderPath;

/**
 *  Load skins in default folder
 *  
 *  This will not load configratures and resources of all the skins 
 *  until it be loaded by @selectore(loadSkin:)
 *
 *  @return array
 */
- (NSArray *)loadSkins;

/**
 *  Load all the configratures and resources with given skin
 *
 *  @param skin who want be loaded.
 */
- (void)loadSkin:(ZSSkin *)skin;

@end
