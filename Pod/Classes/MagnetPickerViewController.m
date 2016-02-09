//
//  PickerViewController.m
//  Whizz3.0
//
//  Created by ufuk on 4/16/14.
//  Copyright (c) 2014 Concept Imago. All rights reserved.
//

#import "MagnetPickerViewController.h"
#import "MagnetKeyValuePair.h"
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static CGFloat const MagnetPickerViewControllerMarginSize = 10.0;
static CGFloat const MagnetPickerViewControllerCancelButtonWidth = 30.0;
static CGFloat const MagnetPickerViewControllerOKButtonWidth = 60.0;

@interface MagnetPickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) UITextField *searchField;
@property (nonatomic, weak) UIPickerView *pickerView;
@property (nonatomic, strong) MagnetKeyValuePair *selectedPair;

@end

@implementation MagnetPickerViewController

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self __initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self __initialize];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self __initialize];
    }
    return self;
}

- (void)__initialize
{
    _showsCancelButton = YES;
    _showsOKButton = YES;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat searchFieldWidth = 175.0;
    CGFloat searchFieldXPosition = MagnetPickerViewControllerMarginSize + MagnetPickerViewControllerCancelButtonWidth + 8.0;
    
    if (self.showsCancelButton)
    {
        UISegmentedControl *cancelButton = [[UISegmentedControl alloc] initWithItems:@[ @"X" ]];
        cancelButton.frame = CGRectMake(MagnetPickerViewControllerMarginSize,
                                        MagnetPickerViewControllerMarginSize,
                                        MagnetPickerViewControllerCancelButtonWidth,
                                        30.0);
        cancelButton.momentary = YES;
        [cancelButton addTarget:self
                         action:@selector(cancelClicked)
               forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:cancelButton];
    }
    else
    {
        searchFieldXPosition = MagnetPickerViewControllerMarginSize;
        searchFieldWidth += MagnetPickerViewControllerCancelButtonWidth + 8.0;
    }
    
    if (self.showsOKButton)
    {
        UISegmentedControl *submitButton = [[UISegmentedControl alloc] initWithItems:@[ NSLocalizedString(@"OK", nil) ]];
        submitButton.momentary = YES;
        [submitButton addTarget:self
                         action:@selector(submitClicked)
               forControlEvents:UIControlEventValueChanged];
        submitButton.frame = CGRectMake(searchFieldXPosition + searchFieldWidth + 7.0,
                                        MagnetPickerViewControllerMarginSize,
                                        MagnetPickerViewControllerOKButtonWidth,
                                        30.0);
        [self.view addSubview:submitButton];
    }
    else
    {
        searchFieldWidth += MagnetPickerViewControllerOKButtonWidth + 7.0;
    }
    
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(searchFieldXPosition,
                                                                             MagnetPickerViewControllerMarginSize,
                                                                             searchFieldWidth,
                                                                             30.0)];
    searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    searchField.placeholder = NSLocalizedString(@"Search", nil);
    searchField.autocorrectionType = UITextAutocorrectionTypeNo;
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [searchField addTarget:self
                    action:@selector(searchValueChanged)
          forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:searchField];
    self.searchField = searchField;
    [self.searchField reloadInputViews];
    
    [self __loadPicker];
}

#pragma mark - Private

- (void)__loadPicker
{
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 35, 300, 200)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
}

- (void)submitClicked
{
    if (!self.selectedPair)
        [self selectFirstElement];
    
    if ([self.delegate respondsToSelector:@selector(pickerViewController:submitClicked:)])
    {
        [self.delegate pickerViewController:self
                              submitClicked:self.selectedPair];
    }
}

- (void)cancelClicked
{
    self.selectedPair = nil;
    if ([self.delegate respondsToSelector:@selector(pickerViewControllerCancelClicked:)])
        [self.delegate pickerViewControllerCancelClicked:self];
}

- (void)searchValueChanged
{
    self.filteredOptions = [self.optionList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(MagnetKeyValuePair *evaluatedObject, NSDictionary *bindings) {
        NSRange range = [[evaluatedObject valueForKey:self.keyNames.value] rangeOfString:self.searchField.text options:NSCaseInsensitiveSearch];
        return range.location != NSNotFound || self.searchField.text.length < 1;
    }]];
    [self selectFirstElement];
    [self.pickerView reloadAllComponents];
}

#pragma mark - Public

- (void)selectFirstElement
{
    if (self.filteredOptions.count > 0)
    {
        self.selectedPair = [[MagnetKeyValuePair alloc] initWithKeyValue:[[self.filteredOptions firstObject] valueForKey:self.keyNames.key] value:[[self.filteredOptions firstObject] valueForKey:self.keyNames.value]];
        
        if ([self.delegate respondsToSelector:@selector(pickerViewController:didChangeValue:)])
        {
            [self.delegate pickerViewController:self
                                 didChangeValue:self.selectedPair];
        }
    }
}

- (void)setOptionList:(NSArray *)list keyNames:(MagnetKeyValuePair *)names
{
    self.optionList = list;
    self.filteredOptions = [self.optionList copy];
    self->_keyNames = names;
    [self.pickerView reloadAllComponents];
}

- (void)resetSearch
{
    self.searchField.text = @"";
    self.filteredOptions = self.optionList;
    [self.pickerView reloadAllComponents];
}

- (void)clearValue
{
    self.selectedPair = nil;
    self.searchField.text = @"";
    [self resetSearch];
    [self.pickerView selectRow:0
                   inComponent:0
                      animated:NO];
}

#pragma mark - UIPickerViewDelegate & UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.filteredOptions.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@", [self.filteredOptions[row] valueForKey:self.keyNames.value]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row < self.filteredOptions.count)
    {
        self.selectedPair = [[MagnetKeyValuePair alloc] initWithKeyValue:[self.filteredOptions[row] valueForKey:self.keyNames.key] value:[self.filteredOptions[row] valueForKey:self.keyNames.value]];
        
        if ([self.delegate respondsToSelector:@selector(pickerViewController:didChangeValue:)])
        {
            [self.delegate pickerViewController:self
                                 didChangeValue:self.selectedPair];
        }
    }
}

@end
