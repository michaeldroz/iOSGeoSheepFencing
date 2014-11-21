//
//  ViewController.m
//  GeoCode3
//
//  Created by Michael Droz on 11/11/14.
//  Copyright (c) 2014 Michael Droz. All rights reserved.
//

#import "ViewController.h"
@import CoreLocation;

@interface ViewController () <CLLocationManagerDelegate>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.delegate = self;
    
    //Check for iOS 8. Wihtout this guard the code will crash with "unknonw select"
    
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    self.locationStore = [[LocationStore alloc] init];
}

- (IBAction)updateLocation:(UIBarButtonItem *)sender {
    float spanX = 0.58;
    float spanY = 0.58;
    self.location = self.locationManager.location;
    //a quick nslog to shus us that it's doing something
    NSLog(@"%@", self.location.description);
    MKCoordinateRegion region;
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span = MKCoordinateSpanMake(spanX, spanY);
    [self.mapView setRegion:region animated:YES];
    [self.locationStore queryNearbyLocations:self.location radius:100.0 withBlock:^(NSString *key, CLLocation *location) {
        NSLog(@"Key '%@' entered the search area and is at location lat:%f,lon:%f", key, location.coordinate.latitude, location.coordinate.longitude);
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = location.coordinate;
        point.title = key;
        [self.mapView addAnnotation:point];
    }];
}

- (IBAction)monitorThisRegion:(UIBarButtonItem *)sender  {

   float theRadius = 100.0;
   NSString *theIdentifier = @"atWork";
   CLLocationCoordinate2D centre;
    centre.latitude = self.mapView.centerCoordinate.latitude;
    centre.longitude = self.mapView.centerCoordinate.longitude;
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:centre
                                                                 radius:theRadius
                                                             identifier:theIdentifier
                            ];
    //Then cast the instance for use with your CLLocationManager instance
   [self.locationManager startMonitoringForRegion:(CLRegion *)region];
 
    //Decprecated method.
    /*[self.locationManager startMonitoringForRegion:[[CLRegion alloc] initCircularRegionWithCenter:centre radius:20.0 identifier:@"Work" ]]; */
}

//Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Now executing didEnterRegion %@", region.identifier);
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setObject:@"Yes" forKey:@"atWork"];
    self.workLabel.text = @"You are at Work";
    [standardDefaults synchronize];
}


-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setObject:@"No" forKey:@"atWork"];
    self.workLabel.text = @"You are not at Work";
    NSLog(@"Now executing didExitRegion");
    [standardDefaults synchronize];
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"Now executing didStartMonitoringForRegion, printing region%@", region.identifier);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addEvent:(id)sender {
    CLLocation *location = self.locationManager.location;

    // Fuzz location by a small random amount to create new points
    CLLocationDegrees latOffset = (arc4random_uniform(100)-50.0) / 1000.0;
    CLLocationDegrees lonOffset = (arc4random_uniform(100)-50.0) / 1000.0;
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude + latOffset
                                                         longitude:location.coordinate.longitude + lonOffset];

    NSString *key = [[NSUUID alloc] init].UUIDString;
    [self.locationStore addLocation:newLocation forKey:key];
}


@end
