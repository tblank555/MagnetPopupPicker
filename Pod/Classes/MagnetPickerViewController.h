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

@property (nonatomic, strong, readonly) MagnetKeyValuePair *keyNames;
@property (nonatomic, strong) NSArray *optionList;
@property (nonatomic, strong) NSArray *filteredOptions;
@property (nonatomic, weak) id<MagnetPickerViewControllerDelegate> delegate;

- (void)selectFirstElement;
- (void)setOptionList:(NSArray *)list keyNames:(MagnetKeyValuePair *)names;
- (void)clearValue;
- (void)resetSearch;

@end

@protocol MagnetPickerViewControllerDelegate <NSObject>

- (void)pickerViewController:(MagnetPickerViewController *)pickerViewController submitClicked:(MagnetKeyValuePair *)selected;
- (void)pickerViewControllerCancelClicked:(MagnetPickerViewController *)pickerViewController;

@end
