c() {
        gcloud compute ssh ubuntu@$1 --zone us-east1-c
}
cc() {
        gcloud compute ssh ubuntu@$1 --zone us-central1-c
}
cdev() {
        gcloud compute ssh ubuntu@$1 --zone us-east1-c --project cortex-dev-244007
}

alias gls='gsutil ls '

alias gssh='gcloud compute ssh '

alias g='gcloud'
alias gc='gcloud compute'
