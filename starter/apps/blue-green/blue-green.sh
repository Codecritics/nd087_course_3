#!/bin/bash

function blue_green_deploy
{
  NUM_OF_BLUE_PODS=$(kubectl get pods -n udacity | grep -c blue)
  echo "BLUE PODS: $NUM_OF_BLUE_PODS"
  TARGET_GREEN_PODS=$NUM_OF_BLUE_PODS
  echo "Number of GREEN PODS will be deployed: $TARGET_GREEN_PODS"

  kubectl scale deployment green --replicas="$TARGET_GREEN_PODS"

   # Check deployment rollout status every 1 second until complete.
  ATTEMPTS=0
  ROLLOUT_STATUS_CMD="kubectl rollout status deployment/green -n udacity"
  until $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 60 ]; do
      $ROLLOUT_STATUS_CMD
      ATTEMPTS=$((ATTEMPTS + 1))
      sleep 1
  done

  NUM_OF_BLUE_PODS=$(kubectl get pods -n udacity | grep -c blue)
  echo "BLUE PODS: $NUM_OF_BLUE_PODS"
  NUM_OF_GREEN_PODS=$(kubectl get pods -n udacity | grep -c green)
  echo "GREEN PODS: $NUM_OF_GREEN_PODS"
}

kubectl apply -f green.yml
blue_green_deploy