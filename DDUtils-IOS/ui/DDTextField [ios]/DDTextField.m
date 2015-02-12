/**
@file      DDTextField.m
@author    Dominik Pich (based heavily on code by M. Zapf)
@date      2013-01-05
@copyright AUDI AG, 2014. All Rights Reserved
*/
#import "DDTextField.h"
#import "CGRectHelpers.h"

@interface DDTextField () <UITextFieldDelegate, UITextViewDelegate> {
    BOOL textViewIsEditing;
    NSString *latestEditedText;
}

@property (nonatomic, strong, readonly) UITextField* textField;
@property (nonatomic, strong, readonly) UITextView* textView;
@property (nonatomic, strong, readonly) UILabel* label;
@property (nonatomic, strong, readonly) UILabel* unitLabel;
@property (nonatomic, strong, readonly) UILabel* placeholderLabel;
@property (nonatomic, weak, readonly) UIColor* textFieldBackgroundColor;
@property (nonatomic, weak, readonly) NSString* decimalSeperator;
@property (nonatomic, strong) UIToolbar* accessoryView;

@end

@implementation DDTextField
@synthesize textField;
@synthesize textView;
@synthesize mandatory;
@synthesize valid;
@synthesize contentInset;
@synthesize label;
@synthesize valueType;
@synthesize unitLabel;
@synthesize value;
@synthesize delegate;
@synthesize placeholder;
@synthesize placeholderLabel;
@synthesize multiLine;
@synthesize accessoryView;
@synthesize regExPattern;
@synthesize regEx;
@synthesize inputAccessoryView;
@synthesize borderColor;

+ (UIFont*)defaultFont {
    static UIFont* font = nil;
    if (font == nil) {
        font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    return font;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        valid = YES;
        [self setupView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
        valid = YES;
		[self setupView];
	}
	return self;
}

- (id)init {
    if ((self = [self initWithFrame:CGRectMake(5.0f, 5.0f, 280.0f, 38.0f)])) {
	}
	return self;
}

- (void)prepareForInterfaceBuilder {
    [self setupView];
}

- (void)setupView {
    contentInset = UIEdgeInsetsMake(4.0f, 10.0f, 4.0f, 10.0f);
    [self addSubview:self.textField];
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    [super setUserInteractionEnabled:userInteractionEnabled];
    self.textField.userInteractionEnabled = userInteractionEnabled;
    
    unitLabel.textColor = [UIColor darkGrayColor];
    textField.textColor = [UIColor blackColor];
    textView.textColor =  [UIColor blackColor];
}
- (UILabel*)label {
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(self.contentInset.left, self.contentInset.top, CGRectGetWidth(self.bounds) -(self.contentInset.left + self.contentInset.right) , 22.0f)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:10];
        label.numberOfLines = 0;
        
        UIColor *c = self.userInteractionEnabled ? [UIColor blackColor] : [UIColor darkGrayColor];
        unitLabel.textColor = c;
        textField.textColor = c;
        
        [self addSubview:label];
    }
    return label;
}

- (UILabel*)placeholderLabel {
    if (placeholderLabel == nil) {
        placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentInset.left, self.contentInset.top, CGRectGetWidth(self.bounds) - (self.contentInset.left + self.contentInset.right) , 22.0f)];
        placeholderLabel.backgroundColor = [UIColor clearColor];
        placeholderLabel.textColor = [UIColor darkGrayColor];
        placeholderLabel.font = textField.font;
        [self addSubview:placeholderLabel];
    }
    
    return placeholderLabel;
}

- (UILabel*)unitLabel {
    if (unitLabel == nil) {
        unitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        unitLabel.backgroundColor = [UIColor clearColor];
        UIColor *c = self.userInteractionEnabled ? [UIColor blackColor] : [UIColor darkGrayColor];
        unitLabel.textColor = (label != nil)? c:[UIColor lightGrayColor];
        unitLabel.font = textField.font;
        [self addSubview:unitLabel];
    }
    return unitLabel;
}

