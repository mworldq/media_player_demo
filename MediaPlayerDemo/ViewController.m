

#import "ViewController.h"

@interface ViewController (Private)
- (void) startPlayingVideo:(id)paramSender;
- (void) stopPlayingVideo:(id)paramSender;
@end

@implementation ViewController

@synthesize moviePlayer, label, textField, button;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //button
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.button.frame = CGRectMake(0.0f, 0.0f, 70.0f, 37.0f);
    self.button.center = self.view.center;
    
    self.button.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleRightMargin;
    
    [self.button addTarget:self
                    action:@selector(startPlayingVideo:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitle:@"Play"
                 forState:UIControlStateNormal];
    
    //label
    
    CGRect rect1 = CGRectMake(30.0f, self.view.bounds.size.height/2 - 100, 50.0f, 30.0f);
    self.label = [[UILabel alloc]initWithFrame:rect1];
    self.label.text = @"URL:";
    self.label.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleRightMargin;
    
    
    //text field
    CGRect rect2 = CGRectMake(80.0f, self.view.bounds.size.height/2 - 100, self.view.bounds.size.width-140, 30.0f);
    self.textField = [[UITextField alloc]initWithFrame:rect2];
    self.textField.text = @"https://devimages.apple.com.edgekey.net/resources/http-streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8";
    self.textField.accessibilityHint = @"url";
    self.textField.backgroundColor = [UIColor yellowColor];
    
    self.textField.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleRightMargin;
    
    [self.view addSubview:self.button];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.label];
    
}

- (void) viewDidUnload{
    self.button = nil;
    self.textField = nil;
    [self stopPlayingVideo:nil];
    self.moviePlayer = nil;
    [super viewDidUnload];
}

- (void)startPlayingVideo:(id)paramSender{
    NSString *urlAsString = self.textField.text;
    NSURL *url = [NSURL URLWithString:urlAsString];
    if (self.moviePlayer != nil){
        [self stopPlayingVideo:nil];
    }
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    if (self.moviePlayer != nil){
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(videoHasFinishedPlaying:)
         name:MPMoviePlayerPlaybackDidFinishNotification
         object:self.moviePlayer];
        
        NSLog(@"Successfully instantiated the movie player.");
        
        self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        [self.moviePlayer play];
        [self.view addSubview:self.moviePlayer.view];
        [self.moviePlayer setFullscreen:YES
                               animated:YES];
    } else {
        NSLog(@"Failed to instantiate the movie player.");
    }
}

- (void)stopPlayingVideo:(id)paramSender{
    if (self.moviePlayer != nil){
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:MPMoviePlayerPlaybackDidFinishNotification
         object:self.moviePlayer];

        [self.moviePlayer stop];
        
        if ([self.moviePlayer.view.superview isEqual:self.view]){
            [self.moviePlayer.view removeFromSuperview];
        }
    }
}

- (void) videoHasFinishedPlaying:(NSNotification *)paramNotification{
    
    NSNumber *reason =
    [paramNotification.userInfo
     valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    if (reason != nil){
        NSInteger reasonAsInteger = [reason integerValue];
        switch (reasonAsInteger){
            case MPMovieFinishReasonPlaybackEnded:{
                break;
            }
            case MPMovieFinishReasonPlaybackError:{
                break;
            }
            case MPMovieFinishReasonUserExited:{
                break;
            }
        }
        
        NSLog(@"Finish Reason = %ld", (long)reasonAsInteger);
        [self stopPlayingVideo:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation
:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}

@end
