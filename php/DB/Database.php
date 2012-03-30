<?
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this file,
* You can obtain one at http://mozilla.org/MPL/2.0/. */

class Database
{
	public $host;
	public $database;
	public $user;
	public $password;
	
	function __construct($database, $user='root', $password='', $host='localhost')
	{
		assert(!empty($database));
		$this->database = $database;
		$this->user = $user;
		$this->password = $password;
		$this->host = $host;
	}
	
	function connect() 
	{
		try {
			$options = array(PDO::ATTR_PERSISTENT => true);
			$template = 'mysql:host=%s;dbname=%s';
			$database = sprintf($template, $this->host, $this->database); 
			$connection = new PDO($database, $this->user, $this->password, $options);
		  // necessary to generate Exceptions, otherwise will simply return empty object
			$connection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		} catch (Exception $e) {
			throw new Exception('can not connect');
		}
		return $connection;
	}

	function insert($sql)
	{
		$this->query($sql);
		$connection = $this->connect();
		return $connection->lastInsertId();
	}
	
	function executePrepared($sql, $data)
	{
		assert(is_string($sql));
		
		$result = false;
		$connection = $this->connect();	
		try {
			$statement = $connection->prepare($sql);
			foreach ($data as $key=>$value)
				$params[':'.$key] = $value;
				//$statement->bindParam(":" . $key, $value);
			$result = $statement->execute($params);
		}
		catch (Exception $e) {
			throw $e;
		}
		return $result;
	}
	
	function query($sql)
	{
		assert(is_string($sql));
		
		$rows = array();
		try {	
			$connection = $this->connect();	
		} 
		catch (Exception $e) {
			throw $e;
		}
		try {
			$rows = $connection->query($sql, PDO::FETCH_OBJ);
		}
		catch (Exception $e) {
			throw $e;
		}
		return $rows;
	}
}

?>