- (UIColor*)textFieldBackgroundColor {
    static __strong UIColor* textFieldBackgroundColor = nil;
    if (textFieldBackgroundColor == nil) {
        textFieldBackgroundColor = [UIColor colorWithWhite:0.75 alpha:0.25];
    }
    return textFieldBackgroundColor;
}

- (void)setValueType:(DDUnitType)newValueType {
    valueType = newValueType;
    
    switch (valueType) {
        case DDUnitTypeNone:
            [unitLabel removeFromSuperview];
            unitLabel = nil;
            break;
            
        default:
            self.unitLabel.text = [DDUnits unitTextForUnitType:valueType];
            self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            break;
    }
    [self setNeedsLayout];
}

- (UIToolbar *)accessoryView {
    if (accessoryView == nil) {
        accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        accessoryView.barStyle = UIBarStyleBlack;
        id str = NSLocalizedString(@"feature_button_done", @"Fertig");
		UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:str style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        accessoryView.items = [NSArray arrayWithObjects:space, item, nil];
    }
    return accessoryView;
}

- (void)dismissKeyboard {
    [self.textField resignFirstResponder];
}

- (UITextField*)textField {
	if (textField == nil) {
		textField = [[UITextField alloc] initWithFrame:CGRectWithUIEdgeInsets(self.bounds, self.contentInset)];
		textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		textField.borderStyle = UITextBorderStyleNone;
        textField.backgroundColor = [UIColor clearColor];
		textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        UIColor *c = self.userInteractionEnabled ? [UIColor blackColor] : [UIColor darkGrayColor];
		textField.textColor = c;
		textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.font = [DDTextField defaultFont];
        textField.delegate = self;
	}
	return textField;
}


