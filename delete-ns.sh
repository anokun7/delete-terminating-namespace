#! /bin/bash
kubectl get ns test
secret_name=$(kubectl get sa default -o jsonpath='{.secrets[].name}')
TOKEN=$(kubectl get secret $secret_name -o jsonpath='{.data.token}' | base64 -d)
kubectl get ns test -o json > test-ns.json$$
sed -i '.bk' '/finalizers/{N;s/\n.*//;}' test-ns.json$$
curl -X PUT --data-binary @test-ns.json$$ http://localhost:8080/api/v1/namespaces/test/finalize -H "Content-Type: application/json" --header "Authorization: Bearer $TOKEN" --insecure
kubectl get ns test
sleep 5
kubectl get ns test
