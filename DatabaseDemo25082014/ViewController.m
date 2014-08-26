//
//  ViewController.m
//  DatabaseDemo25082014
//
//  Created by NikhilD on 8/25/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize Name,Address,rollNo,databasePath,contactdb,status;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *docDir;
    NSArray *dirArr;
    dirArr=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docDir=dirArr[0];
    
    databasePath=[[NSString alloc]initWithString:[docDir stringByAppendingPathComponent:@"contact.db"]];
    NSFileManager *filemgr=[NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath:databasePath]==NO)
    {
        const char *dbpath=[databasePath UTF8String];
        if (sqlite3_open(dbpath, &(contactdb))==SQLITE_OK)
        {
            char *errmsg;
            const char *sql_smt="CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)";
            if (sqlite3_exec(contactdb, sql_smt, NULL, NULL, &errmsg)!= SQLITE_OK)
            {
                status.text=@"fail to create database";
            }
            sqlite3_close(contactdb);
        }
        else
        {
            status.text=@"fail to open/create database";
        }
    }
}

-(IBAction)SaveClick:(id)sender
{
    sqlite3_stmt *statment;
    const char *dbpath=[databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactdb)==SQLITE_OK)
    {
        NSString *insert=[NSString stringWithFormat:@"INSERT INTO CONTACTS (name, address, phone) VALUES (\"%@\", \"%@\", \"%@\")",
                          Name.text,Address.text,rollNo.text];
        
        const char *insertstmt=[insert UTF8String];
        sqlite3_prepare_v2(contactdb, insertstmt, -1, &statment, NULL);
        if (sqlite3_step(statment)==SQLITE_DONE)
        {
            status.text=@"contact Added";
            Name.text=@"";
            Address.text=@"";
            rollNo.text=@"";
        }
        else
        {
            status.text=@"fail to add Data";
        }
        sqlite3_finalize(statment);
        sqlite3_close(contactdb);
    }
}


-(IBAction)FindClick:(id)sender
{
    sqlite3_stmt *statement;
    const char *dbpath=[databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactdb) == SQLITE_OK)
    {
        NSString *findSql=[NSString stringWithFormat:@"SELECT address, phone FROM contacts WHERE name=\"%@\"",
                          Name.text];
        const char *selectSql=[findSql UTF8String];
        if (sqlite3_prepare_v2(contactdb, selectSql, -1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *addressField=[[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                Address.text=addressField;
                NSString *rollField=[[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                rollNo.text=rollField;
                status.text=@"Match Found";
            }
            else
            {
                status.text=@"match not found";
                Address.text=@"";
                rollNo.text=@"";
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactdb);
    }
    
}

-(IBAction)deleteClick:(id)sender
{
    sqlite3_stmt *statement;
    const char *dbpath=[databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactdb)==SQLITE_OK)
    {
        NSString *delete=[NSString stringWithFormat:@"DELETE FROM CONTACTS WHERE name=\"%@\"",Name.text];
        
        const char *deletestmt=[delete UTF8String];
        sqlite3_prepare_v2(contactdb, deletestmt, -1, &statement, NULL);
        if (sqlite3_step(statement)==SQLITE_DONE)
        {
            status.text=@"contact Added";
            Name.text=@"";
            Address.text=@"";
            rollNo.text=@"";
        }
        else
        {
            status.text=@"fail to add Data";
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactdb);
    }
    
}

#pragma TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField // called when 'return' key pressed. return NO to ignore.
{
    [Name resignFirstResponder];
    [Address resignFirstResponder];
    [rollNo resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
