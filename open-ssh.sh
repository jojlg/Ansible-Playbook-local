#!/bin/bash

# Vérification des droits root
if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être exécuté en tant que root."
   exit 1
fi

# Installation d'OpenSSH
echo "Installation d'OpenSSH Server..."
apt update && apt install -y openssh-server

# Activation du protocole SSHv2 uniquement
echo "Configuration de SSH pour utiliser uniquement le protocole SSHv2..."
sed -i '/^#?Protocol/s/^.*$/Protocol 2/' /etc/ssh/sshd_config

# Création de la bannière de sécurité
echo "Création de la bannière SSH..."
cat << 'EOF' > /etc/ssh/banner
********************************************************
*                 AVERTISSEMENT                        *
https://192.168.1.98***********************************************
*  Cette connexion est la propriété de la société X.   *
*  L'accès est autorisé uniquement aux utilisateurs    *
*  autorisés. Toute autre tentative constitue une      *
*  violation de la sécurité et sera poursuivie en      *
*  justice.                                            *
********************************************************
********************************************************
*                    WARNING                           *
********************************************************
*  This connection is the property of X. Access is     *
*  only permitted to authorized users. Any other       *
*  access attempt constitutes a violation of system    *
*  security and will be prosecuted to the fullest      *
*  extent of the law.                                  *
********************************************************
EOF

# Configuration pour utiliser la bannière
echo "Activation de la bannière SSH..."
if grep -q '^#?Banner' /etc/ssh/sshd_config; then
  sed -i '/^#?Banner/s|^.*$|Banner /etc/ssh/banner|' /etc/ssh/sshd_config
else
  echo 'Banner /etc/ssh/banner' >> /etc/ssh/sshd_config
fi

# Vérification de la configuration SSH
echo "Vérification de la syntaxe de la configuration SSH..."
sshd -t
if [[ $? -ne 0 ]]; then
  echo "Erreur de configuration dans /etc/ssh/sshd_config. Veuillez vérifier les erreurs."
  exit 1
fi

# Redémarrage du service SSH pour appliquer les modifications
echo "Redémarrage du service SSH..."
systemctl restart sshd

echo "Configuration d'OpenSSH terminée avec succès."
