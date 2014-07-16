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
    
   // dateFormatter = [[NSDateFormatter alloc] init];
    
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm a"];
    
    btnEndDate.layer.borderWidth=1.0f;
    btnEndDate.layer.borderColor=[UIColor darkGrayColor].CGColor;
    
    btnStrtDate.layer.borderWidth=1.0f;
    btnStrtDate.layer.borderColor=[UIColor darkGrayColor].CGColor;
	// Do any additional setup after loading the view, typically from a nib.

  //  [self iCloudCalendar];
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


#pragma Mark - Code To test for iCloud Calendar Api

-(void)iCloudCalendar
{
    
    EKEventStore *store = [[EKEventStore alloc] init];
    EKSource *localSource = nil;
    for (EKSource *source in store.sources)
    {
        if (source.sourceType == EKSourceTypeCalDAV && [source.title isEqualToString:@"iCloud"])
        {
            localSource = source;
            break;
        }
    }
    if (localSource == nil)
    {
        for (EKSource *source in store.sources) {
            if (source.sourceType == EKSourceTypeLocal)
            {
                localSource = source;
                break;
            }
        }
    }
    
    EKEventStore *es = [[EKEventStore alloc] init];
    [es requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
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
    
    //NSString *identifier; //Use to create for the first time and store somewhere
    NSString *identifier = @"704A1304-5213-4AB3-9C7B-F6B59E3454BB"; //Stored version
    
    //Create the calendar
    EKCalendar *cal;
    if (identifier == nil)
    {
        cal = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:store];
        
        cal.title = @"Demo1 Calendar";
        cal.source = localSource;
        [store saveCalendar:cal commit:YES error:nil];
        NSLog(@"cal id = %@", cal.calendarIdentifier);
        
    } else {
        //Calendar already exists!
        cal = [store calendarWithIdentifier:identifier];
        NSLog(@"cal id = %@", cal.calendarIdentifier);
    }
    
    //calendar properties
    NSLog(@"%@", cal);
    
    //Add Event to Calendar
    NSLog(@"Adding event!");

    
    

    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    event.title = txtFieldTitle.text;
    event.startDate = strSelectedStrtDate;
    event.endDate = strSelectedEndDate;
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
                                  cancelButtonTitle:@"Right On!" otherButtonTitles:nil] ;
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
                                    strSelectedStrtDate=[MMPickerView sharedView] .datePicker.date;
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
                                   
                                    strSelectedEndDate= [MMPickerView sharedView] .datePicker.date;
                                    [sender setTitle:[NSString stringWithFormat:@"%@",[MMPickerView sharedView] .datePicker.date] forState:UIControlStateNormal];
                                    
                                }];
    
    
    
}


#pragma mark- Create Event Method

-(IBAction)btnCreateEventPressed:(id)sender
{
    if (strSelectedStrtDate ==NULL && strSelectedEndDate==NULL) {
    [[[UIAlertView alloc] initWithTitle:nil message:@"Please select start and end date." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil]show];
    }
    else if ([txtFieldTitle.text length]==0)
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please select Event title." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil]show];
    }
    else
    {
      
        NSComparisonResult result=[strSelectedStrtDate compare:strSelectedEndDate];
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
            [self iCloudCalendar];
        }
        
    }
    
    
}

@end
