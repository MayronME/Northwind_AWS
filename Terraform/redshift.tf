resource "aws_redshift_cluster" "NorthWind" {
    cluster_identifier  = "sql-cluster"       # Nome do Cluster
    database_name       = "northwind"         # Nome do Banco
    master_username     = var.db_username
    master_password     = var.db_password
    node_type           = "dc2.large"         # Maquina do Free Trial 
    cluster_type        = "single-node"       # Cluster do Free Trial
    skip_final_snapshot = true
}

resource "local_file" "dados_conexao" {
  content = aws_redshift_cluster.NorthWind.endpoint
  filename = "../key/connect_redshift.txt"
}