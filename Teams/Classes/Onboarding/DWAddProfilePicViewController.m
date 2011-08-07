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
#import "DWAnalyticsManager.h"


static NSString* const kMsgIncompleteTitle      = @"Incomplete";
static NSString* const kMsgIncomplete           = @"Please upload a picture";
static NSString* const kMsgErrorTitle           = @"Error";
static NSString* const kMsgCancelTitle          = @"OK";
static NSString* const kAddProfilePicText       = @"Add a Profile Picture";
static NSString* const kNavBarRightButtonText   = @"Next";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWAddProfilePicViewController

@synthesize addProfilePicButton             = _addProfilePicButton;
@synthesize underlayImageView               = _underlayImageView;
@synthesize useFacebookPhotoButton          = _useFacebookPhotoButton;
@synthesize spinnerContainerView            = _spinnerContainerView;

@synthesize userImage                       = _userImage;
@synthesize userFBToken                     = _userFBToken;
@synthesize userID                          = _userID;
@synthesize teamID                          = _teamID;

@synthesize navTitleView                    = _navTitleView;
@synthesize navBarRightButtonView           = _navBarRightButtonView;
@synthesize spinnerOverlayView              = _spinnerOverlayView;

@synthesize usersController                 = _usersController;
@synthesize mediaController                 = _mediaController;
@synthesize membershipsController           = _membershipsController;

@synthesize facebookConnect                 = _facebookConnect;

@synthesize delegate                        = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
        self.usersController                = [[[DWUsersController alloc] init] autorelease];        
        self.usersController.delegate       = self;
        
        self.mediaController                = [[[DWMediaController alloc] init] autorelease];
        self.mediaController.delegate       = self;
        
        self.membershipsController          = [[[DWMembershipsController alloc] init] autorelease];
        self.membershipsController.delegate = self;
        
        self.facebookConnect                = [[[DWFacebookConnect alloc] init] autorelease];
        self.facebookConnect.delegate       = self;
	}
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {	
	
    self.addProfilePicButton            = nil;
    self.underlayImageView              = nil;
    self.useFacebookPhotoButton         = nil;
    self.spinnerContainerView           = nil;
    
    self.userImage                      = nil;
    self.userFBToken                    = nil;
    
    self.navTitleView                   = nil;
	self.navBarRightButtonView          = nil;
    self.spinnerOverlayView             = nil;
    
    self.usersController                = nil;
    self.mediaController                = nil;
    self.membershipsController          = nil;
    
    self.facebookConnect                = nil;
	
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    if (self.userImage) 
        self.underlayImageView.image = self.userImage;
    
    [[self.underlayImageView layer] setCornerRadius:4.0f];
    [[self.addProfilePicButton layer] setCornerRadius:4.0f];
    
    self.underlayImageView.clipsToBounds = YES;
    
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
        self.spinnerOverlayView = [[[DWSpinnerOverlayView alloc] initWithSpinnerOrigin:CGPointMake(150,180) 
                                                                          spinnerStyle:UIActivityIndicatorViewStyleWhite 
                                                                        andMessageText:kEmptyString] autorelease];
    
    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:kActionNameForLoad];
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
    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"user_updated"
                                                               andExtraInfo:[NSString stringWithFormat:@"image=%d",
                                                                             _hasChangedImage]];
}

//----------------------------------------------------------------------------------------------------
- (void)presentMediaPickerControllerForPickerMode:(NSInteger)pickerMode {    
    
    DWMediaPickerController *picker = [[[DWMediaPickerController alloc] initWithDelegate:self] 
                                       autorelease];
    
    [picker prepareForImageWithPickerMode:pickerMode 
                              withPreview:pickerMode == kMediaPickerLibraryMode];
    
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
    UIActionSheet *actionSheet  = [[UIActionSheet alloc] initWithTitle:nil 
                                                              delegate:self 
                                                     cancelButtonTitle:kMsgActionSheetCancel
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:kMsgActionSheetCamera,kMsgActionSheetLibrary,nil];
    
    [actionSheet showInView:self.view];
    [actionSheet release];
}

//----------------------------------------------------------------------------------------------------
- (IBAction)useFacebookPhotoButtonTapped:(id)sender {
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"facebook_selected"];
    
    
    [self freezeUI];
    self.facebookConnect.accessToken = self.userFBToken;
    
    if ([self.facebookConnect authenticate])
        [self.facebookConnect getProfilePicture];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIActionSheet Delegate

//----------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {	
    
    if (buttonIndex == 0) {
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                                 withActionName:@"camera_selected"];
        
        [self presentMediaPickerControllerForPickerMode:kMediaPickerCaptureMode];
    }
    else if(buttonIndex == 1)  {
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                                 withActionName:@"library_selected"];
        
        [self presentMediaPickerControllerForPickerMode:kMediaPickerLibraryMode];        
    }
    else if(buttonIndex == 2) {
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                                 withActionName:@"cancel_selected"];
    }
    
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
    
    [self.membershipsController createMembershipForTeamID:self.teamID];
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
#pragma mark DWMembershipsController Delegate

//----------------------------------------------------------------------------------------------------
- (void)membershipCreated:(DWMembership*)membership {
    [self.delegate membershipCreated];
    [self unfreezeUI];
}

//----------------------------------------------------------------------------------------------------
- (void)membershipCreationError:(NSString*)error {
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
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"phone_image_selected"];
    
    
    _hasChangedImage                = YES;
    
    self.userImage                  = editedImage;
    self.underlayImageView.image    = editedImage;
    
	[self dismissModalViewControllerAnimated:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)mediaPickerCancelledFromMode:(NSInteger)imagePickerMode {    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"phone_image_rejected"];
    
    
    [self dismissModalViewControllerAnimated:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)photoLibraryModeSelected {
    [self dismissModalViewControllerAnimated:NO];
    [self presentMediaPickerControllerForPickerMode:kMediaPickerLibraryMode];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWFacebookConnectDelegate

//----------------------------------------------------------------------------------------------------
- (void)fbAuthenticated {
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"facebook_authenticated"];
    
    [self.facebookConnect getProfilePicture];
}

//----------------------------------------------------------------------------------------------------
- (void)fbAuthenticationFailed {    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"facebook_rejected"];
    
    [self unfreezeUI];
}

//----------------------------------------------------------------------------------------------------
- (void)fbRequestLoaded:(id)result {
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"facebook_image_loaded"];
    
    _hasChangedImage                = YES;
    
    self.userImage                  = [UIImage imageWithData:result];
    self.underlayImageView.image    = [UIImage imageWithData:result];
    
    [self unfreezeUI];
}

//----------------------------------------------------------------------------------------------------
- (void)fbRequestFailed:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorTitle
													message:[error localizedDescription]
												   delegate:nil 
										  cancelButtonTitle:kMsgCancelTitle
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
    
    [self unfreezeUI];
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
