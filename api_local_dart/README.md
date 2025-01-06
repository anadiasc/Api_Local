# API Local de Posts

Esta API simples foi desenvolvida em Dart, utilizando o framework `shelf`, para permitir a criação e recuperação de posts. A API oferece funcionalidades básicas de CRUD com suporte a CORS (Cross-Origin Resource Sharing), permitindo interações de diferentes origens.

## Funcionalidades

- **GET /posts**: Retorna todos os posts cadastrados.
- **POST /posts**: Adiciona um novo post com os campos `texto` e `imagem`.

### Campos dos Posts

- `texto` (String): Conteúdo do post.
- `imagem` (String): URL ou referência à imagem associada ao post.

## Tecnologias Utilizadas

- Dart
- Shelf
- Shelf Router
- Uuid (para geração de IDs únicos)
- JSON para comunicação de dados

## Pré-requisitos

Antes de rodar o projeto, é necessário ter o Dart instalado em sua máquina. Você pode verificar a instalação do Dart utilizando o seguinte comando:

```bash
dart --version
