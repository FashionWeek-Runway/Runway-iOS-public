#!/bin/sh

#  ci_post_clone.sh
#  Runway-iOS
#
#  Created by 김인환 on 2023/02/15.
#  

# Install CocoaPods using Homebrew.
brew install cocoapods
        
# Install dependencies you manage with CocoaPods.
pod install
