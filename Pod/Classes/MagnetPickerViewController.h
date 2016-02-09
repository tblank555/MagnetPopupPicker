//
//  PickerViewController.h
//  Whizz3.0
//
//  Created by ufuk on 4/16/14.
//  Copyright (c) 2014 Concept Imago. All rights reserved.
//

#import "MagnetKeyValuePair.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MagnetPickerViewControllerDelegate;

@interface MagnetPickerViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *optionList;
@property (nonatomic, strong) NSArray *filteredOptions;

@property (nonatomic, strong, readonly) MagnetKeyValuePair *keyNames;

/** The currently selected key/value pair. */
@property (nonatomic, strong, readonly) MagnetKeyValuePair *selectedPair;

/** 
 Boolean value indicating whether to show the cancel button. 
 @discussion Defaults to YES.
 */
@property (nonatomic, assign) BOOL showsCancelButton;

/** 
 Boolean value indicating whether to show the OK button.
 @discussion Defaults to YES. If this value is set to YES, the `pickerViewController:submitClicked:` method will be called on the delegate when the OK button is tapped. If it is set to NO, the delegate may still respond to the user's changes by implementing the `pickerViewController:didChangeValue:` method.
 */
@property (nonatomic, assign) BOOL showsOKButton;

@property (nonatomic, weak) id<MagnetPickerViewControllerDelegate> delegate;

- (void)selectFirstElement;
- (void)setOptionList:(NSArray *)list keyNames:(MagnetKeyValuePair *)names;
- (void)clearValue;
- (void)resetSearch;

@end

@protocol MagnetPickerViewControllerDelegate <NSObject>
@optional

- (void)pickerViewController:(MagnetPickerViewController *)pickerViewController didChangeValue:(MagnetKeyValuePair *)newValue;
- (void)pickerViewController:(MagnetPickerViewController *)pickerViewController submitClicked:(MagnetKeyValuePair *)selected;
- (void)pickerViewControllerCancelClicked:(MagnetPickerViewController *)pickerViewController;

@end
