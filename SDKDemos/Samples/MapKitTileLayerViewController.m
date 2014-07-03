//
//  MapKitTileLayerViewController.m
//  SDKDemos
//
//  Created by Ortwin Gentz on 17.03.14.
//
//

#import "MapKitTileLayerViewController.h"
#import <MapKit/MapKit.h>
#import "GridTileOverlay.h"

@interface MapKitTileLayerViewController () <MKMapViewDelegate>

@end

@implementation MapKitTileLayerViewController {
  MKMapView *mapView;
  UISegmentedControl *switcher;
  MKTileOverlay *tileOverlay;
  MKTileOverlay *gridOverlay;
  NSInteger tileSource;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
  mapView.delegate = self;
  mapView.showsBuildings = YES;
  mapView.region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(37.78318, -122.403874), 5000, 5000);
  self.view = mapView;
  
  gridOverlay = [[GridTileOverlay alloc] init];
  gridOverlay.canReplaceMapContent=NO;
  

  // The possible floors that might be shown.
  NSArray *types = @[@"Public Transport", @"MapQuest", @"Open Aerial"];
  
  // Create a UISegmentedControl that is the navigationItem's titleView.
  switcher = [[UISegmentedControl alloc] initWithItems:types];
  switcher.selectedSegmentIndex = 0;
  switcher.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  switcher.frame =
  CGRectMake(0, 0, 300, switcher.frame.size.height);
  self.navigationItem.titleView = switcher;
  
  // Listen to touch events on the UISegmentedControl, force initial update.
  [switcher addTarget:self action:@selector(didChangeSwitcher)
      forControlEvents:UIControlEventValueChanged];
  [self didChangeSwitcher];
  
  
  UISwitch *belowBuildingsSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
  belowBuildingsSwitch.onTintColor = self.view.tintColor;
  [belowBuildingsSwitch addTarget:self action:@selector(switchedLayer:) forControlEvents:UIControlEventValueChanged];

  
  UISwitch *gridSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
  gridSwitch.onTintColor = self.view.tintColor;
  [gridSwitch addTarget:self action:@selector(switchGrid:) forControlEvents:UIControlEventValueChanged];
  
  self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:gridSwitch],
                                              [[UIBarButtonItem alloc] initWithCustomView:belowBuildingsSwitch]];
}

-(MKTileOverlayRenderer *)mapView:(MKMapView*)mapView rendererForOverlay:(id<MKOverlay>)overlay {
  return [[MKTileOverlayRenderer alloc] initWithOverlay:overlay];
}

- (void)didChangeSwitcher {
  NSInteger tileSource = switcher.selectedSegmentIndex;
  // Clear existing tileLayer, if any.
  [mapView removeOverlay:tileOverlay];
  
  NSString *url = @[@"http://www.openptmap.org/tiles/{z}/{x}/{y}.png",
                    @"http://a.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    @"http://otile1.mqcdn.com/tiles/1.0.0/sat/{z}/{x}/{y}.jpg"][tileSource];
  
  tileOverlay = [[MKTileOverlay alloc] initWithURLTemplate:url];
  tileOverlay.canReplaceMapContent = !!tileSource;
  [mapView addOverlay:tileOverlay];
  tileSource = tileSource;
}

- (void)switchedLayer:(UISwitch*)sender {
  [mapView removeOverlay:tileOverlay];
  [mapView addOverlay:tileOverlay level:sender.on ? MKOverlayLevelAboveRoads : MKOverlayLevelAboveLabels];
  
}


- (void)switchGrid:(UISwitch*)sender {
  [mapView removeOverlay:gridOverlay];
  
  if (sender.isOn) {
    [mapView addOverlay:gridOverlay level:MKOverlayLevelAboveLabels];
  }
}
@end
