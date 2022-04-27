--------------------------------------------------------
---------------- Criação das tabelas ------------------
--------------------------------------------------------

CREATE TABLE Usuarios (
 id serial PRIMARY KEY,
 logi VARCHAR(30) NOT NULL UNIQUE,
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
 idioma CHAR(5) NOT NULL,
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

--------------------------------------------------------
---------------- Inserção nas tabelas ------------------
--------------------------------------------------------

insert INTO Usuarios (logi,cidade,data_nasc,nome,sexo,estado,senha,email,apresent,foto_perfil) VALUES (
  'willianpramio',
  'Porto Alegre',
  NULL,
  'Willian Pramio',
  'M',
  'RS',
  'abc123',
  'willianpramio@gmail.com',
  NULL,
  NULL
);
insert INTO Usuarios (logi,cidade,data_nasc,nome,sexo,estado,senha,email,apresent,foto_perfil) VALUES (
  'yasminbeer',
  'Porto Alegre',
  NULL,
  'Yasmin Beer',
  'F',
  'RS',
  'qwerty',
  'yasminbeer@gmail.com',
  'Oi!',
  NULL
);
insert INTO Usuarios (logi,cidade,data_nasc,nome,sexo,estado,senha,email,apresent,foto_perfil) VALUES (
  'karinbecker',
  'Porto Alegre',
  NULL,
  'Karin Becker',
  'F',
  'RS',
  'asdfg',
  'karinbecker@gmail.com',
  'Oi!',
  NULL
);

INSERT INTO Editoras (nome, site_oficial, descricao) VALUES (
  'Sextante',
  'www.esextante.com.br/',
  'Investimos para que cada produto da Sextante seja um instrumento para alcançar a paz interior.'
);
INSERT INTO Editoras (nome, site_oficial, descricao) VALUES (
  'Record',
  NULL,
  'Editora Record.'
);
INSERT INTO Editoras (nome, site_oficial, descricao) VALUES (
  'Arqueiro',
  NULL,
  'Editora Arqueiro'
);

INSERT INTO Livros (titulo,sinopse,idioma,ano,media_notas,edicao,isbn,num_paginas,id_editora) VALUES (
  'O Código Da Vinci', 'Um assassinato dentro do Museu do Louvre, em Paris', 'pt-br', '2004', '4.1', '1', '9788575421130', '432', '1');
INSERT INTO Livros (titulo,subtitulo,sinopse,idioma,ano,media_notas,edicao,isbn,num_paginas,id_editora) VALUES (
  'Anjos e Demônios',
  'A Primeira Aventura de Robert Langdon',
  'Antes de decifrar `O Código Da Vinci`, Robert Langdon',
  'pt-br',
  '2004',
  '4.3',
  '1',
  '9788575421',
  '464',
  '1'
);
INSERT INTO Livros (titulo,sinopse,idioma,ano,media_notas,edicao,isbn,num_paginas,id_editora) VALUES (
  ' Terras do Sem Fim',
  'A história se passa no começo do século XX, no sul da Bahia',
  'pt-br',
  '1947',
  '4.0',
  '1',
  '12122131',
  '282',
  '2'
);

INSERT INTO Tags (nome) VALUES ('Ficção');
INSERT INTO Tags (nome) VALUES ('Suspense e Mistério');
INSERT INTO Tags (nome) VALUES ('Literatura Estrangeira');
INSERT INTO Tags (nome) VALUES ('Literatura Brasileira');
INSERT INTO Tags (nome) VALUES ('Romance');

INSERT INTO Amizades (id_usuario_seguido, id_usuario_seguidor) VALUES ('2', '1');
INSERT INTO Amizades (id_usuario_seguido, id_usuario_seguidor) VALUES ('1', '2');
INSERT INTO Amizades (id_usuario_seguido, id_usuario_seguidor) VALUES ('3', '1');
INSERT INTO Amizades (id_usuario_seguido, id_usuario_seguidor) VALUES ('1', '3');

INSERT INTO Autores (nome,biografia,data_nasc,local_nasc) VALUES (
  'Dan Brown',
  'O escritor norte-americano Dan Brown nasceu em 1965 em New Hampshire, nos EUA.',
  '1964-06-22',
  'Estados Unidos - New Hampshire - Exeter'
);
INSERT INTO Autores (nome,biografia,data_nasc,local_nasc) VALUES (
  'Jorge Amado',
  'Foi um dos mais famosos e traduzidos escritores brasileiros de todos os tempos.',
  '1912-08-10',
  'Brasil - Bahia - Itabuna'
);
INSERT INTO Autores (nome,biografia,data_nasc,local_nasc) VALUES (
  'Douglas Adams',
  'Douglas Adams nasceu em Cambridge, Inglaterra.',
  '1952-03-11',
  'Inglaterra - Cambridge'
);

INSERT INTO Autorias (id_autor, id_livro) VALUES ('1', '1');
INSERT INTO Autorias (id_autor, id_livro) VALUES ('1', '2');
INSERT INTO Autorias (id_autor, id_livro) VALUES ('2', '3');

INSERT INTO Palavras_chave (id_tag, id_livro) VALUES ('1', '1');
INSERT INTO Palavras_chave (id_tag, id_livro) VALUES ('2', '1');
INSERT INTO Palavras_chave (id_tag, id_livro) VALUES ('3', '1');
INSERT INTO Palavras_chave (id_tag, id_livro) VALUES ('1', '2');
INSERT INTO Palavras_chave (id_tag, id_livro) VALUES ('2', '2');
INSERT INTO Palavras_chave (id_tag, id_livro) VALUES ('3', '2');
INSERT INTO Palavras_chave (id_tag, id_livro) VALUES ('1', '3');
INSERT INTO Palavras_chave (id_tag, id_livro) VALUES ('4', '3');
INSERT INTO Palavras_chave (id_tag, id_livro) VALUES ('5', '3');

INSERT INTO Estantes (colecao, nota, id_livro, id_usuario) VALUES ('Lido', '5', '1', '1');
INSERT INTO Estantes (colecao, nota, id_livro, id_usuario) VALUES ('Lido', '5', '2', '1');
INSERT INTO Estantes (colecao, nota, id_livro, id_usuario) VALUES ('Lido', '4', '3', '1');
INSERT INTO Estantes (colecao, nota, id_livro, id_usuario) VALUES ('Lendo', NULL, '1', '2');
INSERT INTO Estantes (colecao, nota, id_livro, id_usuario) VALUES ('Quero ler', NULL, '2', '3');

INSERT INTO Grupos (nome,data_criacao,descricao) VALUES ('Ajuda', '2011-01-21', 'Grupo criado para ajudar os Skoobers de primeira viagem');
INSERT INTO Grupos (nome,data_criacao,descricao) VALUES ('Surto quando entro em livrarias', '2010-10-16', 'Os viciados em livros entendem.');
INSERT INTO Grupos (nome,data_criacao,descricao) VALUES ('Stephen King', '2010-06-16', 'Grupo destinado a todos os fãs desse autor magnífico');

INSERT INTO Membros (id_usuario, id_grupo) VALUES ('1', '1');
INSERT INTO Membros (id_usuario, id_grupo) VALUES ('1', '2');
INSERT INTO Membros (id_usuario, id_grupo) VALUES ('2', '1');
INSERT INTO Membros (id_usuario, id_grupo) VALUES ('3', '2');

INSERT INTO Topicos (titulo,descricao,data_criacao,id_grupo) VALUES (
  'Paginômetro bugado',
  'Bom dia, eu gostaria de saber como desbugar meu paginômetro',
  '2020-10-09',
  '1'
);
INSERT INTO Topicos (titulo,descricao,data_criacao,id_grupo) VALUES (
  'páginas não contabilizam na meta',
  'Tenho um livro que li, e as páginas não estão contabilizadas na meta de 2022',
  '2022-03-02',
  '1'
);
INSERT INTO Topicos (titulo,descricao,data_criacao,id_grupo) VALUES (
  'Qual livro vocês estão lendo?',
  'No momento estou lendo convite para um homicídio - Agatha Christie, e vocês?',
  '2013-01-23',
  '2'
);

INSERT INTO Mensagens (texto,data_envio,id_usuario,id_topico) VALUES (
  'Estranho.. o meu também tá esquisito',
  '2020-10-09',
  '1',
  '1'
);
INSERT INTO Mensagens (texto,data_envio,id_usuario,id_topico) VALUES (
  'Logo no começo do ano algumas pessoas falaram sobre esse problema ',
  '2022-02-03',
  '2',
  '2'
);
INSERT INTO Mensagens (texto,data_envio,id_usuario,id_topico) VALUES (
  'As Crônicas de Gelo e Fogo - Vol. IV',
  '2013-01-23',
  '2',
  '3'
);

INSERT INTO Resenhas_video (titulo, link, id_livro, id_usuario) VALUES (
  'Análise: `Anjos e Demonios` de Dan Brown',
  'www.youtube.com/watch?v=GaBmWY2qJe4',
  '1',
  '1'
);
INSERT INTO Resenhas_video (titulo, link, id_livro, id_usuario) VALUES (
  'Li `Anjos e Demonios`, minha opinião',
  'www.youtube.com/watch?v=47cB3v7qxef',
  '1',
  '2'
);
INSERT INTO Resenhas_video (titulo, link, id_livro, id_usuario) VALUES (
  'Terras do Sem Fim: minha resenha + sorteiro',
  'www.youtube.com/watch?v=Y9Kcgt83iOQ',
  '3',
  '3'
);

INSERT INTO Resenhas_texto (titulo, texto, data_envio, curtidas, spoiler, id_livro, id_usuario) VALUES (
  'meus neurônios foram fritados',
  'Dan Brown é simplesmente um gênio, quero perguntar pra ele como foi capaz de pensar em um livro tão incrível.',
  '2022-03-12',
  '4',
  'false',
  '1',
  '1'
);
INSERT INTO Resenhas_texto (titulo, texto, data_envio, curtidas, spoiler, id_livro, id_usuario) VALUES (
  'Amo teorias da conspiração',
  'Eu amei demais esse livro, Dan Brown nunca me decepcionou!',
  '2022-03-11',
  '9',
  'false',
  '1',
  '2'
);
INSERT INTO Resenhas_texto (titulo, texto, data_envio, curtidas, spoiler, id_livro, id_usuario) VALUES (
  'Regionalismo marcante',
  'Não é dos meus livros favoritos de Jorge Amado, mas este também é muito bom!!',
  '2022-03-02',
  '2',
  'false',
  '3',
  '1'
);

INSERT INTO Comentarios (texto, data_envio, id_resenha_texto, id_usuario) VALUES (
  'Nem me fala, to até agora digerindo as reviravoltas!',
  '2022-03-11',
  '1',
  '3'
);
INSERT INTO Comentarios (texto, data_envio, id_resenha_texto, id_usuario) VALUES (
  'Também nunca me decepciono com ele!',
  '2022-03-11',
  '2',
  '3'
);
INSERT INTO Comentarios (texto, data_envio, id_resenha_texto, id_usuario) VALUES (
  'Aproveita o embalo e leias os outros, muito bons',
  '2022-03-11',
  '3',
  '1'
);