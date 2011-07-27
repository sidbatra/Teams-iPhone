//
//  DWSmallUserImageView.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWSmallProfilePicView.h"


static NSString* const kImgOverlayImage         = @"user_photo_gloss.png";
static CGFloat   const kProfileButtonAlpha      = 0.98;



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSmallProfilePicView

@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {       
        self.clipsToBounds              = YES;
        
        profilePicButton                = [UIButton buttonWithType:UIButtonTypeCustom];
        profilePicButton.alpha          = kProfileButtonAlpha;
        
        [profilePicButton addTarget:self 
                             action:@selector(didTapSmallUserImage:event:) 
                   forControlEvents:UIControlEventTouchUpInside];
        
        [profilePicButton setFrame:CGRectMake(0, -8, 60, 60)];
        profilePicButton.enabled = NO;
        [self addSubview:profilePicButton];
        
        
        profilePicOverlay = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        
        profilePicOverlay.image                     = [UIImage imageNamed:kImgOverlayImage];
        profilePicOverlay.userInteractionEnabled    = NO;
        profilePicOverlay.hidden                    = YES;
        
        [self addSubview:profilePicOverlay];
        [profilePicOverlay release];
        
        
        spinner			= [[UIActivityIndicatorView alloc] 
                           initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        spinner.frame	= CGRectMake(20,12,20,20);
        spinner.hidden  = YES;    
        
        [self addSubview:spinner];	
        [spinner release];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.delegate = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
-(void)setProfilePicButtonBackgroundImage:(UIImage*)image {
    profilePicOverlay.hidden = NO;
    
    [profilePicButton setBackgroundImage:image 
                                forState:UIControlStateNormal];
}

//----------------------------------------------------------------------------------------------------
-(void)enableProfilePicButton {
    profilePicButton.enabled = YES;
}

//----------------------------------------------------------------------------------------------------
- (void)showProcessingState {
    profilePicButton.hidden     = YES;
    profilePicOverlay.hidden    = YES;
    spinner.hidden              = NO;
    [spinner startAnimating];
}

//----------------------------------------------------------------------------------------------------
- (void)showNormalState {
    profilePicButton.hidden     = NO;
    profilePicOverlay.hidden    = NO;
    spinner.hidden              = YES;
    [spinner stopAnimating];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)didTapSmallUserImage:(id)sender event:(id)event {
    [self.delegate profilePictureTouched];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)shouldBeRemovedFromNav {
    
}

@end
