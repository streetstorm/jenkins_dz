#!/bin/sh
for namespace in "dev" "test" "prod"
do
cat <<EOF | ./kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: $namespace
---
apiVersion: v1
kind: Pod
metadata:
  name: test-time
  namespace: $namespace
spec:
  containers:
    - name: hostname
      image: alpine:latest
      command: ["/bin/sh"]
      args: ["-c", "while true; do echo \$(date +%T) \$(hostname); sleep 5;done"]
EOF
done
