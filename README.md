# Monitor Ping Latency Across AWS Regions

The ping latency within a region is much less than between regions. This much is obvious but how much variance is there in intra-region latency timing? And when does it spike during certain times or coincide with your application connection issues?

This project shows are way to monitor intra-region ping times.

# us-east-1c
ssh -i ~/.ssh/odol-sango.pem ec2-user@34.227.7.33

# us-east-1e
ssh -i ~/.ssh/odol-sango.pem ec2-user@3.87.3.86

#!/bin/bash
cat <<EOF > push-latency-metric.sh
  INSTANCE_ID=$(curl --silent http://169.254.169.254/latest/meta-data/instance-id)
  METRIC=$(ping -c 1 34.227.7.33 | head -n 2 | tail -n 1 | cut -d'=' -f4 | cut -d' ' -f1)
  echo "$INSTANCE_ID: $METRIC"

  aws cloudwatch put-metric-data \
    --metric-name ping-latency-us-east-1c-to-us-east-1e \
    --dimensions Instance=$INSTANCE_ID \
    --namespace "Custom" \
    --value $METRIC
EOF
chmod +x push-latency-metric.sh

cat <<EOF > repeat.sh
#!/bin/bash
while true
do
 ./push-latency-metric.sh
 sleep 60
done
EOF
chmod +x repeat.sh

nohup ./repeat.sh &
