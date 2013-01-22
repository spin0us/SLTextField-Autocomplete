//
//  SLTextField+Autocomplete.m
//  TMSTaxi
//
//  Created by Laurent Spinelli on 13/08/12.
//  Copyright (c) 2012 Elemasoft. All rights reserved.
//

#import "SLTextField+Autocomplete.h"

@interface SLTextField_Autocomplete()

@property (nonatomic, retain) UIMenuController* completionMenu;

- (void)doShowMenu;

@end

@implementation SLTextField_Autocomplete
@synthesize completionMenu;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        completionMenu = [UIMenuController sharedMenuController];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [completionMenu release];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    NSString *sel = NSStringFromSelector(action);
    NSRange match = [sel rangeOfString:@"magic_"];
    if (match.location == 0) {
        return YES;
    }
    return NO;
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (void)showAutocompleteItems:(NSString*)_string
{
    NSMutableArray* menuItems = [[NSMutableArray alloc] init];
    NSInteger counter = 0;
    for (NSString* value in self.dataSource) {
        if ([value rangeOfString:_string options:NSCaseInsensitiveSearch].location == 0 ) {
            NSString *sel = [NSString stringWithFormat:@"magic_%@", value];
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:[value capitalizedString] action:NSSelectorFromString(sel)]];
            counter ++;
        }
        if (counter >= SLTextFieldMaxItemToDisplay) {
            break;
        }
    }
    [completionMenu setTargetRect:CGRectMake(0,0,320,70) inView:self.superview];
    [completionMenu setMenuItems:menuItems];
    [completionMenu setArrowDirection:UIMenuControllerArrowDown];
    [self performSelector:@selector(doShowMenu) withObject:nil afterDelay:0.5];
    [menuItems release];
}

- (void)doShowMenu
{
    [completionMenu setMenuVisible:YES animated:YES];
}

- (void)tappedMenuItem:(NSString *)_string {
    self.text = [_string capitalizedString];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    if ([super methodSignatureForSelector:sel]) {
        return [super methodSignatureForSelector:sel];
    }
    return [super methodSignatureForSelector:@selector(tappedMenuItem:)];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSString *sel = NSStringFromSelector([invocation selector]);
    NSRange match = [sel rangeOfString:@"magic_"];
    if (match.location == 0) {
        [self tappedMenuItem:[sel substringFromIndex:6]];
    } else {
        [super forwardInvocation:invocation];
    }
}
@end
