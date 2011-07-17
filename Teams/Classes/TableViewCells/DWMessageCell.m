//
//  DWMessageCell.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWMessageCell.h"

/**
 * Private method and property declarations
 */
@interface DWMessageCell()

/**
 * Create a label to display the message of the cell
 */
- (void)createMessageLabel;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWMessageCell

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {
		
		[self createMessageLabel];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;	
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createMessageLabel {
    messageLabel					= [[[UILabel alloc] initWithFrame:self.contentView.frame] autorelease];
    messageLabel.font				= [UIFont fontWithName:@"HelveticaNeue" size:17];	
    messageLabel.textColor			= [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    messageLabel.backgroundColor	= [UIColor clearColor];
    messageLabel.textAlignment		= UITextAlignmentCenter;
    
    [self.contentView addSubview:messageLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
