alias kube='kubectl'

kkk() {
  kubectl exec -it $1 -- /bin/bash
}

kk() {
  space=$(echo $1 | awk '{n=split($0, a, "-"); printf("%s-%s\n", a[n-3], a[n-2])}')
  kubectl exec -it $1 -n $space -- /bin/bash
}

kkm() {
  space=$(echo $1 | awk '{n=split($0, a, "-"); printf("%s-%s\n", a[n-3], a[n-2])}')
  kubectl exec -it $1 -n $space --cluster=gke_bd17-gcp_us-central1-c_cluster-main -- /bin/bash
}

knvidia() {
  space=$(echo $1 | awk '{n=split($0, a, "-"); printf("%s-%s\n", a[n-3], a[n-2])}')
  kubectl exec -it $1 -n $space -- nvidia-smi
}

klogs() {
  space=$(echo $1 | awk '{n=split($0, a, "-"); printf("%s-%s\n", a[n-3], a[n-2])}')
  kubectl logs $2 $1 --namespace $space
}

kdelpod() {
  space=$(echo $1 | awk '{n=split($0, a, "-"); printf("%s-%s\n", a[n-3], a[n-2])}')
  kubectl delete pod $1 --namespace $space
}

kdeljob() {
  space=$(echo $1 | awk '{n=split($0, a, "-"); printf("%s-%s\n", a[n-3], a[n-2])}')
  job=$(echo $1 | cut -d'-' -f1-4)
  kubectl delete job $job --namespace $space
}

kpods() {
  kubectl get pods --all-namespaces | grep -vE "default|kube-system"
}

kedesc() {
  kubectl describe pod $1 --namespace enricher
}

kddesc() {
  kubectl describe pod $1 --namespace detector
}

kdescribepod() {
  space=$(echo $1 | awk '{n=split($0, a, "-"); printf("%s-%s\n", a[n-3], a[n-2])}')
  kubectl describe pod $1 --namespace $space
}

kdp1() {
  space=$(echo $1 | awk '{n=split($0, a, "-"); printf("%s-%s\n", a[n-3], a[n-2])}')
  kubectl describe pod $1 --namespace $space
}

kpodstat(){
        kubectl get pods --all-namespaces | grep -vE "default|kube-system|STATUS"| awk  '{print $1 ">" $4}'  | sort | uniq -c | sort -nr
}
kpodpending() {
        kubectl get pods --all-namespaces | grep -vE "default|kube-system" | grep Pending | sort -k 6
}

ktrain() {
  gcloud container clusters get-credentials cluster-train --zone us-central1-c
}

kbenchmark() {
  gcloud container clusters get-credentials cluster-regular-us-central1-c --zone us-central1-c
}

kmedulla() {
  gcloud container clusters get-credentials cluster-medulla --zone us-central1-c
}

kgetpodsbytime_enricher() {
        kubectl get pods -nenricher --sort-by=.metadata.creationTimestamp | grep -vE "kube-system"
}

kgetpodsbytime() {
        kubectl get pods --all-namespaces --sort-by=.metadata.creationTimestamp | grep -vE "kube-system"
}

kdlogs() {
        kubectl logs $2 $1 --namespace detector -f
}

kelogs() {
        kubectl logs $2 $1 --namespace enricher -f
}


#----------------------------------------------------------------------


klogs() {
        pod=$1;
        if [[ $pod == object* ]]   ; then
             space=enricher
	fi
        if [[ $pod == distance* ]]   ; then
             space=enricher
	fi
        if [[ $pod == detector* ]]   ; then
             space=detector
	fi
        if [[ $pod == aggergator* ]]   ; then
             space=enricher
	fi

        kubectl logs $pod --namespace $space
}

kdispatcher() {
    dispatcher_pod=`kubectl get pods --all-namespaces | grep dispatcher|awk '{print $2}'`
    echo dispatcher=$dispatcher_pod
    command_to_do=$1
    shift
    case ${command_to_do} in
        log)
            kubectl logs $dispatcher_pod --namespace default $*
            ;;
        bash)
            kubectl exec -it ${dispatcher_pod} --namespace default -- /bin/bash
            ;;
    esac
}

klogin() {
            kubectl exec -it $1 --namespace $2 -- /bin/bash

}

kdelpod() {
        space=$(echo $1 | awk '{n=split($0, a, "-"); printf("%s-%s\n", a[n-3], a[n-2])}')
        kubectl delete pod $1 --namespace $space
}
kdeljob() {
        space=$(echo $1 | awk '{n=split($0, a, "-"); printf("%s-%s\n", a[n-2], a[n-1])}')
        #job=$(echo $1 | cut -d'-' -f1-4)
        kubectl delete job $1 --namespace $space
}
kgetpods() {
        kubectl get pods --all-namespaces | grep -vE "default|kube-system"
}

kgetpods_enrichers(){
      kubectl get pods --namespace enricher  
}

kgetpods_detectors(){
      kubectl get pods --namespace detector  
}

kegetpods_running(){
      kubectl get pods --namespace enricher  --field-selector status.phase=Running
}

kdgetpods_running(){
      kubectl get pods --namespace detector  --field-selector status.phase=Running
}

kgetpods_aggergator(){
      kubectl get pods --namespace enricher  | grep aggergator
}

kdescribepod() {
        space=$(echo $1 | awk '{n=split($0, a, "-"); printf("%s-%s\n", a[n-3], a[n-2])}')
        kubectl describe pod $1 --namespace $space
}

kclouddemo_prod_logs() {
    kubectl logs $(kubectl get pod | grep prod  | grep Running | awk '{print $1}') -f
}

kclouddemo_dev_logs() {
    kubectl logs $(kubectl get pod | grep dev  | grep Running | awk '{print $1}') -f
}

kclouddemo_dev_bash() {
    kubectl exec -it $(kubectl get pod | grep dev  | grep Running | awk '{print $1}') -- bash
}

kclouddemo_prod_bash() {
    kubectl exec -it $(kubectl get pod | grep prod  | grep Running | awk '{print $1}') -- bash
}

# (( ${+commands[kubectl]} )) && alias kubectl='test -z $C_KUBE && C_KUBE=1 && source <(command kubectl completion zsh); command kubectl'
# alias k='kubectl'
