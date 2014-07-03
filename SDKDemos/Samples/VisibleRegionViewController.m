#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "SDKDemos/Samples/VisibleRegionViewController.h"

#import <GoogleMaps/GoogleMaps.h>

static CGFloat kOverlayHeight = 140.0f;

@implementation VisibleRegionViewController {
  GMSMapView *mapView_;
  UIView *overlay_;
  UIBarButtonItem *flyInButton_;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-37.81969
                                                          longitude:144.966085
                                                               zoom:4];
  mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];

  // Enable my location button to show more UI components updating.
  mapView_.settings.myLocationButton = YES;
  mapView_.myLocationEnabled = YES;
  mapView_.padding = UIEdgeInsetsMake(0, 0, kOverlayHeight, 0);
  self.view = mapView_;

  // Create a button that, when pressed, causes an overlaying view to fly-in/out.
  flyInButton_ = [[UIBarButtonItem alloc] initWithTitle:@"Toggle Overlay"
                                                  style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:@selector(didTapFlyIn)];
  self.navigationItem.rightBarButtonItem = flyInButton_;

  CGRect overlayFrame = CGRectMake(0, -kOverlayHeight, 0, kOverlayHeight);
  overlay_ = [[UIView alloc] initWithFrame:overlayFrame];
  overlay_.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;

  overlay_.backgroundColor = [UIColor colorWithHue:0.0 saturation:1.0 brightness:1.0 alpha:0.5];
  [self.view addSubview:overlay_];
}

- (void)didTapFlyIn {
  UIEdgeInsets padding = mapView_.padding;

  [UIView animateWithDuration:2.0 animations:^{
    CGSize size = self.view.bounds.size;
    if (padding.bottom == 0.0f) {
      overlay_.frame = CGRectMake(0, size.height - kOverlayHeight, size.width, kOverlayHeight);
      mapView_.padding = UIEdgeInsetsMake(0, 0, kOverlayHeight, 0);
    } else {
      overlay_.frame = CGRectMake(0, mapView_.bounds.size.height, size.width, 0);
      mapView_.padding = UIEdgeInsetsZero;
    }
  }];
}

@end
