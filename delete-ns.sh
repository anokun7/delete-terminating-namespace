#! /bin/bash
if [ `kubectl get ns -o jsonpath='{.items[?(@.status.phase=="Terminating")].metadata.name}' | wc -w` -gt 0 ] ; then
  SECRET=$(kubectl get sa default -o jsonpath='{.secrets[].name}')
  TOKEN=$(kubectl get secret $SECRET -o jsonpath='{.data.token}' | base64 -d)
  for ns in `kubectl get ns -o jsonpath='{.items[?(@.status.phase=="Terminating")].metadata.name}'`
  do
    kubectl get ns $ns -o json > /var/tmp/$ns-ns.json$$
    sed -i '.bk' '/finalizers/{N;s/\n.*//;}' /var/tmp/$ns-ns.json$$
    curl -X PUT --data-binary @/var/tmp/$ns-ns.json$$ http://localhost:8080/api/v1/namespaces/$ns/finalize \
      --header "Content-Type: application/json" \
      --header "Authorization: Bearer $TOKEN"
    rm /var/tmp/$ns-ns.json$$
    done
fi

if [ `kubectl get ns -o jsonpath='{.items[?(@.status.phase=="Terminating")].metadata.name}' | wc -w` -gt 0 ] ; then
  sleep 5
fi
kubectl get ns -o jsonpath='{.items[?(@.status.phase=="Terminating")].metadata.name}'
