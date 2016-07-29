//
//  ZSObject.h
//  ZSSkinKit
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/NSObject.h>
#import <objc/objc.h>

@interface ZSObject : NSObject<NSCoding>

@property (nonatomic, copy) NSString *objectId;

+ (id)objectFromDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSMutableDictionary *)toDictionary;

- (NSDictionary *)map;

//subclass can overwrite this function to deal special key-value
- (id)handleParseFor:(id)value key:(NSString *)key;

@end
