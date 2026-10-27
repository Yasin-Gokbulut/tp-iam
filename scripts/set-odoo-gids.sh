#!/usr/bin/env bash
# Remplace les jetons __GID_xxx__ des rôles applicatifs par les ID réels des groupes Odoo.
set -euo pipefail
cd "$(dirname "$0")/.."
DB=odoo_demo
declare -A MAP=(
  [USER]=base.group_user
  [SYSTEM]=base.group_system
  [ERP_MANAGER]=base.group_erp_manager
  [SALE_SALESMAN]=sales_team.group_sale_salesman
  [SALE_MANAGER]=sales_team.group_sale_manager
  [HR_USER]=hr.group_hr_user
  [ACCOUNT_INVOICE]=account.group_account_invoice
)
for key in "${!MAP[@]}"; do
  xmlid=${MAP[$key]}; module=${xmlid%%.*}; name=${xmlid#*.}
  id=$(docker compose exec -T odoo_db psql -U odoo -d "$DB" -tAc \
       "SELECT res_id FROM ir_model_data WHERE model='res.groups' AND module='$module' AND name='$name'")
  [[ -z "$id" ]] && { echo "Groupe $xmlid introuvable (module installé ?)"; exit 1; }
  sed -i "s/__GID_${key}__/${id}/g" objects/2*-role-odoo-*.xml
  printf '%-34s -> %s\n' "$xmlid" "$id"
done
