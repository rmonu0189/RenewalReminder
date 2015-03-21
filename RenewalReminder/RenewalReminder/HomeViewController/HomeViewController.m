//
//  HomeViewController.m
//  RenewalReminder
//
//  Created by MonuRathor on 28/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import "HomeViewController.h"
#import "Renewal30DaysCell.h"
#import "RenewalOtherCell.h"
#import "RequestConnection.h"
#import "RenewalViewController.h"
#import "SWRevealViewController.h"
#import "Notification.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate, RequestConnectionDelegate>
@property (nonatomic, strong) NSDictionary *selectedRenewal;
@property (nonatomic, strong) RequestConnection *connection;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSCalendar *calender;
@property (nonatomic, strong) Notification *localNotification;
@end

@implementation HomeViewController

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
    
    self.btnNorecordFound.hidden = YES;
    self.imgNoRecordFound.hidden = YES;
    
    self.localNotification = [[Notification alloc] init];
    
    [self.btnMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    
    self.calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    self.connection = [[RequestConnection alloc] init];
    self.connection.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:@"LOGOUT" object:nil];
    [[AppDelegate sharedAppDelegate] startLoadingView];
    [self.connection getRenewalsList];
    //[self.localNotification addNotification:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)logout:(NSNotification *)notification{
    [[AppDelegate sharedAppDelegate] clearUser];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([AppDelegate sharedAppDelegate].renewalsList30Days.count>0 || [AppDelegate sharedAppDelegate].renewalsListOther.count>0) {
        return 2;
    }
    else{
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
        imgView.image = [UIImage imageNamed:@"imgNext30.png"];
        return imgView;
    }
    else{
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 35)];
        imgView.image = [UIImage imageNamed:@"imgNextOther.png.png"];
        return imgView;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [AppDelegate sharedAppDelegate].renewalsList30Days.count;
    }
    else{
        return [AppDelegate sharedAppDelegate].renewalsListOther.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        Renewal30DaysCell *cell = (Renewal30DaysCell*)[tableView dequeueReusableCellWithIdentifier:@"renewal_30" forIndexPath:indexPath];
        NSDictionary *param = [[AppDelegate sharedAppDelegate].renewalsList30Days objectAtIndex:indexPath.row];
        cell.lblTitle.text = [param valueForKey:@"type"];
        NSInteger days = [[AppDelegate sharedAppDelegate] getDifferenceFromTodayTo:[[[param valueForKey:@"renewal_date"] componentsSeparatedByString:@" "] firstObject]];
        if (days == 0) {
            cell.lblRemainDays.text = @"Today";
        }
        else{
            cell.lblRemainDays.text = [NSString stringWithFormat:@"%d days",(int)days];
        }
        cell.lblYouAreWith.text = [param valueForKey:@"provider"];
        cell.imgFirst.image = [UIImage imageNamed:[[AppDelegate sharedAppDelegate] getTypeImageLogoName:[param valueForKey:@"category"]]];
        cell.imgBackground.image = [UIImage imageNamed:[[AppDelegate sharedAppDelegate] getTypeImageBackName:[param valueForKey:@"category"]]];
        return cell;
    }
    else{
        Renewal30DaysCell *cell = (Renewal30DaysCell*)[tableView dequeueReusableCellWithIdentifier:@"renewal_30" forIndexPath:indexPath];
        NSDictionary *param = [[AppDelegate sharedAppDelegate].renewalsListOther objectAtIndex:indexPath.row];
        cell.lblTitle.text = [param valueForKey:@"type"];
        
        NSInteger days = [[AppDelegate sharedAppDelegate] getDifferenceFromTodayTo:[[[param valueForKey:@"renewal_date"] componentsSeparatedByString:@" "] firstObject]];
        if (days == 0) {
            cell.lblRemainDays.text = @"Today";
        }
        else{
            cell.lblRemainDays.text = [NSString stringWithFormat:@"%d days",(int)days];
        }
        
        cell.lblYouAreWith.text = [param valueForKey:@"provider"];
        cell.imgFirst.image = [UIImage imageNamed:[[AppDelegate sharedAppDelegate] getTypeImageLogoName:[param valueForKey:@"category"]]];
        cell.imgBackground.image = [UIImage imageNamed:[[AppDelegate sharedAppDelegate] getTypeImageBackName:[param valueForKey:@"category"]]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"select row");
    if (indexPath.section == 0) {
        self.selectedRenewal = [[AppDelegate sharedAppDelegate].renewalsList30Days objectAtIndex:indexPath.row];
    }
    else{
        self.selectedRenewal = [[AppDelegate sharedAppDelegate].renewalsListOther objectAtIndex:indexPath.row];
    }
    [self performSegueWithIdentifier:@"viewRenewal" sender:self];
    
}

