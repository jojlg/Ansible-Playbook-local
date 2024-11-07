#Ajout de quelques fonctions pour renforcer la sécurité
#/etc/apt/apt.conf.d/20auto-upgrades




# Chemin du fichier de configuration
APT_CONF="/etc/apt/apt.conf.d/20auto-upgrades"

# Créer ou mettre à jour les configurations pour les mises à jour automatiques
echo "Configuration de $APT_CONF pour activer les mises à jour automatiques..."

sudo tee $APT_CONF > /dev/null <<EOL
// Activer les mises à jour automatiques de sécurité
APT::Periodic::Unattended-Upgrade "1";

// Télécharger automatiquement les paquets disponibles pour mise à jour
APT::Periodic::Download-Upgradeable-Packages "1";

// Nettoyer automatiquement les paquets obsolètes à intervalle
APT::Periodic::AutocleanInterval "7";

// Mettre à jour la liste des paquets
APT::Periodic::Update-Package-Lists "1";
EOL

echo "Configuration ajoutée dans $APT_CONF."

# Redémarrer le timer apt-daily pour appliquer les modifications
echo "Redémarrage du timer apt-daily pour appliquer les changements..."
sudo systemctl restart apt-daily.timer
sudo systemctl restart apt-daily-upgrade.timer

echo "Configuration de sécurité mise à jour avec succès et timers redémarrés."
