#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "SDKDemos/Samples/DoubleMapViewController.h"

#import <GoogleMaps/GoogleMaps.h>

@interface DoubleMapViewController () <GMSMapViewDelegate>
@end

@implementation DoubleMapViewController {
  GMSMapView *mapView_;
  GMSMapView *boundMapView_;
}

+ (GMSCameraPosition *)defaultCamera {
  return [GMSCameraPosition cameraWithLatitude:37.7847
                                     longitude:-122.41
                                          zoom:5];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // Two map views, second one has its camera target controlled by the first.
  CGRect frame = self.view.bounds;
  frame.size.height = frame.size.height / 2;
  mapView_ = [GMSMapView mapWithFrame:frame camera:[DoubleMapViewController defaultCamera]];
  mapView_.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                              UIViewAutoresizingFlexibleHeight |
                              UIViewAutoresizingFlexibleBottomMargin;

  mapView_.delegate = self;
  [self.view addSubview:mapView_];

  frame = self.view.bounds;
  frame.size.height = frame.size.height / 2;
  frame.origin.y = frame.size.height;
  boundMapView_ =
      [GMSMapView mapWithFrame:frame camera:[DoubleMapViewController defaultCamera]];
  boundMapView_.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                   UIViewAutoresizingFlexibleHeight |
                                   UIViewAutoresizingFlexibleTopMargin;
  boundMapView_.settings.scrollGestures = NO;

  [self.view addSubview:boundMapView_];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
  CGRect frame = self.view.bounds;
  frame.size.height = frame.size.height / 2;
  mapView_.frame = frame;
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
  GMSCameraPosition *previousCamera = boundMapView_.camera;
  boundMapView_.camera = [GMSCameraPosition cameraWithTarget:position.target
                                                        zoom:previousCamera.zoom
                                                     bearing:previousCamera.bearing
                                                viewingAngle:previousCamera.viewingAngle];
}

@end
