# Capturas reais da execução local com Java

Capturas obtidas em 09/09/2026 durante a execução da aplicação Biblioteca diretamente com Java 21.0.11 e Spring Boot 4.0.6, em `http://localhost:8080`.

Esta execução não utilizou Docker nem provedores de nuvem. As imagens abaixo documentam somente o teste local via Java; não demonstram execução em contêiner, publicação de imagem ou implantação multicloud.

## Login

Login realizado com a conta de demonstração da aplicação. A tela autenticada exibe a navegação e a opção de sair.

![Tela após login na aplicação local via Java](local-02-login.png)

## Operação de escrita

O autor de demonstração **Machado de Assis**, com nacionalidade **Brasileira**, foi cadastrado pelo formulário. A listagem confirmou o registro com ID 1.

![Autor cadastrado pela interface da aplicação local via Java](local-03-operacao.png)

## Verificação

- Projeto utilizado: cópia local da Biblioteca na pasta `Java_`, incluindo as alterações locais que já existiam nessa cópia.
- Compilação: `mvnw.cmd -B package`, concluída com sucesso.
- Testes existentes: 1 executado, sem falhas nem erros.
- Execução: JAR gerado pelo Maven, com endereço de escuta restrito a `127.0.0.1` e porta `8080`.
- Segredo JWT fornecido por variável de ambiente durante a inicialização, sem registro do valor nas evidências.
- Banco H2 em memória: o cadastro de demonstração se perde quando a aplicação é encerrada.
- Imagens capturadas diretamente do navegador, sem edição do conteúdo.

As demais imagens da pasta não foram revalidadas por esta execução local.
