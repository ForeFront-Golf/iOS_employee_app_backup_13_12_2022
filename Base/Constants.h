//
//  Constants.h
//  GolfEmployee
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#ifndef _Constants_h
#define _Constants_h

////////////////////// General constants //////////////////////
#if TARGET_IPHONE_SIMULATOR
static const bool kIsSimulator = true;
#else
static const bool kIsSimulator = false;
#endif

#define kIsIpad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define kIsIPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

////////////////////// Server Constants //////////////////////
//static NSString *const kServerURL = @"https://api.dev.foreorder.com";
//static NSString *const kServerURL = @"https://api.foreorder.com";
static NSString *const kServerURL = @"http://18.143.85.82:8088/api";
static NSString *const kAWSBucket = @"forefront-userfiles-mobilehub-1269340312";
static NSString *const kAWSURL = @"https://s3.amazonaws.com";

////////////////////// General Constants /////////////////////
static const CGSize kImageSize = {400.0f, 400.0f};
static const CGSize kThumbnailSize = {100.0f, 100.0f};

static const CGFloat kJPEGCompressionQuality = 0.8;
static const NSInteger kLandmarkCount = 77;
static const NSInteger kMapZoomLevel = 17;
static const NSInteger kNavButtonWidth = 100;
static NSString *const kResultsController = @"ResultsController";
static const NSInteger kS3UpdateImageTime =  60 * 5;
static NSString *const kUICollectionViewCell = @"UICollectionViewCell";
static NSString *const kUITableViewCell = @"UITableViewCell";
static const NSInteger kUpdateLocationsInteval = 30;

static NSString *const kMedia = @"media";
static NSString *const kMediaUpdatedAt = @"mediaUpdatedAt";
static NSString *const kThumbnail = @"thumb";
static NSString *const kThumbUpdatedAt = @"thumbUpdatedAt";

////////////////////// App specefic Constants /////////////////////

////////////////////// Notifcations //////////////////////
static NSString *const kFileDownloaded = @"fileDownloaded";
static NSString *const kLoggingInCompleted = @"loggingInCompleted";
static NSString *const kLoggingOut = @"loggingOut";

////////////////////// Server Error Codes //////////////////////
static const NSInteger kInvalidAccountError = 401;
static const NSInteger kDisabledAccountError = 460;

////////////////////// Includes //////////////////////////
//Framework
#import "AmazonAws/AWSMobileClient.h"
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
#import <AWSS3/AWSS3.h>
#import <GoogleMaps/GoogleMaps.h>
#import <OneSignal/OneSignal.h>

//Categories
#import "CALayer+Extend.h"
#import "NSDate+Extend.h"
#import "NSFileManager+Extend.h"
#import "NSIndexPath+Extend.h"
#import "NSManagedObject+Extend.h"
#import "NSNumber+Extend.h"
#import "NSPredicate+Extend.h"
#import "NSString+Extend.h"
#import "PKRevealController+Extend.h"
#import "UIAlertAction+Extend.h"
#import "UIAlertController+Extend.h"
#import "UICollectionView+Extend.h"
#import "UIColor+Extend.h"
#import "UIImage+Extend.h"
#import "UIImagePickerController+Extend.h"
#import "UIImageView+Extend.h"
#import "UINavigationController+Extend.h"
#import "UIScrollView+Extend.h"
#import "UIView+Extend.h"
#import "UIViewController+Extend.h"

// Classes
#import "AppDelegate.h"
#import "CollectionViewResultsController.h"
#import "DDMBlockOperation.h"
#import "DDMDownloadManager.h"
#import "DDMMarker.h"
#import "DDMNavigationController.h"
#import "DDMResultsController.h"
#import "DDMTextField.h"
#import "DDMTimer.h"
#import "ServerClient.h"
#import "TableViewResultsController.h"
#import "Transition.h"
#import "TransitionObjects.h"
#import "TransitionSlide.h"

// External
#import "PKRevealController.h"

// Views
#import "ContainerView.h"
#import "MarkerView.h"
#import "MainView.h"
#import "MenuTypeHeaderView.h"

// Controllers
#import "ClubViewController.h"
#import "DocumentViewController.h"
#import "LaunchViewController.h"
#import "LoginViewController.h"
#import "OrdersViewController.h"
#import "OrderViewController.h"
#import "SettingsViewController.h"

#endif
