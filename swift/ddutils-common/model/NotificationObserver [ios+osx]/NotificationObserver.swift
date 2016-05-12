//
//  NotificationObserver.swift
//  FocusMode
//
//  Created by Dominik Pich on 5/3/16.
//  Copyright © 2016 Dominik Pich. All rights reserved.
//

import Foundation

/**
 A `NotificationObserver` object is a small wrapper around Apple's NotificationCenter API which manages to automatically register/unregister observers on the Center
 */
public class NotificationObserver : NSObject {   
    // MARK: - Public properties
    
    /**
     Dictionary of notifications that are being observed on the `observed` object, with callback functions.
     
     **Key**: The notification that is being observed.
     
     **Value**: The callback function that is invoked when a notification comes in. The NSNotification is passed to it
     */
    public var events: [String: (NSNotification) -> Void] {
        didSet {
            if isObserving {
                // Stop observing any values that are no longer present in the dictionary,
                // and begin observing new values that are now present.
                endObserving(Array(oldValue.keys.filter { self.events[$0] == nil }))
                beginObserving(Array(events.keys.filter { oldValue[$0] == nil }))
            }
        }
    }
    
    /**
     Whether or not this class is currently observing any notifications on the `observed` object.
     
     Setting this value will begin or end observing the notifications given in the `events` dictionary.
     */
    public var isObserving: Bool {
        willSet(newIsObserving) {
            if (newIsObserving != isObserving) {
                if (newIsObserving) {
                    beginObserving(Array(events.keys))
                } else {
                    endObserving(Array(events.keys))
                }
            }
        }
    }
    
    // MARK: Private
    
    /// Internal context used to ensure this class passes on other KVO events it did not register it
    private let context = UnsafeMutablePointer<Void>(bitPattern: 123)
    
    /// The object whom we are observing property changes on or nil... nil means global
    private let observed: NSObject?
    
    /// the NSNotificationCenter being used
    private let notificationCenter : NSNotificationCenter
    
    // MARK: - Lifecycle
    
    /**
     Initializes a new `NotificationObserver` object which listens for changes on a given object.
     
     :param: observed The object to listen for notifications or nil... nil means global.
     :param: isInitiallyObserving Optional boolean to start observing events immediately.
     :param: notificationCenter Optional the notificationCenter to observe
     :param: events Optional dictionary of notifications to listen for.
     */
    public init(observed: NSObject? = nil, callOnStart: Bool = true, isInitiallyObserving: Bool = false, notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter(), events: [String: (NSNotification) -> Void] = [:]) {
        self.observed = observed
        self.events = events
        self.isObserving = isInitiallyObserving
        self.notificationCenter = notificationCenter
        super.init()
        
        if (isInitiallyObserving) {
            beginObserving(Array(events.keys))
        }
    }
    
    deinit {
        assert(isObserving == false)
    }
    
    // MARK: - Update
    
    /**
     Updates the `events` dictionary by adding the keys and values provided, and starts observing the newly added properties.
     
     :param: events The keys and values to be appended to the `events` dictionary.
     */
    public func addEvents(events: [String: (NSNotification) -> Void]) {
        var newEvents = self.events
        for (k, v) in events {
            newEvents.updateValue(v, forKey: k)
        }
        self.events = newEvents
    }
    
    /**
     Updates the `events` dictionary by removing the keys provided, and stops observing those properties automatically.
     
     :param: events The keys to be removed from the `events` dictionary.
     */
    public func removeEvents(events: [String]) {
        var newEvents = self.events
        for k in events {
            newEvents.removeValueForKey(k)
        }
        self.events = newEvents
    }
    
    // MARK: - notifications
    
    private func beginObserving(notifications: [String]) {
        for noteName in notifications {
            notificationCenter.addObserver(self, selector: #selector(NotificationObserver.notificationReceived), name: noteName, object: observed)
        }
    }
    
    private func endObserving(notifications: [String]) {
        for noteName in notifications {
            notificationCenter.removeObserver(self, name: noteName, object: observed)
        }
    }
    
    public func notificationReceived(note: NSNotification!) {
        guard let note = note else {
            fatalError("note should not be nil")
        }
        if let event = events[note.name] {
            event(note)
        }
    }
    
}
