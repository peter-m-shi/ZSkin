//
//  ZSObject.m
//  ZSSkinKit
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "ZSObject.h"
#import "ZSRuntimeUtility.h"

@import UIKit;

#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"

@implementation ZSObject

@synthesize objectId;
static NSString *idPropertyName = @"id";
static NSString *idPropertyNameOnObject = @"objectId";

Class nsDictionaryClass;
Class nsArrayClass;


+ (id)objectFromDictionary:(NSDictionary *)dictionary
{
    id item = [[self alloc] initWithDictionary:dictionary];
    return item;
}


- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (!nsDictionaryClass)
    {nsDictionaryClass = [NSDictionary class];}
    if (!nsArrayClass)
    {nsArrayClass = [NSArray class];}

    if ((self = [super init]))
    {
        for (NSString *key in [ZSRuntimeUtility propertyNames:[self class]])
        {

            id value = [dictionary valueForKey:[[self map] valueForKey:key]];

            if (value == [NSNull null] || value == nil)
            {
                continue;
            }

            if ([ZSRuntimeUtility isPropertyReadOnly:[self class] propertyName:key])
            {
                continue;
            }

            // handle dictionary
            if ([value isKindOfClass:nsDictionaryClass])
            {
                Class klass = [ZSRuntimeUtility propertyClassForPropertyName:key ofClass:[self class]];
                value = [[klass alloc] initWithDictionary:value];
            }
                // handle array
            else if ([value isKindOfClass:nsArrayClass])
            {

                NSMutableArray *childObjects = [NSMutableArray arrayWithCapacity:[(NSArray *)value count]];

                for (id child in value)
                {
                    if ([[child class] isSubclassOfClass:nsDictionaryClass])
                    {
                        Class arrayItemType = [[self class] performSelector:NSSelectorFromString([NSString stringWithFormat:@"%@_class", key])];
                        if ([arrayItemType isSubclassOfClass:[NSDictionary class]])
                        {
                            [childObjects addObject:child];
                        }
                        else if ([arrayItemType isSubclassOfClass:[ZSObject class]])
                        {
                            ZSObject *childDTO = [[arrayItemType alloc] initWithDictionary:child];
                            [childObjects addObject:childDTO];
                        }
                    }
                    else
                    {
                        [childObjects addObject:child];
                    }
                }

                value = childObjects;
            }
            else if ([value isKindOfClass:[NSString class]])
            {
                NSString *str = value;
                unsigned int intValue = [str intValue];
                float alpha = 1;

                if ([str characterAtIndex:0] == '0' && [str characterAtIndex:1] == 'x')
                {
                    NSScanner *scanner = [NSScanner scannerWithString:str];
                    [scanner scanHexInt:&intValue];
                }

                Class klass = [ZSRuntimeUtility propertyClassForPropertyName:key ofClass:[self class]];
                if ([klass isEqual:[UIColor class]])
                {
                    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@Color", value]);
                    if ([UIColor respondsToSelector:selector])
                    {
                        value = [UIColor performSelector:selector];
                    }
                    else
                    {
                        float r = ((float)((intValue & 0xff0000) >> 16)) / 255.0;
                        float g = ((float)((intValue & 0xff00) >> 8)) / 255.0;
                        float b = ((float)((intValue & 0xff) >> 0)) / 255.0;
                        value = [UIColor colorWithRed:r green:g blue:b alpha:alpha];
                    }
                }
                else if ([klass isEqual:[NSNumber class]])
                {
                    value = [NSNumber numberWithInt:intValue];
                }
            }

            // handle all others
            [self setValue:value forKey:key];
        }

        id objectIdValue;
        if ((objectIdValue = [dictionary objectForKey:idPropertyName]) && objectIdValue != [NSNull null])
        {
            if (![objectIdValue isKindOfClass:[NSString class]])
            {
                objectIdValue = [NSString stringWithFormat:@"%@", objectIdValue];
            }
            [self setValue:objectIdValue forKey:idPropertyNameOnObject];
        }
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.objectId forKey:idPropertyNameOnObject];
    for (NSString *key in [ZSRuntimeUtility propertyNames:[self class]])
    {
        [encoder encodeObject:[self valueForKey:key] forKey:key];
    }
}


- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        [self setValue:[decoder decodeObjectForKey:idPropertyNameOnObject] forKey:idPropertyNameOnObject];

        for (NSString *key in [ZSRuntimeUtility propertyNames:[self class]])
        {
            if ([ZSRuntimeUtility isPropertyReadOnly:[self class] propertyName:key])
            {
                continue;
            }
            id value = [decoder decodeObjectForKey:key];
            if (value != [NSNull null] && value != nil)
            {
                [self setValue:value forKey:key];
            }
        }
    }
    return self;
}


- (NSMutableDictionary *)toDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.objectId)
    {
        [dic setObject:self.objectId forKey:idPropertyName];
    }

    for (NSString *key in [ZSRuntimeUtility propertyNames:[self class]])
    {
        id value = [self valueForKey:key];
        if (value && [value isKindOfClass:[ZSObject class]])
        {
            [dic setObject:[value toDictionary] forKey:[[self map] valueForKey:key]];
        }
        else if (value && [value isKindOfClass:[NSArray class]] && ((NSArray *)value).count > 0)
        {
            id internalValue = [value objectAtIndex:0];
            if (internalValue && [internalValue isKindOfClass:[ZSObject class]])
            {
                NSMutableArray *internalItems = [NSMutableArray array];
                for (id item in value)
                {
                    [internalItems addObject:[item toDictionary]];
                }
                [dic setObject:internalItems forKey:[[self map] valueForKey:key]];
            }
            else
            {
                [dic setObject:value forKey:[[self map] valueForKey:key]];
            }
        }
        else if (value != nil)
        {
            [dic setObject:value forKey:[[self map] valueForKey:key]];
        }
    }
    return dic;
}


- (NSDictionary *)map
{
    NSArray *properties = [ZSRuntimeUtility propertyNames:[self class]];
    NSMutableDictionary *mapDictionary = [[NSMutableDictionary alloc] initWithCapacity:properties.count];
    for (NSString *property in properties)
    {
        [mapDictionary setObject:property forKey:property];
    }
    return [NSDictionary dictionaryWithDictionary:mapDictionary];
}


- (NSString *)description
{
    NSMutableDictionary *dic = [self toDictionary];

    return [NSString stringWithFormat:@"#<%@: id = %@ %@>", [self class], self.objectId, [dic description]];
}


- (BOOL)isEqual:(id)object
{
    if (object == nil || ![object isKindOfClass:[ZSObject class]])
    {return NO;}

    ZSObject *model = (ZSObject *)object;

    return [self.objectId isEqualToString:model.objectId];
}

@end
