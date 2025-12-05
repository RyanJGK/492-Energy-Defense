#!/bin/bash
# Quick Deploy Script - Ultra Simple Version

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Quick Deploy to Hetzner                              ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Get server IP
read -p "Enter your Hetzner server IP: " SERVER_IP

if [ -z "$SERVER_IP" ]; then
    echo "Error: Server IP required"
    exit 1
fi

echo ""
echo "Deploying to $SERVER_IP..."
echo ""

# Run main deployment
./hetzner-deploy/deploy-to-hetzner.sh "$SERVER_IP" root

echo ""
echo "════════════════════════════════════════════════════════"
echo "Deployment Complete!"
echo ""
echo "Access your application:"
echo "  Dashboard: http://$SERVER_IP:3000"
echo "  API:       http://$SERVER_IP:8000"
echo "  Docs:      http://$SERVER_IP:8000/docs"
echo ""
echo "To check status:"
echo "  ssh root@$SERVER_IP 'cd /opt/cyberdefense && docker-compose ps'"
echo ""
