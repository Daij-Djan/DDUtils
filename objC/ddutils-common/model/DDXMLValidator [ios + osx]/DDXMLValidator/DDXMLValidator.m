//
//  DDXMLValidator.m
//
//  Created by Dominik Pich on 11.09.13.
// based mainly on code by Todd Ditchendorfer
//

#import "DDXMLValidator.h"

#import <libxml/parser.h>
#import <libxml/valid.h>
#import <libxml/xmlschemas.h>
#import <libxml/relaxng.h>

@interface DDXMLValidator ()

- (void)appendErrorString:(NSString *)errorString;

@end

void myGenericErrorFunc(id self, const char *msg, ...);
void myGenericErrorFunc(id self, const char *msg, ...) {
	va_list vargs;
	va_start(vargs, msg);

	NSString *format = [NSString stringWithUTF8String:msg];
	NSMutableString *str = [[NSMutableString alloc] initWithFormat:format arguments:vargs];

	[self appendErrorString:str];

	va_end(vargs);
}

@implementation DDXMLValidator {
    NSMutableString *errors;
}

+ (instancetype)sharedInstace {
    static DDXMLValidator *validator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        validator = [[[self class] alloc] init];
    });
    return validator;
}

- (BOOL)validateXMLData:(NSData *)data withSchema:(DDXMLValidatorSchemaType)schema schemaFile:(NSURL *)schemaURL error:(NSError *__autoreleasing  *)error {
    NSParameterAssert(data.length);
    NSParameterAssert(schemaURL.isFileURL);
    
	//open doc
    xmlDocPtr doc = xmlReadMemory(data.bytes, (int)data.length, "", NULL, XML_PARSE_RECOVER);
    if (doc == NULL) {
        NSLog(@"Unable to parse.");
        *error = [NSError errorWithDomain:@"DDXMLVaidator" code:-1 userInfo:nil];
        return NO;
    }
    
    BOOL br = [self validateXMLDoc:doc withSchema:schema schemaFile:schemaURL error:error];
    xmlFreeDoc(doc);
    return br;
}

- (BOOL)validateXMLFile:(NSURL *)xmlUrl withSchema:(DDXMLValidatorSchemaType)schema schemaFile:(NSURL *)schemaURL error:(NSError *__autoreleasing  *)error {
    NSParameterAssert(xmlUrl.isFileURL);
    NSParameterAssert(schemaURL.isFileURL);
    
	//open doc
    xmlDocPtr doc = xmlReadFile(xmlUrl.absoluteString.UTF8String, "utf-8", 0);
    if (doc == NULL) {
        NSLog(@"Unable to parse.");
        *error = [NSError errorWithDomain:@"DDXMLVaidator" code:-1 userInfo:nil];
        return NO;
    }

    BOOL br = [self validateXMLDoc:doc withSchema:schema schemaFile:schemaURL error:error];
    xmlFreeDoc(doc);
    return br;
}

