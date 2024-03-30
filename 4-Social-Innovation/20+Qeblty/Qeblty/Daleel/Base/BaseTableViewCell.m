//
//  BaseTableViewCell.m
//  Gamfun
//
//  Created by mac on 2022/7/15.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kClearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initialize];
        [self setupViews];
    }
    return self;
}

+ (CGFloat)rowHeightForObject:(id)object {
    return 0.f;
}

+ (NSString *)cellIdentifier {
    return  NSStringFromClass(self);
}

+ (instancetype)initCellWithTableView:(UITableView *)tableView {
    id cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifier]];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self cellIdentifier]];
    }
    return cell;
}

- (void)updateWithCellData:(id)aData {}

- (void)initialize {}

- (void)setupViews {}

@end
