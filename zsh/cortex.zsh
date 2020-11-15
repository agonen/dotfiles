project_id="bd17-gcp"
zone=us-central1-c
instance_name=amihay-1


create_disk() {
  disk_name=$1
  snapshot_name=$2
  
  if [ "$disk_name" = "" ] || [ "${snapshot_name}" = "" ];
  then 
      echo missing parameters disk_name snapshot
      return
  fi 

  project_id="bd17-gcp"
  zone=us-central1-c

  echo creating disk:${disk_name} from ${snapshot_name}
  disksize=2000
  gcloud compute disks create ${disk_name} \
      --description='read-only volumes for research data ' \
      --labels=system=medulla,creator=$USERNAME,status=inprogress \
      --size=${disksize}GB --type=pd-ssd --source-snapshot=${snapshot_name} \
      --zone=${zone} --project=${project_id}
    
}

mount_disk() {
  disk_name=${1:-disk_name}
  mount_dir="/home/ubuntu/user_mnt/disks/new_disk"
  device_id=/dev/disk/by-id/google-${disk_name}
  gcloud compute instances attach-disk ${instance_name} --mode="rw" --disk ${disk_name} --device-name ${disk_name} --project=${project_id}
  gcloud compute instances start ${instance_name} --zone=${zone} --project=${project_id}
  gcloud compute ssh ubuntu@${instance_name} --project=${project_id} --command="mkdir -p ${mount_dir}"
  gcloud compute ssh ubuntu@${instance_name} --project=${project_id} --command="sudo umount  ${mount_dir}" > /dev/null
  gcloud compute ssh ubuntu@${instance_name} --project=${project_id} --command="sudo umount  /data" >/dev/null
  gcloud compute ssh ubuntu@${instance_name} --project=${project_id} --command="sudo mount -o rw,discard,defaults,nofail ${device_id} ${mount_dir}"
  echo mounted ${disk_name} on %{instance_name}:${mount_dir}
}

create_snapshot(){
  disk_name=${1:-disk_name}
  gcloud compute ssh ubuntu@${instance_name} --project=${project_id} --command="sudo umount  /home/ubuntu/user_mnt/disks/new_disk"
  if [ "$?" != "0" ];
  then
     echo failed to umount
     return
  fi
  gcloud compute instances stop ${instance_name} --zone=${zone} --project=${project_id}
  gcloud compute instances detach-disk ${instance_name}  --disk ${disk_name} --project=${project_id}
  ## create snapshot
  gcloud compute disks snapshot  ${disk_name} --async --snapshot-names=${disk_name} --labels=system=medulla,creator=$USERNAME --zone=${zone} --project=${project_id}
  # verify that we can mount the disk in read-only mode mounting on ${instance_name}
  gcloud compute instances start  ${instance_name} --zone=${zone} --project=${project_id}
  gcloud compute instances attach-disk ${instance_name} --mode="ro" --disk ${disk_name} --device-name ${disk_name} --project=${project_id}
  if [ "$?" != "0" ];
  then
     echo failed to attached ${disk_name} in ro
     return
  fi
  echo created snapshot for disk ${disk_name}
}


validate_readonly_disk(){
  disk_name=${1:-disk_name}
  instance_name=${2:-${USERNAME}-1}
  project_id=${3:-bd17-gcp}
  zone=${4:-us-central1-c}
  gcloud compute instances stop ${instance_name} --zone=${zone} --project=${project_id}
  gcloud compute instances detach-disk ${instance_name}  --disk ${disk_name} --project=${project_id}
  gcloud compute instances start  ${instance_name} --zone=${zone} --project=${project_id}
  gcloud compute instances attach-disk ${instance_name} --mode="ro" --disk ${disk_name} --device-name ${disk_name} --project=${project_id}
  if [ "$?" != "0" ];
  then
     echo failed to attached ${disk_name} in ro
     return "$?"
  fi
 echo ${disk_name} was attached as  read-only successfully
}

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
	disk_name=$1
	mode=${2:-ro}
	instance_name=${3:-amihay-1}
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
