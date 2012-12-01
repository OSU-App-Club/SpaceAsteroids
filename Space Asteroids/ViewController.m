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
#import "Rocket.h"

//Create a private interface for things we don't want others to see/use
@interface ViewController ()

@property (nonatomic, strong) CMMotionManager * motionManager; //Handles all the sensor data from a device
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, weak) IBOutlet Ship *ship;
@property (nonatomic, strong) NSTimer *asteroidTimer;

@property (nonatomic, strong) NSMutableSet *asteroids;
@property (nonatomic, strong) NSMutableSet *rockets;

@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;


@end



@implementation ViewController
@synthesize motionManager = _motionManager, displayLink = _displayLink;
@synthesize ship = _ship;
@synthesize asteroids = _asteroids, rockets = _rockets;
@synthesize scoreLabel = _scoreLabel, currentScore = _currentScore;


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
    self.rockets = [[NSMutableSet alloc] initWithCapacity:8];
    
    //Create CADisplayeLink to update do collision checking on each frame
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];

    
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
    
    //Create an alert at the start of the game...delegate will tell us when they clicked the button
    UIAlertView *startGameAlert = [[UIAlertView alloc] initWithTitle:@"Asteroids" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Start", nil];
    [startGameAlert show];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark - Game Control

-(void) startGame{
    //Clear score
    self.currentScore = [NSNumber numberWithInt:0];
    //Print out score
    self.scoreLabel.text = [NSNumberFormatter localizedStringFromNumber:self.currentScore numberStyle:NSNumberFormatterBehaviorDefault];
    
    //Start game loops
    
    //Start motion updates (By leaving the interval blank it will update as fast as possible)
    //self.motionManager.deviceMotionUpdateInterval = .05f;
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:
         ^(CMDeviceMotion * motion, NSError *error){
             //This is a block...think of it as an inline function
             
             //NSLog(@"Ship Location X: %f Y:%f",self.ship.frame.origin.x,self.ship.frame.origin.y);
             
             //CMDevice Motion contains information about the "attitude" of the device, or angles relative to the X,Y, and Z axes
             if (motion.attitude.pitch>=0) {
                 self.ship.frame = CGRectMake(MIN(197.9 + (350.0 * motion.attitude.pitch),self.view.bounds.size.width - self.ship.bounds.size.width), 261, self.ship.frame.size.width, self.ship.frame.size.width);
             }
             else{
                 self.ship.frame = CGRectMake(MAX(197.9 + (350.0 * motion.attitude.pitch),0), 261, self.ship.frame.size.width, self.ship.frame.size.width);
             }
             
             //It is always helpful to print out the data to see what you are working with
             //NSLog(@"Pitch: %f Roll %f Yaw: %f",currentAttitude.pitch,currentAttitude.roll,currentAttitude.yaw);
             
        }
     ];
    
    //Start making asteroids
    self.asteroidTimer = [NSTimer scheduledTimerWithTimeInterval:1.75 target:self selector:@selector(createAsteroid) userInfo:nil repeats:YES];
    
    //Add tap gesture to shoot (Must add it to view)
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shootRocket:)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    //Add display link
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
}
-(void) endGame{
    //Stop updates when they are not needed anymore
    [self.motionManager stopDeviceMotionUpdates];
    [self.asteroidTimer invalidate];
    [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
-(void) gameOver{
    //Stop game loops
    [self endGame];
    
    //Remove all rockets and asteroids from screen
    for (Rocket* rocket in self.rockets) {
        [rocket removeFromSuperview];
    }
    for (Asteroid *asteroid in self.asteroids) {
        [asteroid removeFromSuperview];
    }
    [self.asteroids removeAllObjects];
    [self.rockets removeAllObjects];
    
    //Present alert about score
    UIAlertView *gameOverAlert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:[@"Score: " stringByAppendingString:self.currentScore.stringValue] delegate:self cancelButtonTitle:@"Restart" otherButtonTitles:nil];
    [gameOverAlert show];
    
}
#pragma mark - Object Creation
-(void) createAsteroid{
    Asteroid *asteroid = [Asteroid mediumAsteroid];
    
    //Make frame
    asteroid.frame = CGRectMake( fmodf(arc4random(), self.view.bounds.size.width - asteroid.bounds.size.width), (-1) * asteroid.bounds.size.height, asteroid.bounds.size.width, asteroid.bounds.size.height);
    
    //Add to view
    [self.view insertSubview:asteroid belowSubview:self.scoreLabel];
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
-(void) shootRocket:(UITapGestureRecognizer*)tapGesture{
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        //Only add rocket after we finish the gesture
        Rocket *rocket = [Rocket standardRocket];
        
        //Make frame
        rocket.frame = CGRectMake(self.ship.center.x, self.ship.center.y, rocket.bounds.size.width, rocket.bounds.size.height);
        
        //Add to view
        [self.view insertSubview:rocket belowSubview:self.ship];
        //Add to set
        [self.rockets addObject:rocket];
        
        //Animate up the screen
        [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^(){
            rocket.frame = CGRectMake(rocket.frame.origin.x, (-1)*rocket.bounds.size.height, rocket.bounds.size.width, rocket.bounds.size.height);
            
        }completion:^(BOOL finished){
            [rocket removeFromSuperview];
            [self.rockets removeObject:rocket];
        }];

        
    }
}
-(void) update:(CADisplayLink*) displayLink{
    //Do collision detection between asteroids and rockets/ship
    [self.asteroids enumerateObjectsUsingBlock:^(Asteroid *obj, BOOL *stop){
        //Check colliion with a rocket (This is another way to enumerate thru all the objects in a set)
        for (Rocket *rocket in self.rockets) {
            if (CGRectIntersectsRect([obj.layer.presentationLayer frame], [rocket.layer.presentationLayer frame])) {
                //Remove both from screen (Maybe add explosion animation)
                [obj removeFromSuperview];
                [rocket removeFromSuperview];
                
                //Give points for hit
                self.currentScore = [NSNumber numberWithInt:self.currentScore.intValue + rocket.points];
                
                //Update score
                self.scoreLabel.text = [NSNumberFormatter localizedStringFromNumber:self.currentScore numberStyle:NSNumberFormatterBehaviorDefault];
                
                return; //Finish collision checking with this
            }
        }
        
        //Check against ship
        if (CGRectIntersectsRect([obj.layer.presentationLayer frame], self.ship.frame)) {
            //Remove both from screen
            [obj removeFromSuperview];
            
            *stop = YES; //Stops loop from going again
            [self gameOver];
        }
        
    }];
    
}
#pragma mark - UIAlertViewDelegate
-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    //We only know the titles so we can use that to determine if which alert this is
    [self startGame];
}

@end
