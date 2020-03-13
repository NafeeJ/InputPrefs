//
//  AppDelegate.swift
//  InputPrefs
//
//  Created by Nafee Jan on 3/5/20.
//  Copyright © 2020 Nafee Workshop. All rights reserved.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var menu: NSMenu?
    
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
        menu?.addItem(NSMenuItem(title: "Natural Scrolling", action: #selector(switchScrolling), keyEquivalent: ""))
        menu?.addItem(NSMenuItem(title: "Function Row Default", action: #selector(switchFnKeys), keyEquivalent: ""))
        menu?.addItem(NSMenuItem.separator())
        menu?.addItem(NSMenuItem(title: "Quit InputPrefs", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
        statusItem.menu = menu
        statusItem.button?.title = "✲"
    }
    
    @objc func switchScrolling() {
        executeScript(script: switchScrollingScript)
    }
    
    @objc func switchFnKeys() {
        executeScript(script: switchFnKeysScript)
    }
    
    func executeScript(script: String) {
        if let scriptObject = NSAppleScript(source: script) {
            var errorDict: NSDictionary? = nil
            let _: NSAppleEventDescriptor? = scriptObject.executeAndReturnError(&errorDict)
            print(errorDict ?? "")
        }
    }
    
    @objc func loadAboutWindow() {
        NSApp.orderFrontStandardAboutPanel()
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
