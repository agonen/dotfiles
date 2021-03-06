alias k='kubectl'
kkk() {
        kubectl exec -it $1 -- /bin/bash
}
kk() {
        space=$(echo $1 | awk '{n=split($0, a, "-"); printf("%s-%s\n", a[n-3], a[n-2])}')
        kubectl exec -it $1 -n $space -- /bin/bash
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
        space=$(echo $1 | awk '{n=split($0, a, "-"); printf("%s-%s\n", a[n-2], a[n-1])}')
        #job=$(echo $1 | cut -d'-' -f1-4)
        kubectl delete job $1 --namespace $space
}
kgetpods() {
        kubectl get pods --all-namespaces | grep -vE "default|kube-system"
}
kdescribepod() {
        space=$(echo $1 | awk '{n=split($0, a, "-"); printf("%s-%s\n", a[n-3], a[n-2])}')
        kubectl describe pod $1 --namespace $space
}
