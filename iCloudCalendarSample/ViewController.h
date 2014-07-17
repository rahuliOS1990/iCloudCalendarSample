//
//  ViewController.h
//  iCloudCalendarSample
//
//  Created by R. Sharma on 7/15/14.
//  Copyright (c) 2014 AgileMobileDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIButton *btnStrtDate;
    IBOutlet UIButton *btnEndDate;
    
    NSDate *selectedStrtDate;
    NSDate *selectedEndDate;
    IBOutlet UITextField *txtFieldTitle;
  
    
}
@end
