# RetailMax Infrastructure

## Objetivos del proyecto
Lograr integración centralizada y sincronizada de inventarios entre las 50 tiendas físicas y la tienda en línea.
Permitir la visibilidad en tiempo real de inventario global, facilitando las decisiones para reabastecimiento, distribución y ventas omnicanal.

## ⚠️ CONFIGURACIÓN OPTIMIZADA PARA AWS ACADEMY

Esta infraestructura ha sido específicamente optimizada para funcionar con las limitaciones y restricciones de **AWS Academy Learner Lab**, que tiene recursos limitados y costos controlados.

### 🔧 Optimizaciones Implementadas

#### 1. **EKS Cluster - DESHABILITADO TEMPORALMENTE**
- ❌ **Estado**: Comentado en `main.tf`
- 💰 **Motivo**: EKS es muy costoso (~$72/mes solo por el control plane)
- 🔄 **Alternativa**: Instancia EC2 simple con Docker
- ✅ **Para habilitarlo**: Descomentar el bloque `module "eks"` en `main.tf`

#### 2. **VPC Simplificada**
```hcl
# Configuración actual (optimizada)
azs             = ["us-east-1a", "us-east-1b"]  # Solo 2 AZs
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]  # Solo públicas
enable_nat_gateway = false  # Sin NAT Gateway
```

#### 3. **NAT Gateway - DESHABILITADO**
- ❌ **Estado**: `enable_nat_gateway = false`
- 💰 **Ahorro**: ~$32/mes + transferencia de datos
- 🔄 **Consecuencia**: Solo subnets públicas disponibles

#### 4. **Instancia EC2 de Prueba**
```hcl
resource "aws_instance" "retailmax_app" {
  ami           = "ami-0c02fb55956c7d316"  # Amazon Linux 2
  instance_type = "t2.micro"               # Free tier
  # ...
}
```

### 💰 Análisis de Costos

| Recurso | Configuración Original | Configuración AWS Academy | Ahorro Mensual |
|---------|----------------------|---------------------------|----------------|
| EKS Control Plane | $72.00 | $0.00 (deshabilitado) | $72.00 |
| NAT Gateway | $32.40 | $0.00 (deshabilitado) | $32.40 |
| EC2 Instances | t3.medium | t2.micro (free tier) | ~$20.00 |
| **TOTAL** | **~$124.40** | **~$0.00** | **~$124.40** |

### 🚀 Instrucciones de Despliegue

#### Prerrequisitos para AWS Academy:
1. **Acceso al AWS Academy Learner Lab**
2. **Credenciales temporales configuradas** (se renuevan cada sesión)
3. **Terraform instalado** localmente

#### Pasos:
```bash
# 1. Inicializar Terraform
terraform init

# 2. Validar configuración
terraform validate

# 3. Revisar plan (recursos a crear)
terraform plan

# 4. Aplicar infraestructura
terraform apply
```

### ⚙️ Configuración de Credenciales AWS Academy

Las credenciales de AWS Academy son **temporales** y deben renovarse cada sesión:

```bash
# Exportar credenciales desde AWS Academy Details
export AWS_ACCESS_KEY_ID="tu_access_key"
export AWS_SECRET_ACCESS_KEY="tu_secret_key" 
export AWS_SESSION_TOKEN="tu_session_token"
```

### 🔄 Migración a Producción

Cuando tengas acceso a una cuenta AWS completa, puedes habilitar recursos adicionales:

#### Para habilitar EKS:
1. Descomenta el bloque `module "eks"` en `main.tf`
2. Cambia a subnets privadas:
   ```hcl
   private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
   enable_nat_gateway = true
   ```
3. Ejecuta `terraform plan` y `terraform apply`

#### Para instancias más grandes:
```hcl
instance_types = ["t3.medium"]  # o más grandes
min_size       = 2
max_size       = 5
```

### 📋 Recursos Actuales Creados

- ✅ **VPC** con 2 AZs y subnets públicas
- ✅ **EC2 Instance** (t2.micro) para testing
- ✅ **Security Groups** básicos
- ❌ **EKS Cluster** (deshabilitado)
- ❌ **NAT Gateway** (deshabilitado)

### 🔍 Monitoreo y Troubleshooting

#### Comandos útiles:
```bash
# Ver estado actual
terraform show

# Destruir recursos (importante al final de sesión Academy)
terraform destroy

# Ver logs de instancia
aws ec2 describe-instances --instance-ids <instance-id>
```

### ⚠️ Limitaciones Conocidas de AWS Academy

1. **Credenciales temporales** - Se vencen cada pocas horas
2. **Límites de instancias** - Máximo 2-3 instancias simultáneas
3. **Sin soporte para ciertos servicios** (EKS puede estar limitado)
4. **Regiones limitadas** - Principalmente us-east-1
5. **Presupuesto limitado** - $100 USD típicamente

### 📞 Soporte

Si encuentras errores relacionados con:
- **Credenciales**: Renueva las credenciales desde AWS Academy
- **Límites**: Verifica los límites de tu cuenta Academy
- **Permisos**: Algunos recursos pueden requerir permisos adicionales

---

**Última actualización**: Septiembre 2025  
**Configurado para**: AWS Academy Learner Lab  
**Terraform Version**: >= 1.5.0