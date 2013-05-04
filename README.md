# Dash Plugin for Xcode

## Overview

This Xcode plugin helps [Dash](http://kapeli.com/dash/) users avoid the Xcode documentation window. When it's installed and enabled, links from the Quick Help documentation popup and inspector open Dash, instead of the documentation browser in the Xcode Organizer. Quick Help otherwise operates normally.

Since Xcode understands Objective-C selector syntax and knows which platform's documentation you're interested in, this plugin does too. It does its best to send you to the right place.

If you want to use Xcode's built-in documentation browser again, you can disable the Dash integration using the "Dash Integration" item in the "Edit" menu. Or if you just want to do it temporarily, hold the Shift key while clicking the link.

This plugin has been heavily modified by [@architechies](http://twitter.com/architechies), and is based on a similar plugin by [@olemoritz](http://twitter.com/olemoritz). ([His version](https://github.com/Kapeli/Dash-Plugin-for-Xcode) completely overrides the Quick Help popup.) If you like reading Apple's documentation, you might also like Ole's [iOS app DocSets](https://github.com/omz/DocSets-for-iOS) for reading on your iPad or iPhone, even if you have no internet connection.

## Usage & Installation

1. Download the source, build the Xcode project and restart Xcode. The plugin will automatically be installed in `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins`. To uninstall, just remove the plugin from there (and restart Xcode).
2. To use - **Option-Click** any method/class/symbol in Xcode's text editor.

## License

    Copyright (c) 2012-13, Ole Zorn & Brent Royal-Gordon
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this
      list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
    OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
