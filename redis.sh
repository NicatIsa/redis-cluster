#!/bin/bash
#### CHECK REDIS CUSTER ##########
echo
echo "Keys on nodes"
echo "-------------"

kubectl -n redis-cluster exec -it redis-0-0 -- redis-cli --cluster check redis-0:6379 | grep keys

echo
echo "Disk usage"
echo "----------"

for POD in $(kubectl -n redis-cluster get pods -l app=redis-cluster | tail -n +2 | awk '{print $1}'); do \
  echo $POD': '$(kubectl -n redis-cluster exec -it $POD -- ls -al | grep appendonly.aof | awk '{print $5" "$6" "$7" "$8}');
done;

echo
echo "Node roles"
echo "----------"

for POD in $(kubectl -n redis-cluster get pods -l app=redis-cluster | tail -n +2 | awk '{print $1}'); do \
  IP=$(kubectl -n redis-cluster get pod $POD -o wide | tail -n +2 | awk '{print $6}')
  echo $POD': '$IP
  kubectl -n redis-cluster exec -it $POD -- redis-cli role;
  echo
done;