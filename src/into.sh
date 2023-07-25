#!/bin/sh

#LPLA-br

read -p 'host>' HOST;

for ARQUIVONOME in * ; do
	if [[ $ARQUIVONOME != 'into.sh' || $ARQUIVONOME != '.' || $ARQUIVONOME != '..' ]]; then
		echo "$ARQUIVONOME para o database;";
		psql --host=$HOST --username='postgres' --dbname='world' < $ARQUIVONOME;
	fi
done
