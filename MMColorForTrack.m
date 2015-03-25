//
//  MMColorForTrack.m
//
//  Created by Michalis Mavris on 25/03/15.
//  Copyright (c) 2015 Miksoft. All rights reserved.
//

#import "MMColorForTrack.h"

@implementation MMColorForTrack

+(UIImage*)getTrackImageWithColorR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b A:(NSInteger)a{


UIImage *newUIImage;

        
        int width = 3;
        int height = 2;
        
        char* rgba = (char*)malloc(width*height*4);
        int offset=0;
        for(int i=0; i < height; ++i)
        {
            for (int j=0; j < width; j++)
            {
                rgba[4*offset]   = r;
                rgba[4*offset+1] = g;
                rgba[4*offset+2] = b;
                rgba[4*offset+3] = a;
                offset ++;
            }
        }
        
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef bitmapContext = CGBitmapContextCreate(
                                                           rgba,
                                                           width,
                                                           height,
                                                           8, // bitsPerComponent
                                                           4*width, // bytesPerRow
                                                           colorSpace,
                                                           kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Big);
        
        CFRelease(colorSpace);
        
        CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
        
        free(rgba);
        
        newUIImage = [UIImage imageWithCGImage:cgImage];

    
    return newUIImage;
    
    
};
@end
