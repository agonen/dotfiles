alias reload!='. ~/.zshrc'


alias cls='clear' # Good 'ol Clear Screen command

alias k='kubectl ' # for kube

alias venv3="source ~/.venv3/bin/activate"
alias venv2="source .venv2/bin/activate"
alias venv="source .venv/bin/activate"

alias tailf="tail -f "

alias g='gcloud'
alias gc='gcloud compute'


ssh_cortex() {
        pkill -f "ssh -i"
        ssh -i "~/.ssh/google_compute_engine" -N -f -L localhost:5000:localhost:5000 ubuntu@cortex-ui
        ssh -i "~/.ssh/google_compute_engine" -N -f -L localhost:5001:localhost:5001 ubuntu@cortex-ui
        ssh -i "~/.ssh/google_compute_engine" -N -f -L localhost:5002:localhost:5001 ubuntu@cortex-ui-dev
        #ssh -i "~/.ssh/google_compute_engine" -N -f -L localhost:3001:localhost:80 ubuntu@cortex-admin-dev
        #ssh -i "~/.ssh/google_compute_engine" -N -f -L localhost:8000:localhost:8000 ubuntu@cortex-admin-dev
}
c() {
        gcloud compute ssh ubuntu@$1 --zone us-east1-c
}
cc() {
        gcloud compute ssh ubuntu@$1 --zone us-central1-c
}
cdev() {
        gcloud compute ssh ubuntu@$1 --zone us-east1-c --project cortex-dev-244007
}

