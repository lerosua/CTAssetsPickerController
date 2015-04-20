/*
 CTAssetsPageViewController.m
 
 The MIT License (MIT)
 
 Copyright (c) 2013 Clement CN Tsang
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "CTAssetsPageViewController.h"
#import "CTAssetItemViewController.h"
#import "CTAssetScrollView.h"
#import "NSBundle+CTAssetsPickerController.h"
#import "CTAssetsPickerController.h"




@interface CTAssetsPageViewController ()
<UIPageViewControllerDataSource, UIPageViewControllerDelegate, CTAssetItemViewControllerDataSource>

@property (nonatomic, weak) CTAssetsPickerController *picker;
@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, assign, getter = isStatusBarHidden) BOOL statusBarHidden;

@property (nonatomic, strong) UIButton *selectButton;
@end





@implementation CTAssetsPageViewController

- (id)initWithAssets:(NSArray *)assets
{
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                  options:@{UIPageViewControllerOptionInterPageSpacingKey:@30.f}];
    if (self)
    {
        self.assets                 = assets;
        self.dataSource             = self;
        self.delegate               = self;
        self.view.backgroundColor   = [UIColor whiteColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNotificationObserver];
    [self setupNavbar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupToolbar];
    
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setButtonStatus:self.pageIndex];

}

- (void)dealloc
{
    [self removeNotificationObserver];
}

- (BOOL)prefersStatusBarHidden
{
    return self.isStatusBarHidden;
}
#pragma mark -
- (void) setupNavbar {
    self.selectButton= [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectButton.frame = CGRectMake(0, 0, 30, 30);
    [self.selectButton setImage:[UIImage imageNamed:@"CTAssetsPickerUnChecked"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"CTAssetsPickerChecked"] forState:UIControlStateHighlighted];
    [self.selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setupToolbar
{
    self.toolbarItems = self.picker.toolbarItems;
}

- (void) selectAction:(UIButton *)sender {
    
    if(self.pageIndex < self.assets.count){
        ALAsset *asset = [self.assets objectAtIndex:self.pageIndex];
        if([self.picker.selectedAssets containsObject:asset]){
            [self.picker deselectAsset:asset];
            if ([self.picker.delegate respondsToSelector:@selector(assetsPickerController:didDeselectAsset:)]){
                [self.picker.delegate assetsPickerController:self.picker didDeselectAsset:asset];
            }
        }else{
            if ([self.picker.delegate respondsToSelector:@selector(assetsPickerController:shouldSelectAsset:)]){
                if([self.picker.delegate assetsPickerController:self.picker shouldSelectAsset:asset]){
                    [self.picker selectAsset:asset];
                    if ([self.picker.delegate respondsToSelector:@selector(assetsPickerController:didSelectAsset:)]){
                        [self.picker.delegate assetsPickerController:self.picker didSelectAsset:asset];
                    }
                }
            }else{
                [self.picker selectAsset:asset];
                if ([self.picker.delegate respondsToSelector:@selector(assetsPickerController:didSelectAsset:)]){
                    [self.picker.delegate assetsPickerController:self.picker didSelectAsset:asset];
                }
            }
        }
        [self setButtonStatus:self.pageIndex];
    }
}

#pragma mark - Update Title

- (void)setTitleIndex:(NSInteger)index
{
    NSInteger count = self.assets.count;
    self.title      = [NSString stringWithFormat:CTAssetsPickerControllerLocalizedString(@"%ld of %ld"), index, count];
}

#pragma mark - Update Button
- (void) setButtonStatus:(NSInteger)index
{
    if (index < self.assets.count) {
        ALAsset *asset = [self.assets objectAtIndex:index];
        if([self.picker.selectedAssets containsObject:asset]){
            [self.selectButton setImage:[UIImage imageNamed:@"CTAssetsPickerChecked"] forState:UIControlStateNormal];
        }else{
            [self.selectButton setImage:[UIImage imageNamed:@"CTAssetsPickerUnChecked"] forState:UIControlStateNormal];
        }
    }

}


#pragma mark - Page Index

- (NSInteger)pageIndex
{
    return ((CTAssetItemViewController *)self.viewControllers[0]).pageIndex;
}

- (void)setPageIndex:(NSInteger)pageIndex
{
    NSInteger count = self.assets.count;
    
    if (pageIndex >= 0 && pageIndex < count)
    {
        CTAssetItemViewController *page = [CTAssetItemViewController assetItemViewControllerForPageIndex:pageIndex];
        page.dataSource = self;
        
        [self setViewControllers:@[page]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:NULL];
        
        [self setTitleIndex:pageIndex + 1];
    }
}


#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = ((CTAssetItemViewController *)viewController).pageIndex;
    
    if (index > 0)
    {
        CTAssetItemViewController *page = [CTAssetItemViewController assetItemViewControllerForPageIndex:(index - 1)];
        page.dataSource = self;
        
        return page;
    }
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger count = self.assets.count;
    NSInteger index = ((CTAssetItemViewController *)viewController).pageIndex;
    
    if (index < count - 1)
    {
        CTAssetItemViewController *page = [CTAssetItemViewController assetItemViewControllerForPageIndex:(index + 1)];
        page.dataSource = self;
        
        return page;
    }
    
    return nil;
}


#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed)
    {
        CTAssetItemViewController *vc   = (CTAssetItemViewController *)pageViewController.viewControllers[0];
        NSInteger index                 = vc.pageIndex + 1;
        
        [self setTitleIndex:index];
        [self setButtonStatus:index-1];
    }
}


#pragma mark - Notification Observer

- (void)addNotificationObserver
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self
               selector:@selector(scrollViewTapped:)
                   name:CTAssetScrollViewTappedNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(selectedAssetsChanged:)
                   name:CTAssetsPickerSelectedAssetsChangedNotification
                 object:nil];
}

- (void)removeNotificationObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CTAssetScrollViewTappedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CTAssetsPickerSelectedAssetsChangedNotification object:nil];

}


#pragma mark - Tap Gesture

- (void)scrollViewTapped:(NSNotification *)notification
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)notification.object;
    
    if (gesture.numberOfTapsRequired == 1)
        [self toogleNavigationBar:gesture];
}

#pragma mark -
- (void)selectedAssetsChanged:(NSNotification *)notification
{
    NSArray *selectedAssets = (NSArray *)notification.object;
    [[self.toolbarItems objectAtIndex:1] setTitle:[NSString stringWithFormat:@"%ld",(long)selectedAssets.count]];
    
}

#pragma mark - Fade in / away navigation bar

- (void)toogleNavigationBar:(id)sender
{
	if (self.isStatusBarHidden)
		[self fadeNavigationBarIn];
    else
		[self fadeNavigationBarAway];
}

- (void)fadeNavigationBarAway
{
    self.statusBarHidden = YES;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self setNeedsStatusBarAppearanceUpdate];
                         [self.navigationController.navigationBar setAlpha:0.0f];
                         [self.navigationController setNavigationBarHidden:YES];
                         self.view.backgroundColor = [UIColor blackColor];
                         
                         [self.navigationController.toolbar setAlpha:0.0f];
                         [self.navigationController setToolbarHidden:YES];
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)fadeNavigationBarIn
{
    self.statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self setNeedsStatusBarAppearanceUpdate];
                         [self.navigationController.navigationBar setAlpha:1.0f];
                         self.view.backgroundColor = [UIColor whiteColor];
                         
                         
                         [self.navigationController.toolbar setAlpha:1.0f];
                         [self.navigationController setToolbarHidden:NO];
                     }];
}



#pragma mark - CTAssetItemViewControllerDataSource

- (ALAsset *)assetAtIndex:(NSUInteger)index;
{
    return [self.assets objectAtIndex:index];
}
#pragma mark - Accessors
- (CTAssetsPickerController *)picker
{
    return (CTAssetsPickerController *)self.navigationController.parentViewController;
}
@end
