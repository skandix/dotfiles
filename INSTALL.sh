#/usr/bin/env bash

## Color Variables
magenta=$'\e[1;35m'
red=$'\e[1;31m'
green=$'\e[1;32m'
cyan=$'\e[1;36m'
normie=$'\e[0m'

## String Variables
newline=$'\n'
inputArrow=" ---> "

## Directories
dots=~/.dotfiles/files/dots/
confs=~/.dotfiles/files/confs/
script=~/.dotfiles/scripts/
misc=~/.dotfiles/files/misc/

# Find all dotfiles(.examplerc) and dotconfigs($HOME/.config/example)
dotsDetect=$(find $dots -maxdepth 1 -name '*' ! -name 'dots' ! -name '*.' -printf '%f ')
confsDetect=$(find $confs -maxdepth 1 -name '*' ! -name 'confs' ! -name '*.' -printf '%f ')
scriptDetect=$(find $confs -maxdepth 1 -name '*.sh' ! -name 'scrips' ! -name '*.' -printf '%f ')

# create these dirs for later
mkdir $HOME/gitclones 2>1
mkdir $HOME/.jordeple 2>1
mkdir $HOME/Projects 2>1
mkdir $HOME/.ssh 2>1

motd(){
#Ascii Logo <3
echo ""
echo "$magenta"
echo '______      _                                       '
echo '|  _  \    | |                                      '
echo '| | | |__ _| |_ __ _ _ __   ___  _ __   ____   ___  '
echo '| | | / _  | __/ _` |  _ \ / _ \|  __| |  _ \ / _ \ '
echo '| |/ / (_| | || (_| | |_) | (_) | | _  | | | | (_) |'
echo '|___/ \__,_|\__\__,_| .__/ \___/|_|(_) |_| |_|\___/ '
echo '                    | |                             '
echo '                    |_|                             '
echo "$normie"
}

dirExsists(){
echo ""
	if [ -d $1 ]
	then
		echo "$green [O.K] Found $1 $normie"
	else
		echo "$red [Error]: Can't find $1, Creating directory $normie"
		mkdir -p $1
	fi
}

# Symlink all dotfiles
dotfiles(){
echo ""
read -p "$cyan [Dotfiles] $normie Symlink dotfiles ? $magenta y/n$normie $newline$inputArrow" option
echo ""
case "$option" in
	y|Y) echo "$green Yes $normie";
		for dotfile in $dotsDetect; do
			ln -svfn $dots$dotfile ~/$dotfile 2>/dev/null
		done;;
	n|N|* ) echo "$red No $normie";;
esac
echo
}

# Symlinks all files that goes in /home/$USER/.config
dotconfig(){
echo ""
read -p "$cyan [DotConfigs] $normie Symlink dotconfig? $magenta y/n$normie $newline$inputArrow" option
echo ""
case "$option" in
	y|Y ) echo "$green Yes $normie";
		dirExsists $HOME/.config
		for dotconfig in $confsDetect; do
			ln -svfn $confs$dotconfig ~/.config/$dotconfig
		done;;
	n|N|* ) echo "$red No $normie";;
esac
echo
}


scripts(){
echo ""
read -p "$cyan [Scripts] $normie Symlink scripts? $magenta y/n$normie $newline$inputArrow" option
echo ""
case "$option" in
	y|Y ) echo "$green Yes $normie";
		for sh in $scriptDetect; do
			sudo ln -svfn $script$sh /bin/$sh
		done;;
	n|N|* ) echo "$red No $normie";;
esac
echo
}

#Install Awesome, Compton and Xorg
xorg(){
echo ""
read -p "$cyan [GUI] $normie Install Awesome,compton & Xorg? $magenta y/n$normie $newline$inputArrow" option
echo ""
case "$option" in
	y|Y ) echo "$green Yes $normie";
		sudo apt update;

		echo "$cyan [AWESOME] $normie";
        wallpapers=$(ls $misc/wallpapers | shuf | head -n 1)
	    sudo apt install awesome awesome-extra -y;
		sudo ln -svfn $misc/wallpapers/$wallpapers /usr/share/awesome/themes/default/background.png;

		echo "$cyan [COMPTON] $normie";
		sudo apt install compton -y;

		echo "$cyan [XORG] $normie";
		sudo apt install xorg -y;;

	n|N|* ) echo "$red No $normie";;
esac
echo
}

