# Set Terraform working directory
$TERRAFORM_WORKING_DIR = "main.tf"

# Set Terraform configuration file
$TERRAFORM_CONFIG_FILE = "main.tf"

# Set Terraform state file
$TERRAFORM_STATE_FILE = "terraform.tfstate"

# Initialize Terraform working directory
Set-Location $TERRAFORM_WORKING_DIR

# Initialize Terraform
Write-Host "Initializing Terraform..."
terraform init

# Validate Terraform configuration
Write-Host "Validating Terraform configuration..."
terraform validate

# Plan Terraform configuration
Write-Host "Planning Terraform configuration..."
terraform plan -out "tfplan"

# Apply Terraform configuration
Write-Host "Applying Terraform configuration..."
terraform apply -auto-approve

# Check if Terraform deployment was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host "Terraform deployment successful!"
    exit 0
} else {
    Write-Host "Terraform deployment failed!"
    exit 1
}