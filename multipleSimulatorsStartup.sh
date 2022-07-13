#!/bin/sh

#  multipleSimulatorsStartup.sh
#  planning-pocker
#
#  Created by Tieu Viet Trong Nghia on 07/07/2022.
#  
xcrun simctl shutdown all

path=$(find ~/Library/Developer/Xcode/DerivedData/planning-pocker-*/Build/Products/Debug-iphonesimulator -name "planning-pocker.app" | head -n 1)
echo "${path}"

filename=SimulatorsList.txt
grep -v '^#' $filename | while read -r line
do
xcrun simctl boot "$line" # Boot the simulator with identifier hold by $line var
xcrun simctl install "$line" "$path" # Install the .app file located at location hold by $path var at booted simulator with identifier hold by $line var
xcrun simctl launch "$line" com.visikard.planning-pocker # Launch .app using its bundle at simulator with identifier hold by $line var
done
