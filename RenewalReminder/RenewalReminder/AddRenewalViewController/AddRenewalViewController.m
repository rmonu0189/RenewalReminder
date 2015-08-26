//
//  AddRenewalViewController.m
//  RenewalReminder
//
//  Created by MonuRathor on 28/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import "AddRenewalViewController.h"
#import "RequestConnection.h"

@interface AddRenewalViewController ()<UIPickerViewDelegate, UITextViewDelegate, RequestConnectionDelegate>
{
    
    BOOL isSelectStartDate,isSelectRenewalDate;
    NSMutableArray *arrTypes;
    int selectTypeIndex;
}
@property (nonatomic, strong) RequestConnection *connection;
@end

@implementation AddRenewalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewPicker.hidden = YES;
    self.typePicker.hidden = YES;
    self.datePicker.hidden = YES;
    self.typePicker.backgroundColor = [UIColor grayColor];
    self.datePicker.backgroundColor = [UIColor grayColor];
    
    [self.datePicker setTimeZone:[NSTimeZone systemTimeZone]];
    
    self.connection = [[RequestConnection alloc] init];
    self.connection.delegate = self;
    
//    NSDateFormatter *f = [[NSDateFormatter alloc] init];
//    [f setDateStyle:NSDateFormatterFullStyle];
//    [f setTimeZone:[NSTimeZone systemTimeZone]];
//    [f setDateFormat:@"EEEE, d MMMM, yyyy"];
//    self.txtStartDate.text = [f stringFromDate:[NSDate date]];
//    self.txtRenewaldate.text = self.txtStartDate.text;
    
    arrTypes = [[NSMutableArray alloc] init];
    [arrTypes addObject:@{@"type":@"Boiler Cover",@"category":@"Home"}];
    [arrTypes addObject:@{@"type":@"Broadband",@"category":@"Utilities"}];
    [arrTypes addObject:@{@"type":@"Business Insurance",@"category":@"Insurance"}];
    [arrTypes addObject:@{@"type":@"Car Breakdown Cover",@"category":@"Motoring"}];
    [arrTypes addObject:@{@"type":@"Car Insurance",@"category":@"Motoring"}];
    [arrTypes addObject:@{@"type":@"Car Leasing Contract",@"category":@"Motoring"}];
    [arrTypes addObject:@{@"type":@"Car MOT",@"category":@"Motoring"}];
    [arrTypes addObject:@{@"type":@"Car Road Tax",@"category":@"Motoring"}];
    [arrTypes addObject:@{@"type":@"Car Servicing",@"category":@"Motoring"}];
    [arrTypes addObject:@{@"type":@"Caravan Insurance",@"category":@"Travel"}];
    [arrTypes addObject:@{@"type":@"Digital TV Service",@"category":@"Utilities"}];
    [arrTypes addObject:@{@"type":@"Gadget Insurance",@"category":@"Utilities"}];
    [arrTypes addObject:@{@"type":@"Health Insurance",@"category":@"Lifestyle"}];
    [arrTypes addObject:@{@"type":@"Home Emergency Cover",@"category":@"Home"}];
    [arrTypes addObject:@{@"type":@"Home Insurance",@"category":@"Home"}];
    [arrTypes addObject:@{@"type":@"Landlord Insurance",@"category":@"Home"}];
    [arrTypes addObject:@{@"type":@"Life Insurance",@"category":@"Lifestyle"}];
    [arrTypes addObject:@{@"type":@"Mobile Phone Contract",@"category":@"Lifestyle"}];
    [arrTypes addObject:@{@"type":@"Motorbike Insurance",@"category":@"Motoring"}];
    [arrTypes addObject:@{@"type":@"Motorbike MOT",@"category":@"Motoring"}];
    [arrTypes addObject:@{@"type":@"Motorbike Road Tax",@"category":@"Motoring"}];
    [arrTypes addObject:@{@"type":@"Motorbike Servicing",@"category":@"Motoring"}];
    [arrTypes addObject:@{@"type":@"Pet Insurance",@"category":@"Lifestyle"}];
    [arrTypes addObject:@{@"type":@"Travel Insurance",@"category":@"Travel"}];
    [arrTypes addObject:@{@"type":@"Van Breakdown Cover",@"category":@"Motoring"}];
    [arrTypes addObject:@{@"type":@"Van Insurance",@"category":@"Motoring"}];
    [arrTypes addObject:@{@"type":@"Van Leasing Contract",@"category":@"Motoring"}];
    [arrTypes addObject:@{@"type":@"Van MOT",@"category":@"Motoring"}];
    [arrTypes addObject:@{@"type":@"Van Road Tax",@"category":@"Motoring"}];
    [arrTypes addObject:@{@"type":@"Van Servicing",@"category":@"Motoring"}];
    
    if (self.root != nil) {
        [self setRootValue];
    }
    
}

