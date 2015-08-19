//
//  MapViewController.m
//  1919
//
//  Created by 丁强 on 15/8/18.
//  Copyright (c) 2015年 丁强. All rights reserved.
//
#define DEFAULTSPAN 0.01000

#define ZOOM_LEVEL 5


#import "MapViewController.h"

@interface MapViewController ()

@end


@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化mapview
    [self initMapView];
    
    searchResultName = [[NSMutableArray alloc] init];
    searchResultAddress = [[NSMutableArray alloc]init];
    searchResultLocation = [[NSMutableArray alloc]init];

    
    searchAddres.delegate = self;
    
//    position = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"position"]];
    
//    position.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2 -12,[[UIScreen mainScreen] bounds].size.height/2-78, 24, 24);

//    position.contentMode = UIViewContentModeScaleAspectFit;
//    [_mapView addSubview:position];
    
    
    [location.layer setCornerRadius:5];
//    [upPosition.layer setCornerRadius:15];

    
    searchAddres.placeholder = @"输入你想搜索的地址";
    searchAddres.translucent = NO;
    
    searchAddres.delegate = self;
}

-(void)initMapView{
    //请求定位服务
    _locationManager=[[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startUpdatingHeading];
    
    
    //    用一个经纬度初始化
    CLLocation *tempLocation = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    
    //    设置缩放级别大小
    MKCoordinateSpan span;
    span.latitudeDelta = 0.1;
    span.longitudeDelta = 0.1;
    
    //    设置显示范围
    MKCoordinateRegion region;
    region.center = tempLocation.coordinate;
    region.span = span;
    [_mapView setRegion:region animated:NO];


    
    _mapView.showsUserLocation = YES;
    
    //支持缩放
    _mapView.zoomEnabled = YES;
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    //设置地图类型
    _mapView.mapType = MKMapTypeStandard;
    
    //设置代理
    _mapView.delegate=self;
    
    //视图接受交互，YES才能使用手势等
    _mapView.userInteractionEnabled = YES;
    
    
    //点击手势
    UITapGestureRecognizer *tap_once = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTap:)];
    tap_once.numberOfTapsRequired = 1;

    [_mapView addGestureRecognizer:tap_once];
    
    
    
    //长按手势
    longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(touchLongPress:)];
    longPress.minimumPressDuration = 1.5f;
    
    //mapview添加长按手势
    [_mapView addGestureRecognizer:longPress];
    
    
}
//地图点击手势
-(void)touchTap:(UIGestureRecognizer*)gestureRecognizer{
    NSLog(@"点击了%@",self.navigationController);
//    self.navigationController.navigationBarHidden = YES;
    
}


//地图长按手势，调出大头针
- (void)touchLongPress:(UIGestureRecognizer*)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        return;
    }
    
    //这里touchPoint是点击的某点在地图控件中的位置
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
    
    //这里touchMapCoordinate就是该点的经纬度了
    CLLocationCoordinate2D touchMapCoordinate =
    [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];


    //用自定义的类创建大头针
    MapAnnotation *pointAnnotation=[[MapAnnotation alloc]init];
    pointAnnotation.coordinate = touchMapCoordinate;
    
    pointAnnotation.title = @"名字";
    
    
    //控制mapview上只有一个大头针
    if(_mapView.annotations.count > 0){
        [_mapView removeAnnotations:_mapView.annotations];
    }
    [_mapView addAnnotation:pointAnnotation];  //添加大头针
    
    
    //手势状态：开始
    if (gestureRecognizer.state==UIGestureRecognizerStateBegan) {
        longPress.enabled = NO;
    }
    //手势状态：进行中
    if (gestureRecognizer.state==UIGestureRecognizerStateChanged) {
    }
    //手势状态：结束
    if (gestureRecognizer.state==UIGestureRecognizerStateEnded) {
    }
}


