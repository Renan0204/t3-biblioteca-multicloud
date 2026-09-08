# Plano da equipe — o que falta para entregar o T3

## Já está pronto (no GitHub)

- Documento completo: [`TUTORIAL.md`](../TUTORIAL.md)
- `Dockerfile`, `.dockerignore`, manifestos Kubernetes em [`k8s/`](../k8s/)
- Apresentação de 10 slides: `apresentacao.html`
- Roteiro de execução com os comandos: [`docs/EXECUCAO.md`](./EXECUCAO.md)
- Repositório: https://github.com/Renan0204/t3-biblioteca-multicloud

## Falta fazer

1. Rodar a aplicação no Docker local e publicar a imagem.
2. Instalar nas 3 nuvens (Hetzner, Azure, AWS) e tirar os prints.
3. **Apagar tudo das nuvens no fim.**
4. Consultar os preços no dia da entrega.
5. Montar o PDF final com as evidências e enviar o e-mail ao professor.

## Divisão de tarefas

Quem mexer em nuvem precisa de: conta no provedor + cartão de crédito + a CLI dele.
Custo total ~US$ 1 a 3 **se apagar tudo logo depois**.

| Pessoa | Responsável por |
|---|---|
| Renan Oliveira | Docker local, publicar imagem, fechamento (PDF + e-mail) |
| Adrian Souza | AWS (Amazon EKS) — Fase 3 |
| Fernando Cardoso | Azure (AKS) — Fase 2 |
| Victor Caitano | Hetzner (servidor + K3s) — Fase 1 |
| Guilherme Vitor | Comparação de custos (preços do dia) + conferência dos prints |

## Ordem

1. **Renan** faz a Fase 0 (build + teste local + publica a imagem no Docker Hub) e
   avisa no grupo o nome da imagem (`docker.io/USUARIO/biblioteca:1.0`).
2. **Victor, Fernando e Adrian** rodam as Fases 1, 2 e 3 **em paralelo**, cada um na
   sua nuvem, usando o nome da imagem que o Renan passou. Salvam os prints em
   `docs/evidencias/` com os nomes indicados no `EXECUCAO.md`.
3. **Todos** rodam a Fase 4 (apagar tudo) e conferem o painel de cobrança.
4. **Guilherme** consulta os preços dos 3 provedores no dia, manda os números no
   grupo, e confere se todos os prints estão na pasta, com os nomes certos e sem
   dados sensíveis à mostra.
5. **Renan** sobe tudo (`git add -A && git commit -m "..." && git push`), avisa, gera
   o PDF final e envia o e-mail.

## Regras que não podem falhar

- Apagar **todos** os recursos de nuvem no fim (clusters, balanceadores, servidores,
  discos, registros).
- Nunca colocar senha, chave ou token real em print ou no repositório.
- Nos prints, tapar: número da conta, dados de cartão, IDs de assinatura.
- A aplicação roda com **1 réplica** (banco em memória) — é de propósito.
- Prazo: até o fim da aula.

## E-mail final (Renan envia)

- **Para:** diogo.p.ranghetti@gmail.com
- **Cc:** e-mails de todos os 5 integrantes
- **Assunto:** `[Cloud DevOps] T3 – Biblioteca em Kubernetes`
- **Anexo:** o PDF
- **Corpo:** lista dos 5 integrantes + link do repositório + observação de que os
  recursos foram removidos. Modelo pronto no final do `TUTORIAL.md` (seção 17.2) e no
  histórico da conversa.
