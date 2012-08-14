//
//  SLTextField+Autocomplete.h
//  TMSTaxi
//
//  Created by Laurent Spinelli on 13/08/12.
//  Copyright (c) 2012 Elemasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SLTextFieldMaxItemToDisplay  2

@interface SLTextField_Autocomplete : UITextField

@property (nonatomic, retain) NSArray* dataSource;

- (void)showAutocompleteItems:(NSString*)_string;

@end
