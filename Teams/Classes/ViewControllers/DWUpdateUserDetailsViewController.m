//
//  DWUpdateUserDetailsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUpdateUserDetailsViewController.h"

#import "DWUser.h"
#import "DWNavTitleView.h"
#import "DWNavBarRightButtonView.h"
#import "DWSpinnerOverlayView.h"
#import "DWSession.h"
#import "DWConstants.h"
#import "DWGUIManager.h"
#import "DWAnalyticsManager.h"


static NSString* const kMsgIncompleteTitle      = @"Incomplete";
static NSString* const kMsgIncomplete           = @"Enter first name, last name and byline";
static NSString* const kMsgErrorTitle           = @"Error";
static NSString* const kMsgCancelTitle          = @"OK";
static NSString* const kUpdateUserDetailsText   = @"Edit Your Details";
static NSString* const kNavBarRightButtonText   = @"Save";
static NSString* const kMsgProcesssing          = @"Updating your details...";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUpdateUserDetailsViewController

@synthesize firstNameTextField              = _firstNameTextField;
@synthesize lastNameTextField               = _lastNameTextField;
@synthesize byLineTextField                 = _byLineTextField;
@synthesize userImageView                   = _userImageView;
@synthesize changeUserImageButton           = _changeUserImageButton;
@synthesize spinnerContainerView            = _spinnerContainerView;

@synthesize firstName                       = _firstName;
@synthesize lastName                        = _lastName;
@synthesize byline                          = _byline;
@synthesize userImage                       = _userImage;

@synthesize displayMediaPickerController    = _displayMediaPickerController;

@synthesize navTitleView                    = _navTitleView;
@synthesize navBarRightButtonView           = _navBarRightButtonView;
@synthesize spinnerOverlayView              = _spinnerOverlayView;

@synthesize usersController                 = _usersController;
@synthesize mediaController                 = _mediaController;


//----------------------------------------------------------------------------------------------------
- (id)initWithUserToEdit:(DWUser*)user {
	self = [super init];
	
	if(self) {        
        self.usersController            = [[[DWUsersController alloc] init] autorelease];        
        self.usersController.delegate   = self;
        
        self.mediaController            = [[[DWMediaController alloc] init] autorelease];
        self.mediaController.delegate   = self;
        
        _userID                         = user.databaseID;        
        self.firstName                  = user.firstName;
        self.lastName                   = user.lastName;
        self.byline                     = user.byline;
        self.userImage                  = user.smallImage;
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(smallUserImageLoaded:) 
													 name:kNImgSmallUserLoaded
												   object:nil];
	}
    
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    	
	self.firstNameTextField             = nil;
    self.lastNameTextField              = nil;
	self.byLineTextField                = nil;
    self.userImageView                  = nil;
    self.changeUserImageButton          = nil;
    self.spinnerContainerView           = nil;
    
    self.firstName                      = nil;
    self.lastName                       = nil;
    self.byline                         = nil;
    self.userImage                      = nil;
    
    self.displayMediaPickerController   = nil;
    
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
    
    self.navigationController.navigationBar.clipsToBounds   = NO;
    self.navigationItem.leftBarButtonItem                   = [DWGUIManager navBarBackButtonForNavController:self.navigationController];
    self.navigationItem.hidesBackButton                     = YES;
    
    self.firstNameTextField.text                            = self.firstName;
    self.lastNameTextField.text                             = self.lastName;
    self.byLineTextField.text                               = self.byline;
    
    
    if (self.userImage) 
        self.userImageView.image    = self.userImage; 
    else
        [[DWUser fetch:_userID] startSmallImageDownload];
    
    
    if (!self.navTitleView)
        self.navTitleView = [[[DWNavTitleView alloc] 
                              initWithFrame:CGRectMake(kNavTitleViewX,0,
                                                       kNavTitleViewWidth,
                                                       kNavTitleViewHeight) 
                                andDelegate:self] autorelease];
    
    [self.navTitleView displayTitle:kUpdateUserDetailsText];
    
    if (!self.navBarRightButtonView)
        self.navBarRightButtonView = [[[DWNavBarRightButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavRightButtonWidth,
                                                                kNavRightButtonHeight)
                                               title:kNavBarRightButtonText 
                                           andTarget:self] autorelease];
    
    if (!self.spinnerOverlayView)
        self.spinnerOverlayView     = [[[DWSpinnerOverlayView alloc] initWithSpinnerOrigin:CGPointMake(70,134)
                                                                            andMessageText:kMsgProcesssing] autorelease];
    
    [self.firstNameTextField becomeFirstResponder];
    
    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:kActionNameForLoad
                                                                 withViewID:_userID];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];

    self.firstName          = self.firstNameTextField.text;
    self.lastName           = self.lastNameTextField.text;
    self.byline             = self.byLineTextField.text;
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
    
	if (self.byLineTextField.text.length == 0 || 
        self.firstNameTextField.text.length == 0 ||
        self.lastNameTextField.text.length == 0) {
        
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
        
        if (_hasChangedImage) 
            _mediaResourceID = [self.mediaController postImage:self.userImageView.image
                                                    withPrefix:kS3UsersPrefix];
        else
            [self.usersController updateUserHavingID:_userID 
                                       withFirstName:self.firstNameTextField.text 
                                            lastName:self.lastNameTextField.text 
                                              byline:self.byLineTextField.text 
                                         andFilename:kEmptyString];
	}
    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"user_updated"
                                                                 withViewID:_userID
                                                               andExtraInfo:[NSString stringWithFormat:@"first=%@&last=%@&byline=%@&photo=%d",
                                                                             self.firstNameTextField.text,
                                                                             self.lastNameTextField.text,
                                                                             self.byLineTextField.text,
                                                                             _hasChangedImage]];
}

