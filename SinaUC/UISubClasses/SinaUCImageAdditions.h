//
//  SinaUCImageAdditions.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-27.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

typedef enum {
    SinaUCButtonActive = 0,
    SinaUCButtonPressed,
    SinaUCButtonUnknown,
    SinaUCButtonDisabled,
    SinaUCButtonHovered
} SinaUCCloseButtonState;

typedef enum {
	SinaUCUnknownFileType = -9999,
	SinaUCTIFFFileType = NSTIFFFileType,
    SinaUCBMPFileType = NSBMPFileType,
    SinaUCGIFFileType = NSGIFFileType,
    SinaUCJPEGFileType = NSJPEGFileType,
    SinaUCPNGFileType = NSPNGFileType,
    SinaUCJPEG2000FileType = NSJPEG2000FileType
} SinaUCBitmapImageFileType;


@interface NSImage (SinaUCImageAdditions)

+ (NSImage *)imageNamed:(NSString *)name forClass:(Class)inClass;
+ (NSImage *)imageNamed:(NSString *)name forClass:(Class)inClass loadLazily:(BOOL)flag;

+ (NSImage *)imageForSSL;

+ (SinaUCBitmapImageFileType)fileTypeOfData:(NSData *)inData;
+ (NSString *)extensionForBitmapImageFileType:(SinaUCBitmapImageFileType)inFileType;

- (NSData *)JPEGRepresentation;
- (NSData *)JPEGRepresentationWithCompressionFactor:(float)compressionFactor;
/*!
 * @brief Obtain a JPEG representation which is sufficiently compressed to have a size <= a given size in bytes
 *
 * The image will be increasingly compressed until it fits within maxByteSize. The dimensions of the image are unchanged,
 * so for best quality results, the image should be sized (via -[NSImage(AIImageDrawingAdditions) imageByScalingToSize:])
 * before calling this method.
 *
 * @param maxByteSize The maximum size in bytes
 *
 * @result An NSData JPEG representation whose length is <= maxByteSize, or nil if one could not be made.
 */
- (NSData *)JPEGRepresentationWithMaximumByteSize:(NSUInteger)maxByteSize;
- (NSData *)PNGRepresentation;
- (NSData *)GIFRepresentation;
- (NSData *)BMPRepresentation;
- (NSData *)bestRepresentationByType;
- (NSBitmapImageRep *)largestBitmapImageRep;
- (NSData *)representationWithFileType:(NSBitmapImageFileType)fileType
					   maximumFileSize:(NSUInteger)maximumSize;

/*
 * Writes Application Extension Block and modifies Graphic Control Block for a GIF image
 */
- (void)writeGIFExtensionBlocksInData:(NSMutableData *)data forRepresenation:(NSBitmapImageRep *)bitmap;

/*
 * Properties for a GIF image
 */
- (NSDictionary *)GIFPropertiesForRepresentation:(NSBitmapImageRep *)bitmap;

@end

//Defined in AppKit.framework
@interface NSImageCell(NSPrivateAnimationSupport)
- (BOOL)_animates;
- (void)_setAnimates:(BOOL)fp8;
- (void)_startAnimation;
- (void)_stopAnimation;
- (void)_animationTimerCallback:fp8;
@end

