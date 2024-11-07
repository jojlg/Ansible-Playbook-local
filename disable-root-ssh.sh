#!/bin/bash

# Fichier de configuration SSH
SSH_CONFIG="/etc/ssh/sshd_config"

# Vérifier si le fichier de configuration SSH existe
if [ ! -f "$SSH_CONFIG" ]; then
    echo "Le fichier de configuration $SSH_CONFIG est introuvable."
    exit 1
fi

# Désactiver la connexion root via SSH
echo "Désactivation de la connexion root via SSH..."

# Modifier ou ajouter la ligne PermitRootLogin no
sudo sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' "$SSH_CONFIG"
sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' "$SSH_CONFIG"

# Sauvegarder le fichier avant de procéder au redémarrage du service SSH
echo "Redémarrage du service SSH pour appliquer les changements..."

# Essayer de redémarrer le service SSH avec 'ssh' au lieu de 'sshd'
if sudo systemctl restart ssh; then
    echo "Le service SSH a été redémarré avec succès."
else
    echo "Erreur lors du redémarrage du service SSH. Veuillez vérifier votre installation SSH."
    exit 1
fi

echo "La connexion root via SSH a été désactivée."
