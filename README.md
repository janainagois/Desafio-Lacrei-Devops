# 🌈 Desafio DevOps - Lacrei Saúde

Este projeto entrega uma pipeline CI/CD segura e automatizada, com deploy de uma aplicação Node.js em ambientes separados de *staging* e *produção*, usando GitHub Actions, Docker e AWS (EC2, S3, DynamoDB).  
Toda a infraestrutura foi criada com **Terraform modularizado** e backend remoto.

---

## 💡 Objetivo

Criar e gerenciar uma infraestrutura com deploy automatizado em dois ambientes distintos (staging e produção), priorizando **boas práticas de segurança**, **infraestrutura como código**, e escalabilidade.

---

## 🔐 Segurança: Cuidados e Boas Práticas

- 🔑 **GitHub Secrets:** As credenciais sensíveis (AWS Access Keys, IPs) foram armazenadas com segurança no GitHub Secrets.
- 🔁 **Workflows Separados:** Criação de workflow dedicado ao `destroy`, permitindo reverter configurações mal aplicadas com segurança.
- 👤 **IAM com Privilégios Mínimos:**
  - Políticas customizadas foram criadas para conceder apenas as permissões necessárias.
  - Diferenciação de IAMs para ambientes de `staging` e `produção`.
  - Permissões específicas aplicadas à VPC com `Resource` restrito, por exemplo:  
    ```json
    "Resource": "arn:aws:ec2:us-east-1:<SUA_CONTA_ID>:vpc/*"
    ```
- 📁 **Terraform:**
  - Arquivos `.terraform` e `terraform.tfstate` adicionados ao `.gitignore`.
  - Em produção, utilizar:
    ```bash
    terraform plan -out=tfplan && terraform apply tfplan
    ```
    para garantir que o executado seja exatamente o planejado.
- 🧱 **Segurança de Porta:**
  - Para produção, o acesso à porta da aplicação pode ser restrito por IP:
    ```hcl
    ingress {
      from_port   = var.app_port
      to_port     = var.app_port
      protocol    = "tcp"
      cidr_blocks = ["123.123.123.123/32"] # IP do Load Balancer ou VPN
    }
    ```

---

## 🛠️ Infraestrutura

**Principais recursos criados:**

- EC2 para aplicação (com EIP configurável)
- VPC e Subnets customizadas
- Bucket S3 e tabela DynamoDB para backend remoto
- Segurança configurada via Security Groups e IAM

### Módulos Reutilizáveis
O código foi modularizado, permitindo reutilização e fácil escalabilidade.

**Variáveis utilizadas:**

| Nome        | Tipo     | Descrição                                   | Padrão   |
|-------------|----------|---------------------------------------------|----------|
| `vpc_id`    | string   | ID da VPC para o Security Group             | -        |
| `app_port`  | number   | Porta da aplicação Node.js                  | `3000`   |
| `environment` | string | Ambiente de deploy (`staging` ou `production`) | -      |

---

## ⚙️ CI/CD

O deploy está automatizado via GitHub Actions. Ao fazer push nas branches `staging` ou `production`, o respectivo workflow executa:

1. `terraform init` com backend remoto
2. `terraform plan` e `apply`
3. `docker build` e `push` (caso aplicável)
4. Configura a aplicação em EC2 com segurança

---

## 🧪 Testes seguros

Para testar sem afetar o ambiente de produção:

1. **Crie uma branch de teste**
2. **Edite o workflow de staging (`.github/workflows/ci-staging.yml`)**
   - Altere o nome dos recursos adicionando um prefixo temporário
3. **Adicione novos secrets no repositório GitHub**
   - Exemplo:
     - `TF_VAR_key_name` → `nome-da-chave`
4. Execute localmente:
   ```bash
   terraform apply -replace="aws_instance.app" -var="ami_id=ami-antiga"