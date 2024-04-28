# Terraform Criar VM no GCP

Pré-requisitos

- gcloud instalado
- Terraform instalado

Logar no GCP usando gcloud com o comando abaixo

```sh
gcloud auth login
```

Criar uma chave pública e privada para acessar a VM criada na GCP, com nome "id_rsa" e copiar para a raiz do projeto do Terraform

```sh
ssh-keygen -t rsa -b 4096
```

Inicializar o Terraform

```sh
terraform init
```

Executar o Terraform

```sh
terraform apply

# ou

terraform apply -auto-approve
```

Acessar a máquina usando SSH com o comando abaixo

```sh
ssh ubuntu@<IP> -i id_rsa
```

Usar o comando abaixo para remover os recursos

```sh
terraform destroy
```