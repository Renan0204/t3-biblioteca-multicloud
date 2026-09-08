# O que falta para entregar o T3

## Já está pronto (no repositório)

- Documento completo: [`TUTORIAL.md`](../TUTORIAL.md)
- `Dockerfile`, `.dockerignore`, manifestos Kubernetes em [`k8s/`](../k8s/)
- Apresentação de 10 slides: `apresentacao.html`
- Roteiro de execução com os comandos: [`docs/EXECUCAO.md`](./EXECUCAO.md)
- Repositório: https://github.com/Renan0204/t3-biblioteca-multicloud

Tudo acima foi produzido por **Renan Oliveira**.

## Falta fazer

1. Rodar a aplicação no Docker local e publicar a imagem.
2. Instalar nas 3 nuvens (Hetzner, Azure, AWS) e tirar os prints.
3. **Apagar tudo das nuvens no fim.**
4. Consultar os preços no dia da entrega.
5. Montar o PDF final com as evidências e enviar o e-mail ao professor.

## Tarefas

Cada tarefa de nuvem precisa de: conta no provedor + cartão de crédito + a CLI dele.
Custo total ~US$ 1 a 3 **se apagar tudo logo depois**. Os comandos de cada fase estão
no [`EXECUCAO.md`](./EXECUCAO.md).

- **Docker local e imagem (Fase 0):** fazer o build, testar em `http://localhost:8080/login`,
  publicar a imagem no Docker Hub e divulgar o nome dela (`docker.io/USUARIO/biblioteca:1.0`)
  para as demais tarefas. Salvar os prints `local-01` a `local-05`.
- **Hetzner, VPS + K3s (Fase 1):** a mais rápida e barata. Prints `hetzner-01` a `hetzner-05`.
- **Azure, AKS (Fase 2):** conta nova tem US$ 200 de crédito. Prints `azure-01` a `azure-06`.
- **AWS, Amazon EKS (Fase 3):** a mais demorada (~50 min) e a única que custa (~US$ 1).
  Prints `aws-01` a `aws-06`.
- **Apagar tudo (Fase 4):** cada ambiente apaga o que criou; conferir o painel de
  cobrança. Prints `*-07-limpeza`.
- **Comparação de custos:** no dia da entrega, consultar as páginas de preço da AWS,
  Azure e Hetzner e anotar valor do cluster, dos servidores, do balanceador e a data.
  Conferir se todos os prints estão em `docs/evidencias/` com os nomes certos e sem
  dados sensíveis à mostra.
- **Fechamento (Renan Oliveira):** juntar as evidências, subir no Git, gerar o PDF
  final e enviar o e-mail.

## Ordem

1. Fazer a **Fase 0** primeiro e divulgar o nome da imagem publicada.
2. **Fases 1, 2 e 3 em paralelo**, cada uma na sua nuvem, usando essa imagem.
   Salvar os prints em `docs/evidencias/` com os nomes do `EXECUCAO.md`.
3. **Fase 4** em todos os ambientes; conferir a cobrança.
4. Consultar os **preços do dia** e conferir os prints.
5. Subir tudo no Git (`git add -A && git commit -m "..." && git push`), gerar o
   **PDF final** e enviar o **e-mail** ao professor — **fechamento por Renan Oliveira**.

## Regras que não podem falhar

- Apagar **todos** os recursos de nuvem no fim (clusters, balanceadores, servidores,
  discos, registros).
- Nunca colocar senha, chave ou token real em print ou no repositório.
- Nos prints, tapar: número da conta, dados de cartão, IDs de assinatura.
- A aplicação roda com **1 réplica** (banco em memória) — é de propósito.
- Prazo: até o fim da aula.

## E-mail final

- Renan Oliveira envia:
- **Para:** diogo.p.ranghetti@gmail.com
- **Cc:** e-mails de todos os integrantes
- **Assunto:** `[Cloud DevOps] T3 – Biblioteca em Kubernetes`
- **Anexo:** o PDF
- **Corpo:** lista dos integrantes + link do repositório + observação de que os
  recursos foram removidos. Modelo no final do `TUTORIAL.md` (seção 17.2).
- **Renan Oliveira** envia, com os demais integrantes em cópia.
