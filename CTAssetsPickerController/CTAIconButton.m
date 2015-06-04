//
//  CTAIconButton.m
//  Pods
//
//  Created by lerosua on 15/4/17.
//
//

#import "CTAIconButton.h"
#import "NSBundle+CTAssetsPickerController.h"
#import <POP.h>

@implementation UIView(CTAAnimation)

- (void) cta_scaleAnimation {
    float resizeValue = 1.2f;
    
    // Grow animation
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    
    scaleAnimation.fromValue  = [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5f)];
    //    scaleAnimation.springBounciness = 18.0f;
    scaleAnimation.toValue  = [NSValue valueWithCGSize:CGSizeMake(resizeValue, resizeValue)];
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        // Grow animation done
        POPSpringAnimation *scaleAnimationDown = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimationDown.fromValue  = [NSValue valueWithCGSize:CGSizeMake(resizeValue, resizeValue)];
        scaleAnimationDown.toValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
        scaleAnimationDown.springBounciness = 18.0f;
        
        [self.layer pop_addAnimation:scaleAnimationDown forKey:@"OJAscaleDownAnimation"];
    };
    
    [self.layer pop_addAnimation:scaleAnimation forKey:@"OJAscaleUpAnimation"];
}

@end

@interface CTAIconButton()

@property (nonatomic, strong) UIView  *iconView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation CTAIconButton

static CGFloat IconButtonOffetY = 10;


- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        _iconView = [[UIView alloc] initWithFrame:CGRectMake(0, IconButtonOffetY+2, 16, 16)];
        _iconView.backgroundColor = CTATextColor;
        _iconView.layer.cornerRadius = 8;
        _iconView.layer.masksToBounds = YES;
        
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 16, 16)];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.font = [UIFont systemFontOfSize:12];
        _numberLabel.text = @"0";
        [_iconView addSubview:_numberLabel];
        
        [self addSubview:_iconView];
//        _iconView.hidden = YES;

        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, IconButtonOffetY, CGRectGetWidth(frame)-20, 20)];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = CTATextColor;
        _textLabel.text = CTAssetsPickerControllerLocalizedString(@"Done");
        [self addSubview:_textLabel];
    }
    return self;
}

- (void) setNumberText:(NSString *)numStr {
    
    if ([numStr isEqualToString:@"0"]) {
        self.iconView.hidden = YES;
        self.textLabel.textColor = [UIColor grayColor];
    }else{
        self.iconView.hidden = NO;
        self.numberLabel.text = numStr;
        self.textLabel.textColor = CTATextColor;
        //做动画
        [self.iconView cta_scaleAnimation];
    }

    
}

@end

@interface CTAIconButtonBarItem()

@end

@implementation CTAIconButtonBarItem

- (instancetype) init {
    self = [super init];
    if(self){
        _iconButton = [[CTAIconButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        self.customView = _iconButton;
    }
    return self;
}

- (void) setTitle:(NSString *)title{
    if ([title isEqualToString:@"0"]) {
        self.iconButton.enabled = NO;
        self.enabled = NO;
    }else{
        self.enabled = YES;
        self.iconButton.enabled = YES;
    }
    
    [self.iconButton setNumberText:title];
}


@end

