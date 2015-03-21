//
//  RegisterViewController.m
//  RenewalReminder
//
//  Created by MonuRathor on 26/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import "RegisterViewController.h"
#import "RequestConnection.h"

@interface RegisterViewController ()<RequestConnectionDelegate>
@property (nonatomic, strong) RequestConnection *connection;

@end

@implementation RegisterViewController

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
    
    //-- setup border of register fields
    self.viewRegisterFields.layer.masksToBounds = YES;
    self.viewRegisterFields.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.viewRegisterFields.layer.borderWidth = 1.0f;
    
    self.titlePicker.hidden = YES;
    
    self.connection = [[RequestConnection alloc] init];
    self.connection.delegate = self;
    
    UIToolbar *numberToolbar = [[UIToolbar alloc] init];
    [numberToolbar sizeToFit];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(clickedNumberDone:)];
    [numberToolbar setItems:[NSArray arrayWithObjects:btnDone, nil]];
    
    
    
    self.txtMobile.inputAccessoryView = numberToolbar;
    
    // Do any additional setup after loading the view.
}

- (IBAction)clickedNumberDone:(id)sender{
    NSLog(@"Cliucked next");
    [self.txtPassword becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

- (IBAction)clickedHome:(id)sender {
    [self.txtEmail resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickedRegister:(id)sender {
    NSString *error = @"";
    if (self.txtEmail.text.length<=0) {
        error = @"Email address can not be blank.";
    }
    else if (![self.txtEmail.text isEqualToString:self.txtConfirmEmail.text]) {
        error = @"Confirm email address is not same.";
    }
    else if (self.txtPassword.text.length <= 0) {
        error = @"Password can not be blank.";
    }
    else if(self.txtPassword.text.length < 4){
        error = @"Password should be a minimum of 4 character.";
    }
    
    if (error.length>0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        [[AppDelegate sharedAppDelegate] startLoadingView];
        [self.connection registerUserID:self.txtEmail.text Title:self.txtTitle.text FirstName:self.txtFirstName.text Surname:self.txtSurname.text Email:self.txtEmail.text Password:self.txtPassword.text Mobile:self.txtMobile.text andLoginType:@"0"];
    }
}

- (IBAction)clickedTitle:(id)sender {
    self.titlePicker.hidden = NO;
}

- (void)requestResultSuccess:(id)response andError:(NSError *)error{
    [[AppDelegate sharedAppDelegate] stopLoadingView];
    if (!error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:response delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.titlePicker.hidden = YES;
    [self.scrollViewRegister setContentSize:CGSizeMake(320, 800)];
    if ([self.txtTitle isEqual:textField]) {
        [self.scrollViewRegister setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if ([self.txtFirstName isEqual:textField]) {
        [self.scrollViewRegister setContentOffset:CGPointMake(0, 43) animated:YES];
    }
    else if ([self.txtSurname isEqual:textField]) {
        [self.scrollViewRegister setContentOffset:CGPointMake(0, 86) animated:YES];
    }
    else if ([self.txtEmail isEqual:textField]) {
        [self.scrollViewRegister setContentOffset:CGPointMake(0, 129) animated:YES];
    }
    else if ([self.txtConfirmEmail isEqual:textField]) {
        [self.scrollViewRegister setContentOffset:CGPointMake(0, 172) animated:YES];
    }
    else if ([self.txtMobile isEqual:textField]) {
        [self.scrollViewRegister setContentOffset:CGPointMake(0, 215) animated:YES];
    }
    else if ([self.txtPassword isEqual:textField]) {
       [self.scrollViewRegister setContentOffset:CGPointMake(0, 258) animated:YES];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([self.txtTitle isEqual:textField]) {
        [self.txtFirstName becomeFirstResponder];
    }
    else if ([self.txtFirstName isEqual:textField]) {
        [self.txtSurname becomeFirstResponder];
    }
    else if ([self.txtSurname isEqual:textField]) {
        [self.txtEmail becomeFirstResponder];
    }
    else if ([self.txtEmail isEqual:textField]) {
        [self.txtConfirmEmail becomeFirstResponder];
    }
    else if ([self.txtConfirmEmail isEqual:textField]) {
        [self.txtMobile becomeFirstResponder];
    }
    else if ([self.txtMobile isEqual:textField]) {
        [self.txtPassword becomeFirstResponder];
    }
    else if ([self.txtPassword isEqual:textField]) {
        [self.txtPassword resignFirstResponder];
        [self.scrollViewRegister setContentSize:CGSizeMake(320, 568)];
        [self.scrollViewRegister setContentOffset:CGPointMake(0, 0) animated:YES];
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
    return 6;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (row==0) {
        return  @"Mr";
    }
    else if(row == 1){
        return @"Mrs";
    }
    else if(row == 2){
        return @"Ms";
    }
    else if(row == 3){
        return @"Miss";
    }
    else if(row == 4){
        return @"Dr";
    }
    else{
        return @"Prof";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (row==0) {
        self.txtTitle.text =  @"Mr";
    }
    else if(row == 1){
        self.txtTitle.text = @"Mrs";
    }
    else if(row == 2){
        self.txtTitle.text = @"Ms";
    }
    else if(row == 3){
        self.txtTitle.text = @"Miss";
    }
    else if(row == 4){
        self.txtTitle.text = @"Dr";
    }
    else if(row == 5){
        self.txtTitle.text = @"Prof";
    }
    self.titlePicker.hidden = YES;
}


@end
