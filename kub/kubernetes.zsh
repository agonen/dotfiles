
kkk() {
        kubectl exec -it $1 -- /bin/bash
}
kk() {
        space=$(echo $1 | awk '{n=split($0, a, "-"); printf("%s-%s\n", a[n-3], a[n-2])}')
        kubectl exec -it $1 -n $space -- /bin/bash
}
klogs() {
        pod=$1;
        if [[ $pod == aggergator* ]]   ; then
             space=enricher
        else
            echo "Unknown namespace"
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
      kubectl get pods --all-namespaces | grep -vE "default|kube-system"| grep enricher
}

kgetpods_detectors(){
      kubectl get pods --all-namespaces | grep -vE "default|kube-system"| grep detetcors
}

kgetpods_aggergator(){
      kubectl get pods --all-namespaces | grep -vE "default|kube-system"| grep aggergator
}

kdescribepod() {
        space=$(echo $1 | awk '{n=split($0, a, "-"); printf("%s-%s\n", a[n-3], a[n-2])}')
        kubectl describe pod $1 --namespace $space
}

kpodstat(){
        kubectl get pods --all-namespaces | grep -vE "default|kube-system|STATUS"| awk  '{print $4}'  | sort | uniq -c | sort -nr
}

kpodpending() {
        kubectl get pods --all-namespaces | grep -vE "default|kube-system" | grep Pending | sort -k 6
}


(( ${+commands[kubectl]} )) && alias kubectl='test -z $C_KUBE && C_KUBE=1 && source <(command kubectl completion zsh); command kubectl'
alias k='kubectl'
