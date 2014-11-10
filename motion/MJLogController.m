//
//  MJLogController.m
//  motion
//
//  Created by Dan Park on 11/3/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJPedoMeter.h"
#import "MJActivityTypeMeter.h"
#import "CMMotionActivity+MJMotionActivity.h"
#import "CMPedometerData+MJPedometerData.h"
#import "MJLogController.h"

@interface MJLogController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) MJPedoMeter *pedometerManager;
@property (nonatomic, strong) MJActivityTypeMeter *typeManager;
@end

@implementation MJLogController {
    __weak IBOutlet UITableView *tableView;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    NSLog(@"%s", __func__);
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([MJPedoMeter checkPedometerAvailableUI]) {
        [self setPedometerManager:[MJPedoMeter sharedInstance]];
        [_pedometerManager checkAuthorizationUI];
        [_pedometerManager startPedometerUpdates];
    }
    
    if ([MJActivityTypeMeter checkActivityTypeAvailableUI]) {
        [self setTypeManager:[MJActivityTypeMeter sharedInstance]];
        [_typeManager checkAuthorizationUI];
        [_typeManager startActivityUpdatesToQueue];
        [self registerObserverKVO];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"%s", __func__);
    [super viewDidDisappear:animated];
    
    [self unregisterObserverKVO];
}

#pragma mark - KVO

- (void)unregisterObserverKVO {
    NSLog(@"%s", __func__);
    
    [_typeManager unregisterObserverKVO:self];
    [_pedometerManager unregisterObserverKVO:self];
}

- (void)registerObserverKVO {
    NSLog(@"%s", __func__);
    
    [_typeManager registerObserverKVO:self];
    [_pedometerManager registerObserverKVO:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    NSLog(@"%s: keyPath:%@, change:%@", __func__, keyPath, change);

    if ([keyPath isEqualToString:@"records"] )
        [tableView reloadData];
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Pedometer";
        case 1:
            return @"Activity Type";
    }
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = 0;
    
    if (section == 0) {
        count = [_pedometerManager.records count];
        count = (count > 3) ? 3 : count;
    } else if (section == 1) {
        count = [_typeManager.records count];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [atableView dequeueReusableCellWithIdentifier:@"SubtitleCellID" forIndexPath:indexPath];
//    UITableViewCell *cell = [atableView dequeueReusableCellWithIdentifier:@"RightDetailCellID" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        CMPedometerData *pedometerData = _pedometerManager.records[indexPath.row];
//        cell.textLabel.text = [pedometerData timestampString];
//        cell.detailTextLabel.text = [pedometerData description];
        
        cell.textLabel.text = [pedometerData description];
        cell.detailTextLabel.text = [pedometerData timestampString];
    }
    else if (indexPath.section == 1) {
        CMMotionActivity *activity = _typeManager.records[indexPath.row];
//        cell.textLabel.text = [activity timestampString];
//        cell.detailTextLabel.text = [activity description];
        
        cell.textLabel.text = [activity description];
        cell.detailTextLabel.text = [activity timestampString];
    }
    return cell;
}

@end
