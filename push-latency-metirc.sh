#!/bin/bash

INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
METRIC=$(ping -c 1 bbc.com | head -n 2 | tail -n 1 | cut -d'=' -f4 | cut -d' ' -f1)

aws cloudwatch put-metric-data \
  --metric-name ping-to \
  --dimensions $INSTANCE_ID \
  --namespace "Custom" \
  --value $METRIC
