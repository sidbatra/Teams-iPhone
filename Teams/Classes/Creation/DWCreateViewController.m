//
//  DWCreateViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWCreateViewController.h"
#import "DWItemsController.h"
#import "DWUsersHelper.h"
#import "DWLocationManager.h"
#import "DWSession.h"
#import "DWConstants.h"
#import "DWAnalyticsManager.h"

static NSString* const kMsgDataTextViewPlaceholder			= @"What's happening?";
static NSInteger const kTableViewX							= 0;
static NSInteger const kTableViewY							= 44;
static NSInteger const kTableViewWidth						= 320;
static NSInteger const kTableViewHeight						= 200;
static NSInteger const kMaxPlaceNameLength					= 32;
static NSInteger const kMaxPostLength						= 140;
static NSString* const kImgTransBackground                  = @"trans55.png";
static NSString* const kImgLightBackgroundButton			= @"button_gray_light.png";
static NSString* const kImgDarkBackgroundCancelButton		= @"button_gray_dark_cancel.png";
static NSString* const kImgDarkBackgroundCancelButtonActive	= @"button_gray_dark_cancel_active.png";
static NSString* const kImgLightCameraButton				= @"camera_white.png";
static NSString* const kImgCheckedLightCameraButton			= @"camera_white_checked.png";
static NSString* const kImgCheckedBlueCameraButton			= @"camera_blue_checked.png";
static NSString* const kMsgMissingFieldsTitle				= @"Incomplete";
static NSString* const kMsgDataMissing						= @"Add an update using text, photo and video";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCreateViewController

@synthesize previewImageView	= _previewImageView;
@synthesize transImageView		= _transImageView;
@synthesize dataTextView		= _dataTextView;
@synthesize	cancelButton		= _cancelButton;
@synthesize doneButton			= _doneButton;
@synthesize cameraButton		= _cameraButton;
@synthesize coverLabel			= _coverLabel;
@synthesize bylineLabel         = _bylineLabel;

@synthesize data                = _data;
@synthesize placeholder         = _placeholder;
@synthesize cameraImage			= _cameraImage;
@synthesize videoURL			= _videoURL;
@synthesize videoOrientation	= _videoOrientation;

@synthesize itemsController     = _itemsController;

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if (self) {
		_attachmentType         = kAttachmentNone;
        self.itemsController    = [[[DWItemsController alloc] init] autorelease];
            
        self.placeholder        = kMsgDataTextViewPlaceholder;
	}
    
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	
	[[UIApplication sharedApplication] setStatusBarStyle:kStatusBarStyle];
    
    [[DWLocationManager sharedDWLocationManager] stopLocationTracking];
	
	self.previewImageView		= nil;
	self.transImageView			= nil;
	self.dataTextView			= nil;
	self.cancelButton			= nil;
	self.doneButton				= nil;
	self.cameraButton			= nil;
	self.coverLabel				= nil;
    self.bylineLabel            = nil;
	
    self.data                   = nil;
    self.placeholder            = nil;
	self.cameraImage			= nil;
	self.videoURL				= nil;
	self.videoOrientation		= nil;
    
    self.itemsController        = nil;
	
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.navigationController)
        [self.navigationController setNavigationBarHidden:YES
                                                 animated:YES];
    
    
    self.bylineLabel.text               = [DWUsersHelper signatureWithTeamName:[DWSession sharedDWSession].currentUser];
    self.dataTextView.text              = self.data;
    self.dataTextView.placeholderColor  = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.25];
	self.dataTextView.placeholderText	= self.placeholder;
    
    [self.dataTextView becomeFirstResponder];
    
    self.previewImageView.image         = self.cameraImage;
    self.transImageView.image           = [UIImage imageNamed:kImgTransBackground];
    self.transImageView.hidden			= !_inMediaMode;

    
    [[DWLocationManager sharedDWLocationManager] startLocationTracking];
    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:kActionNameForLoad];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];	
    
    self.data   = self.dataTextView.text;
}

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
	/**
	 * Commented out to prevent reloading upon a
	 * low memory warning
	 */
	//[super didReceiveMemoryWarning];
}

//----------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (void)displayMediaUI {
	/**
	 * Revamp the entire UI when media is selected
	 */
    _inMediaMode = YES;
	//self.coverLabel.backgroundColor		= [UIColor blackColor];
	
	//self.previewImageView.hidden		= NO;
	self.transImageView.hidden			= NO;
	
	//[self.cancelButton setBackgroundImage:[UIImage imageNamed:kImgDarkBackgroundCancelButton] 
	//							 forState:UIControlStateNormal];
	//[self.cancelButton setBackgroundImage:[UIImage imageNamed:kImgDarkBackgroundCancelButtonActive]
	//							 forState:UIControlStateHighlighted];
	
	//[self.cameraButton setBackgroundImage:[UIImage imageNamed:kImgLightCameraButton]
	//							 forState:UIControlStateNormal];

	//self.dataTextView.placeholderColor = [UIColor clearColor];
	//[self.dataTextView setNeedsDisplay];
	
    //self.dataTextView.textColor	= [UIColor whiteColor];
}

