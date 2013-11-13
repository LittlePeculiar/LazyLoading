//
//  ViewController.m
//  LazyLoading
//
//  Created by Gina Mullins on 11/12/13.
//  Copyright (c) 2013 Gina Mullins. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"
#import "Download.h"

#define kCELLSIZE       50

NSString * const REUSE_CUSTOM_CELLID = @"CustomCell";

@interface ViewController ()

@property (nonatomic, strong) Download *downloadManager;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, weak) IBOutlet UITableView *listTable;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"NetBrains", @"NetBrains");
        self.listArray = [[NSMutableArray alloc] init];
        
        self.downloadManager = [[Download shareManager] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *tableCellNib = [UINib nibWithNibName:REUSE_CUSTOM_CELLID bundle:[NSBundle bundleForClass:[CustomCell class]]];
    [self.listTable registerNib:tableCellNib forCellReuseIdentifier:REUSE_CUSTOM_CELLID];
    
    [self getData];
}

- (void)getData
{
    [self.listArray removeAllObjects];
    self.listArray = [self.downloadManager refreshData];
    
    [self.listTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.downloadManager = nil;
    self.listArray = nil;
    self.listTable = nil;
}

#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // could also be a class
    NSString *urlString = [self.listArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"Rays-Office.jpg"];
    
    // only download if we are moving
    if (self.listTable.dragging == NO && self.listTable.decelerating == NO)
    {
        [self.downloadManager retrieveImage:urlString withCompletionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded)
            {
                // use the downloaded image
                cell.imageView.image = image;
            }
            else
                 NSLog(@"download Error");
        }];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark UITableViewDelegate methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"My Photos";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // same for now
    return kCELLSIZE;
}


@end
