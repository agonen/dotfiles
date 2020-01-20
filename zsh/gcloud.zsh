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

export GOOGLE_APPLICATION_CREDENTIALS=~/.gsutil/bd17-gcp-84cf3ce5ff0f.json
