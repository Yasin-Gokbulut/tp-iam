#!/usr/bin/env bash
# Déploie (crée ou remplace) les objets XML du dossier objects/ via l'API REST de midPoint.
# Usage : MP_PASS='motdepasse' ./scripts/deploy.sh [fichier.xml ...]
set -euo pipefail
cd "$(dirname "$0")/.."
MP_URL=${MP_URL:-http://localhost:8080/midpoint}
MP_USER=${MP_USER:-administrator}
MP_PASS=${MP_PASS:?Définir MP_PASS (mot de passe de l administrateur midPoint)}

files=("$@"); [[ ${#files[@]} -eq 0 ]] && files=(objects/[0-4]*.xml)

for f in "${files[@]}"; do
  oid=$(grep -o 'oid="[^"]*"' "$f" | head -1 | cut -d'"' -f2)
  root=$(grep -oE '<(resource|role|task|archetype|objectTemplate)[ >]' "$f" | head -1 | tr -d '< >')
  case $root in
    resource) ep=resources ;;  role) ep=roles ;;  task) ep=tasks ;;
    archetype) ep=archetypes ;;  objectTemplate) ep=objectTemplates ;;
    *) echo "IGNORÉ  $f (type non géré)"; continue ;;
  esac
  code=$(curl -s -o /dev/null -w '%{http_code}' -u "$MP_USER:$MP_PASS" -X PUT \
         -H 'Content-Type: application/xml' --data-binary @"$f" "$MP_URL/ws/rest/$ep/$oid")
  echo "HTTP $code  $ep/$oid  <- $f"
done
