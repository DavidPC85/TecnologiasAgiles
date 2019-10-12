
<?php
	try {
	    
	    $oConn = new PDO('mysql:host=127.0.0.1;dbname=seguridad', 'root', 'rpass2018');
	    $oConn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

	    // 'dsn' => "mysql:dbname=".$db['dbname'].";host=".$db['host'], 'username' => $db['user'], 'password' => $db['pass']

	    //---------------------------------------------------------------------
	    //Iteracion para SELECT
	    /*
	    foreach($mbd->query('SELECT * from usuario') as $fila) {
	        print_r($fila);
	    }
	    $mbd = null;
	    */
	    //---------------------------------------------------------------------
	    //INSERT
	    /*
	    $data = [
		    'usuario'  => 'dpechcutz',
		    'password' => 'pass2019'
		];
		
		$sql  = "INSERT INTO usuario(cusuario, cpassword, dtfechacreacion, lactivo)";
		$sql .= " VALUES(:usuario, :password, CURRENT_TIMESTAMP, 1);";
		$stmt = $oConn->prepare($sql);
		if($stmt->execute($data)){
			echo "success insert";
		}
		else{
			echo "Ocurrio un error en el insert";
		}
		*/
		//---------------------------------------------------------------------
		/*
		$data = [		   
			'id' => 1,
		    'password' => 'pass2019'
		];
		
		$sql  = "UPDATE usuario set dtfechacreacion = CURRENT_TIMESTAMP,";
		$sql .= " cpassword = :password ";
		$sql .= " where iid = :id ";
		
		$stmt = $oConn->prepare($sql);
		if($stmt->execute($data)){
			echo "success update";
		}
		else{
			echo "Ocurrio un error en el update";
		}
		*/
		//---------------------------------------------------------------------
		/*
		$data = [		   
			'id' => 2		    
		];
		
		$sql = "DELETE FROM usuario WHERE iid = :id";        
	   	$stmt = $oConn->prepare($sql);
		if($stmt->execute($data)){
			echo "success delete";
		}
		else{
			echo "Ocurrio un error en el delete";
		} 
		*/
		//---------------------------------------------------------------------

	} catch (PDOException $e) {
	    print "¡Error!: " . $e->getMessage() . "<br/>";
	    die();
	}
?>
