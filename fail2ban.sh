#!/bin/bash

# Mise à jour des paquets
echo "Mise à jour des paquets système..."
sudo apt update && sudo apt upgrade -y

# Installation de fail2ban
echo "Installation de fail2ban..."
sudo apt install fail2ban -y

# Démarrer et activer le service fail2ban
echo "Démarrage et activation du service fail2ban..."
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

# Vérifier que fail2ban est en cours d'exécution
if systemctl is-active --quiet fail2ban; then
    echo "fail2ban est en cours d'exécution."
else
    echo "Échec du démarrage de fail2ban."
    exit 1
fi

# Configuration de base de fail2ban (copie du fichier de configuration par défaut)
echo "Copie du fichier de configuration fail2ban..."
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Modifier la configuration pour ajuster les paramètres de sécurité
echo "Modification des paramètres de sécurité dans fail2ban..."
sudo sed -i 's/^#ignoreip = 127.0.0.1/ignoreip = 127.0.0.1/' /etc/fail2ban/jail.local
sudo sed -i 's/^#bantime = 600/bantime = 3600/' /etc/fail2ban/jail.local   # Bloquer pendant 1 heure (3600 secondes)
sudo sed -i 's/^#maxretry = 3/maxretry = 5/' /etc/fail2ban/jail.local       # Tentatives de connexion échouées avant le bannissement
sudo sed -i 's/^#findtime = 600/findtime = 600/' /etc/fail2ban/jail.local    # Temps (en secondes) dans lequel maxretry doit être atteint
sudo sed -i 's/^#enabled = false/enabled = true/' /etc/fail2ban/jail.local    # Activer le filtre SSH

# Redémarrer fail2ban pour appliquer les modifications
echo "Redémarrage de fail2ban pour appliquer les changements..."
sudo systemctl restart fail2ban

# Vérifier l'état de fail2ban
echo "Vérification de l'état de fail2ban..."
sudo fail2ban-client status

# Afficher les règles en cours
echo "Affichage des règles en cours dans fail2ban..."
sudo fail2ban-client status sshd

echo "fail2ban a été installé et configuré avec succès."
