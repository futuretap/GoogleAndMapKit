#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "SDKDemos/Samples/MyLocationViewController.h"

@implementation MyLocationViewController {
  GMSMapView *mapView_;
  BOOL firstLocationUpdate_;
  NSLayoutConstraint *upperToolbarConstraint;
  NSLayoutConstraint *lowerToolbarConstraint;
  BOOL fullSize;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  UIView *container = [[UIView alloc] initWithFrame:self.view.bounds];
  container.translatesAutoresizingMaskIntoConstraints = NO;
  container.clipsToBounds = YES;
  [self.view addSubview:container];

  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:48.1 longitude:11.5 zoom:10];

  mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  mapView_.settings.compassButton = YES;
  mapView_.settings.myLocationButton = YES;
  mapView_.delegate = self;
  
  // Listen to the myLocation property of GMSMapView.
  [mapView_ addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];

  mapView_.translatesAutoresizingMaskIntoConstraints = NO;
  [container addSubview:mapView_];
  
  UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
  toolbar.translatesAutoresizingMaskIntoConstraints = NO;
  toolbar.items = @[[[UIBarButtonItem alloc] initWithTitle:@"Toolbar" style:UIBarButtonItemStylePlain target:nil action:nil]];
  [container addSubview:toolbar];
  
  UIToolbar *toolbar2 = [[UIToolbar alloc] initWithFrame:CGRectZero];
  toolbar2.translatesAutoresizingMaskIntoConstraints = NO;
  toolbar2.items = @[[[UIBarButtonItem alloc] initWithTitle:@"Toolbar" style:UIBarButtonItemStylePlain target:nil action:nil]];
  [container addSubview:toolbar2];
  
  NSDictionary *metrics = @{@"topMargin": @80.0};
  NSDictionary *views = NSDictionaryOfVariableBindings(container, mapView_, toolbar, toolbar2);
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[container]|" options:0 metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topMargin)-[container]|" options:0 metrics:metrics views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[mapView_]|" options:0 metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mapView_]|" options:0 metrics:metrics views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[toolbar]|" options:0 metrics:metrics views:views]];
  lowerToolbarConstraint = [NSLayoutConstraint constraintWithItem:toolbar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
  [self.view addConstraint:lowerToolbarConstraint];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[toolbar2]|" options:0 metrics:metrics views:views]];
  upperToolbarConstraint = [NSLayoutConstraint constraintWithItem:toolbar2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeTop multiplier:1 constant:0];
  [self.view addConstraint:upperToolbarConstraint];

  // Ask for My Location data after the map has already been added to the UI.
  dispatch_async(dispatch_get_main_queue(), ^{
    mapView_.myLocationEnabled = YES;
  });

  GMSMarker *marker = [[GMSMarker alloc] init];
  marker.title = @"Munich";
  marker.position = mapView_.camera.target;
  marker.map = mapView_;  

  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"fullsize" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleFullSize:)];

}

- (void)toggleFullSize:(id)sender {
  fullSize = !fullSize;
  
  [UIView animateWithDuration:0.35 animations:^{
    upperToolbarConstraint.constant = fullSize ? -44 : 0;
    lowerToolbarConstraint.constant = fullSize ? 44 : 0;
    
    CGFloat inset = fullSize ? 0 : 44;
    mapView_.padding = UIEdgeInsetsMake(inset, 0, inset, 0);
    
    [self.view layoutIfNeeded];
  }];
}


- (void)dealloc {
  [mapView_ removeObserver:self forKeyPath:@"myLocation" context:NULL];
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
  if (!mapView_.selectedMarker) {
    [self toggleFullSize:mapView];
  }
}


#pragma mark - KVO updates

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if (!firstLocationUpdate_) {
    // If the first location update has not yet been recieved, then jump to that
    // location.
    firstLocationUpdate_ = YES;
    CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
    mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                     zoom:14];
  }
}


@end
