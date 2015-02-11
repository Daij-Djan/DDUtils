/**
@file      DDTextField.h
@author    Dominik Pich
@date      2013-01-24
*/
#import <UIKit/UIKit.h>
#import "DDUnits.h"

@protocol DDTextFieldDelegate;

/**
 control that combines a textfield and a textview based on whether or not you set isMultiline
 */

IB_DESIGNABLE
@interface DDTextField : UIView

///---------------------------------------------------------------------------------------
/// @name designables
///---------------------------------------------------------------------------------------

/**
 TBD.
 
 @see
 */
@property (nonatomic, copy) IBInspectable NSString* text;

/**
 TBD.
 
 @see
 */
@property (nonatomic, copy) IBInspectable NSString* title;

/**
 TBD.
 
 @see
 */
@property (nonatomic, copy) IBInspectable NSString* placeholder;

/**
 TBD.
 
 @see
 */
@property (nonatomic, assign) IBInspectable BOOL mandatory;

/**
 TBD.
 
 @see
 */
@property (nonatomic, assign) IBInspectable BOOL secureTextEntry;

/**
 TBD.
 
 @see
 */
@property (nonatomic, assign, getter = isMultiLine) IBInspectable BOOL multiLine;


/**
 TBD.
 
 @see
 */
@property (nonatomic, copy) IBInspectable NSString* regExPattern;

/**
 TBD.
 
 @see
 */
@property (nonatomic, weak) IBOutlet id <DDTextFieldDelegate> delegate;

/**
 TBD.
 
 @see
 */
@property (nonatomic, copy) IBInspectable UIColor *borderColor;

///---------------------------------------------------------------------------------------
/// @name properties
///---------------------------------------------------------------------------------------

/**
 TBD.
 
 @see
 */
@property (nonatomic, assign) UIKeyboardType keyboardType;

/**
 TBD.
 
 @see
 */
@property (nonatomic, assign) UIReturnKeyType returnKeyType;

/**
 TBD.
 
 @see
 */
@property (nonatomic, strong) UIFont* font;


/**
 TBD.
 
 @see
 */
@property (nonatomic, copy) NSNumber* value;

/**
 TBD.
 
 @see
 */
@property (nonatomic, assign) DDUnitType valueType;

/**
 TBD.
 
 @see
 */
@property (nonatomic, assign) UITextAutocapitalizationType autocapitalizationType;

/**
 TBD.
 
 @see
 */
@property (nonatomic, readonly, getter=isEditing) BOOL editing;

/**
 TBD.
 
 @see
 */
@property (nonatomic, strong) NSRegularExpression* regEx;

/**
 TBD.
 
 @see
 */
@property (readwrite, strong) UIView *inputAccessoryView;


/**
 TBD.
 
 @see
 */
@property (nonatomic, assign) UIEdgeInsets contentInset;

/**
 TBD.
 
 @see
 */
+ (UIFont*)defaultFont;

///---------------------------------------------------------------------------------------
/// @name properties
///---------------------------------------------------------------------------------------

/**
 TBD 
 
 @param
 @return
 @discussion
 @warning
 @exception
 @see
 */
- (NSString *)textInRange:(UITextRange *)range;

/** 
 TBD.
 
 @param
 @return
 @discussion
 @warning
 @exception
 @see
 */
- (void)replaceRange:(UITextRange *)range withText:(NSString *)text;

/**
 TBD.
 
 @see
 */
@property(weak, nonatomic) UITextRange *selectedTextRange;

/**
 TBD.
 
 @see
 */
@property (weak, nonatomic, readonly) UITextPosition *beginningOfDocument;

/**
 TBD.
 
 @see
 */
@property (weak, nonatomic, readonly) UITextPosition *endOfDocument;


/**
 TBD.
 
 @param
 @return
 @discussion
 @warning
 @exception
 @see
 */
- (UITextPosition *)positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset;

/**
 TBD.
 
 @param
 @return
 @discussion
 @warning
 @exception
 @see
 */
- (UITextRange *)textRangeFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition;

///---------------------------------------------------------------------------------------
/// @name validation
///---------------------------------------------------------------------------------------

