#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "SDKDemos/Samples/FixedPanoramaViewController.h"

#import <GoogleMaps/GoogleMaps.h>

static CLLocationCoordinate2D kPanoramaNear = {-33.732022, 150.312114};

@interface FixedPanoramaViewController () <GMSPanoramaViewDelegate>
@end

@implementation FixedPanoramaViewController {
  GMSPanoramaView *view_;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  view_ = [GMSPanoramaView panoramaWithFrame:CGRectZero
                              nearCoordinate:kPanoramaNear];
  view_.camera = [GMSPanoramaCamera cameraWithHeading:180
                                                pitch:-10
                                                 zoom:0];
  view_.delegate = self;
  view_.orientationGestures = NO;
  view_.navigationGestures = NO;
  view_.navigationLinksHidden = YES;
  self.view = view_;
}

@end
