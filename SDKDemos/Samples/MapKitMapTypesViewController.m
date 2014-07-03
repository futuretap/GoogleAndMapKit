//
//  MapKitMapTypesViewController.m
//  SDKDemos
//
//  Created by Ortwin Gentz on 17.03.14.
//
//

#import "MapKitMapTypesViewController.h"
#import <MapKit/MapKit.h>

@interface MapKitMapTypesViewController () <MKMapViewDelegate>

@end

@implementation MapKitMapTypesViewController {
  MKMapView *mapView_;
  UISegmentedControl *switcher_;
  MKTileOverlay *tileOverlay;
  NSInteger floor_;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  mapView_ = [[MKMapView alloc] initWithFrame:self.view.bounds];
  mapView_.delegate = self;
  mapView_.showsPointsOfInterest = NO;
  mapView_.region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(48.14, 11.57), 500, 500);
  self.view = mapView_;
  
  NSArray *types = @[@"Map", @"Satellite", @"Hybrid"];

  // Create a UISegmentedControl that is the navigationItem's titleView.
  switcher_ = [[UISegmentedControl alloc] initWithItems:types];
  switcher_.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
  UIViewAutoresizingFlexibleWidth |
  UIViewAutoresizingFlexibleBottomMargin;
  switcher_.selectedSegmentIndex = 0;
  self.navigationItem.titleView = switcher_;
  
  // Listen to touch events on the UISegmentedControl.
  [switcher_ addTarget:self action:@selector(didChangeSwitcher:)
      forControlEvents:UIControlEventValueChanged];
}

- (void)didChangeSwitcher:(UISegmentedControl*)control {
  mapView_.mapType = control.selectedSegmentIndex;
}


@end
