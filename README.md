# biblioteca-multicloud

Entregáveis do **Trabalho 3** — Cloud Computing e DevOps Avançado.
Implantação da aplicação [Biblioteca](https://github.com/dpRanghetti/biblioteca)
(Spring Boot 4 / Java 21) com **Docker** e **Kubernetes** em três ambientes:

| Ambiente | Serviço | Papel |
|---|---|---|
| **AWS** | Amazon EKS | Kubernetes gerenciado |
| **Microsoft Azure** | Azure AKS (tier Free) | Kubernetes gerenciado |
| **Hetzner Cloud** | VPS CX22 + K3s | Kubernetes autogerenciado |

## Conteúdo

```text
biblioteca-multicloud/
├── TUTORIAL.md                     # passo a passo completo (estrutura do slide 47)
├── Dockerfile                     # build multi-stage, usuário não-root
├── .dockerignore
├── k8s/
│   ├── base/
│   │   ├── deployment.yaml        # 1 réplica, Secret via env, probes, limites
│   │   └── secret.example.yaml    # MODELO — não aplicar direto
│   ├── managed/
│   │   └── service-loadbalancer.yaml   # AWS + Azure
│   └── vps/
│       ├── service-nodeport.yaml       # Hetzner + K3s (porta 30080)
│       └── ingress-traefik.yaml        # opcional: Ingress + HTTPS
└── docs/evidencias/               # prints de cada ambiente (slide 38)
```

## Uso rápido

1. **Imagem** (uma vez, usada nos três ambientes):
   ```bash
   git clone https://github.com/dpRanghetti/biblioteca.git && cd biblioteca
   cp ../biblioteca-multicloud/Dockerfile ../biblioteca-multicloud/.dockerignore .
   docker build -t biblioteca:1.0 .
   docker tag biblioteca:1.0 docker.io/SEU_USUARIO/biblioteca:1.0
   docker push docker.io/SEU_USUARIO/biblioteca:1.0
   ```
2. Ajuste `image:` em `k8s/base/deployment.yaml`.
3. Siga o [`TUTORIAL.md`](./TUTORIAL.md) para cada provedor (seções 8, 9 e 10).
4. **Limpeza obrigatória** ao final: `TUTORIAL.md` seção 15.

## Avisos

- Banco **H2 em memória**: implantação demonstrativa, **1 réplica**, dados voláteis.
- O segredo JWT (`API_SECURITY_TOKEN_SECRET`) é sempre fornecido por `Secret` —
  **nunca** versione o valor real.
- Apague todos os recursos de nuvem após coletar as evidências.
