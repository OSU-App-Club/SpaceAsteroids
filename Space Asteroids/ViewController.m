//
//  ViewController.m
//  Space Asteroids
//
//  Created by kuwaharg on 11/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Ship.h"
#import "Asteroid.h"

//Create a private interface for things we don't want others to see/use
@interface ViewController ()

@property (nonatomic, strong) CMMotionManager * motionManager; //Handles all the sensor data from a device
@property (nonatomic, strong) IBOutlet Ship *ship;
@property (nonatomic, strong) NSTimer *asteroidTimer;

@property (nonatomic, strong) NSMutableSet *asteroids;

@end



@implementation ViewController
@synthesize motionManager = _motionManager;
@synthesize ship = _ship;
@synthesize asteroids = _asteroids;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Create CMMotionManager only once on startup
    self.motionManager = [[CMMotionManager alloc] init];
    NSLog(@"Screen Width: %f Height: %f",self.view.bounds.size.width,self.view.bounds.size.height);
    
    //Create set
    self.asteroids = [[NSMutableSet alloc] initWithCapacity:10];
    
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
    
    //Start motion updates (By leaving the interval blank it will update as fast as possible)
    //self.motionManager.deviceMotionUpdateInterval = .05f; 
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:
        ^(CMDeviceMotion * motion, NSError *error){
            //This is a block...think of it as an inline function
            
            //NSLog(@"Ship Location X: %f Y:%f",self.ship.frame.origin.x,self.ship.frame.origin.y);
            
            //CMDevice Motion contains information about the "attitude" of the device, or angles relative to the X,Y, and Z axes
            if (motion.attitude.pitch>=0) {
                self.ship.frame = CGRectMake(MIN(197.9 + (267.0 * motion.attitude.pitch),self.view.bounds.size.width - self.ship.bounds.size.width), 261, self.ship.frame.size.width, self.ship.frame.size.width);
            }
            else{
                self.ship.frame = CGRectMake(MAX(197.9 + (267.0 * motion.attitude.pitch),0), 261, self.ship.frame.size.width, self.ship.frame.size.width);
            }
            
            //It is always helpful to print out the data to see what you are working with
            //NSLog(@"Pitch: %f Roll %f Yaw: %f",currentAttitude.pitch,currentAttitude.roll,currentAttitude.yaw);
    
        }
     ];
    
    //Start making asteroids
    self.asteroidTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(createAsteroid) userInfo:nil repeats:YES];
    
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
    [self.asteroidTimer invalidate];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark - Asteroid
-(void) createAsteroid{
    NSLog(@"Create Asteroid");
    Asteroid *asteroid = [Asteroid mediumAsteroid];
    
    //Make frame
    asteroid.frame = CGRectMake( fmodf(arc4random(), self.view.bounds.size.width), (-1) * asteroid.bounds.size.height, asteroid.bounds.size.width, asteroid.bounds.size.height);
    
    //Add to view
    [self.view addSubview:asteroid];
    //Add to set
    [self.asteroids addObject:asteroid];
    
    //Animate down the screen
    [UIView animateWithDuration:3.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^(){
        asteroid.frame = CGRectMake(asteroid.frame.origin.x, self.view.bounds.size.height, asteroid.bounds.size.width, asteroid.bounds.size.height);
        
    }completion:^(BOOL finished){
        [asteroid removeFromSuperview];
        [self.asteroids removeObject:asteroid];
    }];
    
    
}

@end
