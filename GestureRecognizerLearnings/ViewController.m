//
//  ViewController.m
//  GestureRecognizerLearnings
//
//  Created by Angelo Lobo on 6/29/15.
//  Copyright (c) 2015 Angelo Lobo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    //NSLog(@"translation.x = %f |-----| recognizer.view.center.x = %f", translation.x, recognizer.view.center.x);
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    //Reset translation to 0 each time we move the view.
    //(init = 2.5), move by 2, becomes 4.5, view moves by 4.5, move by 3, becomes 7.5, view moves by 7.5, move by 10, becomes 17.5
    //Thus the value compunds and for a small movement will move the view off the screen.
    //So every time we get a translation, we move the view then reset the translation to 0
    //(init = 2.5), move by 2, becomes 4.5, reset to 0, move by 3, becomes 3, view moves only by 3, and not by 7.5
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    //Adding deceleration - RW Blog
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
        
        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
        CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor),
                                         recognizer.view.center.y + (velocity.y * slideFactor));
        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.view.bounds.size.width);
        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.view.bounds.size.height);
        
        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            recognizer.view.center = finalPoint;
        } completion:nil];
    }
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    
    //Use the current transform, each time this method is called. Scale it to the amount the user has scaled the UIView. the user scales the view by pinching in or out. The amount 'in' or 'out' is represented by the UIPinchGestureRecognizer's scale property.
    //We create this transform using the CGAffineTransformScale function, that is a part of the Quartz2D programming framework.
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    
    //Once we have set the current view's transform, we reset the scale to 1. This is because the scale is a multiplier and resetting it to 0, will cause the view to disappear, because in the previous line, we are setting the current transform to the previous transform, scaled along the x and u values by a factor of recognizer.scale, which is a multiplier in internal calcs. This will cause the transform to be set to 0 along the x and y axes which will cause the view to disappear.
    recognizer.scale = 1;
}

- (IBAction)handleRotate:(UIRotationGestureRecognizer *)recognizer {
    
    //Use the current transform, each time this method is called. Rotate the transform by the amount the user has rotated, which is returned in recognizer.rotation - this is the angle by which the user has rotated the view.
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    //Reset recognizer.rotation to 0, since recognizer.rotation is a value of the angle by which to rotate.
    recognizer.rotation = 0;
}

@end
