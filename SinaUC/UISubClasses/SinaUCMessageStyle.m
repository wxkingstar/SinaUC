//
//  SinaUCMessageStyle.m
//  SinaUC
//
//  Created by css on 13-5-10.
//  Copyright (c) 2013年 陈 硕实. All rights reserved.
//

#import "SinaUCMessageStyle.h"
#import "SinaUCMessage.h"
#import "SinaUCStringAdditions.h"
#import "SinaUCMutableStringAdditions.h"

@interface NSBundle (StupidCompatibilityHack)
- (NSString *)semiCaseInsensitivePathForResource:(NSString *)res ofType:(NSString *)type;
- (NSString *)semiCaseInsensitivePathForResource:(NSString *)res ofType:(NSString *)type inDirectory:(NSString *)dirpath;
@end

@implementation NSBundle (StupidCompatibilityHack)
- (NSString *)semiCaseInsensitivePathForResource:(NSString *)res ofType:(NSString *)type
{
	NSString *path = [self pathForResource:res ofType:type];
	if(!path)
		path = [self pathForResource:[res lowercaseString] ofType:type];
    NSLog(@"%@", path);
	return path;
}

- (NSString *)semiCaseInsensitivePathForResource:(NSString *)res ofType:(NSString *)type inDirectory:(NSString *)dirpath
{
	NSString *path = [self pathForResource:res ofType:type inDirectory:dirpath];
	if(!path)
		path = [self pathForResource:[res lowercaseString] ofType:type inDirectory:dirpath];
	return path;
}

@end

@interface NSMutableString (AIKeywordReplacementAdditions)
- (void) replaceKeyword:(NSString *)word withString:(NSString *)newWord;
- (void) safeReplaceCharactersInRange:(NSRange)range withString:(NSString *)newWord;
@end

@implementation NSMutableString (AIKeywordReplacementAdditions)
- (void) replaceKeyword:(NSString *)keyWord withString:(NSString *)newWord
{
	if(!keyWord) return;
	if(!newWord) newWord = @"";
	[self replaceOccurrencesOfString:keyWord
						  withString:newWord
							 options:NSLiteralSearch
							   range:NSMakeRange(0.0f, [self length])];
}

- (void) safeReplaceCharactersInRange:(NSRange)range withString:(NSString *)newWord
{
	if (range.location == NSNotFound || range.length == 0) return;
	if (!newWord) [self deleteCharactersInRange:range];
	else [self replaceCharactersInRange:range withString:newWord];
}
@end

@implementation SinaUCMessageStyle

- (id)init
{
	if ((self = [super init]))  {
        stylePath = @"$$BundlePath$$/Contents/Resources/message style/Renkoo.AdiumMessageStyle";
        styleBundle = [NSBundle bundleWithPath:[stylePath stringByExpandingBundlePath]];	}
	return self;
}

#pragma mark Keyword replacement

