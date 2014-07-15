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
    
    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
    event.title     = @"Event3";
    
    NSDate *startDate = [NSDate date];
    event.calendar = cal;
    event.startDate = startDate;
    event.endDate = [startDate dateByAddingTimeInterval:3600];
    
    NSError *error = nil;
    BOOL result = [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
    if (result) {
        NSLog(@"Saved event to event store.");
    } else {
        NSLog(@"Error saving event: %@.", error);
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
                                   
                                    [sender setTitle:[NSString stringWithFormat:@"%@",[MMPickerView sharedView] .datePicker.date] forState:UIControlStateNormal];
                                    
                                }];
    
}

@end
