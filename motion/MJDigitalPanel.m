//
//  MJDigitalPanel.m
//  motion
//
//  Created by Dan Park on 11/10/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJDigitalPanel.h"

@interface MJDigitalPanel ()
@property (nonatomic, strong) NSMutableString *timeString;
@property (nonatomic, strong) NSMutableString *displayString;
@end

@implementation MJDigitalPanel {
    __weak IBOutlet UILabel *digitalLabel;
    __weak IBOutlet UILabel *backdropLabel;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)constructPanel {
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    [self setTimeString:mutableString];
    
    UIFont *ionfont = [UIFont fontWithName:@"IONC-Bold" size:58];
    [digitalLabel setFont:ionfont];
    [backdropLabel setFont:ionfont];
    [backdropLabel setHidden:NO];
    [backdropLabel setTextColor:[UIColor colorWithWhite:1.0 alpha:1/20.0]];
    [digitalLabel setTextColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
}

- (NSString*)processTimeString {
    NSUInteger commandIndex = 5;
    NSUInteger limit = commandIndex+1;
    NSUInteger periodIndex = 1;
    
    if ([_timeString length] >= limit) {
        NSRange range = NSMakeRange(0, commandIndex+1);
        NSString *immutable = [_timeString substringWithRange:range];
        _timeString = [immutable mutableCopyWithZone:NULL];
    }
    _displayString = [_timeString mutableCopyWithZone:NULL];
    
    if ([_displayString length] >= periodIndex+1) {
        const NSUInteger indexNMinus = [_displayString length] - periodIndex;
        [_displayString insertString:@"." atIndex:indexNMinus];
        
        if ([_displayString length] >= commandIndex+1) {
            const NSUInteger indexNMinus = [_displayString length] - commandIndex;
            [_displayString insertString:@"," atIndex:indexNMinus];
            
            const NSUInteger appendedCount = 2;
            if ([_timeString length] > commandIndex+2+appendedCount) {
                NSUInteger permittedLength = 5;
                NSString *immutable = [_displayString copyWithZone:NULL];
                immutable = [immutable stringByPaddingToLength:permittedLength withString:@"" startingAtIndex:0];
                _displayString = [immutable mutableCopyWithZone:NULL];
            }
        }
    }
    return _displayString;
}

- (void)updateValue:(NSUInteger)value {
    NSString *localizedString = [NSString stringWithFormat:@"%lu", (unsigned long)value];
    [_timeString setString:localizedString];
    [self processTimeString];
    
    dispatch_async(dispatch_get_main_queue(), ^() {
        [digitalLabel setText:[_displayString description]];
    });
}

@end
