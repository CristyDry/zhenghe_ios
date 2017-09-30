//
//  WcrDoctor.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/10.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrDoctor.h"

@implementation WcrDoctor

+(NSArray *)createDoctors {
    
    WcrDoctor *doctor = [[WcrDoctor alloc]init];
    
    doctor.imageName = @"医生头像";
    doctor.name = @"奥巴牛";
    doctor.office = @"妇科";
    doctor.skill = @"腰腿痛，颈肩通，颈椎畸形，腰椎滑落";
    doctor.doctorType = @"主任医师";
    doctor.hospital = @"中山小学第一附属医院";
    doctor.profession = @"中山小学第一附属医院中山小学第一附属医院中山小学第一附属医院中山小学第一附属医院中山小学第一附属医院中山小学第一附属医院中山小学第一附属医院中山小学第一附属医院中山小学第一附属医院中山小学第一附属医院中山小学第一附属医院中山小学第一附属医院中山小学第一附属医院中山小学第一附属医院中山小学第一附属医院中山小学第一附属医院中山小学第一附属医院中山小学第一附属医院中山小学第一附属医院";
    doctor.brief = @"本人叶良辰，我弟赵日天";
    return @[doctor,doctor,doctor,doctor,doctor];
    
}

@end
