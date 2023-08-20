# Projeto sensor radar

### Objetivo
Este projeto refere-se à uma pequena aplicação usando o Kafka Streams e Clojure com objetivo da utilização no aprendizado.

### Descrição
Neste momento do projeto, a idéia é enviar um comando (mensagem) em um tópico de entrada no kafka e seguindo uma lógica esse comando é encaminhado para outros tópicos que vai fazer a leitura dos dados e definir se deve ou não aplicar uma multa naquele comando que chegou. O comando representa uma leitura de um radar de velocidade que contem a placa do veiculo e a velocidade.

![Resumo](/img.png)

### Para rodar o projeto

Subir a infra do kafka com docker compose

```
docker compose up -d
```
Em seguida, vamos entrar no container e adicionar os tópicos do projeto.
```
docker exec -it kafka /bin/bash

kafka-topics.sh --create --bootstrap-server localhost:9092 --topic comando.radar

kafka-topics.sh --create --bootstrap-server localhost:9092 --topic multa

kafka-topics.sh --create --bootstrap-server localhost:9092 --topic relatorio
```

No diretório raiz do projeto, subir o container com a imagem do clojure.

```Windowns```
```
 docker run -it --rm  --name clojure --env-file ./.env  -v ${pwd}:/work -w /work clojure:lein-2.9.3 /bin/bash
```
ou

```Linux```
```
 docker run -it --rm  --name clojure --env-file ./.env  -v %cd%:/work -w /work clojure:lein-2.9.3 /bin/bash
```
rodar o projeto
```
lein run
```

Na janela do kafka, enviar a mensagem no tópico de entrada

```
kafka-console-producer.sh --bootstrap-server localhost:9092 --property "parse.key=true" --property "key.separator=:" --topic comando.radar
```
```json
001:{"status": "pendente", "velocidade": 101, "placa": "AAA-0000"}
```
Observar o log gerado na janela do projeto, além disso um arquivo relatorio.txt sera criado com a sáida do comando "quando houver uma multa aplicada"


### cmds úteis
```cria um tópico ```
```
kafka-topics.sh --create --bootstrap-server localhost:9092 --topic <nome-do-topico>
```

 ```para enviar uma mensagem ao tópico```
 ```
 kafka-console-producer.sh --bootstrap-server localhost:9092 --property "parse.key=true" --property "key.separator=:" --topic <nome-do-topico>
 ```
```imprimir todas mensagens de um tópico```
```
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic comando.radar --isolation-level read_committed --property "print.timestamp=true" --property "print.key=true" --property key.separator=" : 
" --timeout-ms 10000 --from-beginning
```
```deletar um tópico```
```
kafka-topics.sh --bootstrap-server localhost:9092 --delete --topic comando.radar
```