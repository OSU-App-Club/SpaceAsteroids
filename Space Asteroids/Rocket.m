//
//  Rocket.m
//  Space Asteroids
//
//  Created by kuwaharg on 11/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Rocket.h"

@implementation Rocket
@synthesize speed = _speed;
@synthesize points = _points;

+(Rocket *) standardRocket{
    Rocket *createdRocket = [[Rocket alloc] initWithImage:[UIImage imageNamed:@"rocket.png"]];
    
    createdRocket.bounds = CGRectMake(0, 0, 20,30);
    createdRocket.points = 10;
    
    return createdRocket;
}

@end
