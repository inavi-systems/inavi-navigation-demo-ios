//
//  INaviController.h
//  NaviSDK
//
//  Created by DAECHEOL KIM on 2020/03/31.
//  Copyright © 2020 iNaviSys. All rights reserved.
//

#import "INaviFoundation.h"

@class INaviSearchResult;
@class RoutePtItem;

typedef void (^INaviSearchSuccessHandler)(INaviSearchResult * _Nullable result);
typedef void (^INaviSearchFailHandler)(NSInteger errCode, NSString* _Nullable errMsg);

NS_ASSUME_NONNULL_BEGIN

INAVI_EXPORT
@interface INaviController : NSObject
+ (nonnull instancetype)sharedInstance;
-(void)runSearch:(NSString*)query lat:(double)lat lng:(double)lng successHandler:(INaviSearchSuccessHandler)successHandler failHandler:(INaviSearchFailHandler)failHandler;
-(void)runRoute:(RoutePtItem* _Nullable)startItem goalItem:(RoutePtItem*)goalItem;
@end

NS_ASSUME_NONNULL_END