/**
 *  当用户的位置更新时就会调用此方法，刷新用户所在坐标
 *
 *  @param userLocation 表示地图上蓝色那颗大头针的数据
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    currentLocation = userLocation.location.coordinate;
    userLocation.title = @"您的当前位置";
}

#pragma 触摸代理方法
//触摸开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

}
//触摸移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

}
//触摸结束
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

    longPress.enabled = YES;
    
}

#pragma mark 代理方法：显示大头针时调用，注意方法中的annotation参数是即将显示的大头针对象
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MapAnnotation class]]) {
        
        //从缓存池中取出大头针view
        MKPinAnnotationView *annotationView=(MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationKey"];
        
        //如果缓存池中不存在则新建
        if (!annotationView) {
            annotationView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"AnnotationKey"];
            
            
            annotationView.canShowCallout=true;     //允许交互点击
            annotationView.calloutOffset=CGPointMake(0, -2);    //定义详情视图偏移量
            annotationView.centerOffset = CGPointMake(0, 0);    //中心点上下偏移
            annotationView.opaque = YES;
            annotationView.animatesDrop = YES;  //从天而降的动画
            annotationView.draggable = YES; //可以拖动
            annotationView.selected = YES;  //标题自动显示
            annotationView.pinColor = MKPinAnnotationColorPurple;    //大头针颜色（红绿紫）
        }
        
        
        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
        annotationView.annotation=annotation;
//        annotationView.image=((MapAnnotation *)annotation).image;//设置大头针视图的图片

        
        return annotationView;

        
    }else {
        return nil;
    }
}
#pragma mark 选中大头针时触发
//点击一般的大头针KCAnnotation时添加一个大头针作为所点大头针的弹出详情视图
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
}

#pragma mark - 地图控件代理方法
/**
 *  当map开始移动时，调用此方法
 *  用于移除大头针，显示imageview（和大头针一模一样）
 */
-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    //删除所有大头针
//    if(_mapView.annotations.count > 0){
//        [_mapView removeAnnotations:_mapView.annotations];
//    }
//    [position setHidden:NO];
    
}

#pragma mark - 地图控件代理方法
/**
 *  当map停止移动时，调用此方法
 *  用于添加大头针，隐藏固定map中心的imageview，并将此处的坐标点换算成位置显示出来
 */
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
//    MKCoordinateRegion region;
//    //地图中心坐标
//    centerCoordinate = mapView.region.center;
//    //当前地图显示区域
//    region.center= centerCoordinate;
//    
//    //转换位置
//    [self getAddressByLatitude:mapView.region.center.latitude longitude:mapView.region.center.longitude];
}


- (IBAction)backWeb:(UIButton *)sender {
    [_locationManager stopUpdatingLocation];//停止更新
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 *  点击回到用户定位区域（蓝点在中心）
 *
 *  @param sender <#sender description#>
 */
- (IBAction)backLocation:(UIButton *)sender {
//    [self getAddressByLatitude:currentLocation.latitude longitude:currentLocation.longitude];
    // 设置地图的显示范围, 让其显示到当前指定的位置
    [self position:currentLocation];
    
}


/**
 *  点击确定，将定位坐标点信息等返回给rootview。退出mapview
 *
 *  @param sender <#sender description#>
 */

/*
- (IBAction)uploadPosition:(id)sender {
    if (name != nil && state != nil && city != nil && subLocality != nil) {
        [_locationManager stopUpdatingLocation];//停止更新
        
        //转换 google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标至百度坐标
        NSDictionary* baidudic = BMKConvertBaiduCoorFrom(centerCoordinate,BMK_COORDTYPE_COMMON);
        
        //解码显示成
        CLLocationCoordinate2D baiduCoordinate2D = BMKCoorDictionaryDecode(baidudic);
        
        
        NSString *strLatitude = [NSString stringWithFormat:@"%f",baiduCoordinate2D.latitude];
        NSString *strLongitude = [NSString stringWithFormat:@"%f",baiduCoordinate2D.longitude];
        
        
        NSString *newAddress = [[NSString alloc]initWithFormat:@"%@",name];
        
        
        NSDictionary *dict = @{@"address":newAddress,@"latitude":strLatitude,@"longitude":strLongitude,@"province":state,@"city":city,@"district":subLocality};
        
        //这里打印，方便之后查看通过“通知”接收的结果是否正确
        //    NSLog(@"传送的数据：%@",dict);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationNotification" object:nil userInfo:dict];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"地址信息获取不全，请重新选取" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alertView show];
    }
    
}
*/

/**
 *  返回当前定位信息点
 *
 *  @param myLocation <#myLocation description#>
 */
-(void)position:(CLLocationCoordinate2D)myLocation{
    MKCoordinateSpan span = MKCoordinateSpanMake(DEFAULTSPAN, DEFAULTSPAN); //这个显示大小精度自己调整
    
    MKCoordinateRegion region = MKCoordinateRegionMake(myLocation, span);
    [_mapView setRegion:region animated:YES];
    
}

/**
 *  反地理编码获取到详细的地址信息中文描述
 *
 *  @return
 */
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    
    CLGeocoder *_geocoder=[[CLGeocoder alloc]init];
    CLLocation *showLocation=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geocoder reverseGeocodeLocation:showLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        address = placemark.addressDictionary;
        
//        //隐藏image
//        [position setHidden:YES];
//        
//        //添加大头针
//        [self addAnnotation];
    }];
}



