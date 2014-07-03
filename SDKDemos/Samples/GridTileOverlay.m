//
//  OfflineTileOverlay.m
//  CustomMap
//
//  Created by Carlo Vigiani on 19/Jan/14.
//  Copyright (c) 2014 viggiosoft. All rights reserved.
//

#import "GridTileOverlay.h"

@interface GridTileOverlay ()

@end

@implementation GridTileOverlay


-(void)loadTileAtPath:(MKTileOverlayPath)path result:(void (^)(NSData *, NSError *))result {
  //NSLog(@"Loading tile x/y/z: %ld/%ld/%ld",(long)path.x,(long)path.y,(long)path.z);
  
  CGSize sz = self.tileSize;
  CGRect rect = CGRectMake(0, 0, sz.width, sz.height);
  
  UIGraphicsBeginImageContext(sz);
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  [[UIColor blackColor] setStroke];
  CGContextSetLineWidth(ctx, 1.0);
  CGContextStrokeRect(ctx, CGRectMake(0, 0, sz.width, sz.height));
  NSString *text = [NSString stringWithFormat:@"X=%d\nY=%d\nZ=%d",path.x,path.y,path.z];
  [text drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0],
                                         NSForegroundColorAttributeName:[UIColor blackColor]}];
  UIImage *tileImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  NSData *tileData = UIImagePNGRepresentation(tileImage);
  result(tileData,nil);

}


@end