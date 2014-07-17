//
//  ViewController.m
//  iCloudCalendarSample
//
//  Created by R. Sharma on 7/15/14.
//  Copyright (c) 2014 AgileMobileDev. All rights reserved.
//

#import "ViewController.h"
#import "MMPickerView.h"
#import <QuartzCore/QuartzCore.h>
#import <EventKit/EventKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    
    btnEndDate.layer.borderWidth=1.0f;
    btnEndDate.layer.borderColor=[UIColor darkGrayColor].CGColor;
    
    btnStrtDate.layer.borderWidth=1.0f;
    btnStrtDate.layer.borderColor=[UIColor darkGrayColor].CGColor;
	// Do any additional setup after loading the view, typically from a nib.
    
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Text Field Delgates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Code To test for iCloud Calendar Api

-(void)addToiCloudCalendar
{
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKSource *localSource = nil;
    for (EKSource *source in eventStore.sources)
    {
        if (source.sourceType == EKSourceTypeCalDAV && [source.title isEqualToString:@"iCloud"])
        {
            localSource = source;
            break;
        }
    }
    if (localSource == nil)
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"iCloud Account is not configured. Go to Settings to configure Account." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil]show];

        for (EKSource *source in eventStore.sources) {
            if (source.sourceType == EKSourceTypeLocal)
            {
                localSource = source;
                break;
            }
        }
    }
    
    
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        /* This code will run when uses has made his/her choice */
        
        if (error)
        {
            // display error message here
        }
        else if (!granted)
        {
            // display access denied error message here
        }
        else
        {
            // access granted
            
            
            
        }
        
        
    }];
    
    NSString *calendarIdentifier = [[NSUserDefaults standardUserDefaults] valueForKey:@"my_calendar_identifier"];
    
    
    
    
    //Create the calendar
    EKCalendar *cal;
    if (calendarIdentifier == nil)
    {
        cal = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:eventStore];
        
        
        
        
        // Create the predicate from the event store's instance method
        NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:selectedStrtDate
                                                                     endDate:selectedEndDate
                                                                   calendars:nil];
        
        // Fetch all events that match the predicate
        NSArray *events = [eventStore eventsMatchingPredicate:predicate];
        
        if (events.count>0) {
            
            
            [[[UIAlertView alloc] initWithTitle:nil message:@"Please select another event date. There is already an  event on this date." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil]show];
            return;
        }
        
        cal.title = @"Demo1 Calendar";
        cal.source = localSource;
        
        NSString *calendarIdentifier = [cal calendarIdentifier];
        BOOL isSaveCalendar= [eventStore saveCalendar:cal commit:YES error:nil];
        
        if (isSaveCalendar) {
            
            [[NSUserDefaults standardUserDefaults] setObject:calendarIdentifier forKey:@"my_calendar_identifier"];
        
        }
        
    }
    else {
        cal = [eventStore calendarWithIdentifier:calendarIdentifier];
        
        
        // Create the predicate from the event store's instance method
        NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:selectedStrtDate
                                                                     endDate:selectedEndDate
                                                                   calendars:nil];
        
        // Fetch all events that match the predicate
        NSArray *events = [eventStore eventsMatchingPredicate:predicate];
        
        if (events.count>0) {
            
            
            [[[UIAlertView alloc] initWithTitle:nil message:@"Please select another event date. There is already an  event on this date." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil]show];
            return;
        }
        
        
        
    }
    
   
    
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    event.title = txtFieldTitle.text;
    event.startDate = selectedStrtDate;
    event.endDate = selectedEndDate;
    EKAlarm *reminder = [EKAlarm alarmWithRelativeOffset:-6*60*60];
    [event addAlarm:reminder];
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    
    NSTimeInterval alarmOffset = -1*60;//1 hour
    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:alarmOffset];
    
    [event addAlarm:alarm];
    
    NSError *err;
    BOOL saved = [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
    
    // NSLog(@"here is the error %@",[eventStore saveEvent:event span:EKSpanThisEvent error:&err]);
    if (saved == YES)
    {
        NSLog(@"evemt date %@",event.startDate);
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@""
                                  message:@"Saved to calendar"
                                  delegate:nil
                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil] ;
        [alertView show];
    }
    
}




-(IBAction)btnStartTimePressed:(UIButton*)sender
{
    
    
    [MMPickerView showDatePickerViewInView:self.view withOptions:@{MMbackgroundColor: [UIColor whiteColor],
                                                                   MMtextColor: [UIColor whiteColor],
                                                                   MMtoolbarColor: [UIColor blackColor],
                                                                   MMbuttonColor: [UIColor whiteColor],
                                                                   MMfont: [UIFont systemFontOfSize:18],
                                                                   MMvalueY: @3,MMselectedObject:[NSDate date]}
                                completion:^(NSString *sel) {
                                        [btnStrtDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                    selectedStrtDate=[MMPickerView sharedView] .datePicker.date;
                                    [sender setTitle:[NSString stringWithFormat:@"%@",[MMPickerView sharedView] .datePicker.date] forState:UIControlStateNormal];
                                    
                                }];
    
    
}

-(IBAction)btnEndTimePressed:(UIButton*)sender
{
    [MMPickerView showDatePickerViewInView:self.view withOptions:@{MMbackgroundColor: [UIColor whiteColor],
                                                                   MMtextColor: [UIColor whiteColor],
                                                                   MMtoolbarColor: [UIColor blackColor],
                                                                   MMbuttonColor: [UIColor whiteColor],
                                                                   MMfont: [UIFont systemFontOfSize:18],
                                                                   MMvalueY: @3,MMselectedObject:[NSDate date]}
                                completion:^(NSString *sel) {
                                    [btnEndDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

                                    selectedEndDate= [MMPickerView sharedView] .datePicker.date;
                                    [sender setTitle:[NSString stringWithFormat:@"%@",[MMPickerView sharedView] .datePicker.date] forState:UIControlStateNormal];
                                    
                                }];
    
    
    
}


#pragma mark- Create Event Method

-(IBAction)btnCreateEventPressed:(id)sender
{
    if (selectedStrtDate ==NULL && selectedEndDate==NULL) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please select start and end date." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil]show];
    }
    else if ([txtFieldTitle.text length]==0)
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please select Event title." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil]show];
    }
    else
    {
        
        
        
        
        NSComparisonResult result=[selectedStrtDate compare:selectedEndDate];
        BOOL isEndDateBeforeStart=NO;
        
        if(result==NSOrderedAscending)
        {
            NSLog(@"today is less");
        }
        
        else if(result==NSOrderedDescending)
        {
            isEndDateBeforeStart=YES;
        }else
        {
            isEndDateBeforeStart=YES;
        }
        
        if (isEndDateBeforeStart) {
            [[[UIAlertView alloc] initWithTitle:nil message:@"End Date should be ahead of Start date" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil]show];
            return;
        }
        else
        {
            [self addToiCloudCalendar];
        }
        
    }
    
    
}
-(IBAction)btnCancelPressed:(id)sender
{
    [btnStrtDate setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnEndDate setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];


    [btnStrtDate setTitle:@"Please select start Date" forState:UIControlStateNormal];
    [btnEndDate setTitle:@"Please select end Date" forState:UIControlStateNormal];
    
    selectedEndDate=nil;
    selectedStrtDate=nil;
    
}
@end
