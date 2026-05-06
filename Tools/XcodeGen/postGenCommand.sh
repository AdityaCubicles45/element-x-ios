#!/bin/bash

# This script is invoked by xcodegen for running post commands

# Move file header template in project shared data folder
mkdir -p ../../Chatlio.xcodeproj/xcshareddata/
cp IDETemplateMacros.plist ../../Chatlio.xcodeproj/xcshareddata/
