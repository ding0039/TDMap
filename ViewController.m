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
    UIStoryboard *mapStoryboard = [UIStoryboard
                                    storyboardWithName:@"MapView" bundle:nil];
    UIViewController *mapViewController = [mapStoryboard
                                             instantiateViewControllerWithIdentifier:@"TDMap"];
    
    mapViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:mapViewController animated:YES completion:nil];
//
//    MapViewController *mapView = [[MapViewController alloc]init];
//    [self presentViewController:mapView animated:YES completion:nil];
    
}

@end
