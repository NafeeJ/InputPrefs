//
//  AppDelegate.swift
//  InputPrefs
//
//  Created by Nafee Jan on 3/5/20.
//  Copyright © 2020 Nafee Workshop. All rights reserved.
//

import Cocoa
import Foundation
import LaunchAtLogin

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var menu: NSMenu?
    
    //AppleScripts to switch the current default settings
    let switchScrollingScript = """
    tell application "System Preferences"
        reveal anchor "trackpadTab" of pane "com.apple.preference.trackpad"
    end tell
    tell application "System Events" to tell process "System Preferences"
        click radio button "Scroll & Zoom" of tab group 1 of window "Trackpad"
        click checkbox 1 of tab group 1 of window 1
    end tell
    quit application "System Preferences"
    """
    let switchFnKeysScript = """
    tell application "System Preferences"
        reveal anchor "keyboardTab" of pane "com.apple.preference.keyboard"
    end tell
    tell application "System Events" to tell process "System Preferences"
        click checkbox 1 of tab group 1 of window 1
    end tell
    quit application "System Preferences"
    """

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        menu = NSMenu()
        menu?.addItem(NSMenuItem(title: "About InputPrefs", action: #selector(loadAboutWindow), keyEquivalent: ""))
        menu?.addItem(NSMenuItem.separator())
        
        //get launch at login preference and make menu item with according state
        let autoLaunchItem = NSMenuItem(title: "Launch at Login", action: #selector(switchAutoLaunch), keyEquivalent: "")
        autoLaunchItem.state = LaunchAtLogin.isEnabled ? NSControl.StateValue.on : NSControl.StateValue.off
        menu?.addItem(autoLaunchItem)
        
        menu?.addItem(NSMenuItem.separator())
        
        //get current scrolling preference and make menu item with according state
        let scrollingItem = NSMenuItem(title: "Natural Scrolling", action: #selector(switchScrolling), keyEquivalent: "")
        scrollingItem.state = UserDefaults.standard.value(forKey: "com.apple.swipescrolldirection") as! Bool ? NSControl.StateValue.on : NSControl.StateValue.off
        menu?.addItem(scrollingItem)
        
        //get current fnKeys preference and make menu item with according state
        let fnKeysItem = NSMenuItem(title: "Function Keys", action: #selector(switchFnKeys), keyEquivalent: "")
        fnKeysItem.state = UserDefaults.standard.value(forKey: "com.apple.keyboard.fnState") as! Bool ? NSControl.StateValue.on : NSControl.StateValue.off
        menu?.addItem(fnKeysItem)
        
        menu?.addItem(NSMenuItem.separator())
        menu?.addItem(NSMenuItem(title: "Quit InputPrefs", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
        statusItem.menu = menu
        statusItem.button?.title = "✲"
    }
    
    @objc func switchAutoLaunch() {
        menu?.item(at: 2)?.state = LaunchAtLogin.isEnabled ? NSControl.StateValue.off : NSControl.StateValue.on
        LaunchAtLogin.isEnabled = menu?.item(at: 2)?.state == NSControl.StateValue.on
    }
    
    @objc func switchScrolling() {
        executeScript(script: switchScrollingScript)
        menu?.item(at: 4)?.state = UserDefaults.standard.value(forKey: "com.apple.swipescrolldirection") as! Bool ? NSControl.StateValue.on : NSControl.StateValue.off
    }
    
    @objc func switchFnKeys() {
        executeScript(script: switchFnKeysScript)
        menu?.item(at: 5)?.state = UserDefaults.standard.value(forKey: "com.apple.keyboard.fnState") as! Bool ? NSControl.StateValue.on : NSControl.StateValue.off
    }
    
    func executeScript(script: String) {
        if let scriptObject = NSAppleScript(source: script) {
            var errorDict: NSDictionary?
            let _: NSAppleEventDescriptor? = scriptObject.executeAndReturnError(&errorDict)
            print(errorDict ?? "")
        }
    }
    
    @objc func loadAboutWindow() {
        NSApp.orderFrontStandardAboutPanel()
        NSApp.activate(ignoringOtherApps: true)
    }
}