- (NSInteger)getDifferenceFromTodayTo:(NSString *)end{
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [NSDate date];
    
    
    NSString *currentDate = [f stringFromDate:[NSDate date]];
    NSLog(@"%@",startDate);
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:[f dateFromString:currentDate]
                                                          toDate:[f dateFromString:end]
                                                         options:0];
    return components.day;
}

- (void)reloadTable{
    [self.tblRenewal30 reloadData];
    //[self.tblRenewalOther reloadData];
}

- (void)requestResultSuccess:(id)response andError:(NSError *)error{
    [[AppDelegate sharedAppDelegate] stopLoadingView];
    if (!error) {
        [AppDelegate sharedAppDelegate].renewalsList30Days = (NSMutableArray *)[response valueForKey:@"renewal30days"];
        [AppDelegate sharedAppDelegate].renewalsListOther = (NSMutableArray *)[response valueForKey:@"renewalOther"];
        //NSLog(@"%@",[AppDelegate sharedAppDelegate].renewalsList30Days);
        [self reloadTable];
        
        NSInteger count = [[UIApplication sharedApplication] scheduledLocalNotifications].count;
        if (count>0) {
            for (NSDictionary *record in [AppDelegate sharedAppDelegate].renewalsList30Days) {
                if ([[record valueForKey:@"status"] integerValue] == 1) {
                    [self.localNotification addNotification:record];
                }
                else if ([[record valueForKey:@"status"] integerValue] == 2) {
                    [self.localNotification editNotification:record];
                }
            }
            for (NSDictionary *record in [AppDelegate sharedAppDelegate].renewalsListOther) {
                if ([[record valueForKey:@"status"] integerValue] == 1) {
                    [self.localNotification addNotification:record];
                }
                else if ([[record valueForKey:@"status"] integerValue] == 2) {
                    [self.localNotification editNotification:record];
                }
            }
        }
        else{
            for (NSDictionary *record in [AppDelegate sharedAppDelegate].renewalsList30Days) {
                [self.localNotification addNotification:record];
            }
            for (NSDictionary *record in [AppDelegate sharedAppDelegate].renewalsListOther) {
                [self.localNotification addNotification:record];
            }
        }
        
        if ([AppDelegate sharedAppDelegate].renewalsList30Days.count>0 || [AppDelegate sharedAppDelegate].renewalsListOther.count>0) {
            self.btnNorecordFound.hidden = YES;
            self.imgNoRecordFound.hidden = YES;
        }
        else{
            self.btnNorecordFound.hidden = NO;
            self.imgNoRecordFound.hidden = NO;
        }
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue destinationViewController] isKindOfClass:[RenewalViewController class]]) {
        RenewalViewController *rvc = (RenewalViewController*)[segue destinationViewController];
        rvc.renewalID = [self.selectedRenewal valueForKey:@"rid"];
        rvc.root = self.selectedRenewal;
    }
    
}

- (IBAction)clickedMenu:(id)sender {
    if (self.tblMenu.hidden) {
        self.tblMenu.hidden = NO;
    }
    else{
        self.tblMenu.hidden = YES;
    }
}
- (IBAction)clickedNoRecord:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.comparewithus.com/apptour/"]];
}
@end
