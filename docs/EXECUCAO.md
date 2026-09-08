# Roteiro de execução rápida

Versão "só os comandos" para rodar os três ambientes, coletar evidências e apagar
tudo. As explicações completas estão no [`TUTORIAL.md`](../TUTORIAL.md).

- Tempo total: **~3 a 4 horas** (a maior parte é esperar o cluster da AWS).
- Custo se apagar tudo no fim: **~US$ 1 a 3** (só a AWS cobra de verdade).
- Precisa de cartão de crédito nas três contas.
- Cada `SALVAR PRINT:` indica um arquivo para colocar em `docs/evidencias/`.

Placeholders a substituir: `DOCKERHUB_USER`, `ACR_NOME` (só letras/números minúsculos,
único no mundo), `IP_DA_VPS`, `ACCOUNT_ID`.

---

## Fase 0 — Local (grátis, ~30 min)

Pré: instalar Docker Desktop e Git. Ter conta no Docker Hub.

```bash
git clone https://github.com/dpRanghetti/biblioteca.git
cd biblioteca
git log -1 --format="%H %ci"

# copiar os arquivos deste repo para dentro da pasta biblioteca:
copy <pasta-deste-repo>\Dockerfile .
copy <pasta-deste-repo>\.dockerignore .

docker build -t biblioteca:1.0 .
docker image ls biblioteca
```
`SALVAR PRINT: local-01-build.png` (fim do build + `docker image ls`)

```bash
docker run --name biblioteca-local -p 8080:8080 -e API_SECURITY_TOKEN_SECRET=troca-isto-por-uma-chave-grande biblioteca:1.0
```
Abrir `http://localhost:8080/login`, entrar com `admin` / `admin`, cadastrar um autor
e um livro.
`SALVAR PRINT: local-02-login.png` (tela após login)
`SALVAR PRINT: local-03-operacao.png` (autor ou livro cadastrado)

```bash
docker logs biblioteca-local
```
`SALVAR PRINT: local-04-logs.png`

```bash
docker stop biblioteca-local && docker rm biblioteca-local

docker login
docker tag biblioteca:1.0 docker.io/DOCKERHUB_USER/biblioteca:1.0
docker push docker.io/DOCKERHUB_USER/biblioteca:1.0
```
`SALVAR PRINT: local-05-dockerhub.png` (repositório público no site do Docker Hub)

No `k8s/base/deployment.yaml`, trocar a linha `image:` por
`docker.io/DOCKERHUB_USER/biblioteca:1.0`.

---

## Fase 1 — Hetzner + K3s (centavos, ~30 min)

Pré: conta na Hetzner Cloud, um projeto criado, chave SSH adicionada.

1. Console Hetzner: **Add Server** → Ubuntu 24.04, tipo **CX22**, sua chave SSH.
2. Console: criar um **Firewall** e associar ao servidor, liberando entrada TCP nas
   portas **22, 80, 443, 30080**.
3. Anotar o IP público.
`SALVAR PRINT: hetzner-01-servidor.png` (servidor criado, com produto e localização)

```bash
ssh root@IP_DA_VPS
curl -sfL https://get.k3s.io | sh -
k3s kubectl get nodes
```
`SALVAR PRINT: hetzner-02-nodes.png`

```bash
git clone https://github.com/Renan0204/t3-biblioteca-multicloud.git
cd t3-biblioteca-multicloud
# conferir que k8s/base/deployment.yaml já tem a imagem do Docker Hub

k3s kubectl create secret generic biblioteca-secret --from-literal=jwt-secret="$(openssl rand -base64 32)"
k3s kubectl apply -f k8s/base/deployment.yaml
k3s kubectl apply -f k8s/vps/service-nodeport.yaml
k3s kubectl rollout status deployment/biblioteca
k3s kubectl get pods,svc
```
`SALVAR PRINT: hetzner-03-pods.png` (pod `1/1 Running` + service NodePort)

Abrir `http://IP_DA_VPS:30080/login`, entrar com `admin` / `admin`, fazer uma operação.
`SALVAR PRINT: hetzner-04-app.png`

```bash
k3s kubectl logs deployment/biblioteca --tail=40
```
`SALVAR PRINT: hetzner-05-logs.png`

> Pode deixar rodando e apagar na Fase 4, ou apagar agora (Fase 4, item Hetzner).

---

## Fase 2 — Microsoft Azure (AKS) (~grátis, ~30 min)

Pré: conta Azure com assinatura ativa. Instalar a CLI `az`.

```bash
az login
az account show --output table
az group create --name rg-biblioteca --location eastus
```
`SALVAR PRINT: azure-01-grupo.png`

```bash
az acr create --resource-group rg-biblioteca --name ACR_NOME --sku Basic
az acr login --name ACR_NOME
docker tag biblioteca:1.0 ACR_NOME.azurecr.io/biblioteca:1.0
docker push ACR_NOME.azurecr.io/biblioteca:1.0
```
`SALVAR PRINT: azure-02-acr.png` (imagem no ACR)