//----------------------------------------------------------------------------------------------------
-(BOOL)isValidPost {
	
	BOOL status = YES;
	
    if(!(self.dataTextView.text.length > 0 || _attachmentType != kAttachmentNone)) {

		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgMissingFieldsTitle
														message:kMsgDataMissing
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
		
		status = NO;
	}
    
	return status;
}

//----------------------------------------------------------------------------------------------------
-(void)presentMediaPickerControllerForPickerMode:(NSInteger)pickerMode {    
    DWMediaPickerController *picker = [[[DWMediaPickerController alloc] initWithDelegate:self] autorelease];
    [picker prepareForMediaWithPickerMode:pickerMode];
    [self presentModalViewController:picker animated:NO];   
}

//----------------------------------------------------------------------------------------------------
- (void)exit {
    
    if(self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self.parentViewController dismissModalViewControllerAnimated:NO];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)createPost {
    if(![self isValidPost])
		return;
	
    
    if(_attachmentType == kAttachmentNone) {        
        [self.itemsController queueWithData:self.dataTextView.text
                                 atLocation:[[DWLocationManager sharedDWLocationManager] getCurrentLocation]];
        
    }
    else if(_attachmentType == kAttachmentImage) {
        
        [self.itemsController queueWithData:self.dataTextView.text
                                 atLocation:[[DWLocationManager sharedDWLocationManager] getCurrentLocation]
                                  withImage:self.cameraImage];
    }
    else if(_attachmentType == kAttachmentVideo) {			
        
        [self.itemsController queueWithData:self.dataTextView.text
                                 atLocation:[[DWLocationManager sharedDWLocationManager] getCurrentLocation]
                               withVideoURL:self.videoURL
                        andVideoOrientation:self.videoOrientation
                           withPreviewImage:self.previewImageView.image];
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNRequestTabBarIndexChange
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                [NSNumber numberWithInteger:kTabBarFeedIndex],kKeyTabIndex,
                                                                [NSNumber numberWithInteger:kResetHard],kKeyResetType,
                                                                nil]];
	
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"item_created"
                                                               andExtraInfo:[NSString stringWithFormat:@"data=%@&attachment=%d",
                                                                             self.dataTextView.text,
                                                                             _attachmentType]];
    
	
    [self exit];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITextViewDelegate

//----------------------------------------------------------------------------------------------------
- (BOOL)textView:(UITextView *)theTextView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text{
    
    if([text isEqualToString:@"\n"]) {
        [self createPost];
        return NO;
    }
	
	NSUInteger newLength = [self.dataTextView.text length] + [text length] - range.length;
    return (newLength > kMaxPostLength) || [text isEqualToString:@"\n"] ? NO : YES;
    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (void)cancelButtonClicked:(id)sender {
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"cancel_selected"];
     
    
    [self exit];
}

//----------------------------------------------------------------------------------------------------
- (void)cameraButtonClicked:(id)sender {
    [self presentMediaPickerControllerForPickerMode:kMediaPickerCaptureMode];
}

//----------------------------------------------------------------------------------------------------
- (void)doneButtonClicked:(id)sender {
	[self createPost];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWMediaPickerControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)didFinishPickingImage:(UIImage*)originalImage 
				  andEditedTo:(UIImage*)editedImage {
		
	_attachmentType		= kAttachmentImage;
	
	/**
	 * Free memory from a previously selected video
	 */
	self.videoURL			= nil;
	self.videoOrientation	= nil;
	
	[self displayMediaUI];
	
	self.cameraImage			= editedImage;
	self.previewImageView.image = editedImage;
	
	[self dismissModalViewControllerAnimated:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)didFinishPickingVideoAtURL:(NSURL*)theVideoURL
				   withOrientation:(NSString*)orientation
						andPreview:(UIImage*)image {
	
	_attachmentType		= kAttachmentVideo;

	/**
	 * Free memory from a previously selected image
	 */
	self.cameraImage = nil;
	
	[self displayMediaUI];
	
	self.videoURL			= theVideoURL;
	self.videoOrientation	= orientation;	
	
	self.previewImageView.image = image;
		
	[self dismissModalViewControllerAnimated:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)mediaPickerCancelledFromMode:(NSInteger)imagePickerMode {    
    [self dismissModalViewControllerAnimated:NO];  
    
    if (imagePickerMode == kMediaPickerLibraryMode)
        [self presentMediaPickerControllerForPickerMode:kMediaPickerCaptureMode];
}

//----------------------------------------------------------------------------------------------------
- (void)photoLibraryModeSelected {
    [self dismissModalViewControllerAnimated:NO];
    [self presentMediaPickerControllerForPickerMode:kMediaPickerLibraryMode];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
}

//----------------------------------------------------------------------------------------------------
- (void)hideTopShadowOnTabBar {
    
}

@end