- (NSMutableString *)fillKeywords:(NSMutableString *)inString forContent:(SinaUCMessage *)content {
	NSDate			*date = nil;
	NSRange			range;
    
	/*
     htmlEncodedMessage is only encoded correctly for AIContentMessages
     but we do it up here so that we can check for RTL/LTR text below without
     having to encode the message twice. This is less than ideal
	 */
	/*NSString		*htmlEncodedMessage = [AIHTMLDecoder encodeHTML:[content message]
                                                      headers:NO
                                                     fontTags:showIncomingFonts
                                           includingColorTags:(allowsColors && showIncomingColors)
                                                closeFontTags:YES
                                                    styleTags:YES
                                   closeStyleTagsOnFontChange:YES
                                               encodeNonASCII:YES
                                                 encodeSpaces:YES
                                                   imagesPath:NSTemporaryDirectory()
                                            attachmentsAsText:NO
                                    onlyIncludeOutgoingImages:NO
                                               simpleTagsOnly:NO
                                               bodyBackground:NO
                                          allowJavascriptURLs:NO];*/
    NSString *htmlEncodedMessage = [content message];
	//date
	/*if ([content respondsToSelector:@selector(date)])
		date = [(AIContentMessage *)content date];
	
	//Replacements applicable to any AIContentObject
	[inString replaceKeyword:@"%time%"
				  withString:(date ? [timeStampFormatter stringFromDate:date] : @"")];
    
	__block NSString *shortTimeString;
	[NSDateFormatter withLocalizedDateFormatterShowingSeconds:NO showingAMorPM:NO perform:^(NSDateFormatter *dateFormatter){
		shortTimeString = (date ? [dateFormatter stringFromDate:date] : @"");
	}];
	
	[inString replaceKeyword:@"%shortTime%"
				  withString:shortTimeString];
    
	if ([inString rangeOfString:@"%senderStatusIcon%"].location != NSNotFound) {
		//Only cache the status icon to disk if the message style will actually use it
		[inString replaceKeyword:@"%senderStatusIcon%"
					  withString:[self statusIconPathForListObject:theSource]];
	}*/
	
	//Replaces %localized{x}% with a a localized version of x, searching the style's localizations, and then Adium's localizations
	do{
		range = [inString rangeOfString:@"%localized{"];
		if (range.location != NSNotFound) {
			NSRange endRange;
			endRange = [inString rangeOfString:@"}%" options:NSLiteralSearch range:NSMakeRange(NSMaxRange(range), [inString length] - NSMaxRange(range))];
			if (endRange.location != NSNotFound && endRange.location > NSMaxRange(range)) {
				NSString *untranslated = [inString substringWithRange:NSMakeRange(NSMaxRange(range), (endRange.location - NSMaxRange(range)))];
				
				NSString *translated = [styleBundle localizedStringForKey:untranslated
																	value:untranslated
																	table:nil];
				if (!translated || [translated length] == 0) {
					translated = [[NSBundle bundleForClass:[self class]] localizedStringForKey:untranslated
																						 value:untranslated
																						 table:nil];
					if (!translated || [translated length] == 0) {
						translated = [[NSBundle mainBundle] localizedStringForKey:untranslated
																			value:untranslated
																			table:nil];
					}
				}
				
				
				[inString safeReplaceCharactersInRange:NSUnionRange(range, endRange)
											withString:translated];
			}
		}
	} while (range.location != NSNotFound);
    
	[inString replaceKeyword:@"%userIcons%" withString:@"showIcons"];
    
	[inString replaceKeyword:@"%messageClasses%"
				  withString:([content outgoing] == 0 ? @"incoming" : @"outgoing")];
	
	/*[inString replaceKeyword:@"%senderColor%"
				  withString:[NSColor representedColorForObject:contentSource.UID withValidColors:self.validSenderColors]];*/
	
	//HAX. The odd conditional here detects the rtl html that our html parser spits out.
	BOOL isRTL = ([htmlEncodedMessage rangeOfString:@"<div dir=\"rtl\">"
                                            options:(NSCaseInsensitiveSearch | NSLiteralSearch)].location != NSNotFound);
	[inString replaceKeyword:@"%messageDirection%"
				  withString:(isRTL ? @"rtl" : @"ltr")];
	
	//Replaces %time{x}% with a timestamp formatted like x (using NSDateFormatter)
	do{
		range = [inString rangeOfString:@"%time{"];
		if (range.location != NSNotFound) {
			NSRange endRange;
			endRange = [inString rangeOfString:@"}%" options:NSLiteralSearch range:NSMakeRange(NSMaxRange(range), [inString length] - NSMaxRange(range))];
			if (endRange.location != NSNotFound && endRange.location > NSMaxRange(range)) {
				if (date) {
					/*if (!timeFormatterCache) {
						timeFormatterCache = [[NSMutableDictionary alloc] init];
						[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(flushTimeFormatterCache:) name:@"AppleDatePreferencesChangedNotification" object:nil];
						[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(flushTimeFormatterCache:) name:@"AppleTimePreferencesChangedNotification" object:nil];
					}
					NSString *timeFormat = [inString substringWithRange:NSMakeRange(NSMaxRange(range), (endRange.location - NSMaxRange(range)))];
					
					NSDateFormatter *dateFormatter = [timeFormatterCache objectForKey:timeFormat];
					if (!dateFormatter) {
						if ([timeFormat rangeOfString:@"%"].location != NSNotFound) {
							// Support strftime-style format strings, which old message styles may use
							dateFormatter = [[NSDateFormatter alloc] initWithDateFormat:timeFormat allowNaturalLanguage:NO];
						} else {
							dateFormatter = [[NSDateFormatter alloc] init];
							[dateFormatter setDateFormat:timeFormat];
						}
						[timeFormatterCache setObject:dateFormatter forKey:timeFormat];
					}
					
					[inString safeReplaceCharactersInRange:NSUnionRange(range, endRange)
												withString:[dateFormatter stringFromDate:date]];*/
					
				} else
					[inString deleteCharactersInRange:NSUnionRange(range, endRange)];
				
			}
		}
	} while (range.location != NSNotFound);
	
	/*do{
		range = [inString rangeOfString:@"%userIconPath%"];
		if (range.location != NSNotFound) {
			NSString    *userIconPath;
			NSString	*replacementString;
			
			userIconPath = [theSource valueForProperty:KEY_WEBKIT_USER_ICON];
			if (!userIconPath) {
				userIconPath = [theSource valueForProperty:@"UserIconPath"];
			}
			
			if (showUserIcons && userIconPath) {
				replacementString = [NSString stringWithFormat:@"file://%@", userIconPath];
				
			} else {
				replacementString = ([content isOutgoing]
									 ? @"Outgoing/buddy_icon.png"
									 : @"Incoming/buddy_icon.png");
			}
			
			[inString safeReplaceCharactersInRange:range withString:replacementString];
		}
	} while (range.location != NSNotFound);*/
	
	/*[inString replaceKeyword:@"%service%"
				  withString:[content.chat.account.service shortDescription]];
	
	[inString replaceKeyword:@"%serviceIconPath%"
				  withString:[AIServiceIcons pathForServiceIconForServiceID:content.chat.account.service.serviceID
																	   type:AIServiceIconLarge]];
    
	if ([inString rangeOfString:@"%variant%"].location != NSNotFound) {
		//Per #12702, don't allow spaces in the variant name, as otherwise it becomes multiple css classes 
		[inString replaceKeyword:@"%variant%"
					  withString:[self.activeVariant stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
	}
    
	//message stuff
		
    //Use [content source] directly rather than the potentially-metaContact theSource
    NSString *formattedUID = nil;
    if ([content.chat aliasForContact:contentSource]) {
        formattedUID = [content.chat aliasForContact:contentSource];
    } else {
        formattedUID = contentSource.formattedUID;
    }
        
    NSString *displayName = [content.chat displayNameForContact:contentSource];
    
    [inString replaceKeyword:@"%status%"
                  withString:@""];
    
    [inString replaceKeyword:@"%senderScreenName%"
                  withString:[(formattedUID ?
                               formattedUID :
                               displayName) stringByEscapingForXMLWithEntities:nil]];
    
    
    [inString replaceKeyword:@"%senderPrefix%"
                  withString:((AIContentMessage *)content).senderPrefix];
    
    do{
        range = [inString rangeOfString:@"%sender%"];
        if (range.location != NSNotFound) {
            NSString		*senderDisplay = nil;
            if (useCustomNameFormat) {
                if (formattedUID && ![displayName isEqualToString:formattedUID]) {
                    switch (nameFormat) {
                        case AIDefaultName:
                            break;
                            
                        case AIDisplayName:
                            senderDisplay = displayName;
                            break;
                            
                        case AIDisplayName_ScreenName:
                            senderDisplay = [NSString stringWithFormat:@"%@ (%@)",displayName,formattedUID];
                            break;
                            
                        case AIScreenName_DisplayName:
                            senderDisplay = [NSString stringWithFormat:@"%@ (%@)",formattedUID,displayName];
                            break;
                            
                        case AIScreenName:
                            senderDisplay = formattedUID;
                            break;
                    }
                }
                
                //Test both displayName and formattedUID for nil-ness. If they're both nil, the assertion will trip.
                if (!senderDisplay) {
                    senderDisplay = displayName;
                    if (!senderDisplay) {
                        senderDisplay = formattedUID;
                        if (!senderDisplay) {
                            AILog(@"XXX we don't have a sender for %@ (%@)", content, [content message]);
                            NSLog(@"Enormous error: we don't have a sender for %@ (%@)", content, [content message]);
                            
                            // This shouldn't happen.
                            senderDisplay = @"(unknown)";
                        }
                    }
                }
            } else {
                senderDisplay = displayName;
            }
            
            if ([(AIContentMessage *)content isAutoreply]) {
                senderDisplay = [NSString stringWithFormat:@"%@ %@",senderDisplay,AILocalizedString(@"(Autoreply)","Short word inserted after the sender's name when displaying a message which was an autoresponse")];
            }
            
            [inString safeReplaceCharactersInRange:range withString:[senderDisplay stringByEscapingForXMLWithEntities:nil]];
        }
    } while (range.location != NSNotFound);
    
    do {
        range = [inString rangeOfString:@"%senderDisplayName%"];
        if (range.location != NSNotFound) {
            NSString *serversideDisplayName = ([theSource isKindOfClass:[AIListContact class]] ?
                                               [(AIListContact *)theSource serversideDisplayName] :
                                               nil);
            if (!serversideDisplayName) {
                serversideDisplayName = theSource.displayName;
            }
            
            [inString safeReplaceCharactersInRange:range
                                        withString:[serversideDisplayName stringByEscapingForXMLWithEntities:nil]];
        }
    } while (range.location != NSNotFound);
    
    //Blatantly stealing the date code for the background color script.
    do{
        range = [inString rangeOfString:@"%textbackgroundcolor{"];
        if (range.location != NSNotFound) {
            NSRange endRange;
            endRange = [inString rangeOfString:@"}%" options:NSLiteralSearch range:NSMakeRange(NSMaxRange(range), [inString length] - NSMaxRange(range))];
            if (endRange.location != NSNotFound && endRange.location > NSMaxRange(range)) {
                NSString *transparency = [inString substringWithRange:NSMakeRange(NSMaxRange(range),
                                                                                  (endRange.location - NSMaxRange(range)))];
                
                if (allowTextBackgrounds && showIncomingColors) {
                    NSString *thisIsATemporaryString;
                    unsigned rgb = 0, red, green, blue;
                    NSScanner *hexcode;
                    thisIsATemporaryString = [AIHTMLDecoder encodeHTML:[content message] headers:NO
                                                              fontTags:NO
                                                    includingColorTags:NO
                                                         closeFontTags:NO
                                                             styleTags:NO
                                            closeStyleTagsOnFontChange:NO
                                                        encodeNonASCII:NO
                                                          encodeSpaces:NO
                                                            imagesPath:NSTemporaryDirectory()
                                                     attachmentsAsText:NO
                                             onlyIncludeOutgoingImages:NO
                                                        simpleTagsOnly:NO
                                                        bodyBackground:YES
                                                   allowJavascriptURLs:NO];
                    hexcode = [NSScanner scannerWithString:thisIsATemporaryString];
                    [hexcode scanHexInt:&rgb];
                    if (![thisIsATemporaryString length] && rgb == 0) {
                        [inString deleteCharactersInRange:NSUnionRange(range, endRange)];
                    } else {
                        red = (rgb & 0xff0000) >> 16;
                        green = (rgb & 0x00ff00) >> 8;
                        blue = rgb & 0x0000ff;
                        [inString safeReplaceCharactersInRange:NSUnionRange(range, endRange)
                                                    withString:[NSString stringWithFormat:@"rgba(%d, %d, %d, %@)", red, green, blue, transparency]];
                    }
                } else {
                    [inString deleteCharactersInRange:NSUnionRange(range, endRange)];
                }
            } else if (endRange.location == NSMaxRange(range)) {
                if (allowTextBackgrounds && showIncomingColors) {
                    NSString *thisIsATemporaryString;
                    
                    thisIsATemporaryString = [AIHTMLDecoder encodeHTML:[content message] headers:NO
                                                              fontTags:NO
                                                    includingColorTags:NO
                                                         closeFontTags:NO
                                                             styleTags:NO
                                            closeStyleTagsOnFontChange:NO
                                                        encodeNonASCII:NO
                                                          encodeSpaces:NO
                                                            imagesPath:NSTemporaryDirectory()
                                                     attachmentsAsText:NO
                                             onlyIncludeOutgoingImages:NO
                                                        simpleTagsOnly:NO
                                                        bodyBackground:YES
                                                   allowJavascriptURLs:NO];
                    [inString safeReplaceCharactersInRange:NSUnionRange(range, endRange)
                                                withString:[NSString stringWithFormat:@"#%@", thisIsATemporaryString]];
                } else {
                    [inString deleteCharactersInRange:NSUnionRange(range, endRange)];
                }
            }
        }
    } while (range.location != NSNotFound);
    
    if ([content isKindOfClass:[ESFileTransfer class]]) { //file transfers are an AIContentMessage subclass
        
        ESFileTransfer *transfer = (ESFileTransfer *)content;
        NSString *fileName = [[transfer remoteFilename] stringByEscapingForXMLWithEntities:nil];
        NSString *fileTransferID = [[transfer uniqueID] stringByEscapingForXMLWithEntities:nil];
        
        range = [inString rangeOfString:@"%fileIconPath%"];
        if (range.location != NSNotFound) {
            NSString *iconPath = [self iconPathForFileTransfer:transfer];
            NSImage *icon = [transfer iconImage];
            do{
                [[icon TIFFRepresentation] writeToFile:iconPath atomically:YES];
                [inString safeReplaceCharactersInRange:range withString:iconPath];
                range = [inString rangeOfString:@"%fileIconPath%"];
            } while (range.location != NSNotFound);
        }
        
        [inString replaceKeyword:@"%fileName%"
                      withString:fileName];
        
        [inString replaceKeyword:@"%saveFileHandler%"
                      withString:[NSString stringWithFormat:@"client.handleFileTransfer('Save', '%@')", fileTransferID]];
        
        [inString replaceKeyword:@"%saveFileAsHandler%"
                      withString:[NSString stringWithFormat:@"client.handleFileTransfer('SaveAs', '%@')", fileTransferID]];
        
        [inString replaceKeyword:@"%cancelRequestHandler%"
                      withString:[NSString stringWithFormat:@"client.handleFileTransfer('Cancel', '%@')", fileTransferID]];
    }*/
    
    //Message (must do last)
    range = [inString rangeOfString:@"%message%"];
    while(range.location != NSNotFound) {
        [inString safeReplaceCharactersInRange:range withString:htmlEncodedMessage];
        range = [inString rangeOfString:@"%message%"
                                options:NSLiteralSearch
                                  range:NSMakeRange(range.location + htmlEncodedMessage.length,
                                                    inString.length - range.location - htmlEncodedMessage.length)];
    }
    
    // Topic replacement (if applicable)
    /*if ([content isKindOfClass:[AIContentTopic class]]) {
        range = [inString rangeOfString:@"%topic%"];
        
        if (range.location != NSNotFound) {
            [inString safeReplaceCharactersInRange:range withString:[NSString stringWithFormat:TOPIC_INDIVIDUAL_WRAPPER, htmlEncodedMessage]];
        }
    }*/
	return inString;
}

