-- Tables with number of rows and comments
-- Se omiten las tablas de sistema

select tab.owner as schema_name,
       tab.table_name as table_name,
       obj.created,
       obj.last_ddl_time as last_modified,       
       tab.num_rows,
       tab.last_analyzed,
       comm.comments
  from all_tables tab
       inner join all_objects obj
           on obj.owner = tab.owner
          and obj.object_name = tab.table_name
       left outer join all_tab_comments comm
           on tab.table_name = comm.table_name
          and tab.owner = comm.owner
 where tab.owner not in ('ANONYMOUS','CTXSYS','DBSNMP','EXFSYS',
 'LBACSYS', 'MDSYS','MGMT_VIEW','OLAPSYS','OWBSYS','ORDPLUGINS',
 'ORDSYS','OUTLN', 'SI_INFORMTN_SCHEMA','SYS','SYSMAN','SYSTEM',
 'TSMSYS','WK_TEST','WKSYS', 'WKPROXY','WMSYS','XDB','APEX_040000',
 'APEX_PUBLIC_USER','DIP', 'FLOWS_30000','FLOWS_FILES','MDDATA',
 'ORACLE_OCM','SPATIAL_CSW_ADMIN_USR', 'SPATIAL_WFS_ADMIN_USR',
 'XS$NULL','PUBLIC')
 --  and tab.owner = 'HR' 
 order by tab.owner, tab.table_name;
 
 
-- Listar las vista definidas en el sistema 
select obj.owner as schema_name,
       obj.object_name as view_name,
       obj.created,
       obj.last_ddl_time as last_modified,
       def.text as definition,
       comm.comments
  from all_objects obj
       left outer join all_views def
           on obj.owner = def.owner
          and obj.object_name = def.view_name
       left outer join all_tab_comments comm
           on obj.object_name = comm.table_name
          and obj.owner = comm.owner
 where obj.object_type = 'VIEW'
   and obj.owner not in ('ANONYMOUS','CTXSYS','DBSNMP','EXFSYS',
 'LBACSYS', 'MDSYS','MGMT_VIEW','OLAPSYS','OWBSYS','ORDPLUGINS',
 'ORDSYS','OUTLN', 'SI_INFORMTN_SCHEMA','SYS','SYSMAN','SYSTEM',
 'TSMSYS','WK_TEST','WKSYS', 'WKPROXY','WMSYS','XDB','APEX_040000',
 'APEX_PUBLIC_USER','DIP', 'FLOWS_30000','FLOWS_FILES','MDDATA',
 'ORACLE_OCM','SPATIAL_CSW_ADMIN_USR', 'SPATIAL_WFS_ADMIN_USR',
 'XS$NULL','PUBLIC')
     --and obj.owner = 'HR'
 order by obj.owner, obj.object_name;
 
-- Table columns details
select col.owner as schema_name,
       col.table_name, 
       col.column_name, 
       col.data_type,
       decode(char_length, 
              0, data_type,
              data_type || '(' || char_length || ')') as data_type_ext,
       col.data_length, 
       col.data_precision,  
       col.data_scale,  
       col.nullable, 
       col.data_default as default_value,
       nvl(pk.primary_key, ' ') as primary_key, 
       nvl(fk.foreign_key, ' ') as foreign_key, 
       nvl(uk.unique_key, ' ') as unique_key, 
       nvl(check_const.check_constraint, ' ') check_constraint,
       comm.comments
  from all_tables tab
       inner join all_tab_columns col 
           on col.owner = tab.owner 
          and col.table_name = tab.table_name          
       left join all_col_comments comm
           on col.owner = comm.owner
          and col.table_name = comm.table_name 
          and col.column_name = comm.column_name 
       left join (select constr.owner, 
                         col_const.table_name, 
                         col_const.column_name, 
                         'PK' primary_key
                    from all_constraints constr 
                         inner join all_cons_columns col_const
                             on constr.constraint_name = col_const.constraint_name 
                            and col_const.owner = constr.owner
                   where constr.constraint_type = 'P') pk
           on col.table_name = pk.table_name 
          and col.column_name = pk.column_name
          and col.owner = pk.owner
       left join (select constr.owner, 
                         col_const.table_name, 
                         col_const.column_name, 
                         'FK' foreign_key
                    from all_constraints constr
                         inner join all_cons_columns col_const
                             on constr.constraint_name = col_const.constraint_name 
                            and col_const.owner = constr.owner 
                   where constr.constraint_type = 'R'
                   group by constr.owner, 
                            col_const.table_name, 
                            col_const.column_name) fk
           on col.table_name = fk.table_name 
          and col.column_name = fk.column_name
          and col.owner = fk.owner
       left join (select constr.owner, 
                         col_const.table_name, 
                         col_const.column_name, 
                         'UK' unique_key
                    from all_constraints constr
                         inner join all_cons_columns col_const
                             on constr.constraint_name = col_const.constraint_name 
                            and constr.owner = col_const.owner
                   where constr.constraint_type = 'U' 
                   union
                  select ind.owner, 
                         col_ind.table_name, 
                         col_ind.column_name, 
                         'UK' unique_key
                    from all_indexes ind
                         inner join all_ind_columns col_ind 
                            on ind.index_name = col_ind.index_name                  
                   where ind.uniqueness = 'UNIQUE') uk
           on col.table_name = uk.table_name 
          and col.column_name = uk.column_name
          and col.owner = uk.owner
       left join (select constr.owner, 
                         col_const.table_name, 
                         col_const.column_name, 
                         'Check' check_constraint
                    from all_constraints constr 
                         inner join all_cons_columns col_const
                             on constr.constraint_name = col_const.constraint_name 
                            and col_const.owner = constr.owner
                   where constr.constraint_type = 'C'
                   group by constr.owner, 
                         col_const.table_name, 
                         col_const.column_name) check_const
           on col.table_name = check_const.table_name 
          and col.column_name = check_const.column_name      
          and col.owner = check_const.owner
 where col.owner not in ('ANONYMOUS','CTXSYS','DBSNMP','EXFSYS',
 'LBACSYS', 'MDSYS','MGMT_VIEW','OLAPSYS','OWBSYS','ORDPLUGINS',
 'ORDSYS','OUTLN', 'SI_INFORMTN_SCHEMA','SYS','SYSMAN','SYSTEM',
 'TSMSYS','WK_TEST','WKSYS', 'WKPROXY','WMSYS','XDB','APEX_040000',
 'APEX_PUBLIC_USER','DIP', 'FLOWS_30000','FLOWS_FILES','MDDATA',
 'ORACLE_OCM','SPATIAL_CSW_ADMIN_USR', 'SPATIAL_WFS_ADMIN_USR',
 'XS$NULL','PUBLIC')
 --  and col.owner = 'HR' 
 --  and lower(tab.table_name) like '%'   
 order by col.owner, col.table_name, col.column_name;
 