/**
 *  searchBar代理方法。有输入即会触发
 *
 *  @param controller   <#controller description#>
 *  @param searchString <#searchString description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    [searchResultName removeAllObjects];
    [searchResultAddress removeAllObjects];
    [searchResultLocation removeAllObjects];
    
    [self fetchNearbyInfo:searchString];

     return YES;
    
   
}

#pragma tableView 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        
        rows = [searchResultName count];
        
    }else{

        rows = 0;
        
    }
    return rows;
    
}


//绘制tablewView cell信息
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault                   reuseIdentifier:CellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    /* Configure the cell. */
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        
        cell.textLabel.text = [searchResultName objectAtIndex:indexPath.row];
//        cell.detailTextLabel.text = @"";
        
    }   
    
    return cell;
}

/**
 *  响应列表中行的点击事件
 *
 *  @return <#return value description#>
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    CLLocation *temp = [[CLLocation alloc]init];
    temp = searchResultLocation[indexPath.row];
//    NSLog(@"经纬度%f,%f",temp.coordinate.latitude,temp.coordinate.longitude);
    
    [self.searchDisplayController setActive:NO];
    [self position:temp.coordinate];

    
//    NSLog(@"选中d的经度：%f，纬度%f",temp.coordinate.latitude,temp.coordinate.longitude);
}

/**
 *  搜索文本输入完毕点击确定时触发
 *
 *  @param searchBar <#searchBar description#>
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//    NSLog(@"点击确定搜索内容%@",searchBar.text);
    
    //关闭键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

}

//搜索信息，
- (void)fetchNearbyInfo:(NSString *)inputText
{
    __block CLLocation *tempCLLocation;
    
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerCoordinate, DEFAULTSPAN ,DEFAULTSPAN);

    MKLocalSearchRequest *requst = [[MKLocalSearchRequest alloc] init];
    requst.region = region;
    
    requst.naturalLanguageQuery = inputText; //想要的信息
    
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:requst];
    
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        
        if (!error)
        {
            for(MKMapItem *mapItem in response.mapItems){
                
                [searchResultName addObject:mapItem.name];
                [searchResultAddress addObject:mapItem.placemark.addressDictionary];

                //经纬度信息存入数组
                tempCLLocation = [[CLLocation alloc]initWithLatitude:mapItem.placemark.coordinate.latitude longitude:mapItem.placemark.coordinate.longitude];
                
                [searchResultLocation addObject:tempCLLocation];
            }
            
//            NSLog(@"%@",searchResultAddress);
            
            //刷新tableView，此block为异步，不刷新无法更新tableview信息
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
        else
        {
            NSLog(@"error info is：%@",error);
        }
    }];
}

@end