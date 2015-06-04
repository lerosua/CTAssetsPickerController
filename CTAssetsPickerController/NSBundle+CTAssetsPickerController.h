//
//  NSBundle+CTAssetsPickerController.h
//  CTAssetsPickerDemo
//
//  Created by Miguel Cabeça on 25/11/14.
//  Copyright (c) 2014 Clement T. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CTATextColor      [UIColor colorWithRed:107/255.0 green:183/255.0 blue:39/255.0 alpha:1]


#define CTAssetsPickerControllerLocalizedString(key) \
NSLocalizedStringFromTableInBundle((key), @"CTAssetsPickerController", [NSBundle ctassetsPickerControllerBundle], nil)


@interface NSBundle (CTAssetsPickerController)

+ (NSBundle *)ctassetsPickerControllerBundle;

@end
