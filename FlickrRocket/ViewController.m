//
//  ViewController.m
//  FlickrRocket
//
//  Created by Rahul Ratthen on 20/04/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController



//method to handle  left swipe. 
//it loads the next image to the image view. Also takes care of the wrap around
-(void)handleSwipeLeft:(UISwipeGestureRecognizer *)recognizer {
//    NSLog(@"Left Swipe received.");
    if([t count]>2)
    {
    if(img_count==[t count]-1)
        img_count=0;
    else {
        img_count++;
    }
    //myView.image=[t objectAtIndex:img_count];
    [UIView transitionWithView:self.view
                      duration:1.0f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        myView.image = [t objectAtIndex:img_count];
                    } completion:nil];
    
    }
}
  


//method to handle right swipe. 
//it loads the previous image to the image view. Also takes care of the wrap around
-(void)handleSwipeRight:(UISwipeGestureRecognizer *)recognizer {
   // NSLog(@"Right Swipe received.");
    if(img_count<=0)
        img_count=[t count]-1;
    else {
        img_count--;
    }
   // myView.image=[t objectAtIndex:img_count];
    [UIView transitionWithView:self.view
                      duration:1.0f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        myView.image = [t objectAtIndex:img_count];
                    } completion:nil];
}



//I tried these methods when I wanted to use Asynchronous connection. But since I switched to multi-
//threading in the future, I had to use Synchronous connection, making these functions useless.
/*
   
    - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
    {
        // This method is called when the server has determined that it
        // has enough information to create the NSURLResponse.
        
        // It can be called multiple times, for example in the case of a
        // redirect, so each time we reset the data.
        
        // receivedData is an instance variable declared elsewhere.
         NSLog(@"Recieve Response");
        [responseData setLength:0];
    }
    - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
    {
        // Append the new data to receivedData.
        // receivedData is an instance variable declared elsewhere.
        NSLog(@"Revieve Data");
        [responseData appendData:data];
    }

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[responseData length]);
    
    // release the connection, and the data object
    [connection release];
   // [receivedData release];
}

*/
 

-(void)UpdateUI:(double)value
{
    [progressBar setProgress:value];
    if(value==1.0)
    {
    [indicator stopAnimating]; //stop the Activity Indicator when the download is done
    [indicator removeFromSuperview];
    
    [progressBar removeFromSuperview];
    }
}

//Entry point for my Thread. This is where I do all the Data fetching work and store the downloaded images to the NSArray, which will be used by my ImageView.
-(void)myThreadMainMethod:(NSThread *)myThread
{
    NSLog(@"Thread");

    NSString *URLString = @"http://api.flickr.com/services/rest/?format=json&sort=random&method=flickr.photos.search&tags=rocket&tag_mode=all&api_key=0e2b6aaf8a6901c264acb91f151a3350&nojsoncallback=1";
    NSURL *myURL = [NSURL URLWithString:URLString];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    
     NSURLResponse *response = nil;
     NSError *error = nil;
     NSData *responseData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:&response error:&error];
    
    
    
    
    if (responseData) {
      //  NSLog(@"%@", [NSString stringWithCString:[responseData bytes] encoding:NSUTF8StringEncoding]);
        
        NSError * j_error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&j_error];
        if(j_error == nil)
        {
            NSDictionary * result = (NSDictionary *) json; //this will contain the raw data downloaded
            //NSLog(@"|>%@<|", result);
            
            
            NSMutableDictionary *result2 = [[NSMutableDictionary alloc] init];
            result2 = [result valueForKey:@"photos"]; //making a dictionary for the values in "photos"tag
            
            
            NSMutableDictionary *result3 = [[NSMutableDictionary alloc] init];
            result3 = [result2 valueForKey:@"photo"]; //making a dictionary for the values in "photo"tag
            
            //getting the necessary data from the dictionary to build my URL
            NSArray *farm=[result3 valueForKey:@"farm"];
            NSArray *server=[result3 valueForKey:@"server"];
            NSArray *pid=[result3 valueForKey:@"id"];
            NSArray *secret=[result3 valueForKey:@"secret"];
            
            //for loop to construct all the URL addresses.
            for (int i = 0; i < [farm count]; i++)
            {
                NSString *final=[NSString stringWithString:@"http://farm"];
                NSString* temp=[farm objectAtIndex:i] ;
                final = [final stringByAppendingString:[NSString stringWithFormat:@"%@", temp]];
                final = [final stringByAppendingString:@".static.flickr.com/"];
                final = [final stringByAppendingString:[NSString stringWithFormat:@"%@", [server objectAtIndex:i]]];
                final=[final stringByAppendingString:@"/"];
                final = [final stringByAppendingString:[NSString stringWithFormat:@"%@", [pid objectAtIndex:i]]];
                final=[final stringByAppendingString:@"_"];
                final = [final stringByAppendingString:[NSString stringWithFormat:@"%@", [secret objectAtIndex:i]]];
                final=[final stringByAppendingString:@"_m.jpg"];
                //variable final will contain the final URL i created using the information. The only task left is to fetch the images from that location.
                
                
                NSURL *url = [NSURL URLWithString:final];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *img = [[UIImage alloc] initWithData:data];              
                //img will contain the downloaded image. Add it to the NSArray so that IMageVIew uses it for loading.
                
                
                [t addObject:img];
                wait=1; //This is a flag I use to notify the main Thread that atleast one image is loaded. So the ImageView can display the first image.
              
              //   NSLog(@"%@",t);
                progress=(float)(i+1)/[farm count];
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self UpdateUI:progress];
                    

                });
                //NSLog(@"%f",progress);
                
            }
        }
        
    }
        NSLog(@"Loaded");
    
   // [self.activityIndicator stopAnimating];
    
 
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

   // myView = [[UIImageView alloc] initWithFrame:self.view.frame];
    //creating my ImageView 
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    myView = [[UIImageView alloc] initWithFrame:screenBounds];
    //myView.contentMode = UIViewContentModeScaleAspectFit;
    myView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                               UIViewAutoresizingFlexibleHeight);  
    t = [[NSMutableArray alloc] init];
    img_count=0;
    progress=0.0;
    
    wait=0;

    //creating my ActivityIndicator
    indicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite ];
    indicator.hidesWhenStopped = YES;
    [myView addSubview:indicator];
    [indicator startAnimating];
    
    
    //creating a new Thread that takes care of the Downloading process
    NSThread* myThread = [[NSThread alloc] initWithTarget:self    selector:@selector(myThreadMainMethod:)object:nil ];
    [myThread start];
    
   

   
    
    //Tried Progress indicator. But I couldn't use it since I had to use Synchronous connection in my secondary thread.
    
    progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [myView addSubview:progressBar];
    [progressBar setProgress:progress];
       
   
    
    //This while loop is just to make the main thread wait till the secondary thread notifies it about the first image ready to be displayed
    while(!wait)
    {
        //do nothing

    }
    
    
    myView.image=[t objectAtIndex:0];
    
    //adding swipe gestures to my Image View
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    [recognizer release];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
    [recognizer release];
    
    [super viewDidLoad];
    
    
    [self.view addSubview:myView];
    [myView release]; 


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
