O projeto foi desenvolvido para responder a 5 perguntas feitas pela área de negócios utilizando os dados Northwind sample database (modificado).

1. Gostaria de saber se temos feito muitas vendas com valores abaixo do preço de tabela
2. Como está a performance dos funcionários
3. Quais produtos mais caros
4. Quais produtos de fornecedores vem melhorando nas vendas
5. lista dos 5 categorias mais vendidas por ano

O projeto foi desenvolvido na AWS utilizando os serviços S3 para armazenamento dos dados do banco e o Redshift para organização dos dados com SQL

Para executar o projeto é necessário conexão com a AWS CLI
https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html

Terraform
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

Python utilizado 3.10.6
Gerenciador de Pacotes:
	Pip
Bibliotecas:
	boto3:   pip install boto3
	redshift: pip install redshift_connector

Após as instalações navegue até a pasta do terraform é faça a inicialização do mesmo

cd Terraform
:~$ terraform init
:~$ terraform apply

Com isso os serviços redshift e S3 vão ser inicializados

Após a execução do terraform dentro da pasta /key/ será criado um arquivo chamado connect_redshift.txt necessário para o código python

Ao finalizar será necessário executar o código python na pasta /code/ 
No código possui uma variável chamada aws_credentials_path, nela é necessário colocar o caminho padrão do arquivo com as credenciais da AWS 

https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html

Execute o python é ele será responsável por;
Copiar os arquivos  na pasta s3_files para o Bucket S3
Criar as tabelas no redshift com os comandos na pasta sql/northwindddl.sql
Executar um SQL COPY do S3 para o banco de dados dentro do redshift
Criar as Views respondendo às questões apresentadas no início do documento 

Atenção: Todo o projeto foi desenvolvido apenas para estudo das ferramentas.

