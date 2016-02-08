//
//  PopupPickerButton.h
//  Whizz3.0
//
//  Created by ufuk on 4/21/14.
//  Copyright (c) 2014 Concept Imago. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagnetPickerViewController.h"

@protocol PopupPickerButtonStateDelegate;

@interface MagnetPopupPickerButton : UIButton

@property (nonatomic, assign) CGSize pickerSize;
@property (nonatomic, strong) UIColor *popoverColor;

/** Boolean value indicating whether to require the user to tap the OK button to confirm their selection. */
@property (nonatomic, assign) BOOL usesOKButton;

@property (nonatomic, strong) MagnetPickerViewController *pickerController;
@property (nonatomic, strong) MagnetKeyValuePair *selectedPair;
@property (nonatomic, weak) id<PopupPickerButtonStateDelegate> stateDelegate;

- (void)setOptions:(NSArray *)list keyNames:(MagnetKeyValuePair *)names;
- (void)setSelectedValue:(NSString *)value;
- (void)clearValue;

/** Dismisses the popover if it's open. */
- (void)dismissPopover;

- (NSString *)selectedKey;
- (id)selectedValue;

@end

@protocol PopupPickerButtonStateDelegate <NSObject>

- (void)popupPickerButtonValueChanged:(MagnetPopupPickerButton *)popupPickerButton;

@end
