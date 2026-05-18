#!/bin/bash

# GIWA Node Quick Start Script
# This script automates the setup of a GIWA node on Ubuntu/Debian systems

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}  GIWA Node Quick Start Setup${NC}"
echo -e "${GREEN}================================${NC}"
echo ""

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}This script should NOT be run as root${NC}"
   echo "Please run as a normal user with sudo privileges"
   exit 1
fi

# Function to print status messages
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Check system requirements
echo -e "${YELLOW}Checking system requirements...${NC}"
echo ""

# Check OS
if [[ ! -f /etc/os-release ]]; then
    print_error "Cannot determine OS. This script is designed for Ubuntu/Debian."
    exit 1
fi

source /etc/os-release
echo "OS: $PRETTY_NAME"

# Check CPU cores
CPU_CORES=$(nproc)
echo "CPU Cores: $CPU_CORES"
if [ "$CPU_CORES" -lt 4 ]; then
    print_warning "Recommended: 4+ CPU cores (you have $CPU_CORES)"
else
    print_status "CPU cores: OK"
fi

# Check RAM
TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
echo "RAM: ${TOTAL_RAM}GB"
if [ "$TOTAL_RAM" -lt 8 ]; then
    print_warning "Recommended: 8GB+ RAM (you have ${TOTAL_RAM}GB)"
else
    print_status "RAM: OK"
fi

# Check disk space
AVAILABLE_SPACE=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')
echo "Available Disk Space: ${AVAILABLE_SPACE}GB"
if [ "$AVAILABLE_SPACE" -lt 500 ]; then
    print_error "Insufficient disk space. Need 500GB+ (you have ${AVAILABLE_SPACE}GB)"
    echo "Please free up space or use a larger disk"
    exit 1
else
    print_status "Disk space: OK"
fi

echo ""
echo -e "${GREEN}System requirements check complete!${NC}"
echo ""

# Prompt for network selection
echo "Which network do you want to run?"
echo "1) Testnet (Sepolia) - Recommended for testing"
echo "2) Mainnet - Coming soon"
echo ""
read -p "Enter choice [1]: " NETWORK_CHOICE
NETWORK_CHOICE=${NETWORK_CHOICE:-1}

if [ "$NETWORK_CHOICE" == "2" ]; then
    print_error "Mainnet is not yet available. Please use Testnet."
    exit 1
fi

NETWORK="sepolia"
ENV_FILE=".env.sepolia"
print_status "Selected: Testnet (Sepolia)"
echo ""

# Prompt for execution client
echo "Which execution client do you want to use?"
echo "1) Reth - Recommended (faster, lower resources)"
echo "2) Geth - Battle-tested alternative"
echo ""
read -p "Enter choice [1]: " CLIENT_CHOICE
CLIENT_CHOICE=${CLIENT_CHOICE:-1}

if [ "$CLIENT_CHOICE" == "2" ]; then
    CLIENT="geth"
else
    CLIENT="reth"
fi
print_status "Selected: $CLIENT"
echo ""

# Check for Docker
echo -e "${YELLOW}Installing dependencies...${NC}"
echo ""

if ! command -v docker &> /dev/null; then
    print_warning "Docker not found. Installing Docker..."
    
    # Install Docker
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg lsb-release
    
    # Add Docker GPG key
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    # Add Docker repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Install Docker Engine
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    
    # Add user to docker group
    sudo usermod -aG docker $USER
    
    print_status "Docker installed successfully"
    print_warning "You may need to log out and back in for docker group permissions to take effect"
else
    print_status "Docker already installed"
fi

# Verify Docker Compose
if ! docker compose version &> /dev/null; then
    print_error "Docker Compose plugin not found"
    echo "Please install Docker Compose V2: https://docs.docker.com/compose/install/"
    exit 1
else
    print_status "Docker Compose available"
fi

echo ""

# Clone or update repository
echo -e "${YELLOW}Setting up GIWA node repository...${NC}"
echo ""

GIWA_DIR="$HOME/giwa-node"

if [ -d "$GIWA_DIR" ]; then
    print_warning "Directory $GIWA_DIR already exists"
    read -p "Update existing installation? [Y/n]: " UPDATE_CHOICE
    UPDATE_CHOICE=${UPDATE_CHOICE:-Y}
    
    if [[ "$UPDATE_CHOICE" =~ ^[Yy]$ ]]; then
        cd "$GIWA_DIR"
        git pull origin main
        print_status "Repository updated"
    fi
else
    git clone https://github.com/giwa-io/node.git "$GIWA_DIR"
    print_status "Repository cloned"