cpu(){
	echo ""
	echo "$cyan [CPU] $normie Detecting & Installing CPU firmware"
	echo ""
	if grep -q "AMD" "/proc/cpuinfo"; then
		echo "$green [O.K] Found AMD CPU $normie Installing CPU Firmware"
		echo ""
		sudo apt install amd64-microcode
	elif grep -q "Intel" "/proc/cpuinfo" ; then
		echo "$green [O.K] Found Intel CPU $normie Installing CPU Firmware"
		echo ""
		sudo apt install intel-microcode
	else
		echo "$red[ERROR] CPU is not known... $normie"
	fi
}

packages(){
echo ""
read -p "$cyan [Packages] $normie What Packages? $newline$magenta 1:$normie Laptop $newline$magenta 2:$normie Workstation $newline$magenta 3:$normie Server $newline$magenta 4:$normie Minimal Server $newline$inputArrow" option
echo ""
case "$option" in
	1 ) echo "$cyan Laptop $normie"; 
		sudo apt install dunts rofi neofetch mpv screen pulseaudio pavucontrol tmux python3.7 python3.7-dev rxvt-unicode-256color moc dirmngr xbacklight wicd-curses firmware-iwlwifi ntfs-3g keepassx -y;
		mkdir /etc/X11/xorg.conf.d -p;
		sudo ln -sfvn $misc/70-synaptics.conf /etc/X11/xorg.conf.d/70-synaptics.conf;;

	2 ) echo "$cyan Workstation $normie"; 
		sudo apt install dunst rofi neofetch mpv screen pulseaudio pavucontrol tmux python3.7 python3.7-dev rxvt-unicode-256color moc dirmngr ntfs-3g keepassx -y;;

	3 ) echo "$cyan Server $normie"; 
		sudo apt install neofetch screen tmux python3.7 python3.7-dev dirmngr ntfs-3g -y;;

	4 ) echo "$cyan Minimal Server $normie";
		sudo apt install neofetch screen tmux ntfs-3g -y;;

	n|N|* ) echo "$red No $normie";;
esac
echo
}

##Install Vim plugins?
neovim(){
echo ""
read -p "$cyan [Neovim] $normie Install Neovim & Vim Plug? $magenta y/n$normie $newline$inputArrow" option
echo ""
case "$option" in
	y|Y ) echo "Yes";
		echo "\n$cyan [Neovim] $normie Installing Neovim";
		curl -LO https://github.com/neovim/neovim/releases/download/v0.3.4/nvim.appimage;
		chmod u+x nvim.appimage;
		sudo mv nvim.appimage /opt;
		sudo ln -sfvn /opt/nvim.appimage /bin/vim;
		dirExsists /home/$USER/.config/nvim/;
		ln -fvsn /home/$USER/.vimrc /home/$USER/.config/nvim/init.vim;

		echo "\n$cyan [Plug] $normie Installing Vim Pluging Manager";
		curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim;

		pip3 install --upgrade neovim;
		vim +PlugInstall +all;;
	n|n|* ) echo "$red No";;
esac
echo
}

##Install Docker
docker(){
echo ""
read -p "$cyan [Docker] $normie Install Docker?  $magenta y/n$normie $newline$inputArrow" option
echo ""
case "$option" in
	y|Y ) echo "$green Yes $normie";
		cd /tmp
		sudo apt update;
		sudo apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y;
		curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -;
		sudo $(curl -s https://docs.docker.com/install/linux/docker-ce/debian/\#set-up-the-repository | egrep "(apt-key fingerprint ([0-9A-F]{8}))" | cut -d'>' -f 9);
		sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable";
		sudo apt update;
		sudo apt install docker-ce -y;;
	n|N|* ) echo "$red No $normie";;
esac
echo
}

##Install Docker-compose
docker_compose(){
echo ""
read -p "$cyan [Docker-Compose] $normie Install Docker-compose? $magenta y/n$normie $newline$inputArrow" option
echo ""
case "$option" in
	y|Y ) echo "$green Yes $normie";
		cd /tmp;
		sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose;
		sudo chmod +x /usr/local/bin/docker-compose;;
	n|N|* ) echo "$red No $normie";;
esac
echo
}

### MAIN ###
# TODO: MAke arch specific meny and vice versa for debian
# TODO: clean configs.. setup auto git commit shit from each  system.
# TODO: Automated Arch install
# :thinking: Detect on uname hmm, or that migth be a bit shit..

motd
dotfiles
dotconfig
scripts
packages
cpu
neovim
docker
docker_compose
