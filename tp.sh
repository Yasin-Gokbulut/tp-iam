#!/usr/bin/env bash
# Pilotage de l'environnement du TP : ./tp.sh {start|stop|status|logs|init-odoo|reset}
set -euo pipefail
cd "$(dirname "$0")"

ODOO_DB=odoo_demo

case "${1:-}" in
  start)
    docker compose up -d
    echo "midPoint : http://localhost:8080/midpoint  (administrator / Test5ecr3t)"
    echo "Odoo     : http://localhost:8069           (admin / admin)"
    ;;
  stop)
    docker compose stop            # arrête les conteneurs, conserve les données
    ;;
  status)
    docker compose ps
    ;;
  logs)
    docker compose logs -f "${2:-midpoint_server}"
    ;;
  init-odoo)
    # Crée la base Odoo avec les données de démonstration et installe RH, CRM, Facturation
    docker compose run --rm odoo odoo -d "$ODOO_DB" -i hr,crm,account --stop-after-init
    docker compose restart odoo
    ;;
  reset)
    read -r -p "Supprimer TOUTES les données (midPoint + Odoo) ? [o/N] " r
    [[ "$r" == "o" ]] && docker compose down -v
    ;;
  *)
    echo "Usage : $0 {start|stop|status|logs [service]|init-odoo|reset}"
    exit 1
    ;;
esac