- (void)setRootValue{
    self.txtStartDate.text = [[AppDelegate sharedAppDelegate] convertDateFormate:[self.root valueForKey:@"start_date"]];
    self.txtRenewaldate.text = [[AppDelegate sharedAppDelegate] convertDateFormate:[self.root valueForKey:@"renewal_date"]];
    self.txtProvider.text = [self.root valueForKey:@"provider"];
    self.txtPrice.text = [self.root valueForKey:@"price"];
    self.txtNotes.text = [self.root valueForKey:@"notes"];
    self.txtType.text = [self.root valueForKey:@"type"];
    self.txtNotes.textColor = [UIColor darkGrayColor];
    [self.btnAddEdit setTitle:@"Done" forState:UIControlStateNormal];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:@"LOGOUT" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)logout:(NSNotification *)notification{
    [[AppDelegate sharedAppDelegate] clearUser];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)hiddenPickerView{
    self.viewPicker.hidden = YES;
    self.typePicker.hidden = YES;
    self.datePicker.hidden = YES;
}

- (void)showDatePicker{
    
//    NSDate *tmpDate = 
    
    [self.scrollViewAddRenewal setContentSize:CGSizeMake(320, 568)];
    self.typePicker.hidden = YES;
    self.viewPicker.hidden = NO;
    self.datePicker.hidden = NO;
    [self.txtProvider resignFirstResponder];
    [self.txtPrice resignFirstResponder];
    [self.txtNotes resignFirstResponder];
}

- (void)showTypePicker{
    [self.scrollViewAddRenewal setContentSize:CGSizeMake(320, 568)];
//    if (self.txtType.text.length<=0) {
//        self.txtType.text =  @"Home";
//    }
    self.viewPicker.hidden = NO;
    self.typePicker.hidden = NO;
    self.datePicker.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

- (IBAction)clickedCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickedAdd:(id)sender {
    if ([self validate]) {
        [[AppDelegate sharedAppDelegate] startLoadingView];
        if ([self.btnAddEdit.titleLabel.text isEqual:@"Done"]) {
            [self.connection editRenewal:self.renewalID UserID:[AppDelegate sharedAppDelegate].me.userID Type:self.txtType.text StartDate:[[AppDelegate sharedAppDelegate] convertOriginalDate:self.txtStartDate.text] RenewalDate:[[AppDelegate sharedAppDelegate] convertOriginalDate:self.txtRenewaldate.text] provider:self.txtProvider.text Price:self.txtPrice.text Notes:self.txtNotes.text Category:[[arrTypes objectAtIndex:selectTypeIndex] valueForKey:@"category"]];
        }
        else{
            [self.connection addRenewal:[AppDelegate sharedAppDelegate].me.userID Type:self.txtType.text Category:[[arrTypes objectAtIndex:selectTypeIndex] valueForKey:@"category"] StartDate:[[AppDelegate sharedAppDelegate] convertOriginalDate:self.txtStartDate.text] RenewalDate:[[AppDelegate sharedAppDelegate] convertOriginalDate:self.txtRenewaldate.text] provider:self.txtProvider.text Price:self.txtPrice.text Notes:self.txtNotes.text];
        }
    }
}

- (BOOL)validate{
    NSString *error = @"";
    if (self.txtType.text.length<=0) {
        error = @"Please select type.";
    }
    else if (self.txtStartDate.text.length<=0) {
        error = @"Please select start date.";
    }
    else if (self.txtRenewaldate.text.length<=0) {
        error = @"Please select renewal date.";
    }
    else if (self.txtProvider.text.length<=0) {
        error = @"Please enter provider.";
    }
    
    if (error.length>0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    else{
        return YES;
    }
}

- (IBAction)clickedType:(id)sender {
    [self showTypePicker];
}

- (IBAction)clickedRenewalDate:(id)sender {
    isSelectRenewalDate = YES;
    isSelectStartDate = NO;
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateStyle:NSDateFormatterFullStyle];
    [f setTimeZone:[NSTimeZone systemTimeZone]];
    [f setDateFormat:@"EEEE, d MMMM, yyyy"];
    NSDate *tmp = [f dateFromString:self.txtRenewaldate.text];
    if (tmp != nil) {
        [self.datePicker setDate:tmp animated:NO];
    }
    
    [self showDatePicker];
}

- (IBAction)clickedStartDate:(id)sender {
    isSelectStartDate = YES;
    isSelectRenewalDate = NO;
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateStyle:NSDateFormatterFullStyle];
    [f setTimeZone:[NSTimeZone systemTimeZone]];
    [f setDateFormat:@"EEEE, d MMMM, yyyy"];
    NSDate *tmp = [f dateFromString:self.txtStartDate.text];
    if (tmp != nil) {
        [self.datePicker setDate:tmp animated:NO];
    }
    [self showDatePicker];
}