- (UITextView*)textView {
    if (textView == nil) {
        textView = [[UITextView alloc] initWithFrame:CGRectWithUIEdgeInsets(self.bounds, self.contentInset)];
		textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        textView.backgroundColor = [UIColor clearColor];
        textView.autocorrectionType = UITextAutocorrectionTypeNo;
        //to have the TEXT aligned on the left (not the selector)
        //inset depending on os... they have this new text selector
        NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
        if( [sysVersion compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending ) {
            textView.contentInset = UIEdgeInsetsMake(-8.0f, -4.0f, -6.0f, 0.0f);
        }
        else {
            textView.contentInset = UIEdgeInsetsMake(-8.0f, -8.0f, -6.0f, 0.0f);
        }
        textView.delegate = self;
        
        textView.font = (textField)? textField.font:[DDTextField defaultFont];
        UIColor *c = self.userInteractionEnabled ? [UIColor blackColor] : [UIColor darkGrayColor];
        textView.textColor =  (textField) ? textField.textColor : c;
        textView.autocapitalizationType = (textField) ? textField.autocapitalizationType : UITextAutocapitalizationTypeSentences;
        textView.secureTextEntry = (textField) ? textField.secureTextEntry : NO;
        textView.keyboardType = (textField) ? textField.keyboardType: UIKeyboardTypeDefault;
        textView.returnKeyType = (textField) ? textField.returnKeyType: UIReturnKeyDone;
        textView.text = (textField) ? textField.text: nil;
    }
    return textView;
}

- (UIFont*)font {
    return self.textField.font;
}

- (void)setFont:(UIFont *)font {
    textField.font = font;
    textView.font = font;
    
    unitLabel.font = font; //don't take lazy loading accessor
    placeholderLabel.font = font;
}

- (UITextRange *)selectedTextRange {
    if (self.isMultiLine) {
        return self.textView.selectedTextRange;
    }
    else {
        return self.textField.selectedTextRange;
    }
}

- (void)setSelectedTextRange:(UITextRange *)selectedTextRange {
    textField.selectedTextRange = selectedTextRange;
    textView.selectedTextRange = selectedTextRange;
}

- (void)setText:(NSString *)text {
    if (text.length && self.regEx) {
        NSTextCheckingResult* match = [self.regEx firstMatchInString:text options:0 range:NSMakeRange(0, [text length])];
        if (match.range.length != text.length) {
            NSLog(@"'%@'\ndoesn't match regEx\n'%@'", text, self.regEx.pattern);
            return;
        }
    }
    
    if (self.isMultiLine) {
        self.textView.text = text;
    }
    else {
        self.textField.text = text;
    }
    latestEditedText = [text copy];
    
    [self processPlaceholderAndCheckValid];
    
    [self layoutSubviewsWithAnimation:self.superview != nil]; //animate only when visible
}

- (NSString*)text {
    if (textView) {
        return textView.text;
    }
    
    return textField.text;
}

- (void)setMultiLine:(BOOL)theValue {
    multiLine = theValue;
    
    if (multiLine) {
        [textField removeFromSuperview];
        [self addSubview:self.textView];
        
        //release here because lazy getter needs textfield values
        textField = nil;
        
        [self layoutSubviews];
    }
    else {
        [textView removeFromSuperview];
        textView = nil;
        [self addSubview:self.textField];
        [self layoutSubviews];
    }
}

- (void)setBorderColor:(UIColor *)aBorderColor {
    borderColor = aBorderColor;
    self.layer.borderColor = aBorderColor.CGColor;
    self.layer.borderWidth = 1;
}
- (void)setTitle:(NSString *)title {
    self.label.text = title;
    [self layoutSubviewsWithAnimation:self.superview != nil]; //animate only when visible
}

- (NSString*)title {
    return label.text;
}

- (void)setPlaceholder:(NSString *)thePlaceholder {
    placeholder = [thePlaceholder copy];
    self.placeholderLabel.text = thePlaceholder;
    [self layoutSubviewsWithAnimation:self.superview != nil]; //animate only when visible
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    
    if (self.isMultiLine) {
        self.textView.secureTextEntry = secureTextEntry;
    }
    else {
        self.textField.secureTextEntry = secureTextEntry;
    }
}

- (BOOL)secureTextEntry {
    if (textView) {
        return textView.secureTextEntry;
    }
    return textField.secureTextEntry;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    
    if (self.isMultiLine) {
        self.textView.keyboardType = keyboardType;
    }
    else {
        self.textField.keyboardType = keyboardType;
    }
}

- (void)setAutocapitalizationType:(UITextAutocapitalizationType)type {
    if (self.isMultiLine) {
        self.textView.autocapitalizationType = type;
    }
    else {
        self.textField.autocapitalizationType = type;
    }
}

- (UITextAutocapitalizationType)autocapitalizationType {
    if (textView) {
        return textView.autocapitalizationType;
    }
    return textField.autocapitalizationType;
}

- (UIKeyboardType)keyboardType {
    if (textView) {
        return textView.keyboardType;
    }
    return textField.keyboardType;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType {
    if (self.isMultiLine) {
        self.textView.returnKeyType = returnKeyType;
    }
    else {
        self.textField.returnKeyType = returnKeyType;
    }
}

- (UIReturnKeyType)returnKeyType {
    if (textView) {
        return textView.returnKeyType;
    }
    return textField.returnKeyType;
}

- (void)setTag:(NSInteger)tag{
    [super setTag:tag];
    textField.tag = tag;
    textView.tag = tag;
}

- (BOOL)isEditing {
    if (textView) {
        return textViewIsEditing;
    }
    return textField.isEditing;
}

- (void)setValue:(NSNumber *)newValue {
    value = [newValue copy];
    self.text = [DDUnits valueTextWithoutUnitForValue:value withUnitType:self.valueType];
}

- (NSString*)decimalSeperator {
    static __strong NSString* decimalSeperator = nil;
    if (decimalSeperator == nil) {
        decimalSeperator = [[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] copy];
    }
    return decimalSeperator;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: frame = %@", NSStringFromClass([self class]), NSStringFromCGRect(self.frame)];
    if (self.title.length) {
        [description appendFormat:@"; title = '%@'", self.title];
    }
    if (self.text.length) {
        [description appendFormat:@"; text = '%@'", self.text];
    }
    
    [description appendString:@">"];
    return description;
}

- (BOOL)becomeFirstResponder {
    if (textView) {
        return [textView becomeFirstResponder];
    }
    else if (textField) {
        return [textField becomeFirstResponder];
    }
    
    return NO;
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    
    if (textView) {
        return [textView resignFirstResponder];
    }
    else if (textField) {
        return [textField resignFirstResponder];
    }
    
    return NO;
}

- (NSString *)textInRange:(UITextRange *)range {
    if (textView && [textView respondsToSelector:@selector(textInRange:)]) {
        return [textView textInRange:range];
    }
    else if (textField && [textField respondsToSelector:@selector(textInRange:)]) {
        return [textField textInRange:range];
    }
    
    return nil;
}

- (void)replaceRange:(UITextRange *)range withText:(NSString *)text {
    if (textView && [textView respondsToSelector:@selector(replaceRange:withText:)]) {
        return [textView replaceRange:range withText:text];
    }
    else if (textField && [textField respondsToSelector:@selector(replaceRange:withText:)]) {
        return [textField replaceRange:range withText:text];
    }
}

- (UITextPosition *)beginningOfDocument {
    if (textView && [textView respondsToSelector:@selector(beginningOfDocument)]) {
        return [textView beginningOfDocument];
    }
    else if (textField && [textField respondsToSelector:@selector(beginningOfDocument)]) {
        return [textField beginningOfDocument];
    }
    
    return nil;
}

- (UITextPosition *)endOfDocument {
    if (textView && [textView respondsToSelector:@selector(endOfDocument)]) {
        return [textView endOfDocument];
    }
    else if (textField && [textField respondsToSelector:@selector(endOfDocument)]) {
        return [textField endOfDocument];
    }
    
    return nil;
}


- (UITextPosition *)positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset {
    if (textView && [textView respondsToSelector:@selector(positionFromPosition:offset:)]) {
        return [textView positionFromPosition:position offset:offset];
    }
    else if (textField && [textField respondsToSelector:@selector(positionFromPosition:offset:)]) {
        return [textField positionFromPosition:position offset:offset];
    }
    
    return nil;
}

- (UITextRange *)textRangeFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition {
    if (textView && [textView respondsToSelector:@selector(textRangeFromPosition:toPosition:)]) {
        return [textView textRangeFromPosition:fromPosition toPosition:toPosition];
    }
    else if (textField && [textField respondsToSelector:@selector(textRangeFromPosition:toPosition:)]) {
        return [textField textRangeFromPosition:fromPosition toPosition:toPosition];
    }
    
    return nil;
}


#define kUnitLabelWidth 32.0f

- (void)layoutSubviews {    
    [self layoutSubviewsWithAnimation:NO];
}

- (void)layoutSubviewsWithAnimation:(BOOL)animated {
    CGRect textFieldFrame = CGRectWithUIEdgeInsets(self.bounds, self.contentInset);
    
    CGRect labelFrame = CGRectZero;
    CGRect unitLabelFrame = CGRectZero;
    
    UIFont* labelFont = label.font;
    
    //title???
    if (label.text.length) {
        labelFrame = textFieldFrame; //full title / placeholder
        
        //small title ???
        if (self.text.length || self.isEditing) {
            labelFrame.origin.y = CGRectGetMinX(self.bounds);
            labelFrame.size.height = 22.0f;
            textFieldFrame.origin.y = CGRectGetMaxY(labelFrame) - 12.0f;
            labelFont = [UIFont systemFontOfSize:10];
        }
        else {
            textFieldFrame.size.width = 0.0f; //reduce width to 0.0, thus it is not appearing from left
            labelFont = [DDTextField defaultFont];
        }
    }
    
    if (unitLabel && textField) {
        
        unitLabelFrame = textFieldFrame;
        
        if (textField.text.length && !textField.isEditing) {
            NSString *str = [textField.text stringByAppendingString:@" "];
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = NSLineBreakByClipping;
            paragraphStyle.alignment = NSTextAlignmentLeft;
            
            NSDictionary * attributes = @{NSFontAttributeName : textField.font,
                                          NSParagraphStyleAttributeName : paragraphStyle};
            
            NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:str
                                                                                attributes:attributes];
            CGSize maxBoundingSize = CGSizeMake(CGRectGetWidth(textFieldFrame) - kUnitLabelWidth, MAXFLOAT);
            CGRect boundingRect = [attributedStr boundingRectWithSize:maxBoundingSize
                                                              options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                              context:nil];
            
            textFieldFrame.size.width = boundingRect.size.width;
        }
        else if (textFieldFrame.size.width > kUnitLabelWidth) {
            textFieldFrame.size.width -= kUnitLabelWidth;
        }
        
        if (textField.text.length || textField.isEditing) {
            unitLabelFrame.size.width = kUnitLabelWidth;
        }
        else {
            unitLabelFrame.size.width = 0;
        }
        
        unitLabelFrame.origin.x = CGRectGetMaxX(textFieldFrame);
    }
    
    [self processPlaceholderAndCheckValid];
        
    UIView* view = (textView)? textView:textField;
    if (textView) {
        textFieldFrame.origin.y += 6.0f;
        textFieldFrame.size.height -= 12.0f;
    }
    if(!valid) {
        textFieldFrame.size.width -= 18;
    }

    if (animated) {
        [UIView animateWithDuration:0.25
                         animations:^{ 
                             label.frame = labelFrame;
                             view.frame = textFieldFrame;
                             unitLabel.frame = unitLabelFrame;
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 label.font = labelFont;
                             }
                         }];
    }
    else {
        label.frame = labelFrame;
        label.font = labelFont;
        view.frame = textFieldFrame;
        unitLabel.frame = unitLabelFrame;
    }
}

