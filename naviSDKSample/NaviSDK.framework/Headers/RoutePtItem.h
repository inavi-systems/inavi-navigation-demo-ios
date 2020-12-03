//
//  RoutePtItem.h
//  NaviSDK
//
//  Created by DAECHEOL KIM on 2020/03/31.
//  Copyright © 2020 iNaviSys. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoutePtItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic) double dpLat;
@property (nonatomic) double dpLon;
@property (nonatomic) double rpLat;
@property (nonatomic) double rpLon;
@end

NS_ASSUME_NONNULL_END
