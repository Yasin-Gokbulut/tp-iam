-- Liste des groupes Odoo utilisés par les rôles du TP, avec leur identifiant numérique
SELECT g.id,
       d.module || '.' || d.name AS xml_id,
       g.name ->> 'en_US'        AS nom
FROM res_groups g
JOIN ir_model_data d ON d.model = 'res.groups' AND d.res_id = g.id
WHERE d.module || '.' || d.name IN (
      'base.group_user', 'base.group_system', 'base.group_erp_manager',
      'sales_team.group_sale_salesman', 'sales_team.group_sale_manager',
      'hr.group_hr_user', 'account.group_account_invoice')
ORDER BY g.id;
