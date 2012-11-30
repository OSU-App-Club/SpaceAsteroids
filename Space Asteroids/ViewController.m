//
//  ViewController.m
//  Space Asteroids
//
//  Created by kuwaharg on 11/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

//Create a private interface for things we don't want others to see/use
@interface ViewController ()

@property (nonatomic, strong) CMMotionManager * motionManager; //Handles all the sensor data from a device

@end



@implementation ViewController
@synthesize motionManager = _motionManager;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Create CMMotionManager only once on startup
    self.motionManager = [[CMMotionManager alloc] init];
    NSLog(@"Screen Width: %f Height: %f",self.view.bounds.size.width,self.view.bounds.size.height);

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Start motion updates
    self.motionManager.deviceMotionUpdateInterval = .5f;
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:
        ^(CMDeviceMotion * motion, NSError *error){
            //This is a block...think of it as an inline function
            
            //CMDevice Motion contains information about the "attitude" of the device, or angles relative to the X,Y, and Z axes
            CMAttitude *currentAttitude = motion.attitude;
            
            //It is always helpful to print out the data to see what you are working with
            NSLog(@"Pitch: %f Roll %f Yaw: %f",currentAttitude.pitch,currentAttitude.roll,currentAttitude.yaw);
    
        }
     ];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    //Stop updates when they are not needed anymore
    [self.motionManager stopDeviceMotionUpdates];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


@end
