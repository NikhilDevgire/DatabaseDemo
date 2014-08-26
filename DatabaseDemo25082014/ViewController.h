//
//  ViewController.h
//  DatabaseDemo25082014
//
//  Created by NikhilD on 8/25/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface ViewController : UIViewController<UITextFieldDelegate>
{
    
}
@property (strong,nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *contactdb;
@property(strong,nonatomic) IBOutlet UITextField *Name,*Address,*rollNo;
@property (strong,nonatomic) IBOutlet UIButton *save,*find;
@property (strong,nonatomic) IBOutlet UILabel *status;
-(IBAction)SaveClick:(id)sender;
-(IBAction)FindClick:(id)sender;
-(IBAction)deleteClick:(id)sender;

@end
