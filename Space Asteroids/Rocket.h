//
//  Rocket.h
//  Space Asteroids
//
//  Created by kuwaharg on 11/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Rocket : UIImageView

@property (readonly) CGFloat speed; //Speed in points/second

+(Rocket *) standardRocket;


@end