fi

cd "$GIWA_DIR"
echo ""

# Configure environment
echo -e "${YELLOW}Configuring node...${NC}"
echo ""

# Check if .env.sepolia exists
if [ ! -f "$ENV_FILE" ]; then
    print_error "Environment file $ENV_FILE not found"
    exit 1
fi

# Prompt for L1 RPC endpoint
echo "You need an Ethereum L1 RPC endpoint."
echo "Examples:"
echo "  - Alchemy: https://eth-sepolia.g.alchemy.com/v2/YOUR-API-KEY"
echo "  - Infura: https://sepolia.infura.io/v3/YOUR-API-KEY"
echo "  - Quicknode: https://your-endpoint.quiknode.pro/YOUR-TOKEN"
echo ""
read -p "Enter your L1 RPC endpoint: " L1_RPC

if [ -z "$L1_RPC" ]; then
    print_error "L1 RPC endpoint is required"
    exit 1
fi

# Prompt for L1 Beacon endpoint
echo ""
echo "You need an Ethereum L1 Beacon node endpoint."
echo "Examples:"
echo "  - Alchemy: https://eth-sepolia.g.alchemy.com/v2/YOUR-API-KEY"
echo "  - Infura: https://sepolia-beacon.infura.io/YOUR-API-KEY"
echo ""
read -p "Enter your L1 Beacon endpoint: " L1_BEACON

if [ -z "$L1_BEACON" ]; then
    print_error "L1 Beacon endpoint is required"
    exit 1
fi

# Update .env file
sed -i "s|^OP_NODE_L1_ETH_RPC=.*|OP_NODE_L1_ETH_RPC=$L1_RPC|" "$ENV_FILE"
sed -i "s|^OP_NODE_L1_BEACON=.*|OP_NODE_L1_BEACON=$L1_BEACON|" "$ENV_FILE"

print_status "Configuration updated"
echo ""

# Ask about snapshot
echo "Do you want to use a snapshot for faster initial sync?"
echo "(Highly recommended - reduces sync time from days to hours)"
read -p "Use snapshot? [Y/n]: " SNAPSHOT_CHOICE
SNAPSHOT_CHOICE=${SNAPSHOT_CHOICE:-Y}

if [[ "$SNAPSHOT_CHOICE" =~ ^[Yy]$ ]]; then
    print_status "Snapshot recommended. Visit: https://docs.giwa.io/node-operators/snapshots"
    echo "Apply snapshot before starting the node for the first time."
    echo ""
fi

# Build containers
echo -e "${YELLOW}Building Docker containers...${NC}"
echo "This may take several minutes..."
echo ""

CLIENT=$CLIENT docker compose build --parallel

print_status "Docker containers built successfully"
echo ""

# Create systemd service (optional)
read -p "Create systemd service for auto-start on boot? [Y/n]: " SYSTEMD_CHOICE
SYSTEMD_CHOICE=${SYSTEMD_CHOICE:-Y}

if [[ "$SYSTEMD_CHOICE" =~ ^[Yy]$ ]]; then
    SERVICE_FILE="/etc/systemd/system/giwa-node.service"
    
    sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=GIWA Node
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=$GIWA_DIR
Environment="CLIENT=$CLIENT"
Environment="NETWORK_ENV=$ENV_FILE"
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
User=$USER

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable giwa-node.service
    
    print_status "Systemd service created and enabled"
fi

echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}  Setup Complete!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo "To start your GIWA node:"
echo ""
echo -e "${YELLOW}  cd $GIWA_DIR${NC}"
echo -e "${YELLOW}  CLIENT=$CLIENT NETWORK_ENV=$ENV_FILE docker compose up -d${NC}"
echo ""
echo "To view logs:"
echo ""
echo -e "${YELLOW}  docker compose logs -f${NC}"
echo ""
echo "To stop your node:"
echo ""
echo -e "${YELLOW}  docker compose down${NC}"
echo ""

if [[ "$SNAPSHOT_CHOICE" =~ ^[Yy]$ ]]; then
    print_warning "Remember to apply snapshot before first start!"
    echo "Guide: https://docs.giwa.io/node-operators/snapshots"
    echo ""
fi

echo "Useful resources:"
echo "  📖 Documentation: https://docs.giwa.io"
echo "  🐙 GitHub: https://github.com/giwa-io/node"
echo "  🆇 X/Twitter: @giwachain"
echo "  📧 Email: support@giwa.io"
echo ""
echo -e "${GREEN}Happy noding!${NC}"
