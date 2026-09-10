# Evidências de testes locais

Teste realizado em **09/09/2026**, com **Java 21.0.11** e **Spring Boot 4.0.6**, em `http://localhost:8080`. Execução local via Java, sem Docker.

## Login

Login realizado com o usuário de demonstração.

![Login na aplicação — Java local](local-02-login.png)

## Cadastro de autor

Cadastro de **Machado de Assis**, nacionalidade **Brasileira**, confirmado na listagem com ID **1**.

![Cadastro de autor — Java local](local-03-operacao.png)

## Resultado dos testes

- Compilação: `mvnw.cmd -B package` — concluída com sucesso.
- Teste automatizado: **1 executado, 0 falhas e 0 erros**.
- Testes no navegador: login e cadastro de autor concluídos.
- Projeto: cópia local da Biblioteca (`Java_`), com as alterações locais existentes.
- Execução: JAR do Maven em `127.0.0.1:8080`, com segredo JWT fornecido por variável de ambiente.
- Banco H2 em memória: os dados são descartados ao encerrar a aplicação.

As duas capturas documentam o teste local via Java. A validação dos ambientes de nuvem é uma etapa separada.
