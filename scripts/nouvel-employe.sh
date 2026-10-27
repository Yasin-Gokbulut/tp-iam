#!/usr/bin/env bash
# Simule un dépôt d'export RH : ajoute un employé au CSV (test de la chaîne automatique).
set -euo pipefail
cd "$(dirname "$0")/.."
echo '"027","Bruno","Martin","S007","11100"' >> hr/hr.csv
echo "Employé 027 ajouté. Vérifier dans ~60 s : midPoint > Utilisateurs, puis Odoo > Paramètres > Utilisateurs."
