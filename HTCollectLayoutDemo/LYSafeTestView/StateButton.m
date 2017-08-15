//
//  StateButton.m
//  PotatoMall
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "StateButton.h"
#import "UIImage+Extension.h"


@implementation StateButton

#pragma mark - override methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil){
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    self.selected = !self.selected;
//}

//- (void)setSelected:(BOOL)selected
//{
//    [super setSelected:selected];
//}

+ (UIFont*)titleHFont
{
    return [UIFont fontWithName:@"Helvetica"size:14.f];
}


#pragma mark - set up 
- (void)setupUI
{
    NSLog(@"%s",__FUNCTION__);
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 20;
    self.layer.masksToBounds = YES;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
}



@end
