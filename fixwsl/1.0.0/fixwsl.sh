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
bash' | sudo tee ~/fixwsl/autostart.sh > /dev/null

chown -R $user:$user ~/fixwsl

chmod -R 777 ~/fixwsl
chmod 666 ~/fixwsl/autostart.sh
