//
//  ViewController.h
//  FlickrRocket
//
//  Created by Rahul Ratthen on 20/04/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate, NSURLConnectionDelegate>
{
    IBOutlet UIImageView *myView;
    
    NSMutableArray *t ;//array that contains the images downloaded
    
    NSInteger img_count; //index of the loaded image
    
    float progress;
    
    NSInteger wait;//dummy variabale to know when the first image is available so that it can be displayed
    UIActivityIndicatorView *indicator;
    
    UIProgressView *progressBar;
    
}
/*
@property (nonatomic, retain) UIProgressView *progressBar;
@property (nonatomic, retain) NSMutableData *resourceData;
@property (nonatomic, retain) NSNumber *filesize;
*/


@end
