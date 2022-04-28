require 'sinatra'
require 'sequel'

configure do
  set port: 3000
end

get '/' do
  erb :home
end

get '/usuarios' do
  @users = db[:usuarios].distinct(:nome).map{ |m| m[:nome] }
  erb :usuarios
end

# Retorna todas as mensagens de um tópico
get '/topicos/:id_topico' do
  query = %{
    SELECT u.nome, m.texto, m.data_envio
    FROM Mensagens m
    JOIN Usuarios u on m.id_usuario = u.id
    JOIN Topicos t on m.id_topico = t.id
    WHERE t.id = #{params[:id_topico]};
  }
  @topic = db[:topicos].where(id: params[:id_topico]).first
  @messages = db[query]
  erb :topico
end

# Retorna o número de comentários de cada usuário junto com o número de resenhas em que comentou
get '/comentarios_e_resenhas_por_usuario' do
  query = %{
    SELECT
      u.id,
      u.nome,
      count(c.id) as nr_de_comentarios,
      count(r.id) as nr_de_resenhas_comentadas
    FROM Usuarios u
    LEFT JOIN Comentarios c on c.id_usuario = u.id
    LEFT JOIN Resenhas_texto r on r.id = c.id_resenha_texto
    GROUP BY u.id;
  }
  @result = db[query]
  erb :comentarios_e_resenhas_por_usuario
end

# Retorna resenhas populares do usuário (ou seja, com pelo menos um comentário)
get '/resenhas_populares' do
  query = %{
    SELECT 
      r.titulo,
      count(c.id) as nr_de_comentarios
    FROM Usuarios u
    LEFT JOIN Resenhas_texto r on r.id_usuario = u.id
    LEFT JOIN Comentarios c on r.id = c.id_resenha_texto
    WHERE u.login = 'yasminbeer'
    GROUP BY r.id
    HAVING count(c.id) > 0;
  }
  @result = db[query]
  erb :resenhas_populares
end

# Pega o último comentário de uma resenha
get '/ultimo_comentario' do
  query = %{
    SELECT u.nome, c.texto, c.data_envio
    FROM Comentarios c
    JOIN Usuarios u on c.id_usuario = u.id
    WHERE
        c.id = 
        (
          SELECT MAX(c.id)
          FROM Resenhas_texto r
          LEFT JOIN Comentarios c on c.id_resenha_texto = r.id
          WHERE r.id = 1
        );
  }
  @result = db[query]
  erb :ultimo_comentario
end

# Retorna livros que ainda não estão na estante do usuário
get '/livros_fora_estante' do
  query = %{
    SELECT
      l.id,
      l.titulo
    FROM Livros l
    WHERE l.id NOT IN
    (
      SELECT e.id_livro
      FROM Usuarios u
      LEFT JOIN Estantes e on e.id_usuario = u.id
      WHERE u.login = 'yasminbeer'
    );
  }
  @result = db[query]
  erb :livros_fora_estante
end

# Retorna sugestões de seguidores do usuário
get '/sugestoes_seguidores' do
  query = %{
    SELECT
      e.id_usuario
    FROM Estantes e
    LEFT JOIN Usuarios u on u.id = e.id_usuario
    WHERE
      -- Possui livros em comum com o usuário
      e.id_livro in (
        SELECT e.id_livro
        FROM Estantes e
        WHERE e.id_usuario = 1
      )
      
      -- Não é o próprio usuário
      AND NOT e.id_usuario = 1
      
      -- Ainda não é seguido pelo usuário
      AND NOT e.id_usuario in (
        SELECT a.id_usuario_seguido
        FROM Amizades a
        WHERE a.id_usuario_seguidor = 1
      ) 
    GROUP BY e.id_usuario;
  }
  @result = db[query]
  erb :sugestoes_seguidores
end

# Pega a última mensagem de um tópico
get '/ultima_mensagem_topico' do
  query = %{
    SELECT u.nome, m.texto, m.data_envio
    FROM Mensagens m
    JOIN Usuarios u on m.id_usuario = u.id
    WHERE
    m.id = 
    (
      SELECT MAX(m.id)
      FROM Topicos t
          LEFT JOIN Mensagens m on m.id_topico = t.id
          WHERE t.id = 1
          );
  }
  @result = db[query]
  erb :ultima_mensagem_topico
end

# Retorna usuários que não tiveram interações nos últimos 7 dias
get '/usuarios_sem_interacao' do
  query = %{
    SELECT
      u.id,
      u.nome
    FROM Usuarios u
    WHERE
      -- sem comentários nos últimos 7 dias
      NOT EXISTS
      (
        SELECT NULL
        FROM Comentarios c 
        WHERE
          u.id = c.id_usuario AND
          c.data_envio > (NOW() - INTERVAL '7 DAY')
      )
      
      -- sem resenhas de texto nos últimos 7 dias
      AND NOT EXISTS
      (
        SELECT NULL
        FROM Resenhas_texto r 
        WHERE
          u.id = r.id_usuario AND
          r.data_envio > (NOW() - INTERVAL '7 DAY')
      );
  }
  @result = db[query]
  erb :usuarios_sem_interacao
end

# Retorna todas as resenhas de um livro
get '/resenhas_livro' do
  create_resenhas_view
  query = %{
    SELECT
      r.id,
      r.titulo,
      r.type,
      u.login,
      u.nome
    from Livros l
    LEFT JOIN Resenhas r on r.id_livro = l.id
    JOIN Usuarios u on u.id = r.id_usuario
    where l.titulo = 'Terras do Sem Fim';
  }
  @result = db[query]
  erb :resenhas_livro
end

# Retorna todas as resenhas de um usuário
get '/resenhas_usuario' do
  create_resenhas_view
  query = %{
    SELECT
      l.id as id_livro,
      l.titulo,
      l.subtitulo,
      r.id as id_resenha,
      r.titulo,
      r.type as tipo
    FROM Usuarios u
    LEFT JOIN Resenhas r on r.id_usuario = u.id
    JOIN Livros l on l.id = r.id_livro
where u.login = 'yasminbeer';
  }
  @result = db[query]
  erb :resenhas_usuario
end

def db
  Sequel.connect(
    host: ENV['DB_HOST'],
    database: ENV['DB_NAME'],
    user: ENV['DB_USER'],
    password: ENV['DB_PASSWORD'],
    adapter: ENV['DB_ADAPTER']
  )
end

def create_resenhas_view
  sql = %{
    SELECT
      t.id, t.titulo, 't' AS type, t.id_livro, t.id_usuario 
    FROM Resenhas_texto t
    UNION
    SELECT v.id, v.titulo, 'v' AS type, v.id_livro, v.id_usuario
    FROM Resenhas_video v
  }
  db.create_view(:resenhas, sql, temp: true)
end
