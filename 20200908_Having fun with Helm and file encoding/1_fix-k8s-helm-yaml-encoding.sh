### fixing encoding error when creating Kubernetes manifest/Helm chart
### Error: unable to build kubernetes objects from release manifest: error parsing : error converting YAML to JSON: yaml: invalid leading UTF-8 octet

# output nginx deployment to .yaml file (with default encoding)
kubectl create deployment nginx --image=nginx --dry-run=client --output=yaml > .\ourchart\templates\deployment.yaml

# installing helm chart from .yaml file above
helm install ourchart .\ourchart
# Error: unable to build kubernetes objects from release manifest: error parsing : error converting YAML to JSON: yaml: invalid leading UTF-8 octet

# fixing encoding in .yaml output
kubectl create deployment nginx --image=nginx --dry-run=client --output=yaml | Out-File .\ourchart\templates\deployment.yaml -Encoding UTF8