/**
 Checks the textField's content. This method enforces that it isnt empty. it returns YES if content is valid, NO if it isnt.
 
 @note be aware that this is only update when validateContent is called
 */
@property (readonly, nonatomic, assign, getter=isValid) BOOL valid;

@end

/** DDTextFieldDelegate can be implemented by a control's 'owner' to modify the working of a textfield. It COMBINES the UITextInput, UITextField, UITextView protocols applying them to this compound object
 */
@protocol DDTextFieldDelegate <NSObject>
@optional
/**
 Asks the delegate if the specified text should be changed.
 
 @param textField  The text field containing the text.
 @param range The range of characters to be replaced
 @param string The replacement string.
 
 @return YES if the specified text range should be replaced; otherwise, NO to keep the old text.
 @discussion The text field calls this method whenever the user types a new character in the text field or deletes an existing character.
 */
- (BOOL)textField:(DDTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

/**
 Tells the delegate that editing began for the specified text field.
 
 @param textField The text field for which an editing session began.

 @discussion This method notifies the delegate that the specified text field just became the first responder. You can use this method to update your delegate’s state information. For example, you might use this method to show overlay views that should be visible while editing. Implementation of this method by the delegate is optional.
 */
- (void)textFieldDidBeginEditing:(DDTextField *)textField;

/**
 Tells the delegate that editing stopped for the specified text field.
 
 @param textField The text field for which editing ended.

 @discussion This method is called after the text field resigns its first responder status. You can use this method to update your delegate’s state information. For example, you might use this method to hide overlay views that should be visible only while editing. Implementation of this method by the delegate is optional.
 */
- (void)textFieldDidEndEditing:(DDTextField *)textField;

/**
 Asks the delegate if editing should begin in the specified text field.
 
 @param textField  The text field for which editing is about to begin.
 @return YES if an editing session should be initiated; otherwise, NO to disallow editing.
 @discussion When the user performs an action that would normally initiate an editing session, the text field calls this method first to see if editing should actually proceed. In most circumstances, you would simply return YES from this method to allow editing to proceed. Implementation of this method by the delegate is optional. If it is not present, editing proceeds as if this method had returned YES.
 */
- (BOOL)textFieldShouldBeginEditing:(DDTextField *)textField;

/**
 Asks the delegate if the text field’s current contents should be removed.
 
 @param textField The text field containing the text.
 @return YES if the text field’s contents should be cleared; otherwise, NO.
 @discussion The text field calls this method in response to the user pressing the built-in clear button. (This button is not shown by default but can be enabled by changing the value in the clearButtonMode property of the text field.) This method is also called when editing begins and the clearsOnBeginEditing property of the text field is set to YES. Implementation of this method by the delegate is optional. If it is not present, the text is cleared as if this method had returned YES.
 */
- (BOOL)textFieldShouldClear:(DDTextField *)textField;

/**
 Asks the delegate if editing should stop in the specified text field.
 
 @param textField The text field for which editing is about to end.
 @return YES if editing should stop; otherwise, NO if the editing session should continue
 @discussion This method is called when the text field is asked to resign the first responder status. This might occur when your application asks the text field to resign focus or when the user tries to change the editing focus to another control. Before the focus actually changes, however, the text field calls this method to give your delegate a chance to decide whether it should. Normally, you would return YES from this method to allow the text field to resign the first responder status. You might return NO, however, in cases where your delegate detects invalid contents in the text field. By returning NO, you could prevent the user from switching to another control until the text field contained a valid value. Be aware that this method provides only a recommendation about whether editing should end. Even if you return NO from this method, it is possible that editing might still end. For example, this might happen when the text field is forced to resign the first responder status by being removed from its parent view or window. Implementation of this method by the delegate is optional. If it is not present, the first responder status is resigned as if this method had returned YES.
 */
- (BOOL)textFieldShouldEndEditing:(DDTextField *)textField;

/**
 Asks the delegate if the text field should process the pressing of the return button.
 
 @param textField The text field whose return button was pressed.
 @return YES if the text field should implement its default behavior for the return button; otherwise, NO.
 @discussion The text field calls this method whenever the user taps the return button. You can use this method to implement any custom behavior when the button is tapped.
 */
- (BOOL)textFieldShouldReturn:(DDTextField *)textField;


@end
