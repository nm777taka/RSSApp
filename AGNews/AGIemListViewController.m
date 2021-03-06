//
//  AGDetailViewController.m
//  AGNews
//
//  Created by TakahisaFuruta on 2014/05/26.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AGItemListViewController.h"

@interface AGItemListViewController ()
- (void)configureView;
@end

@implementation AGItemListViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timeStamp"] description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
