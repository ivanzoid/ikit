@interface LambdaAlert : NSObject

- (id) initWithTitle:(NSString *)title message:(NSString *)message;
- (void) addButtonWithTitle:(NSString *)title block:(dispatch_block_t)block;
- (void) show;

+ (id) alertWithTitle:(NSString *)title message:(NSString *)message;
+ (id) alertWithTitle:(NSString *)title;
+ (id) alertWithMessage:(NSString *)message;

+ (void) showAlertWithTitle:(NSString *)title message:(NSString *)message block:(dispatch_block_t)block;
+ (void) showAlertWithTitle:(NSString *)title block:(dispatch_block_t)block;
+ (void) showAlertWithMessage:(NSString *)message block:(dispatch_block_t)block;

+ (void) showAlertWithTitle:(NSString *)title message:(NSString *)message;
+ (void) showAlertWithTitle:(NSString *)title;
+ (void) showAlertWithMessage:(NSString *)message;

@end
