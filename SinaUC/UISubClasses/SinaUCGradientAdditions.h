//
//  SinaUCGradientAdditions.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-27.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCColorAdditions.h"

@interface NSGradient (SinaUCGradientAdditions)

/*!
 * @brief Create a gradient for a selected control
 *
 * Use the system selectedControl color to create a gradient. This gradient is appropriate
 * for a Tiger-style selected highlight.
 *
 * @return An autoreleased \c NSGradient for a selected control
 */
+ (NSGradient*)selectedControlGradient;

@end
