# zero-trust architecture with Istio
Local tests of zero-trust architecture with **Istio**

## Environment setup

1. Provision kind cluster
```bash
cd kind-cluster

./create-clusters.sh 
```
2. Verify cluster is created and you have correct kubernetes context set - cluster: *kind-sicily*
```bash
kubectl config get-contexts

kubectl get pods --all-namespaces
```
3. Download istio
```bash
cd zero-trust & curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.17.2 sh -
```
4. Install Istio with *demo* profile(basic configuration, should be sufficient)
```bash
./zero-trust/istio-1.17.2/bin/istioctl install --set profile=demo -y
```
6. Install sample application - https://istio.io/latest/docs/examples/bookinfo/
```bash
kubectl apply -f zero-trust/istio-1.17.2/samples/bookinfo/platform/kube/bookinfo.yaml
```
8. Verify installation of sample application
```bash
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"
```
10. Access product page from sample application
```bash
kubectl port-forward service/productpage 9080:9080 --namespace default
```
Open http://localhost:9080/ in your browser
11. Install addons for better debugging - Kiali, Prometheus, Grafana and Jaeger
```bash
kubectl apply -f zero-trust/istio-1.17.2/samples/addons
```
wait untill kiali in istio-system namespace is running, then you can open dashboard form cli
```bash
./zero-trust/istio-1.17.2/bin/istioctl dashboard kiali
```
13. Generate some traffic
```bash
kubectl apply -f https://raw.githubusercontent.com/linsun/sample-apps/main/sleep/sleep.yaml

kubectl exec -it deploy/sleep -- sh -c 'for i in $(seq 1 100); do curl -s http://productpage:9080/productpage?u=normal | grep reviews-v.-; done'
```
14. Test that you can access backed services from *sleep* pod
```bash
kubectl exec -it deploy/sleep -- curl -i http://reviews:9080/reviews/0
```
16. Apply **allow-nothing** policy - rejects all requests to the workloads in the *default* namespace
```bash
kubectl apply -f zero-trust/authorization-policy-allow-nothing.yaml -n default 
```
17. Verify no-access to productpage from *sleep* pod
```bash
kubectl exec -it deploy/sleep -- curl -i http://productpage:9080/productpage
```
You should get **403** response code with *RBAC: access denied*
18. Now apply productpage-viewer policy and again check access
```bash
kubectl apply -f zero-trust/authorization-policy-productpage-viewer.yaml -n default

kubectl exec -it deploy/sleep -- curl -i http://productpage:9080/productpage
```