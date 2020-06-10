project_id="bd17-gcp"
zone=us-central1-c
instance_name=amihay-1

alias gsetproject_prod="gcloud config set project bd17-gcp"
alias gsetproject_dev="gcloud config set project cortex-dev-244007"

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
#

cstartvm() {
	disk_name=$2
	mode=${3:-ro}
	instance_name=${1:-amihay-1}
	project_id=bd17-gcp
	zone=us-central1-c

	echo "starting ${intance_name} with ${disk_name} mode ${mode}"
	gcloud compute instances start ${instance_name} --zone us-central1-c --project ${GCP_PROD_PROJECT}
    if [ "$disk_name" != "" ];
    then 
    	mount_dir="/home/ubuntu/user_mnt/disks/new_disk"
		device_id=/dev/disk/by-id/google-${disk_name}
		gcloud compute instances attach-disk ${instance_name} --mode="${mode}" --disk ${disk_name} --device-name ${disk_name} --project=${project_id}
		gcloud compute ssh ubuntu@${instance_name} --project=${project_id} --command="mkdir -p ${mount_dir}"
		gcloud compute ssh ubuntu@${instance_name} --project=${project_id} --command="sudo umount ${mount_dir}"
		gcloud compute ssh ubuntu@${instance_name} --project=${project_id} --command="sudo mount -o ${mode},discard,defaults,nofail ${device_id} ${mount_dir}"
	fi
    gcloud compute ssh ubuntu@${instance_name} --zone us-central1-c --project ${GCP_PROD_PROJECT}
}

gdiskslist() {
  gcloud compute instances list --filter="disks[].deviceName~cortex-read-only*" --format="value(name,disks[].deviceName)"| cut -d';' -f2| sort|uniq |grep cortex
}

alias g_activeate_brodmann="gcloud config configurations activate brodmann-config"
