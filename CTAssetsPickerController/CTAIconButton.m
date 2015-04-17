//
//  CTAIconButton.m
//  Pods
//
//  Created by lerosua on 15/4/17.
//
//

#import "CTAIconButton.h"

@interface CTAIconButton()

@property (nonatomic, strong) UIView  *iconView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation CTAIconButton

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        _iconView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _iconView.backgroundColor = [UIColor greenColor];
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.font = [UIFont systemFontOfSize:14];
        _numberLabel.text = @"0";
        [_iconView addSubview:_numberLabel];
        
        [self addSubview:_iconView];
//        _iconView.hidden = YES;
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(frame)-20, 20)];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [UIColor greenColor];
        _textLabel.text = @"完成";
        [self addSubview:_textLabel];
    }
    return self;
}

- (void) setNumberText:(NSString *)numStr {
    
    if ([numStr isEqualToString:@"0"]) {
        self.iconView.hidden = YES;
    }else{
        self.iconView.hidden = NO;
        self.numberLabel.text = numStr;
    }
    //做动画
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

