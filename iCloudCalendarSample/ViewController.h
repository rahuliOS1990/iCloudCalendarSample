//
//  ViewController.h
//  iCloudCalendarSample
//
//  Created by R. Sharma on 7/15/14.
//  Copyright (c) 2014 AgileMobileDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKitUI/EventKitUI.h>

@interface ViewController : UIViewController<UITextFieldDelegate,EKEventEditViewDelegate>
{
    IBOutlet UIButton *btnStrtDate;
    IBOutlet UIButton *btnEndDate;
    
    NSDate *selectedStrtDate;
    NSDate *selectedEndDate;
    IBOutlet UITextField *txtFieldTitle;
    EKEventStore *eventStore;
    
}
@end