- (IBAction)clickedHelp:(id)sender {
}

- (IBAction)clickedPickerDone:(id)sender {
    NSLog(@"%@",self.datePicker.date);
    [self hiddenPickerView];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateStyle:NSDateFormatterFullStyle];
    [f setTimeZone:[NSTimeZone systemTimeZone]];
    [f setDateFormat:@"EEEE, d MMMM, yyyy"];
    if (isSelectStartDate) {
        self.txtStartDate.text = [f stringFromDate:self.datePicker.date];
    }
    else if(isSelectRenewalDate){
        self.txtRenewaldate.text = [f stringFromDate:self.datePicker.date];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self hiddenPickerView];
    [self.scrollViewAddRenewal setContentSize:CGSizeMake(320, 800)];
    if ([textField isEqual:self.txtProvider]) {
        [self.scrollViewAddRenewal setContentOffset:CGPointMake(0, 86) animated:YES];
    }
    else if ([textField isEqual:self.txtPrice]){
        [self.scrollViewAddRenewal setContentOffset:CGPointMake(0, 130) animated:YES];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.txtProvider]) {
        [self.txtPrice becomeFirstResponder];
    }
    else if ([textField isEqual:self.txtPrice]){
        [self.txtNotes becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self hiddenPickerView];
    [self.scrollViewAddRenewal setContentSize:CGSizeMake(320, 800)];
    [self.scrollViewAddRenewal setContentOffset:CGPointMake(0, 200) animated:YES];
    if ([self.txtNotes.text isEqualToString:@"Notes"]) {
        self.txtNotes.text = @"";
        self.txtNotes.textColor = [UIColor darkGrayColor];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (textView.text.length<=0) {
        self.txtNotes.text = @"Notes";
        self.txtNotes.textColor = [UIColor lightGrayColor];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self hiddenPickerView];
        [self.scrollViewAddRenewal setContentSize:CGSizeMake(320, 568)];
        [self.scrollViewAddRenewal setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.txtNotes resignFirstResponder];
        return NO;
    }
    return YES;
}

//-- UIPicker delegate methods
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return arrTypes.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [[arrTypes objectAtIndex:row] valueForKey:@"type"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.txtType.text = [[arrTypes objectAtIndex:row] valueForKey:@"type"];
    selectTypeIndex = row;
}

- (void)requestResultSuccess:(id)response andError:(NSError *)error{
    [[AppDelegate sharedAppDelegate] stopLoadingView];
    if (!error) {
        [AppDelegate sharedAppDelegate].editRenewalData = [NSMutableDictionary dictionary];
        [[AppDelegate sharedAppDelegate].editRenewalData setValue:[[AppDelegate sharedAppDelegate] convertOriginalDate:self.txtStartDate.text] forKeyPath:@"start_date"];
        [[AppDelegate sharedAppDelegate].editRenewalData setValue:[[AppDelegate sharedAppDelegate] convertOriginalDate:self.txtRenewaldate.text] forKeyPath:@"renewal_date"];
        [[AppDelegate sharedAppDelegate].editRenewalData setValue:self.txtProvider.text forKeyPath:@"provider"];
        [[AppDelegate sharedAppDelegate].editRenewalData setValue:self.txtPrice.text forKeyPath:@"price"];
        [[AppDelegate sharedAppDelegate].editRenewalData setValue:self.txtNotes.text forKeyPath:@"notes"];
        [[AppDelegate sharedAppDelegate].editRenewalData setValue:self.txtType.text forKeyPath:@"type"];
        [[AppDelegate sharedAppDelegate].editRenewalData setValue:[[arrTypes objectAtIndex:selectTypeIndex] valueForKey:@"category"] forKeyPath:@"category"];
        [[AppDelegate sharedAppDelegate].editRenewalData setValue:[self.root valueForKey:@"rid"] forKeyPath:@"rid"];
        NSLog(@"%@",[AppDelegate sharedAppDelegate].editRenewalData);
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:response delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}


@end
