#!/bin/bash

# Inicia o servidor Kafka em segundo plano
/opt/bitnami/scripts/kafka/setup.sh
/opt/bitnami/scripts/kafka/run.sh &

# Aguarda o servidor Kafka iniciar
sleep 40

# Cria tópicos
kafka-topics.sh --create --if-not-exists --bootstrap-server kafka:9092 --topic comando.radar
kafka-topics.sh --create --if-not-exists --bootstrap-server kafka:9092 --topic multa
kafka-topics.sh --create --if-not-exists --bootstrap-server kafka:9092 --topic relatorio

# Mantem o contêiner em execução
tail -f /dev/null