//----------------------------------------------------------------------------------------------------
- (void)presentMediaPickerControllerForPickerMode:(NSInteger)pickerMode {    
    
    DWMediaPickerController *picker = [[[DWMediaPickerController alloc] initWithDelegate:self] 
                                       autorelease];
    
    [picker prepareForImageWithPickerMode:pickerMode 
                              withPreview:pickerMode == kMediaPickerLibraryMode];
    
    [self.displayMediaPickerController presentModalViewController:picker 
                                                         animated:NO];   
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)smallUserImageLoaded:(NSNotification*)notification {
	NSDictionary *info          = [notification userInfo];
    id resource                 = [info objectForKey:kKeyImage];
    
    self.userImageView.image    = resource;
    self.userImage              = resource;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (void)didTapBackButton:(id)sender event:(id)event {
	[self.navigationController popViewControllerAnimated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapNavBarRightButton:(id)sender event:(id)event {
    [self updateUser];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
	
	if(textField == self.firstNameTextField) {
		[self.firstNameTextField resignFirstResponder];
		[self.lastNameTextField becomeFirstResponder];
	}
    else if(textField == self.lastNameTextField) {
        [self.lastNameTextField resignFirstResponder];
        [self.byLineTextField becomeFirstResponder];
    }
	else if(textField == self.byLineTextField) {
		[self updateUser];
	}
	
	return YES;
}

//----------------------------------------------------------------------------------------------------
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string {
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (textField == self.firstNameTextField) 
        return (newLength > kMaxUserFirstNameLength) ? NO : YES;
    
    else if (textField == self.lastNameTextField) 
        return (newLength > kMaxUserLastNameLength) ? NO : YES;        
    
    else if (textField == self.byLineTextField) 
        return (newLength > kMaxUserBylineLength) ? NO : YES;
    
    else
        return YES;
}

//----------------------------------------------------------------------------------------------------
- (IBAction)changeUserImageButtonTapped:(id)sender {
        
    UIActionSheet *actionSheet  = [[UIActionSheet alloc] initWithTitle:nil 
                                                              delegate:self 
                                                     cancelButtonTitle:kMsgActionSheetCancel
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:kMsgActionSheetCamera,kMsgActionSheetLibrary,nil];
    
    [actionSheet showInView:self.view];
    [actionSheet release];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIActionSheet Delegate

//----------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {	
    
    if (buttonIndex == 0) {
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                                 withActionName:@"camera_selected"
                                                                     withViewID:_userID];
        
        [self presentMediaPickerControllerForPickerMode:kMediaPickerCaptureMode];
    }
    else if(buttonIndex == 1) {
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                                 withActionName:@"library_selected"
                                                                     withViewID:_userID];
        
        [self presentMediaPickerControllerForPickerMode:kMediaPickerLibraryMode];        
    }
    else {
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                                 withActionName:@"cancel_selected"
                                                                     withViewID:_userID];
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
    [self.usersController updateUserHavingID:_userID 
                               withFirstName:self.firstNameTextField.text 
                                    lastName:self.lastNameTextField.text 
                                      byline:self.byLineTextField.text 
                                 andFilename:filename];    
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
    
    if (_hasChangedImage) 
        [user updateImages:self.userImage];

    [[DWSession sharedDWSession] update];
    
    [user destroy];
    
    [self unfreezeUI];
	[self.navigationController popViewControllerAnimated:YES];    
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
    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"update_failed"
                                                                 withViewID:_userID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWMediaPickerControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)didFinishPickingImage:(UIImage*)originalImage andEditedTo:(UIImage*)editedImage {
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"phone_image_selected"
                                                                 withViewID:_userID];
    
	self.userImageView.image    = editedImage;
    self.userImage              = editedImage;
    
    _hasChangedImage            = YES;
    
	[self.displayMediaPickerController dismissModalViewControllerAnimated:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)mediaPickerCancelledFromMode:(NSInteger)imagePickerMode { 
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"phone_image_rejected"
                                                                 withViewID:_userID];
    
    [self.displayMediaPickerController dismissModalViewControllerAnimated:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)photoLibraryModeSelected {
    [self.displayMediaPickerController dismissModalViewControllerAnimated:NO];
    [self presentMediaPickerControllerForPickerMode:kMediaPickerLibraryMode];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark FullScreenMode
//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
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
