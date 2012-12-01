//
//  Asteroid.m
//  Space Asteroids
//
//  Created by kuwaharg on 11/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Asteroid.h"

@implementation Asteroid
@synthesize type = _type;
@synthesize speed = _speed;

+(Asteroid *) smallAsteroid{
    Asteroid *createdAsteroid = [[Asteroid alloc] initWithImage:nil]; //Create with specific image
    
    //Customize for this type
    

    return createdAsteroid;
}
+(Asteroid *) mediumAsteroid{
    Asteroid *createdAsteroid = [[Asteroid alloc] initWithImage:[UIImage imageNamed:@"asteroid.png"]]; //Create with specific image
    
    createdAsteroid.bounds = CGRectMake(0, 0, 40, 40);
    
    return createdAsteroid;
}
+(Asteroid *) largeAsteroid{
    Asteroid *createdAsteroid = [[Asteroid alloc] initWithImage:nil]; //Create with specific image
    
    return createdAsteroid;
}

@end
