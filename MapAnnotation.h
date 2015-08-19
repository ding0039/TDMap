//
//  MapAnnotation.h
//
//
//  Created by 丁强 on 15/8/18.
//  Copyright (c) 2015年 Terence. All rights reserved.
//
/**
 *  大头针类
 *
 *  @param nonatomic <#nonatomic description#>
 *
 *  @return <#return value description#>
 */
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;    //经纬度
@property (nonatomic, copy) NSString *title;    //标题
@property (nonatomic, copy) NSString *subtitle; //副标题

#pragma mark 自定义一个图片属性在创建大头针视图时使用
@property (nonatomic,strong) UIImage *image;    //大头针自定义图样式




@end



