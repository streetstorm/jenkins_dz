#!/bin/sh
for namespace in "dev" "test" "prod"
do
cat <<EOF | ./kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: $namespace
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-time
  namespace: $namespace
spec:
  replicas: 1
  selector:
    matchLabels:
      app: test-time
  template:
    metadata:
      labels:
        app: test-time
    spec:
      containers:
        - name: hostname
          image: curlimages/curl:7.69.1
          command: ["/bin/sh"]
          args: ["-c", "while true; do echo \$(date +%T) \$(hostname) 2>&1 | tee -a ~/my_log; sleep 5; echo \"number_of_lines \$(cat ~/my_log | wc -l)\" | curl --data-binary @- http://pushgateway:9091/metrics/job/my_job/instance/\$(hostname); done"]
---
apiVersion: v1
kind: Service
metadata:
  name: pushgateway
  namespace: $namespace
  labels:
    app: pushgateway
spec:
  ports:
  - port: 9091
  selector:
    app: pushgateway
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pushgateway
  namespace: $namespace
  labels:
    app: pushgateway
spec:
  replicas: 1
  selector:
    matchLabels:
      app: pushgateway
  template:
    metadata:
      labels:
        app: pushgateway
    spec:
      containers:
      - name: pushgateway
        image: prom/pushgateway:v1.3.1
        ports:
        - containerPort: 9091
EOF
done
