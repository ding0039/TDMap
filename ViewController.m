//
//  ViewController.m
//  TDMap
//
//  Created by 丁强 on 15/8/18.
//  Copyright (c) 2015年 Terence. All rights reserved.
//

#import "ViewController.h"
#import "MapViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openMap:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard
                                    storyboardWithName:@"map" bundle:nil];
    UIViewController *indexViewController = [mainStoryboard
                                             instantiateViewControllerWithIdentifier:@"TDMap"];
    
    indexViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:indexViewController animated:YES completion:nil];
    
}

@end
