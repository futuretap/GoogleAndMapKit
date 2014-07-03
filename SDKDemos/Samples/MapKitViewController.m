//
//  MapKitViewController.m
//  SDKDemos
//
//  Created by Ortwin Gentz on 14.03.14.
//
//

#import "MapKitViewController.h"
#import <MapKit/MapKit.h>

@interface MapKitViewController () <MKMapViewDelegate>

@end

@implementation MapKitViewController {
  MKMapView *mapView_;
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
  
  mapView_ = [[MKMapView alloc] initWithFrame:self.view.bounds];
  mapView_.translatesAutoresizingMaskIntoConstraints = NO;
  mapView_.delegate = self;
  mapView_.region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(48.1, 11.5), 50000, 50000);
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
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"fullsize" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleFullSize:)];

  MKPointAnnotation *poi = [[MKPointAnnotation alloc] init];
  poi.title = @"MapKit";
  poi.subtitle = @"is integrated in Apple's iOS";
  poi.coordinate = mapView_.region.center;
  [mapView_ addAnnotation:poi];
  
  [mapView_ setValue:[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(44, 0, 44, 0)] forKeyPath:@"edgeInsets"];
  
  [mapView_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)]];
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
	if ([annotation isMemberOfClass:[MKUserLocation class]]) {
		return nil;
	}
	MKAnnotationView *mkav = [mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
	if (!mkav) {
		mkav = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
	}
	mkav.canShowCallout = YES;
	mkav.draggable = YES;
	mkav.annotation = annotation;
  
  mkav.leftCalloutAccessoryView = ({
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.backgroundColor = [UIColor colorWithRed:0.247 green:0.573 blue:0.994 alpha:1.000];
    button.tintColor = [UIColor whiteColor];
		[button sizeToFit];
		button.contentEdgeInsets = UIEdgeInsetsMake(4, 0, 24, 0);
		CGRect frame = button.frame;
		frame.size = CGSizeMake(44, 64);
		button.frame = frame;
    button;
  });
  
  mkav.rightCalloutAccessoryView = ({
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    button.backgroundColor = [UIColor colorWithRed:0.247 green:0.573 blue:0.994 alpha:1.000];
    button.tintColor = [UIColor whiteColor];
		[button sizeToFit];
		button.contentEdgeInsets = UIEdgeInsetsMake(4, 0, 24, 0);
		CGRect frame = button.frame;
		frame.size = CGSizeMake(44, 64);
		button.frame = frame;
    button;
  });
  
	return mkav;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
}

- (void)toggleFullSize:(id)sender {
  fullSize = !fullSize;
  
  [UIView animateWithDuration:0.35 animations:^{
    upperToolbarConstraint.constant = fullSize ? -44 : 0;
    lowerToolbarConstraint.constant = fullSize ? 44 : 0;

    CGFloat inset = fullSize ? 0 : 44;
    [mapView_ setValue:[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(inset, 0, inset, 0)] forKeyPath:@"edgeInsets"];

    [self.view layoutIfNeeded];
  }];
}

- (IBAction)singleTap:(id)sender {
  [self performSelector:@selector(toggleFullSize:) withObject:nil afterDelay:0.5];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(toggleFullSize:) object:nil];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(toggleFullSize:) object:nil];
}



@end
