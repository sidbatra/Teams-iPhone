//
//  DWAddProfilePicViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWAddProfilePicViewController.h"

#import "DWUser.h"
#import "DWNavTitleView.h"
#import "DWNavBarRightButtonView.h"
#import "DWSpinnerOverlayView.h"
#import "DWConstants.h"


static NSString* const kMsgIncompleteTitle      = @"Incomplete";
static NSString* const kMsgIncomplete           = @"Please upload a picture";
static NSString* const kMsgErrorTitle           = @"Error";
static NSString* const kMsgCancelTitle          = @"OK";
static NSString* const kAddProfilePicText       = @"Add a Profile Picture";
static NSString* const kNavBarRightButtonText   = @"Next";
static NSString* const kMsgProcesssing          = @"Uploading your photo..";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWAddProfilePicViewController

@synthesize addProfilePicButton             = _addProfilePicButton;
@synthesize useFacebookPhotoButton          = _useFacebookPhotoButton;
@synthesize spinnerContainerView            = _spinnerContainerView;

@synthesize userImage                       = _userImage;
@synthesize userID                          = _userID;

@synthesize navTitleView                    = _navTitleView;
@synthesize navBarRightButtonView           = _navBarRightButtonView;
@synthesize spinnerOverlayView              = _spinnerOverlayView;

@synthesize usersController                 = _usersController;
@synthesize mediaController                 = _mediaController;

@synthesize delegate                        = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
        self.usersController            = [[[DWUsersController alloc] init] autorelease];        
        self.usersController.delegate   = self;
        
        self.mediaController            = [[[DWMediaController alloc] init] autorelease];
        self.mediaController.delegate   = self;
            
	}
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {	
	
    self.addProfilePicButton            = nil;
    self.useFacebookPhotoButton         = nil;
    self.spinnerContainerView           = nil;
    
    self.userImage                      = nil;
    
    self.navTitleView                   = nil;
	self.navBarRightButtonView          = nil;
    self.spinnerOverlayView             = nil;
    
    self.usersController                = nil;
    self.mediaController                = nil;
	
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    [self.addProfilePicButton setBackgroundImage:self.userImage 
                                        forState:UIControlStateNormal];
    
    if (!self.navTitleView)
        self.navTitleView = [[[DWNavTitleView alloc] 
                              initWithFrame:CGRectMake(kNavTitleViewX,0,
                                                       kNavTitleViewWidth,
                                                       kNavTitleViewHeight) 
                                andDelegate:self] autorelease];
    
    [self.navTitleView displayTitle:kAddProfilePicText];
    
    if (!self.navBarRightButtonView)
        self.navBarRightButtonView = [[[DWNavBarRightButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavRightButtonWidth,
                                                                kNavRightButtonHeight)
                                               title:kNavBarRightButtonText 
                                           andTarget:self] autorelease];
    if (!self.spinnerOverlayView)
        self.spinnerOverlayView = [[[DWSpinnerOverlayView alloc] initWithSpinnerOrigin:CGPointMake(50,120)
                                                                        andMessageText:kMsgProcesssing] autorelease];
    
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (void)freezeUI {	
    self.spinnerContainerView.hidden = NO;
    [self.spinnerOverlayView enable];
}

//----------------------------------------------------------------------------------------------------
- (void)unfreezeUI {
    self.spinnerContainerView.hidden = YES;
    [self.spinnerOverlayView disable];
}

//----------------------------------------------------------------------------------------------------
- (void)updateUser {
    
	if (!_hasChangedImage) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgIncompleteTitle
														message:kMsgIncomplete
													   delegate:nil 
											  cancelButtonTitle:kMsgCancelTitle
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else {		
        [self freezeUI];   
        _mediaResourceID = [self.mediaController postImage:self.userImage 
                                                  toFolder:kS3UsersFolder];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)presentMediaPickerControllerForPickerMode:(NSInteger)pickerMode {    
    
    DWMediaPickerController *picker = [[[DWMediaPickerController alloc] initWithDelegate:self] 
                                       autorelease];
    
    [picker prepareForImageWithPickerMode:pickerMode 
                              withPreview:NO];
    
    [self presentModalViewController:picker 
                            animated:NO];   
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (void)didTapNavBarRightButton:(id)sender event:(id)event {
	[self updateUser];
}

//----------------------------------------------------------------------------------------------------
- (IBAction)addProfilePicButtonTapped:(id)sender {
    [self presentMediaPickerControllerForPickerMode:kMediaPickerLibraryMode];
}

//----------------------------------------------------------------------------------------------------
- (IBAction)useFacebookPhotoButtonTapped:(id)sender {
    NSLog(@"to implement facebook integration");
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWMediaController Delegate

//----------------------------------------------------------------------------------------------------
- (NSInteger)mediaResourceID {
    return _mediaResourceID;
}

//----------------------------------------------------------------------------------------------------
- (void)mediaUploaded:(NSString*)filename {
    [self.usersController updateUserHavingID:self.userID 
                                withFilename:filename];
}

//----------------------------------------------------------------------------------------------------
- (void)mediaUploadError:(NSString*)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorTitle
													message:error
												   delegate:nil 
										  cancelButtonTitle:kMsgCancelTitle
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
    
    [self unfreezeUI];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersController Delegate

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(DWUser*)user {
    
    [user updateImages:self.userImage];    
    
    [self.delegate userPhotoUpdated];
    [self unfreezeUI];
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdateError:(NSString*)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorTitle
													message:error
												   delegate:nil 
										  cancelButtonTitle:kMsgCancelTitle
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
    
    [self unfreezeUI];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWMediaPickerControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)didFinishPickingImage:(UIImage*)originalImage andEditedTo:(UIImage*)editedImage {
    _hasChangedImage            = YES;
    self.userImage              = editedImage;
    
    [self.addProfilePicButton setBackgroundImage:editedImage 
                                        forState:UIControlStateNormal];
    
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
- (void)willShowOnNav {
    [self.navigationController.navigationBar addSubview:self.navTitleView];    
    [self.navigationController.navigationBar addSubview:self.navBarRightButtonView];
    [self.navigationController.navigationBar addSubview:self.spinnerOverlayView];    
}


@end
