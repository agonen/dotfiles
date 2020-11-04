project_id="bd17-gcp"
zone=us-central1-c
instance_name=amihay-1

alias gsetproject_prod="gcloud config set project bd17-gcp"
alias gsetproject_dev="gcloud config set project cortex-dev-244007"

alias g="gcloud"
alias g_ls="gsutil ls"
alias g_cat="gsutil cat"

cprod() {
        gcloud compute ssh ubuntu@$1 --zone us-east1-c --project ${GCP_PROD_PROJECT}
}
ccprod() {
        gcloud compute ssh ubuntu@$1 --zone us-central1-c --project ${GCP_PROD_PROJECT}
}
cdev() {
        gcloud compute ssh ubuntu@$1 --zone us-east1-c --project ${GCP_DEV_PROJECT}
}

alias gsls='gsutil ls '

alias g='gcloud'
alias gc='gcloud compute'

#export GOOGLE_APPLICATION_CREDENTIALS=~/.gsutil/bd17-gcp-84cf3ce5ff0f.json
#export GOOGLE_APPLICATION_CREDENTIALS=~/.gsutil/bd17-gcp-84cf3ce5ff0f.json
#


gdiskslist() {
  gcloud compute instances list --filter="disks[].deviceName~cortex-read-only*" --format="value(name,disks[].deviceName)"| cut -d';' -f2| sort|uniq |grep cortex
}

alias g_activeate_brodmann="gcloud config configurations activate brodmann-config"
