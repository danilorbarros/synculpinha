#!/bin/bash

# -[Questão 1, 2 e 3]
# Definição de variáveis necessárias para complementação do código
dir_origem=$1
dir_destino=$2
waiting=*
count=1
list=list_aux.txt
nome=

# Início dos testes quanto a entrada das variáveis
if [ "$#" -le 1 ]; then
	echo "Uso $0 diretorio_origem diretorio_destino."
	exit 1
elif [ "$#" -gt 2 ]; then
	echo "Uso $0 diretorio_origem diretorio_destino."
	exit 1
fi

# -[Questão 4]
# Realização dos testes quanto ao diretório de Origem
if [ -d  "$dir_origem" ]; then
	echo "Diretório $dir_origem existente."
else
	echo "Diretório $dir_origem de origem não encontrado."
	echo "Encerrando execução..."
	exit 1 
fi

# -[Questão  5, 6]
# Impressão quanto ao status da sincronização
echo Sincronização iniciada...

# Laço para caso o diretório de destino ainda não tenha sido criado
while [ ! -d "$dir_destino" ]
do
	# Condição para impressão
	if [ "$count" -le 1 ]; then
		echo "Aguardando conexão com destino: $dir_destino."
	fi

	# Aqui fazendo uso da variável auxiliar pra printar.
	count=$(( $count + 1 ))
	echo -n "$waiting"

	# Condição para recontagem
	if [ "$count" -ge 10 ]; then
		count=1
		printf "\n"
	fi

	# Usando o sleep pra ficar binito.
	sleep 1
done

# Novamente pular linha pra ficar binito
printf "\n"

# Sincronização encerrada
echo "Diretório encontrado."

# -[Questão 7, 8]
# Fazendo a listagem e mapeamento dos arquivos/diretórios no primeiro diretório
ls $dir_origem > $list
mapfile -t arquivos < $list

# Rodando cada um dos arquivos presentes na listagem para processamento.
for (( pos=0; pos<${#arquivos[@]}; pos++))
do
	# Usando variável auxiliar pra não escrever isso direto
	aux=${arquivos[$pos]}

	# Fazendo uma leitura do arquivo inicial para definidor como:
	# Arquivo
	if [ -f "$dir_origem/$aux" ]; then
		nome="arquivo"
	# Diretório
	elif [ -d "$dir_origem/$aux" ]; then
		nome="diretório"
	# Link
	elif [ -L "$dir_origem/$aux" ]; then
		nome="link"
	fi

	# Existe no diretório de destino
	if [ -e "$dir_destino/$aux" ]; then

		# Teste em caso do arquivo não ser o mesmo
		if [ "" -ef "" ]; then
			echo ""

		# Teste em caso do arquivo ser mais novo que o outro
		elif [ "$dir_origem/$aux" -nt "$dir_destino/$aux" ];then
			echo "Atualizando $nome $aux..."
			cp -r "$dir_origem/$aux" "$dir_destino/$aux"

		# Teste em caso do arquivo ser mais antigo que o outro
		elif [ "$dir_origem/$aux" -ot "$dir_destino/$aux" ];then
			echo "Ignorando $nome $aux..."

		fi
	# Não existe no diretório de destino
	else
		echo "Criando $nome $aux"
		cp -r "$dir_origem/$aux" "$dir_destino/$aux"
	fi

done

# -[Questão 9, 10]
# Remoção do arquivo auxiliar e encerramento do script.
rm "$list"
echo "Sincronização encerrada."

exit 0