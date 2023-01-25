import boto3
import os
import redshift_connector

path_sql_file = r'sql/'
path_csv      = r's3_files/'
aws_credentials_path  = r'/home/mayron/.aws/credentials'

AWS_ACCESS_KEY_ID     = open(aws_credentials_path).read().split()[3]
AWS_SECRET_ACCESS_KEY = open(aws_credentials_path).read().split()[-1]

def conn_redshift():
    if 'conn' not in globals():
        conn = redshift_connector.connect(
            host= str(open(r'key/connect_redshift.txt').read().rsplit(":")[0]),
            database='northwind',
            port=int(open(r'key/connect_redshift.txt').read().rsplit(":")[1]),
            user='admin',
            password='123456Aa')
        conn.autocommit = True
        print('Conexão Estabelecida com Redshift')
    else:  
        pass
    return conn

def s3_load():
    s3 = boto3.resource('s3')
    print("Iniciando Upload dos Arquivos no S3")
    for file_name in os.listdir(path_csv):
        try:
            s3.meta.client.upload_file(
            Filename = path_csv+file_name,
            Bucket   = 'dadonorthwindo',
            Key      = file_name)
            print(f"Exito Upload: {file_name}")
        except:
            print(f"Ocorreu um erro inesperado na carga do arquivo {file_name}")
    print('Upload concluido')
    print('-------------------------------------\n\n')

def redshift_create_tables():
    conn = conn_redshift()
    for sql_code in open(path_sql_file+'northwindddl.sql','r').read().split(';'):
        try: 
            print(f'Criando Tabela: {sql_code.split(" ")[2]}')
            conn.cursor().execute(sql_code)
        except: 
            continue
    conn.close()
    print('Criação de Tabelas no redshift finalizada')
    print('-------------------------------------\n\n')

def redshift_load_s3_files():
    conn = conn_redshift()
    s3 = boto3.resource('s3')
    
    for my_bucket_object in s3.Bucket('dadonorthwindo').objects.all():
        conn.cursor().execute(
            f"COPY {str(my_bucket_object.key).split('.')[0]} FROM 's3://dadonorthwindo/{my_bucket_object.key}'\
            CREDENTIALS 'aws_access_key_id={AWS_ACCESS_KEY_ID};aws_secret_access_key={AWS_SECRET_ACCESS_KEY}'\
            delimiter ';'\
            region 'us-east-1'\
            IGNOREHEADER 1\
            DATEFORMAT AS 'YYYY-MM-DD HH:MI:SS'\
            removequotes;")
        print("Carregando dados: "+str(my_bucket_object.key).split('.')[0])
    conn.close()
    print('Carga de dados nas tabelas do redshift finalizada')
    print('-------------------------------------\n\n')

def redshift_view():
    conn = conn_redshift()
    for view in open(path_sql_file+'views.sql').read().split(';'):
        try:
            print(f"Creando VIEW: {view.split('AS')[0].split('VIEW')[1]}")
            conn.cursor().execute(view)
        except:
            pass
    conn.close()

s3_load()
redshift_create_tables()
redshift_load_s3_files()
redshift_view()