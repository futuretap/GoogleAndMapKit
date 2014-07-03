//
//  MapKitOverlaysViewController.m
//  SDKDemos
//
//  Created by Ortwin Gentz on 17.03.14.
//
//

#import "MapKitOverlaysViewController.h"
#import <MapKit/MapKit.h>
#import "GridTileOverlay.h"

@interface MapKitOverlaysViewController () <MKMapViewDelegate>

@end

@implementation MapKitOverlaysViewController {
  MKMapView *mapView;
  MKTileOverlay *gridOverlay;
  MKCircle *circleOverlay;
  MKCircle *circleOverlay2;
  UISwitch *belowBuildingsSwitch;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
  mapView.delegate = self;
  mapView.showsBuildings = YES;
  mapView.showsPointsOfInterest = YES;
  mapView.region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(48.14, 11.57), 500, 500);
  self.view = mapView;

  gridOverlay = [[GridTileOverlay alloc] init];
  gridOverlay.canReplaceMapContent=NO;
  
  circleOverlay = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(48.139, 11.567) radius:100];
  [mapView addOverlay:circleOverlay];
  [mapView addAnnotation:circleOverlay];
  circleOverlay2 = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(48.14, 11.568) radius:100];
  [mapView addOverlay:circleOverlay2];
  
  belowBuildingsSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
  belowBuildingsSwitch.onTintColor = self.view.tintColor;
  [belowBuildingsSwitch addTarget:self action:@selector(switchedLayer:) forControlEvents:UIControlEventValueChanged];

  self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:belowBuildingsSwitch]];
}

-(MKOverlayRenderer *)mapView:(MKMapView*)mapView rendererForOverlay:(id<MKOverlay>)overlay {
  if (overlay == circleOverlay) {
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithOverlay:circleOverlay];
    renderer.fillColor = [UIColor colorWithRed:0.2 green:0.2 blue:1 alpha:0.8];
    return renderer;
  }
  if (overlay == circleOverlay2) {
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithOverlay:circleOverlay2];
    renderer.fillColor = [UIColor colorWithRed:0 green:0.8 blue:0 alpha:0.8];
    return renderer;
  }
  return [[MKTileOverlayRenderer alloc] initWithOverlay:overlay];
}

- (void)switchedLayer:(UISwitch*)sender {
  [mapView removeOverlay:circleOverlay];
  [mapView addOverlay:circleOverlay level:belowBuildingsSwitch.on ? MKOverlayLevelAboveRoads : MKOverlayLevelAboveLabels];
}

@end
