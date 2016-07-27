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

            id ret = [self handleParseFor:value key:key];
            if (ret)
            {
                value = ret;
            }

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


- (id)handleParseFor:(id)value key:(NSString *)key
{
    id result;

    if ([value isKindOfClass:nsDictionaryClass])
    {
        Class klass = [ZSRuntimeUtility propertyClassForPropertyName:key ofClass:[self class]];
        result = [[klass alloc] initWithDictionary:value];
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

        result = childObjects;
    }

    return result;
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


- (BOOL)isEqual:(id)object
{
    if (object == nil || ![object isKindOfClass:[ZSObject class]])
    {return NO;}

    ZSObject *model = (ZSObject *)object;

    return [self.objectId isEqualToString:model.objectId];
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString new];

    [description appendString:[NSString stringWithFormat:@"#<%@: id = 0x%08x>\r\n", [self class], self]];

    for (NSString *property in [ZSRuntimeUtility propertyNames:[self class]])
    {
        SEL selector = NSSelectorFromString(property);
        id value = [self performSelector:selector];
        [description appendString:[NSString stringWithFormat:@"   %@:%@\r\n",property,value]];
    }

    return description;
}
@end
