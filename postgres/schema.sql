--------------------------------------------------------
---------------- Criação das tabelas ------------------
--------------------------------------------------------

CREATE TABLE Usuarios (
 id serial PRIMARY KEY,
 login VARCHAR(30) NOT NULL UNIQUE,
 cidade VARCHAR(50),
 data_nasc DATE,
 nome VARCHAR(50) NOT NULL,
 sexo CHAR(1),
 estado VARCHAR(50),
 senha VARCHAR(64) NOT NULL,
 email VARCHAR(50) NOT NULL UNIQUE,
 apresent VARCHAR(500),
 foto_perfil VARCHAR(200)
);

CREATE TABLE Editoras (
 id serial PRIMARY KEY,  
 nome VARCHAR(50) NOT NULL UNIQUE,  
 site_oficial VARCHAR(50),  
 descricao VARCHAR(500) NOT NULL
);

CREATE TABLE Livros (
 id serial PRIMARY KEY,
 titulo VARCHAR(100) NOT NULL,
 subtitulo VARCHAR(100),
 sinopse VARCHAR(500),
 idioma VARCHAR(30) NOT NULL,
 ano INTEGER NOT NULL,
 media_notas FLOAT NOT NULL,
 edicao INTEGER NOT NULL,
 isbn VARCHAR(15) NOT NULL UNIQUE,
 num_paginas INTEGER NOT NULL,
 capa VARCHAR(200),
 id_editora INTEGER NOT NULL,
 FOREIGN KEY (id_editora) REFERENCES Editoras (id)
);

CREATE TABLE Autores (
 id serial PRIMARY KEY,  
 nome VARCHAR(50) NOT NULL,  
 biografia VARCHAR(500),  
 data_nasc DATE,  
 local_nasc VARCHAR(60)
);

CREATE TABLE Resenhas_texto (
 id serial PRIMARY KEY,  
 titulo VARCHAR(100) NOT NULL,  
 texto VARCHAR(300) NOT NULL,
 data_envio DATE NOT NULL,
 curtidas INTEGER NOT NULL,  
 spoiler BOOLEAN NOT NULL,  
 id_livro INTEGER NOT NULL,  
 id_usuario INTEGER NOT NULL,
 FOREIGN KEY (id_livro) REFERENCES Livros (id),
 FOREIGN KEY (id_usuario) REFERENCES Usuarios (id)
);

CREATE TABLE Comentarios (
 id serial PRIMARY KEY,  
 texto VARCHAR(300) NOT NULL,  
 data_envio DATE NOT NULL,  
 id_resenha_texto INTEGER,  
 id_usuario INTEGER NOT NULL,
 FOREIGN KEY (id_resenha_texto) REFERENCES Resenhas_texto (id),
 FOREIGN KEY (id_usuario) REFERENCES Usuarios (id)
 );

CREATE TABLE Tags (
 id serial PRIMARY KEY,  
 nome VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Estantes (
 id serial PRIMARY KEY,
 colecao VARCHAR(15) NOT NULL,  
 nota INTEGER,  
 data_leitura DATE,  
 id_livro INTEGER NOT NULL,  
 id_usuario INTEGER NOT NULL,
 FOREIGN KEY (id_livro) REFERENCES Livros (id),
 FOREIGN KEY (id_usuario) REFERENCES Usuarios (id),
 CHECK (colecao IN ('Lido', 'Lendo', 'Quero ler', 'Relendo', 'Abandonei')),
 CHECK (nota >= 1 AND nota <= 5)
);

CREATE TABLE Grupos (
 id serial PRIMARY KEY,  
 nome VARCHAR(50) NOT NULL UNIQUE,  
 data_criacao DATE NOT NULL,  
 descricao VARCHAR(500),  
 foto_perfil VARCHAR(200)
);

CREATE TABLE Topicos (
 id serial PRIMARY KEY,  
 titulo VARCHAR(100) NOT NULL,  
 descricao VARCHAR(500) NOT NULL,  
 data_criacao DATE NOT NULL,  
 id_grupo INTEGER NOT NULL,
 FOREIGN KEY (id_grupo) REFERENCES Grupos (id)
);

CREATE TABLE Mensagens (
 id serial PRIMARY KEY,  
 texto VARCHAR(500) NOT NULL,  
 data_envio DATE NOT NULL,  
 id_usuario INTEGER NOT NULL,  
 id_topico INTEGER NOT NULL,
 FOREIGN KEY (id_usuario) REFERENCES Usuarios (id),
 FOREIGN KEY (id_topico) REFERENCES Topicos (id)
);

CREATE TABLE Amizades (
 id serial PRIMARY KEY,  
 id_usuario_seguido INTEGER NOT NULL,  
 id_usuario_seguidor INTEGER NOT NULL,
 FOREIGN KEY (id_usuario_seguido) REFERENCES Usuarios (id),
 FOREIGN KEY (id_usuario_seguidor) REFERENCES Usuarios (id)
);

CREATE TABLE Autorias (
 id serial PRIMARY KEY,
 id_autor INTEGER NOT NULL,  
 id_livro INTEGER NOT NULL,
 FOREIGN KEY (id_autor) REFERENCES Autores (id),
 FOREIGN KEY (id_livro) REFERENCES Livros (id)
);

CREATE TABLE Palavras_chave (
 id serial PRIMARY KEY,
 id_tag INTEGER NOT NULL,  
 id_livro INTEGER NOT NULL,
 FOREIGN KEY (id_tag) REFERENCES Tags (id),
 FOREIGN KEY (id_livro) REFERENCES Livros (id)
);

CREATE TABLE Resenhas_video (
 id serial PRIMARY KEY,  
 titulo VARCHAR(50) NOT NULL,  
 link VARCHAR(100) NOT NULL UNIQUE,  
 id_livro INTEGER NOT NULL,  
 id_usuario INTEGER NOT NULL,
 FOREIGN KEY (id_livro) REFERENCES Livros (id),
 FOREIGN KEY (id_usuario) REFERENCES Usuarios (id)
);

CREATE TABLE Membros (
 id serial PRIMARY KEY,  
 id_usuario INTEGER NOT NULL,  
 id_grupo INTEGER NOT NULL,
 FOREIGN KEY (id_usuario) REFERENCES Usuarios (id),
 FOREIGN KEY (id_grupo) REFERENCES Grupos (id)
);