- (NSString*) scriptForAppendingContent:(SinaUCMessage*) content
{
    NSMutableString *template;
    if ([content.outgoing boolValue]) {
        template = [[NSString stringWithContentsOfUTF8File:[styleBundle semiCaseInsensitivePathForResource:@"Content" ofType:@"html" inDirectory:@"Outgoing"]] mutableCopy];
        
    } else {
        template = [[NSString stringWithContentsOfUTF8File:[styleBundle semiCaseInsensitivePathForResource:@"Content" ofType:@"html" inDirectory:@"Incoming"]] mutableCopy];
    }
    template = [self fillKeywords:template forContent:content];
    return [NSString stringWithFormat:@"appendMessage(\"%@\");", [self _escapeStringForPassingToScript:template]];
}

- (NSMutableString *)_escapeStringForPassingToScript:(NSMutableString *)inString
{
	// We need to escape a few things to get our string to the javascript without trouble
	[inString replaceOccurrencesOfString:@"\\"
							  withString:@"\\\\"
								 options:NSLiteralSearch];
	
	[inString replaceOccurrencesOfString:@"\""
							  withString:@"\\\""
								 options:NSLiteralSearch];
    
	[inString replaceOccurrencesOfString:@"\n"
							  withString:@""
								 options:NSLiteralSearch];
    
	[inString replaceOccurrencesOfString:@"\r"
							  withString:@"<br>"
								 options:NSLiteralSearch];
    
	return inString;
}

@end
