//
//  DWUpdateUserDetailsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUpdateUserDetailsViewController.h"
#import "DWUser.h"
#import "DWNavTitleView.h"
#import "DWNavRightBarButtonView.h"
#import "DWSpinnerOverlayView.h"
#import "DWRequestsManager.h"
#import "NSString+Helpers.h"
#import "DWSession.h"
#import "DWConstants.h"
#import "DWGUIManager.h"


static NSString* const kMsgIncompleteTitle      = @"Incomplete";
static NSString* const kMsgIncomplete           = @"Enter first name, last name and byline";
static NSString* const kMsgErrorTitle           = @"Error";
static NSString* const kMsgCancelTitle          = @"OK";
static NSString* const kUpdateUserDetailsText   = @"Edit Your Details";
static NSString* const kRightNavBarButtonText   = @"Save";
static NSString* const kMsgProcesssing          = @"Editing Your Details ...";


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
@synthesize navRightBarButtonView           = _navRightBarButtonView;
@synthesize spinnerOverlayView              = _spinnerOverlayView;

@synthesize usersController                 = _usersController;


//----------------------------------------------------------------------------------------------------
- (id)initWithUserToEdit:(DWUser*)user {
	self = [super init];
	
	if(self) {        
        self.usersController            = [[[DWUsersController alloc] init] autorelease];        
        self.usersController.delegate   = self;
        
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
	self.navRightBarButtonView          = nil;
    self.spinnerOverlayView             = nil;
    
    self.usersController                = nil;
	
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem           = [DWGUIManager customBackButton:self];
    self.navigationItem.hidesBackButton             = YES;
    
    self.firstNameTextField.text                    = self.firstName;
    self.lastNameTextField.text                     = self.lastName;
    self.byLineTextField.text                       = self.byline;
    
    
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
    
    if (!self.navRightBarButtonView)
        self.navRightBarButtonView = [[[DWNavRightBarButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavTitleViewWidth,
                                                                kNavTitleViewHeight)
                                       title:kRightNavBarButtonText 
                                       andTarget:self] autorelease];
    
    if (!self.spinnerOverlayView)
        self.spinnerOverlayView     = [[[DWSpinnerOverlayView alloc] initWithSpinnerOrigin:CGPointMake(50,170)
                                                                            andMessageText:kMsgProcesssing] autorelease];
    
    [self.firstNameTextField becomeFirstResponder];
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
        
	}
}

//----------------------------------------------------------------------------------------------------
-(void)presentMediaPickerControllerForPickerMode:(NSInteger)pickerMode {    
    DWMediaPickerController *picker = [[[DWMediaPickerController alloc] initWithDelegate:self] autorelease];
    [picker prepareForImageWithPickerMode:pickerMode withPreview:NO];
    [self.displayMediaPickerController presentModalViewController:picker animated:NO];   
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
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
- (IBAction)changeUserImageButtonTapped:(id)sender {
    [self presentMediaPickerControllerForPickerMode:kMediaPickerCaptureMode];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWMediaPickerControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)didFinishPickingImage:(UIImage*)originalImage andEditedTo:(UIImage*)editedImage {
	self.userImageView.image    = editedImage;
    self.userImage              = editedImage;
    
	[self.displayMediaPickerController dismissModalViewControllerAnimated:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)mediaPickerCancelledFromMode:(NSInteger)imagePickerMode {    
    [self.displayMediaPickerController dismissModalViewControllerAnimated:NO];  
    
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
    [self.navigationController.navigationBar addSubview:self.navRightBarButtonView];
}

@end
