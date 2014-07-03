#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "SDKDemos/Samples/AnimatedCurrentLocationViewController.h"

@implementation AnimatedCurrentLocationViewController {
  CLLocationManager *manager_;
  GMSMapView        *mapView_;
  GMSMarker         *locationMarker_;
  
  BOOL							tracking;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:38.8879
                                                          longitude:-77.0200
                                                               zoom:17];
  mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  mapView_.settings.myLocationButton = NO;
  mapView_.settings.indoorPicker = NO;
  mapView_.delegate = self;

  self.view = mapView_;

  // Setup location services
  if (![CLLocationManager locationServicesEnabled]) {
    NSLog(@"Please enable location services");
    return;
  }

  if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
    NSLog(@"Please authorize location services");
    return;
  }

  manager_ = [[CLLocationManager alloc] init];
  manager_.delegate = self;
  manager_.desiredAccuracy = kCLLocationAccuracyBest;
  manager_.distanceFilter = 5.0f;
  [manager_ startUpdatingLocation];

  // Change: add the Locate button
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Locate" style:UIBarButtonItemStyleBordered target:self action:@selector(locate:)];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
    NSLog(@"Please authorize location services");
    return;
  }

  NSLog(@"CLLocationManager error: %@", error.localizedFailureReason);
  return;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  CLLocation *location = [locations lastObject];

  if (locationMarker_ == nil) {
    locationMarker_ = [[GMSMarker alloc] init];
    locationMarker_.position = location.coordinate;

    // Animated walker images derived from an www.angryanimator.com tutorial.
    // See: http://www.angryanimator.com/word/2010/11/26/tutorial-2-walk-cycle/

    NSArray *frames = @[[UIImage imageNamed:@"step1"],
                        [UIImage imageNamed:@"step2"],
                        [UIImage imageNamed:@"step3"],
                        [UIImage imageNamed:@"step4"],
                        [UIImage imageNamed:@"step5"],
                        [UIImage imageNamed:@"step6"],
                        [UIImage imageNamed:@"step7"],
                        [UIImage imageNamed:@"step8"]];

    locationMarker_.icon = [UIImage animatedImageWithImages:frames duration:0.8];
    locationMarker_.groundAnchor = CGPointMake(0.5f, 0.5f); // Change: position the anchor in the center of the image
    locationMarker_.map = mapView_;
  } else {
    [CATransaction begin];
    [CATransaction setAnimationDuration:2.0];
    locationMarker_.position = location.coordinate; // Change: set the position to the initial location
    [CATransaction commit];
  }

  if (tracking) { // Change: added the tracking condition
    GMSCameraUpdate *move = [GMSCameraUpdate setTarget:location.coordinate zoom:17];
    [mapView_ animateWithCameraUpdate:move];
  }
}

// Change: added the button handler and the willMove delegate to stop tracking once the user moves the map via gesture

- (void)locate:(id)sender {
  tracking = YES;
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture {
  if (gesture) {
    tracking = NO;
  }
}


@end
