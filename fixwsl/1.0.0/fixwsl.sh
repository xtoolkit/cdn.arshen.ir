#!/bin/bash

function findUser() {
    thisPID=$$
    origUser=$(whoami)
    thisUser=$origUser

    while [ "$thisUser" = "$origUser" ]
    do
        ARR=($(ps h -p$thisPID -ouser,ppid;))
        thisUser="${ARR[0]}"
        myPPid="${ARR[1]}"
        thisPID=$myPPid
    done

    getent passwd "$thisUser" | cut -d: -f1
}

user=$(findUser)

mkdir ~/fixwsl

echo '#!/bin/bash
bash' | tee ~/fixwsl/autostart.sh > /dev/null

chown -R $user:$user ~/fixwsl

chmod -R 777 ~/fixwsl
chmod 666 ~/fixwsl/autostart.sh

echo 'Set WshShell = CreateObject("WScript.Shell") 
WshShell.Run "C:\Windows\System32\bash.exe -c ""bash ~/fixwsl/autostart.sh""",0
Set WshShell = Nothing' | tee /mnt/c/ProgramData/Microsoft/Windows/Start\ Menu/Programs/Startup/fixwsl.vbs > /dev/null
