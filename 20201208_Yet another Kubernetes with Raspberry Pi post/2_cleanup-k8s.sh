### returns Kubernetes to initial state after testing

# cleanup
kubectl delete deployment -l app=redis
# deployment.apps "redis-master" deleted
# deployment.apps "redis-slave" deleted
 
kubectl delete service -l app=redis
# service "redis-master" deleted
# service "redis-slave" deleted
 
kubectl delete deployment -l app=guestbook
# deployment.apps "frontend" deleted
 
kubectl delete service -l app=guestbook
# service "frontend" deleted
 
kubectl get pods
# No resources found in default namespace.
