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

- (NSArray *)loadSkins;

- (void)loadSkin:(ZSSkin *)skin;

@end
