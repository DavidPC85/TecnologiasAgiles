<?php	
	
	$tns = "(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=127.0.0.1)(PORT=1521)))(CONNECT_DATA=(SERVICE_NAME=XE)))";
	
	$conn = null;

	try {
		
		$conn = new PDO("oci:dbname=".$tns, 'DESARROLLO', 'dev2019');
		
		$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);		
		$conn->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
		$conn->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);		
		//$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);  
        //$pdo->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
        //$pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        $conn->setAttribute(PDO::ATTR_CASE, PDO::CASE_LOWER);    
		//---------------------------------------------------------------------
		/*
		//select 		
		$id = 1;		
		$aParams = [
			'id' => 3
		];
		
		$sQuery = "SELECT IID, CUSUARIO, CPASSWORD, DTFECHACREACION, LACTIVO FROM DESARROLLO.USUARIO where IID = :id";

		$stmt = $conn->prepare($sQuery);
		$stmt->execute( $aParams );
		$resultset = $stmt->fetchAll(PDO::FETCH_ASSOC);				
		foreach ($resultset as $row) {
			print $row['iid'] . "\t";
			print $row['cusuario'] . "\t";
			print "\n";
			//var_dump( $row);
		}//fin:foreach
		*/
		//---------------------------------------------------------------------		
	    //INSERT	    
	    $data = [
		    'usuario'  => 'dpech85',
		    'password' => 'pass2019'
		];
		
		$sql  = "INSERT INTO DESARROLLO.usuario(iid,cusuario, cpassword, dtfechacreacion, lactivo) ";		
		$sql .= " VALUES(DESARROLLO.SEQ_ID_USUARIO.nextval ,:usuario, :password, SYSDATE, 1)";

		$conn->beginTransaction();
		$stmt = $conn->prepare($sql);
		if($stmt->execute($data)){
			echo "success insert";
		}
		else{
			echo "Ocurrio un error en el insert";
		}		
		$conn->commit();
		//---------------------------------------------------------------------
		//echo "SELECT TO_TIMESTAMP (SYSDATE, 'DD-Mon-RR HH24:MI:SS.FF')";
		/*
		$date = new DateTime('2000-01-01');
		$result = $date->format('Y-m-d H:i:s');
		*/
		
		//$date = date("Y-m-d H:i:s");
		//echo date_format($date, 'Y-m-d H:i:s');
		//die(0);
		
		/*
		//$_expires = "TO_TIMESTAMP('05/10/2019 10:05:00','DD/MM/YYYY HH24:MI:SS')";
		$_expires = "TO_TIMESTAMP('".date("d/m/Y H:i:s")."','DD/MM/YYYY HH24:MI:SS')";
			
		// Prepare
		$stmt = $conn->prepare("INSERT INTO DESARROLLO.oauth_access_tokens (access_token, client_id, expires, user_id, scope) VALUES (:access_token, :client_id, $_expires, :user_id, :scope)");
		
		//var_dump("INSERT INTO DESARROLLO.oauth_access_tokens (access_token, client_id, expires, user_id, scope) VALUES (:access_token, :client_id, $_expires, :user_id, :scope)"); die(0);
		
		//$delivDate = date('d-m-Y h:i:s', strtotime($_POST['deliveryDate']));    
		//INSERT INTO DELIVERY (DELIVERY_DATE) VALUES (to_date('".$delivDate."','dd-mm-yy hh24:mi:ss'))";
					
	
		$_access_token = 'c2f02897f4db3d599988';
		$_client_id = 'c2f02897f4db3d5';
		
		//$_expires = date("Y-m-d H:i:s");
		//$_expires = "TO_TIMESTAMP('05/10/2019 10:05:00','DD/MM/YYYY HH24:MI:SS')";	
		$_user_id = null;
		$_scope   = null;
		//$_client_id = null;
			
		//DD/MM/RR HH24:MI:SSXFF
		$stmt->bindParam(':access_token', $_access_token);
		$stmt->bindParam(':client_id',$_client_id);
		//$stmt->bindParam(':expires', $_expires, PDO::PARAM_STR);
		$stmt->bindParam(':expires', $_expires);
		$stmt->bindParam(':user_id', $_user_id);
		$stmt->bindParam(':scope', $_scope);
		
		if($stmt->execute()) {
			echo "Se ha creado el nuevo registro!";
		}
		*/				
	} catch(PDOException $e) {
		$conn->rollBack();
		echo 'ERROR: ' . $e->getMessage();
	}
?>