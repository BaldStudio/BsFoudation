//
//  MachOTestsOC.h
//  BsFoundationTests
//
//  Created by crzorz on 2022/10/17.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct MachOTestData {
    char *name;
} MachOTestData;

#define MACH_O_TEST_SEG     "__TEST"
#define MACH_O_TEST_SECT    "__test"

// Test Data
__attribute((used, section(MACH_O_TEST_SEG "," MACH_O_TEST_SECT)))
static const MachOTestData mach_o_test_data = {
    .name = "test",
};

@interface MachOTestsOC : NSObject

@end

NS_ASSUME_NONNULL_END
