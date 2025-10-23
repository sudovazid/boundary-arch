#!/bin/bash
echo "-------------------Creating Terraform backend bucket-------------------"
echo "Running Terraform backend"
echo ""
cd boundary-backend-tf
terraform init
echo "-----------------------------------------------------------------------"
echo ""

# Function to safely read a variable from terraform.tfvars (if exists)
# Note: This crude parsing works only for simple string assignments (var = "value")
get_default_var() {
    local var_name=$1
    local default_value=""

    # Check if tfvars file exists and read the value
    if [ -f "terraform.tfvars" ]; then
        default_value=$(grep "^${var_name}\s*=" terraform.tfvars | awk -F'=' '{print $2}' | tr -d ' ' | tr -d '"' | tr -d '\n')
    fi
    echo "$default_value"
}

# 1. Read variables, showing defaults and using them if input is empty
DEFAULT_BUCKET_NAME=$(get_default_var "bucket_name")
read -p "Enter the backend bucket name (e.g., backend-tf) [Default: $DEFAULT_BUCKET_NAME]: " BUCKET_NAME_INPUT
BUCKET_NAME=${BUCKET_NAME_INPUT:-$DEFAULT_BUCKET_NAME}

DEFAULT_PROJECT_ID=$(get_default_var "project_id")
read -p "Enter the project id [Default: $DEFAULT_PROJECT_ID]: " PROJECT_ID_INPUT
PROJECT_ID=${PROJECT_ID_INPUT:-$DEFAULT_PROJECT_ID}

DEFAULT_REGION=$(get_default_var "region")
read -p "Enter region (e.g., us-central1) [Default: $DEFAULT_REGION]: " REGION_INPUT
REGION=${REGION_INPUT:-$DEFAULT_REGION}

echo ""
echo "--- Applying Configuration ---"

# Capture output and display simultaneously using tee, redirecting stderr to stdout
APPLY_OUTPUT=$( \
    terraform apply \
    -var="bucket_name=$BUCKET_NAME" \
    -var="project_id=$PROJECT_ID" \
    -var="region=$REGION" \
    -auto-approve \
    2>&1 | tee /dev/tty \
)
APPLY_STATUS=$?

# Check for Terraform errors
if [ $APPLY_STATUS -ne 0 ]; then
    echo "❌ ERROR: Terraform apply failed."
    echo "-----------------------------------------------------------------------"
    exit 1
fi

# Check for the "Already Exists" message in the output summary
if echo "$APPLY_OUTPUT" | grep -q "Resources: 0 added, 0 changed, 0 destroyed."; then
    STATUS_MESSAGE="Bucket already existed (verified)."
else
    STATUS_MESSAGE="GCS State Bucket created successfully."
fi

echo ""
echo "Extraction bucket name..."
BUCKET_FULL_NAME=$(terraform output -raw bucket_name)
echo "-----------------------------------------------------------------------"
echo "✅ ${STATUS_MESSAGE}: ${BUCKET_FULL_NAME} in ${REGION} on project ${PROJECT_ID}"

echo "--------------------- Starting with GCP Boundary Architecture ---------------------"

# --- NEW LOGIC START: Dynamic Backend Config without modifying main.tf ---

# 1. Change to the parent directory and then into the architecture directory
cd ..
cd boundary-arch-tf

# 2. Define the path for the temporary backend config file
BACKEND_CONFIG_FILE="backend.conf"

echo "Writing dynamic backend configuration to ${BACKEND_CONFIG_FILE}..."

# 3. Create the temporary backend config file using the extracted bucket name
# This file will hold the bucket configuration for terraform init
cat > "${BACKEND_CONFIG_FILE}" <<- EOF
bucket = "${BUCKET_FULL_NAME}"
prefix = "terraform/state/boundary"
EOF

# 4. Initialize Terraform using the dynamic backend config file
# The -backend-config flag tells 'init' to use this file to configure the backend.
terraform init -backend-config="${BACKEND_CONFIG_FILE}"

# 5. Clean up the temporary config file
rm "${BACKEND_CONFIG_FILE}"

# --- NEW LOGIC END ---
