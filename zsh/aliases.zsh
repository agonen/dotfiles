alias reload!='. ~/.zshrc'

alias sublime='reattach-to-user-namespace sublime'
alias open='reattach-to-user-namespace open'

alias gssh='gcloud compute ssh '
alias cls='clear' # Good 'ol Clear Screen command


alias tailf="tail -f "


alias tabview='vd'

mount_brodmann33() {
	sshfs brodmann-33:$1 ${HOME}/media/brodmann-33/$1 -o allow_other -o ro
}

start_vpn() {
  sudo openfortivpn -c /etc/openfortivpn/my-config  > /dev/null &
}
