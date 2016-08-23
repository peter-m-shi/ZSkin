//
//  ZSkin.m
//  ZSkin
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "ZSkin.h"

@implementation ZSkin



#pragma mark - overwrite property -


- (ZColorSkin *)color
{
    if (!_color)
    {
        _color = [[ZColorSkin alloc] initWithDictionary:[self loadSkinContent:self.path type:@"color"]];
    }
    return _color;
}


- (ZFontSkin *)font
{
    if (!_font)
    {
        _font = [[ZFontSkin alloc] initWithDictionary:[self loadSkinContent:self.path type:@"font"]];
    }
    return _font;
}


- (ZImageSkin *)image
{
    if (!_image)
    {
        _image = [[ZImageSkin alloc] init];
        _image.path = self.path;
    }
    return _image;
}


- (NSString *)name
{
    if (!_name)
    {
        _name = [[self.path lastPathComponent] stringByDeletingPathExtension];
    }
    return _name;
}


#pragma mark - private function -
- (NSDictionary *)loadSkinContent:(NSString *)path type:(NSString *)type
{
    assert(path && type);

    NSString *filePath = [NSString stringWithFormat:@"%@/%@.plist",self.path,type];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];

    return dictionary;
}

#pragma mark - overwrite super function -
- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];

    [description appendString:@">\r\n"];
    [description appendString:[NSString stringWithFormat:@"color:%@\r\n",self.color]];
    [description appendString:[NSString stringWithFormat:@"font:%@\r\n",self.font]];
    [description appendString:[NSString stringWithFormat:@"image:%@\r\n",self.image]];

    return description;
}

@end
