//
//  CTAIconButton.h
//  Pods
//
//  Created by lerosua on 15/4/17.
//
//

#import <UIKit/UIKit.h>

@interface UIView (CTAAnimation)

- (void) cta_scaleAnimation;

@end

@interface CTAIconButton : UIButton

- (void) setNumberText:(NSString *)numStr;

@end


@interface CTAIconButtonBarItem : UIBarButtonItem

@property (nonatomic, strong) CTAIconButton *iconButton;

- (void) setTitle:(NSString *)title;


@end