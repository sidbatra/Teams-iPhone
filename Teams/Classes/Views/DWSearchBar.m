//
//  DWSearchBar.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWSearchBar.h"
#import "DWConstants.h"

static NSString* const kImgCancelButton         = @"button_cancel.png";
static NSString* const kMsgSearchPlaceholder    = @"Search Teams and People";

/**
 * Private method and property declarations
 */
@interface DWSearchBar()

/**
 * White background image behind the text field
 */
- (void)createBackground;

/**
 * Text field for writing search queries
 */
- (void)createSearchField;

/**
 * Cancel button for wiping the search view
 */
- (void)createCancelButton;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSearchBar

@synthesize delegate    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self createBackground];
        [self createSearchField];
        [self createCancelButton];        
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createBackground {
    UILabel *label                  = [[[UILabel alloc] initWithFrame:CGRectMake(0,0,265,30)] autorelease];
    label.backgroundColor           = [UIColor whiteColor];
    label.userInteractionEnabled    = NO;
    
    
    [self addSubview:label];
}

//----------------------------------------------------------------------------------------------------
- (void)createSearchField {
    searchTextField                 = [[[UITextField alloc] initWithFrame:CGRectMake(0,0,200,30)] autorelease];
    searchTextField.delegate        = self;
    searchTextField.placeholder     = kMsgSearchPlaceholder;
    
    
    [self addSubview:searchTextField];
}

//----------------------------------------------------------------------------------------------------
- (void)createCancelButton {
    UIButton *button    = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame        = CGRectMake(265,0,55,44);
    
    [button setBackgroundImage:[UIImage imageNamed:kImgCancelButton]
                                          forState:UIControlStateNormal];
    
    [button addTarget:self
               action:@selector(didTapCancelButton:)
     forControlEvents:UIControlEventTouchDown];
    
    
    [self addSubview:button];
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)becomeActive {
    [searchTextField becomeFirstResponder];
}

//----------------------------------------------------------------------------------------------------
- (void)resignActive {
    searchTextField.text = kEmptyString;
    [searchTextField resignFirstResponder];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UISearchBarDelegate

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [searchTextField resignFirstResponder];
    
    [self.delegate searchWithQuery:searchTextField.text];
    
    return YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)didTapCancelButton:(UIButton*)button {
    [self.delegate searchCancelled];
}


@end