- (void)processPlaceholderAndCheckValid {
    NSString *text;
    
    if(self.isMultiLine) {
        text = textViewIsEditing ? latestEditedText : textView.text;
    }
    else {
        text = textField.isEditing ? latestEditedText : textField.text;
    }
    
    if (placeholder.length) {
        if (!text.length) {
            CGRect frame = self.isMultiLine ? textView.frame : textField.frame;
            placeholderLabel.frame = frame;
            placeholderLabel.hidden = NO;
        }
        else {
            placeholderLabel.frame = CGRectZero;
            placeholderLabel.hidden = YES;
        }
    }
    
    if(mandatory) {
        self.valid = text.length;
    }
}

- (NSRegularExpression*)regEx {
    if (regEx == nil) {
        if (regExPattern.length) {
            regEx = [NSRegularExpression regularExpressionWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:NULL];
            NSAssert(regEx, regExPattern);
        }
        else if (self.valueType != DDUnitTypeNone) {
            
            NSString* unitRegExPattern = [DDUnits regExPatternForUnitType:self.valueType];
            if (unitRegExPattern.length) {
                regEx = [NSRegularExpression regularExpressionWithPattern:unitRegExPattern options:0 error:NULL];
                NSAssert(regEx, unitRegExPattern);
            }
        }
    }
    return regEx;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (!self.userInteractionEnabled) {
        return nil;
    }
    
    //if label,... is visible
    UIView* hittedView = [super hitTest:point withEvent:event];
    if (hittedView && (hittedView == self || hittedView == label || hittedView == unitLabel)) {
        if (textView) {
            return textView;
        }
        return textField;
    }
    
    return hittedView;
}

