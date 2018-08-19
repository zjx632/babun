#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"

# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"
src="$babun_source/babun-core/plugins/core/src"

typeset -i installed_version
installed_version=$(cat "$babun/installed/core" || echo "0")

cp -rf $src/babun /usr/local/bin
chmod 755 /usr/local/bin/babun

cp -rf /usr/local/etc/babun.rc /usr/local/etc/babun.rc.old || echo ""
cp -rf $src/babun.rc /usr/local/etc
source /usr/local/etc/babun.rc

cp -rf $src/babun.bash /usr/local/etc
cp -rf $src/babun.zsh /usr/local/etc
cp -rf $src/babun.start /usr/local/etc
cp -rf $src/babun.instance /usr/local/etc

mkdir -p "$babun/home/core"
cp -rf $src/.babunrc "$babun/home/core/.babunrc"


profiles=("/etc/bash.bashrc")
for profile in "${profiles[@]}"; do
    if ! grep -Fxq "source /usr/local/etc/babun.rc" "$profile" ;then
        echo "Supplementing shell with babun.rc -> $profile"
        echo "source /usr/local/etc/babun.rc" >> "$profile"
    fi

    if ! grep -Fxq "source /usr/local/etc/babun.bash" "$profile" ;then
        echo "Supplementing bash -> $profile"
        echo "source /usr/local/etc/babun.bash" >> "$profile"
    fi

    if ! grep -Fxq "source /usr/local/etc/babun.start" "$profile" ;then
        echo "Adding startup script -> $profile"
        echo "source /usr/local/etc/babun.start" >> "$profile"
    fi
done

if ! [ -f /etc/zshrc ]; then
    touch /etc/zshrc
    chmod 755 /etc/zshrc
fi

profiles=("/etc/zshrc")
for profile in "${profiles[@]}"; do
    if ! grep -Fxq "source /usr/local/etc/babun.rc" "$profile" ;then
        echo "Supplementing shell with babun.rc -> $profile"
        echo "source /usr/local/etc/babun.rc" >> "$profile"
    fi

    if ! grep -Fxq "source /usr/local/etc/babun.zsh" "$profile" ;then
        echo "Supplementing zsh -> $profile"
        echo "source /usr/local/etc/babun.zsh" >> "$profile"
    fi

    if ! grep -Fxq "source /usr/local/etc/babun.start" "$profile" ;then
        echo "Adding startup script -> $profile"
        echo "source /usr/local/etc/babun.start" >> "$profile"
    fi
done

# COMPATIBILITY FIXES
if [[ "$installed_version" -le 1 ]]; then
    echo "Compatibility fixes [core] version=[$installed_version]"

    # fix permissions on cygdrive
    echo "Fixing /etc/fstab permissions on /cygdrive"
    sed -e "s/binary,posix/binary,noacl,posix/" -i /etc/fstab

    # fix /etc/passwd in case the $HOME variable is set to the user's Windows HOME folder
    if [[ "$HOME" == /cygdrive* ]]; then
        echo "Fixing /etc/passwd for a Windows based home folder"
        mkpasswd -l -c -p "$(cygpath -H)" > /etc/passwd
        mkgroup -l -c > /etc/group
        #setting default shell back to /bin/zsh
        sed -i 's/\/bin\/bash/\/bin\/zsh/' "/etc/passwd"
    fi

    # fix permissions in /usr/local
    echo "Fixing permissions"
    chmod 755 -R /usr/local
    chmod u+rwx -R /etc

    # fix mintty problem in the babun.bat launcher (best effort)
    if [[ -f "$BABUN_HOME/babun.bat" ]]; then
        echo "Trying to fix babun.bat launcher"
        sed -i "s/--size 100,35 -o Font='Lucida Console'//" "$BABUN_HOME/babun.bat"
    fi

fi

if [[ "$installed_version" -le 2 ]]; then
    # remove duplicate lines from /etc/zshrc (consequence of #249)
    #awk '!a[$0]++{printf $0}' /etc/zshrc > /etc/zshrc.fixed
    #mv /etc/zshrc.fixed /etc/zshrc
fi
