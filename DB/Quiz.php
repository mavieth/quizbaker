<?php
/* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this file,
* You can obtain one at http://mozilla.org/MPL/2.0/. */

class Quiz {
    var $quizId;
    var $summaryId;
    var $username;
    var $title;
    
    public function save() {
        $this->quizId = $this->createQuiz();
        $this->summaryId = $this->createSummary();
    }
    
    function createQuiz() {
        $p=$_POST;

        $db = $this->connect();
        
        // create quiz record
        $name = $p['quiz']['strTitle'];
        $this->title = $name;
        $sql = "INSERT IGNORE INTO quiz VALUES(NULL, '$name')";
        $quizId = $db->insert($sql) || $this->getQuiz($name);
        return $quizId;
    }

    // if quiz already exists, find it's id
    function getQuiz($name='') {
        $db = $this->connect();

        $sql = "SELECT * from quiz WHERE name='@name'";
        $sql = str_replace("@name", $name, $sql);
        $row = $db->query($sql);
        
        return $row->id;
    }
    
    function createSummary($quizId) {
        $q = $_POST['quiz'];

        $db = $this->connect();

        // create user record with summary of results
        // $user = $q['oOptions']['strName'];
	$user = $_SERVER['LOGON_USER'];
	if (empty($user))
		$user = $q['oOptions']['strName'];
        if (empty($user))
	        $user=$_SERVER['REMOTE_ADDR'];
        $this->username = $user;
        $sql = "INSERT IGNORE INTO quiz_summary values (NULL, @qid, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);";
        $sql = str_replace('@qid', $quizId, $sql);

        $id = $db->insert($sql);
        if ($id>0)
            $this->updateSummary($user, $id);
        $this->summaryId = $id;
        return $id;
    }
    
    function updateSummary($user, $id) {
        $q = $_POST['quiz'];
        $db = $this->connect();

        $data=new stdClass();
        $data['network_id'] = $user;
        $data['status'] = $q['strResult'];
        $data['raw_score'] = $q['strScore'];
        $data['passing_score'] = $q['strPassingScore'];
        $data['max_score'] = $q['strMaxScore'];
        $data['min_score'] = $q['strMinScore'];
        $data['time'] = formatDateTime(new DateTime);
        $sql = "UPDATE quiz_summary SET    
                    network_id = :network_id,
                    status = :status,
                    raw_score = :raw_score,
                    passing_score = :passing_score,
                    max_score = :max_score,
                    min_score = :min_score,
                    time = :time 
                    WHERE id = :id";
        $db->executePrepared($sql, $data);
    }
    
    // if user already exists, find id
    function getUser($quizId) {
        $db = $this->connect();
        
        $sql = "SELECT * from quiz_summary WHERE quiz_id=@quizId";
        $sql = str_replace("@quizId", $quizId, $sql);
        $row = $db->query($sql);
        return $row->id;        
    }

    // create result records
    function createDetails($summaryId) {
        $q = $_POST['quiz'];

        $db = $this->connect();

        // create user record with summary of results
        $sql = "INSERT IGNORE INTO quiz_detail values (NULL, @summaryId, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);";
        $sql = str_replace('@qid', $summaryId, $sql);

        $id = $db->insert($sql);
        if ($id>0)
            $this->updateSummary($summaryId, $id);
        return $id;
    }
    
    function updateDetails($user, $id) {
        $q = $_POST['quiz'];
        $db = $this->connect();

        $data=new stdClass();
        $data['network_id'] = $user;
        $data['status'] = $q['strResult'];
        $data['raw_score'] = $q['strScore'];
        $data['passing_score'] = $q['strPassingScore'];
        $data['max_score'] = $q['strMaxScore'];
        $data['min_score'] = $q['strMinScore'];
        $t = new DateTime;
        $data['time'] = formatDateTime($t);
        $sql = "UPDATE quiz_summary SET    
                    network_id = :network_id,
                    status = :status,
                    raw_score = :raw_score,
                    passing_score = :passing_score,
                    max_score = :max_score,
                    min_score = :min_score,
                    time = :time 
                    WHERE id = :id";
        $db->executePrepared($sql, $data);
    }
    
    // if user already exists, find id
    function getDetails($summaryId) {
        $db = $this->connect();
        
        $sql = "SELECT * from quiz_detail WHERE summary_id=@summaryId";
        $sql = str_replace("@summaryId", $summaryId, $sql);
        $row = $db->query($sql);
        return $row->id;        
    }
    
    public function connect() {
        // connect
        $db = new Database('quizmaker');
        $db->connect();
        return $db;
    }
    
}
?>
