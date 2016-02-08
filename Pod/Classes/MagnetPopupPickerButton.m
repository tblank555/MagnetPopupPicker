//
//  PopupPickerButton.m
//  Whizz3.0
//
//  Created by ufuk on 4/21/14.
//  Copyright (c) 2014 Concept Imago. All rights reserved.
//

#import "MagnetPopupPickerButton.h"
#import "MagnetPickerViewController.h"
#import "MagnetPopoverView.h"

@interface MagnetPopupPickerButton () <UIPopoverControllerDelegate, MagnetPickerViewControllerDelegate>

@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) MagnetPopoverView *popover;
@property (nonatomic, strong) NSString *placeholder;

@end

@implementation MagnetPopupPickerButton

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initButton];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initButton];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder])
    {
        [self initButton];
    }
    return self;
}

- (void)initButton
{
    [self setDefaults];
    [self loadController];
    [self addTarget:self action:@selector(openPopover:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Private

- (void)setDefaults
{
    _usesOKButton = YES;
    _popoverColor = [UIColor whiteColor];
    _pickerSize = CGSizeMake(300.0, 200.0);
}

- (void)loadController
{
    self.pickerController = [[MagnetPickerViewController alloc] initWithNibName:nil bundle:nil];
    self.pickerController.delegate = self;
}

- (void)openPopover:(UIButton *)button
{
    if ([self.popover isVisible])
    {
        [self.popover dismissPopover];
        return;
    }
    
    self.pickerController.view.frame = CGRectMake(0, 0, self.pickerSize.width, self.pickerSize.height);
    self.popover = [[MagnetPopoverView alloc] initWithContentView:self.pickerController.view];
    self.popover.backgroundColor = self.popoverColor;
    [self.popover showPopoverFromButton:self];
}

#pragma mark - Overridden

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    if (!self.placeholder)
        self.placeholder = title;
    [super setTitle:title forState:state];
}

- (void)setUsesOKButton:(BOOL)usesOKButton
{
    _usesOKButton = usesOKButton;
    self.pickerController.showsOKButton = usesOKButton;
}

#pragma mark - Public

- (void)setOptions:(NSArray *)list keyNames:(MagnetKeyValuePair *)names
{
    self.selectedPair = nil;
    [self.pickerController setOptionList:list keyNames:names];
    [self setTitle:self.placeholder forState:UIControlStateNormal];
}

- (void)setSelectedValue:(NSString *)value
{
    NSArray *filtered = [self.pickerController.optionList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.%@ = %@", self.pickerController.keyNames.key, value]];
    if(filtered.count > 0)
    {
        self.selectedPair = [[MagnetKeyValuePair alloc] initWithKeyValue:[[filtered objectAtIndex:0] valueForKey:self.pickerController.keyNames.key] value:[[filtered objectAtIndex:0] valueForKey:self.pickerController.keyNames.value]];
        [self setTitle:self.selectedPair.value forState:UIControlStateNormal];
    }
}

- (void)clearValue
{
    self.selectedPair = nil;
    [self.pickerController clearValue];
    [self setTitle:self.placeholder forState:UIControlStateNormal];
}

- (void)dismissPopover
{
    if (self.popover.isVisible)
        [self.popover dismissPopover];
}

- (NSString *)selectedKey
{
    return self.selectedPair.key;
}

- (id)selectedValue
{
    id fieldText = self.selectedPair.value;
    if (!fieldText)
        fieldText = self.titleLabel.text;
    
    return fieldText;
}

#pragma mark - MagnetPickerViewControllerDelegate

- (void)pickerViewController:(MagnetPickerViewController *)pickerViewController didChangeValue:(MagnetKeyValuePair *)newValue
{
    if (!self.usesOKButton)
    {
        self.selectedPair = newValue;
        [self setTitle:self.selectedPair.value
              forState:UIControlStateNormal];
        [self.stateDelegate popupPickerButtonValueChanged:self];
    }
}

- (void)pickerViewController:(MagnetPickerViewController *)pickerViewController submitClicked:(MagnetKeyValuePair *)selected
{
    self.selectedPair = selected;
    [self.pickerController resetSearch];
    [self setTitle:self.selectedPair.value forState:UIControlStateNormal];
    [self.stateDelegate popupPickerButtonValueChanged:self];
    [self.popover dismissPopover];
}

- (void)pickerViewControllerCancelClicked:(MagnetPickerViewController *)pickerViewController
{
    [self clearValue];
    [self.stateDelegate popupPickerButtonValueChanged:self];
    [self.popover dismissPopover];
}

@end
