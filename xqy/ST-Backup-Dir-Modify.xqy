xquery version "1.0-ml";
(: 
  Written by Indrajeet Verma (Indy) 
- This code will update the $backup-dir for all the existing schedule Tasks that mentioned in the database list (line no 42). 
- This code will not create any new STs.
- This code first save configurations with $updated backup-dir 
- Then delete the existing confirgurations
- Save configurations with updated $backup-dir value
- This code can be run via qconsole by selecting any Content Source and Query Type: XQuery
:)
import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
(: New ST backup directory that you want to add in the configuration :)
declare variable $NEW-BACK-DIR := "E:\marklogicBackups\dbs\";
declare function local:update-backup-directory($node as node(), $db) as node()
{
  typeswitch($node)
  (: create a document node and recurse :)
  case document-node() return
    document {
      $node/(element()|text()|binary()) ! local:update-backup-directory(., $db)
    }
   (: create an element node, copy attributes, and recurse :)
  case element() return
    element { fn:node-name($node) } {
      if(fn:local-name($node) = ("backup-directory")) then 
      (
        (:E:\marklogicBackups\dbs\<db-name>:)
        $NEW-BACK-DIR||$db
      )
      else
      (
        $node/@*,
        $node/node() ! local:update-backup-directory(., $db)
      ) 
   }
  (: return $node as is, will be copied when added to another parent :)
  default return $node
};

(: Starting point:)
let $dbList := ("Fab", "Modules") (: database names for them you want to rename the backup-dir for the STs:)
for $db in $dbList
let $config := admin:get-configuration()
let $database := xdmp:database($db)
let $current-config := admin:database-get-backups($config, $database)
let $updated-config := local:update-backup-directory($current-config, $db)
let $cfgs := admin:database-delete-backup($config, $database, $current-config)
let $_ := admin:save-configuration($cfgs)
return 
  admin:save-configuration(admin:database-add-backup($config, $database, $updated-config))

