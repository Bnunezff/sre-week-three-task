NAMESPACE="sre"
DEPLOYMENT="swype-app"
MAX_RESTARTS=4
RESTART_INTERVAL=60

while true; do
  RESTARTS=$(kubectl get pods -n ${NAMESPACE} -l app=${DEPLOYMENT} -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}")
  echo "Pod restart count: ${RESTARTS}"
  
  if (( RESTARTS > MAX_RESTARTS )); then
    echo "Excessive restarts detected. Initiating deployment scaling..."
    kubectl scale deployment/${DEPLOYMENT} --replicas=0 -n ${NAMESPACE}
    echo "Deployment scaled down."
    break
  fi
  
  echo "No excessive restarts detected. Waiting for ${RESTART_INTERVAL} seconds before next check..."
  sleep ${RESTART_INTERVAL}
done
