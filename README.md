![ZSkin](https://github.com/peter-m-shi/ZSkin/raw/master/Images/Logo.jpg)

> ZSkin is a powerful skin/theme kit for iOS.

> You can easily customize and change your app's appearance using ZSkin.

> Contact Me : peter.m.shi@outlook.com

## Installation

ZSkin is available on [CocoaPods](http://cocoapods.org). Just add the following to your project Podfile:

```ruby
pod 'ZSkin'
```

Bugs are first fixed in master and then made available via a designated release. If you tend to live on the bleeding edge, you can use ZSkin from master with the following Podfile entry:

```ruby
pod 'ZSkin', :git => 'https://github.com/peter-m-shi/ZSkin.git'
```

## Demo
Gif of demo(coming soon)



## Usage

### Import
Use by including the following import:

```objective-c
#import "ZSkinKit.h"
```

And including the category import of ZColorSkin that you defined

```objective-c
#import "ZColorSkin+Custom.h"
```

### Binding

#### Property Binding
To binding property of UIView as follow:

```objective-c
ZSB(self.view,backgroundColor) = SK(color.background);
```

To binding property of UILabel as follow:

```objective-c
ZSB(self.label,textColor) = SK(color.foreground);
```

To binding property of UIButton as follow:

```objective-c
ZSB(self.button, backgroundColor) = SK(color.background);
ZSB(self.button, titleColorNormal) = SK(color.foreground);
ZSB(self.button, titleColorHightlight) = SK(color.hightlight);
ZSB(self.button, titleColorSelected) = SK(color.selected);
```

More other binding way(not recommend)

```objective-c
//Binding By Literal
[self.textField bind:@"backgroundColor" to:@"color.background"];

//Binding By Macro Definition
[self.textField bind:OP(self.textField, backgroundColor) to:SK(color.background)];
[self.textField bind:OPView(backgroundColor) to:SK(color.foreground)];
[self.label bind:OPLabel(textColor) to:SK(color.background)];
```

#### Dynamic Binding And UnBinding

```objective-c
- (IBAction)clickToBindOrUnBind:(id)sender
{
    UIButton *btn = (UIButton *)sender;

    //Dynamic Binding And UnBinding
    NSString *oKeyPath = [btn bindInfo:@"backgroundColor"];
    if (oKeyPath)
    {
        [btn unBind:@"backgroundColor" to:oKeyPath];
        [btn setTitle:@"Click to bind" forState:UIControlStateNormal];
    }
    else
    {
        [btn bind:@"backgroundColor" to:@"color.foreground"];
        [btn setTitle:@"Click to unbind" forState:UIControlStateNormal];
    }

}
```

#### Custom Binding
```objective-c
[self.button3 bind:^(id sender, ZSkin *skin) {
	//update UI here
    UIButton *btn = sender;
    [btn setBackgroundColor:skin.color.foreground];
    [btn setTitleColor:skin.color.background forState:UIControlStateNormal];
    [btn setTitle:skin.name forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:[skin.font.largeSize floatValue]]];
}];
```

#### Skin Changed Notification
```objective-c
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(receiveNotification:)
                                             name:ZSkinChangedNotificationKey
                                           object:nil];
...

- (void)receiveNotification:(NSNotification *)notification
{
    ZSkin *skin = notification.object;
    NSLog(@"%@ receive skin change notification:%@", self.class, skin);
    self.title = skin.name;
}
```

## Change Skin

easily change skin as follow:

```objective-c
//Change skin with index number
[[ZSkinManager instance] setSkinIndexed:0];

//Change skin with name string
[[ZSkinManager instance] setSkinNamed:@"dark"];

//Change skin
self.skin = [[ZSkinManager instance].skins objectAtIndex:self.segment.selectedSegmentIndex];
[ZSkinManager instance].skin = self.skin;
```

## Skin Package

### Bundle Struct
```
skin.bundle
├── color.plist     // color config file
├── font.plist      // font config file
└── image           // image config folder
	└── test.jpg
 
```

### Color
![ZSkin](https://github.com/peter-m-shi/ZSkin/raw/master/Images/Color.png)

value supported formats in color.plist:

```objective-c

// "0xffcc00"			//RGB
// "#ffcc00"			//RGB
// "255,204,0"			//RGB

// "0xffcc00dd"			//RGBA
// "#ffcc00dd"			//RGBA
// "255,204,0,0.87"		//RGBA

// "red"            Color property of UIColor

```

Access a color property as follow:

```objective-c
[ZSkinManager instance].skin.color.foreground;
c

### Custom Color
A Category Class Named(Custom) should be created if you add any key to "color.plist"
And the new property with the same name should be add to Category Class. etc.

```objective-c
 
ZColorSkin+Custom.h
 
@interface ZColorSkin (Custom)
 
@property (nonatomic) UIColor *customColor;

...

@end
 
 
 
ZColorSkin+Custom.m
 
@implementation ZColorSkin (Custom)

DYNAMIC(customColor,setCustomColor,UIColor*)

...
 
@end
```

### Font
![ZSkin](https://github.com/peter-m-shi/ZSkin/raw/master/Images/Font.png)

Access a font property as follow:

```objective-c
[ZSkinManager instance].skin.font.largeSize;
```

### Image

Access a image as follow:

```objective-c
[self.image bind:^(id sender, ZSkin *skin) {
    [(UIImageView *)sender setImage:[skin.image imageNamed:@"folder1/test.png"]];
}];
```

## Resources

A collection of links to external resources that may prove valuable:

## Contributing
### Issue
If you find a bug or need a help, you can [create a issue](https://github.com/peter-m-shi/ZSkin/issues/new)


### Pull Request
Expect your pull request :D. But please make sure it's needed by most developers and make it simple to use. If you are not sure you can create a issue and let's discuss before coding.

## License

The MIT License (MIT)

Copyright (c) 2016 peter-m-shi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
Contact GitHub API Training Shop Blog About
