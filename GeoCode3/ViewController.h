//
//  ViewController.h
//  GeoCode3
//
//  Created by Michael Droz on 11/11/14.
//  Copyright (c) 2014 Michael Droz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet CLLocation *location;

- (IBAction)updateLocation:(id)sender;
- (IBAction)monitorThisRegion:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *workLabel;

@end

