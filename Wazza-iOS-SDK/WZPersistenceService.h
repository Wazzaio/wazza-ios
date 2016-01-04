/*
 * wazza-ios
 * https://github.com/Wazzaio/wazza-ios
 * Copyright (C) 2013-2015  Duarte Barbosa, João Vazão Vasques
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


#import <Foundation/Foundation.h>
#import "WZSessionInfo.h"

#define SESSION_INFO @"session_info"
#define PURCHASE_INFO @"purchase_info"

@interface WZPersistenceService : NSObject


-(id)initPersistence;

-(void)storeContent:(id)content :(NSString *)key;

-(NSMutableArray *)getArrayContent:(NSString *)arrayKey;

-(void)addContentToArray:(id)content :(NSString *)arrayKey;

-(id)getContent:(NSString *)key;

-(BOOL)contentExists:(NSString *)key;

-(void)clearContent:(NSString *)key;

@end