#pragma mark -
#pragma mark MAValidationProtocol
- (void)setValid:(BOOL)newValue {
    valid = newValue;

    UIView *redLine = [self viewWithTag:669];
    UILabel *mark = (UILabel*)[self viewWithTag:668];
    
    if(!redLine) {
        redLine = [[UIView alloc] initWithFrame:CGRectMake(5, self.frame.size.height-5, self.frame.size.width-10, 1)];
        redLine.backgroundColor = [UIColor redColor];
        redLine.tag = 669;
        [self addSubview:redLine];
    }
    
    if(!mark) {
        mark = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-30, self.frame.size.height-30, 20, 20)];
        mark.textAlignment = NSTextAlignmentCenter;
        mark.backgroundColor = [UIColor redColor];
        mark.textColor = [UIColor whiteColor];
        mark.font = [UIFont boldSystemFontOfSize:14];
        mark.text = @"!";
        
        mark.tag = 668;
        [self addSubview:mark];
    }

    redLine.hidden = mark.hidden = valid;
}

- (BOOL)validateContent {
    self.valid = (self.text.length > 0);
    return self.valid;
}


#pragma mark -
#pragma mark UITextFieldDelegate

#define kMinusSymbol    @"-"

- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self performSelector:@selector(processPlaceholderAndCheckValid) withObject:nil afterDelay:0.0f];
    
    latestEditedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate textField:self shouldChangeCharactersInRange:range replacementString:string];
    }
    
    //delete
    if (string.length == 0) {
        return YES;
    }
    
    if (self.regEx) {
        NSMutableString* check = [NSMutableString stringWithString:theTextField.text];
        [check replaceCharactersInRange:range withString:string];
        NSTextCheckingResult* match = [self.regEx firstMatchInString:check options:0 range:NSMakeRange(0, [check length])];
        if (match.range.length != check.length) {
            return NO;
        }
    }
    
    if (self.valueType != DDUnitTypeNone) {
        //reset value
        value = [DDUnits valueForText:latestEditedText withUnitType:self.valueType];
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)theTextField {
    if (theTextField.keyboardType == UIKeyboardTypeNumberPad) {
        textField.inputAccessoryView = self.accessoryView;
    }

    if ([self.delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.delegate textFieldShouldBeginEditing:self];
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)theTextField {
    [self performSelector:@selector(processPlaceholderAndCheckValid) withObject:nil afterDelay:0.0f];
    
    if ([self.delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        if(![self.delegate textFieldShouldClear:self])
            return NO;
    }
    
    latestEditedText = @"";
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)theTextField {
    [self performSelector:@selector(processPlaceholderAndCheckValid) withObject:nil afterDelay:0.0f];
    
    if ([self.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.delegate textFieldShouldEndEditing:self];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)theTextField {
    
    //set the text without any grouping seperators because this won't work with the regEx pattern.
    if (self.valueType != DDUnitTypeNone && value) {
        theTextField.text = [[DDUnits valueTextWithoutUnitForValue:value withUnitType:self.valueType] stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator] withString:@""];
    }
    
    [self layoutSubviewsWithAnimation:YES];
    
    if ([self.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.delegate textFieldDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)theTextField {
    if (self.valueType != DDUnitTypeNone) {
        value = [DDUnits valueForText:textField.text withUnitType:self.valueType];
        
        //at least set the well formatted text
        theTextField.text = [DDUnits valueTextWithoutUnitForValue:value withUnitType:self.valueType];
    }
    
    [self layoutSubviewsWithAnimation:YES];

    if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.delegate textFieldDidEndEditing:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if ([self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.delegate textFieldShouldReturn:self];
    }
    
    return YES;
}

#pragma mark -
#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)theTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    [self performSelector:@selector(processPlaceholderAndCheckValid) withObject:nil afterDelay:0.0f];
    latestEditedText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate textField:self shouldChangeCharactersInRange:range replacementString:text];
    }
    
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location != NSNotFound ) {
        BOOL br = YES;
        if ([self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
            br = [self.delegate textFieldShouldReturn:self];
        }
        if(!br) {
            [theTextView resignFirstResponder];
            return NO;
        }
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textViewIsEditing = YES;
    [self layoutSubviewsWithAnimation:YES];
    
    if ([self.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.delegate textFieldDidBeginEditing:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    textViewIsEditing = NO;
    [self layoutSubviewsWithAnimation:YES];
    
    if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.delegate textFieldDidEndEditing:self];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.delegate textFieldShouldBeginEditing:self];
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.delegate textFieldShouldEndEditing:self];
    }

    return YES;
}

- (BOOL)isEqual:(id)object {
    if (object == self || object == textField || object == textView) {
        return YES;
    }
    
    return NO;
}

#pragma mark -
#pragma mark Needed Memory Management

- (void)dealloc {
    textField.delegate = nil;
    textView.delegate = nil;
}

@end
