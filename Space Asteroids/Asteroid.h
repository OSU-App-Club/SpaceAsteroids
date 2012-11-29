//
//  Asteroid.h
//  Space Asteroids
//
//  Created by kuwaharg on 11/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum asteroidType{
            smallType = 0,
            mediumType = 1,
            largeType = 2
        } asteroidType;

@interface Asteroid : UIImageView

@property (readonly) asteroidType type;
@property (readonly) CGFloat    speed; //Speed in points/second

//Create Functions
+ (Asteroid *) smallAsteroid;
+ (Asteroid *) mediumAsteroid;
+ (Asteroid *) largeAsteroid;


@end
