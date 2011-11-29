//
//  MemView.h
//
//  Created by Ivan Zezyulya on 01.11.11.
//

#import <UIKit/UIKit.h>

//
// MemView
//
// This is simple view which displays memory used by current process and amout of free memory in the system.
//
//
//
// Example usage:
//
//	MemView *memView = [[MemView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2,
//																 [UIScreen mainScreen].bounds.size.height - 15,
//																 [UIScreen mainScreen].bounds.size.width/2, 15)];
//	[self.window addSubview:memView];
//
//
//
// NOTES:
//  MemView is written for ARC (Automatic Reference Counting) mode, you'll get a small leak in non-ARC mode.
//  Apple LLVM Compiler >= 3.0 is also required (Supported in XCode 4.2).
//

@interface MemView : UIView

@end
