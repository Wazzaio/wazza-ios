//
//  SecurityService.h
//  Sdk
//
//  Created by Joao Vasques on 26/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityService : NSObject

- (NSData *)AES256EncryptWithKey:(NSString *)key :(NSString *)content;

- (NSData *)AES256DecryptWithKey:(NSString *)key :(NSString *)content;

- (NSString *)hashContent:(NSString *)input;

@end
