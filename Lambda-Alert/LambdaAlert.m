#import "LambdaAlert.h"

@interface LambdaAlert () <UIAlertViewDelegate>
@end

@implementation LambdaAlert {
	UIAlertView *alert;
	NSMutableArray *blocks;
	id selfLink;
}

- (id) initWithTitle:(NSString *)title message:(NSString *)message
{
	if ((self = [super init]))
	{
		alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
		blocks = [NSMutableArray new];
	}
	return self;
}

+ (id) alertWithTitle:(NSString *)title message:(NSString *)message
{
	return [[self alloc] initWithTitle:title message:message];
}

+ (id) alertWithTitle:(NSString *)title
{
	return [[self alloc] initWithTitle:title message:nil];
}

+ (id) alertWithMessage:(NSString *)message
{
	return [[self alloc] initWithTitle:nil message:message];
}

+ (void) showAlertWithTitle:(NSString *)title message:(NSString *)message block:(dispatch_block_t)block
{
	LambdaAlert *alert = [self alertWithTitle:title message:message];
	[alert addButtonWithTitle:@"OK" block:block];
	[alert show];
}

+ (void) showAlertWithTitle:(NSString *)title block:(dispatch_block_t)block
{
	[self showAlertWithTitle:title message:nil block:block];
}

+ (void) showAlertWithMessage:(NSString *)message block:(dispatch_block_t)block
{
	[self showAlertWithTitle:nil message:message block:block];
}

- (void) show
{
	if ([blocks count] == 0) {
		[self addButtonWithTitle:@"OK" block:nil];
	}

	selfLink = self;

	[alert show];
}

- (void) addButtonWithTitle:(NSString *)title block:(dispatch_block_t)block
{
	if (!block) {
		block = ^{};
	}

	[alert addButtonWithTitle:title];
	[blocks addObject:[block copy]];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex >= 0 && buttonIndex < [blocks count])
	{
		dispatch_block_t block = [blocks objectAtIndex:buttonIndex];
		block();
	}
	selfLink = nil;
}

+ (void) showAlertWithTitle:(NSString *)title message:(NSString *)message
{
	[self showAlertWithTitle:title message:message block:nil];
}

+ (void) showAlertWithTitle:(NSString *)title
{
	[self showAlertWithTitle:title block:nil];
}

+ (void) showAlertWithMessage:(NSString *)message
{
	[self showAlertWithMessage:message block:nil];
}

@end
