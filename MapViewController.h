//
//  MapViewController.h
//  1919
//
//  Created by 丁强 on 15/8/18.
//  Copyright (c) 2015年 丁强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapAnnotation.h"

@interface MapViewController : UIViewController <MKMapViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate,UITableViewDelegate>

{
    __weak IBOutlet UIButton *location;
    
    __weak IBOutlet UISearchBar *searchAddres;
    
    
    __weak IBOutlet UINavigationItem *TopNavigation;
    
    __weak IBOutlet UIToolbar *buttomBar;
    
    
    CLLocationManager *_locationManager;
    
//    UIImageView *position;  //替换移动地图时隐藏的大头针
    
    CLLocationCoordinate2D centerCoordinate;    //当前map坐标中心点坐标
    CLLocationCoordinate2D currentLocation;     //GPS定位的当前所在坐标

    NSDictionary *address;

    NSMutableArray *searchResultName;   //搜索结果的name信息
    NSMutableArray *searchResultAddress;    //搜索结果地址完整信息
    NSMutableArray *searchResultLocation;   //搜索结果经纬度信息

    
    UILongPressGestureRecognizer *longPress;    //长按手势
}


@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end
