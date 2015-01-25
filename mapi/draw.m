//
//  draw.m
//  mapi
//
//  Created by 内山 香 on 2014/08/30.
//  Copyright (c) 2014年 内山 香. All rights reserved.
//

#import "draw.h"
#import "newmap.h"
#import "SingletonManager.h"

@implementation draw


// @synthesize lineX;
//@synthesize lineY;
//@synthesize t_count;


-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=UIColor.clearColor;
        
    }
    //    checknum=0;
    SingletonManager *single=[SingletonManager shareManager];
    //    self.locationcount = [single getCount];
    self.startlocation = [single getStartLocation];
    self.location = [single getLocation];
    self.scrollView = [single getScrollView];
    
    return self;
    
}

-(void)drawRect:(CGRect)rect
{
    // 直線を描画
    CGContextRef context = UIGraphicsGetCurrentContext();  // コンテキストを取得
    CGContextSetStrokeColorWithColor(context, UIColor.grayColor.CGColor);
    CGContextSetLineWidth(context, 3.0);
    CGContextMoveToPoint(context,self.startlocation.x-_scrollView.contentOffset.x,self.startlocation.y-_scrollView.contentOffset.y);  // 始点
    CGContextAddLineToPoint(context,self.location.x-_scrollView.contentOffset.x, self.location.y-_scrollView.contentOffset.y);  // 終点
    
    //ドラッグしてendを取得する方法を探れ!!!!!!!!!!!!!!!
    CGContextStrokePath(context);  // 描画！
    
    
}




@end