```bash
az aks create --resource-group rg-biblioteca --name biblioteca --node-count 1 --node-vm-size Standard_B2s --tier free --attach-acr ACR_NOME --generate-ssh-keys
az aks get-credentials --resource-group rg-biblioteca --name biblioteca
kubectl get nodes
```
`SALVAR PRINT: azure-03-nodes.png`

Se usou o ACR, ajustar `image:` no `deployment.yaml` para `ACR_NOME.azurecr.io/biblioteca:1.0`.

```bash
kubectl create secret generic biblioteca-secret --from-literal=jwt-secret="$(openssl rand -base64 32)"
kubectl apply -f k8s/base/deployment.yaml
kubectl apply -f k8s/managed/service-loadbalancer.yaml
kubectl rollout status deployment/biblioteca
kubectl get service biblioteca -w
```
Esperar o `EXTERNAL-IP` aparecer (~2 min).
`SALVAR PRINT: azure-04-pods-service.png` (pod Running + service com IP)

Abrir `http://EXTERNAL-IP/login`, logar, fazer uma operação.
`SALVAR PRINT: azure-05-app.png`
```bash
kubectl logs deployment/biblioteca --tail=40
```
`SALVAR PRINT: azure-06-logs.png`

---

## Fase 3 — AWS (Amazon EKS) (~US$ 1, ~50 min)

Pré: conta AWS. Instalar `aws` (v2) e `eksctl`. Ter as Access Keys.

```bash
aws configure                       # chave, segredo, regiao us-east-1, json
aws sts get-caller-identity
```
`SALVAR PRINT: aws-01-identidade.png` (ocultar o Account ID)

```bash
aws ecr create-repository --repository-name biblioteca --region us-east-1
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com
docker tag biblioteca:1.0 ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/biblioteca:1.0
docker push ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/biblioteca:1.0
```
`SALVAR PRINT: aws-02-ecr.png`

Ajustar `image:` no `deployment.yaml` para o endereço do ECR.

```bash
eksctl create cluster --name biblioteca --region us-east-1 --nodes 1 --node-type t3.medium --managed
# 15 a 20 minutos
aws eks update-kubeconfig --name biblioteca --region us-east-1
kubectl get nodes
```
`SALVAR PRINT: aws-03-nodes.png`

```bash
kubectl create secret generic biblioteca-secret --from-literal=jwt-secret="$(openssl rand -base64 32)"
kubectl apply -f k8s/base/deployment.yaml
kubectl apply -f k8s/managed/service-loadbalancer.yaml
kubectl rollout status deployment/biblioteca
kubectl get service biblioteca -w
```
Esperar o `EXTERNAL-IP` (um endereço `...elb.amazonaws.com`, ~3–5 min).
`SALVAR PRINT: aws-04-pods-service.png`

Abrir `http://EXTERNAL-IP/login`, logar, fazer uma operação.
`SALVAR PRINT: aws-05-app.png`
```bash
kubectl logs deployment/biblioteca --tail=40
```
`SALVAR PRINT: aws-06-logs.png`

---

## Fase 4 — Apagar tudo (CRÍTICO, ~30 min)

### AWS
```bash
kubectl delete -f k8s/managed/service-loadbalancer.yaml   # remove o balanceador ANTES
kubectl delete deployment biblioteca
eksctl delete cluster --name biblioteca --region us-east-1
aws ecr delete-repository --repository-name biblioteca --region us-east-1 --force
```
Conferir no console: EKS sem cluster, EC2 → Load Balancers vazio, EC2 → Volumes sem
EBS órfão, CloudFormation sem stacks `eksctl-biblioteca-*`.
`SALVAR PRINT: aws-07-limpeza.png`

### Azure
```bash
az group delete --name rg-biblioteca --yes --no-wait
```
Conferir que `rg-biblioteca` e `MC_rg-biblioteca_biblioteca_eastus` sumiram.
`SALVAR PRINT: azure-07-limpeza.png`

### Hetzner
```bash
ssh root@IP_DA_VPS "/usr/local/bin/k3s-uninstall.sh"
```
Console Hetzner: apagar o **Server**, o **Firewall** e (se não for reusar) a chave SSH.
Conferir a aba **Usage / Billing**.
`SALVAR PRINT: hetzner-07-limpeza.png`

### Docker Hub
Opcional: manter a imagem pública (não gera custo) ou apagar o repositório.

---

## Fase 5 — Montar as evidências

1. Colocar todos os PNG em `docs/evidencias/` com os nomes acima.
2. Ocultar nos prints: tokens, chaves, Account/Subscription ID, dados de cobrança.
3. Inserir as evidências na seção 11 do `TUTORIAL.md`, anotar os problemas
   encontrados (Slide 56), preencher os preços do dia na seção 12.1 e regenerar o PDF.
4. Subir:
   ```bash
   cd <pasta-local-do-repositorio>
   git add -A
   git commit -m "Adiciona evidencias de execucao e precos do dia"
   git push
   ```