- (BOOL)validateXMLDoc:(xmlDocPtr)doc withSchema:(DDXMLValidatorSchemaType)schema schemaFile:(NSURL *)schemaURL error:(NSError *__autoreleasing  *)error {
    //prepare to get errors
    errors = [NSMutableString stringWithString:@""];
	xmlSetGenericErrorFunc((__bridge void  *)self, (xmlGenericErrorFunc)myGenericErrorFunc);
    
    //parse
    switch (schema) {
        case DDXMLValidatorSchemaTypeDTD:
            [self doDTDValidation:doc schemaFile:schemaURL.path];
            break;
        case DDXMLValidatorSchemaTypeXSD:
            [self doXSDValidation:doc schemaFile:schemaURL.path];
            break;
        case DDXMLValidatorSchemaTypeRNG:
            [self doRNGValidation:doc schemaFile:schemaURL.path];
            break;
    }
	
    if ([errors length]) {
        NSLog(@"'Validate XML Documents' Error: %@", errors);
        *error = [NSError errorWithDomain:@"DDXMLValidator" code:0 userInfo:@{@"errors":errors}];
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark Private

- (void)appendErrorString:(NSString *)errorString {
    [errors appendFormat:@"%@\n", errorString];
}

- (void)doDTDValidation:(xmlDocPtr)source schemaFile:(NSString *)systemId {
	xmlValidCtxtPtr validCtxt = NULL;
	xmlDtdPtr dtd = NULL;
	int res;

	validCtxt = xmlNewValidCtxt();

	if (!validCtxt) {
		[self appendErrorString:@"DTD validation failed due to possible libxml2 error."];
        return;
	}
	   
	if ([systemId length]) {
        
		dtd = xmlParseDTD(NULL, (xmlChar  *)[systemId UTF8String]);
	
		if (!dtd) {
			[self appendErrorString:@"Error parsing DTD document."];
            if (validCtxt)
                xmlFreeValidCtxt(validCtxt);
            return;
		}
	
		res = xmlValidateDtd(validCtxt, source, dtd);
        
	} else {
        
		res = xmlValidateDocument(validCtxt, source);
        
	}

	if (validCtxt)
		xmlFreeValidCtxt(validCtxt);
	if (dtd)
		xmlFreeDtd(dtd);
}

- (void)doXSDValidation:(xmlDocPtr)source schemaFile:(NSString *)loc {
    int res;
	xmlSchemaParserCtxtPtr parserCtxt = NULL;
	xmlSchemaPtr schema = NULL;
	xmlSchemaValidCtxtPtr validCtxt = NULL;

	if ([loc length]) {
		parserCtxt = xmlSchemaNewParserCtxt([loc UTF8String]);
	
		if (!parserCtxt) {
			[self appendErrorString:@"Could not locate XML Schema document."];
			goto leave;
		}
	
		schema = xmlSchemaParse(parserCtxt);
	
		if (!schema) {
			[self appendErrorString:@"Error parsing XML Schema document."];
			goto leave;
		}
	
		validCtxt = xmlSchemaNewValidCtxt(schema);
	
		if (!validCtxt) {
			[self appendErrorString:@"Error parsing XML Schema document."];
			goto leave;
		}
	
		res = xmlSchemaValidateDoc(validCtxt, source);
	
	} else {
		xmlSchemaValidCtxtPtr validCtxt = xmlSchemaNewValidCtxt(NULL);
        
		if (!validCtxt) {
			[self appendErrorString:@"XML Schema validation failed due to possible libxml2 error."];
			goto leave;
		}
	
		res = xmlSchemaValidateDoc(validCtxt, source);
	}
    
	if (res) {
		[self appendErrorString:@"XML Schema validation failed."];
	}
    
leave:
	if (parserCtxt)
		xmlSchemaFreeParserCtxt(parserCtxt);
	if (schema)
        xmlSchemaFree(schema);
	if (validCtxt)
		xmlSchemaFreeValidCtxt(validCtxt);
}

- (void)doRNGValidation:(xmlDocPtr)source schemaFile:(NSString *)loc {
	int res;
	
    xmlRelaxNGParserCtxtPtr parserCtxt = NULL;
	xmlRelaxNGPtr schema = NULL;
	xmlRelaxNGValidCtxtPtr validCtxt = NULL;

	parserCtxt = xmlRelaxNGNewParserCtxt([loc UTF8String]);

	if (!parserCtxt) {
		[self appendErrorString:@"Could not locate RELAX NG document."];
		goto leave;
	}

	schema = xmlRelaxNGParse(parserCtxt);

	if (!schema) {
		[self appendErrorString:@"Error parsing RELAX NG document."];
		goto leave;
	}

	validCtxt = xmlRelaxNGNewValidCtxt(schema);

	if (!validCtxt) {
		[self appendErrorString:@"Error parsing RELAX NG document."];
		goto leave;
	}

	res = xmlRelaxNGValidateDoc(validCtxt, source);

	if (res) {
		[self appendErrorString:@"RELAX NG validation failed."];
	}

leave:
	//xmlRelaxNGCleanupTypes();
	if (parserCtxt)
		xmlRelaxNGFreeParserCtxt(parserCtxt);
	if (schema)
		xmlRelaxNGFree(schema);
	if (validCtxt)
		xmlRelaxNGFreeValidCtxt(validCtxt);
}

@end
