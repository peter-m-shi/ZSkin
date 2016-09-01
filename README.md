![ZSkin](https://github.com/peter-m-shi/ZSkin/raw/master/Images/Logo.jpg)

ZSkin is a skin manager tool for iOS

## Installation

ZSkin is available on [CocoaPods](http://cocoapods.org). Just add the following to your project Podfile:

```ruby
pod 'ZSkin', '~> 1.0'
```

Bugs are first fixed in master and then made available via a designated release. If you tend to live on the bleeding edge, you can use ZSkin from master with the following Podfile entry:

```ruby
pod 'ZSkin', :git => 'https://github.com/peter-m-shi/ZSkin.git'
```

## Demo
Gif演示图

## Usage

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
#### Binding and Unbinding

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
    NSLog(@"%@ receive skin change notification", self.class);
    self.title = self.skin.name;
}
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
