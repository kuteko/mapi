//
//  SingletonManager.m
//  mapi
//
//  Created by 内山 香 on 2014/08/30.
//  Copyright (c) 2014年 内山 香. All rights reserved.
//

#import "SingletonManager.h"

@implementation SingletonManager

static SingletonManager * shareData_=nil;

+(SingletonManager *)shareManager{
    
    @synchronized(self){
        if (shareData_ ==nil) {
            shareData_=[[self alloc]init];
            
        }
    }
    return shareData_;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    @synchronized(self){
        if (shareData_==nil) {
            shareData_=[super allocWithZone:zone];
            return shareData_;
        }
    }
    
    return nil;
}

-(id)copyWithZone:(NSZone *)zone{
    return self;
    
}


-(void)setCount:(int) count{
    managedCount = count;
}

-(int)getCount{
    return managedCount;
}


-(void)setStartLocation:(CGPoint)location{
    managedStartLocation=location;
}
-(CGPoint)getStartLocation{
    return managedStartLocation;
}



-(void)setLocation:(CGPoint)location{
    managedLocation=location;
}
-(CGPoint)getLocation{
    return managedLocation;
}



-(void)setEndLocation:(CGPoint)location{
    managedEndLocation=location;
}
-(CGPoint)getEndLocation{
    return managedEndLocation;
}

-(void)setScrollView:(UIScrollView *)scview{
    managedScrollView=scview;
    
}
-(UIScrollView *)getScrollView{
    return managedScrollView;
}

-(void)setSaveCount:(NSUserDefaults *)singlesavecount{
    managedSaveCount=singlesavecount;
    
}
-(NSUserDefaults *)getSaveCount{
    
    return managedSaveCount;
}


@end
