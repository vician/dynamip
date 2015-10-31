#!/usr/bin/php
<?php

// Include constants for authorization
require_once(dirname(__FILE__)."/wedos.conf.php")

class DNS {
	const DEBUG = true;

	const URL = "https://api.wedos.com/wapi/xml";

	const TTL = 1800;

	private $_codes = array(1000);

	private function auth() {
		return sha1(USER.sha1(PASS).date('H', time()));
	}

	private function result($res) {
		if(empty($res)) {
			die("ERROR: Result from api is empty!");
		}
		$xml = new SimpleXMLElement($res);
		if(empty($xml)) {
			die("ERROR: Convertion to xml failed!");
		}
		if(!in_array($xml->code,$this->_codes)) {
			if(self::DEBUG) {
				$debug = print_r($xml,true);
			} else {
				$debug = "";
			}
			die("ERROR: Wrong return code: ".$xml->code."\nDEBUG: ".$debug."\n");
		}
		return $xml;
	}

	public function cmd($cmd, $data = null) {
		$auth = $this->auth();
		$request = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
		$request .= "<request>\n";
		$request .= "<user>".USER."</user>\n";
		$request .= "<auth>".$auth."</auth>\n";
		$request .= "<command>".$cmd."</command>\n";
		if($data != null) {
			$request .= "<data>\n";
			foreach($data as $name => $value) {
				$request .= "<".$name.">".$value."</".$name.">\n";
			}
			$request .= "</data>\n";
		}
		$request .= "</request>\n";

		if(self::DEBUG) echo "DEBUG: ".$request;

		// POST data
		$post = 'request='.urlencode($request);

		// init cURL session
		$ch = curl_init();

		// nastavení URL a POST dat
		curl_setopt($ch,CURLOPT_URL,self::URL);
		curl_setopt($ch,CURLOPT_POST,true);
		curl_setopt($ch,CURLOPT_POSTFIELDS,$post);

		// odpověď chceme jako návratovou hodnotu curl_exec()
		curl_setopt($ch,CURLOPT_RETURNTRANSFER,true);

		// doba, po kterou skript čeká na odpověď
		curl_setopt($ch,CURLOPT_TIMEOUT,100);

		// vypnutí kontrol SSL certifikátů
		curl_setopt($ch,CURLOPT_SSL_VERIFYHOST,false);
		curl_setopt($ch,CURLOPT_SSL_VERIFYPEER,false);

		// provedení volání
		$res = curl_exec($ch);

		return $this->result($res);
	}

	public function getDnsRowList($domain) {
		$xml = $this->cmd("dns-rows-list",array("domain"=>$domain));
		print_r($xml);
		return $xml;
	}

	public function getSubdomainRowId($subdomain,$domain) {
		$xml = $this->getDnsRowList($domain);
		foreach($xml->data->row as $item) {
			if($item->name == $subdomain) {
				return $item->ID;
			}
		}
		return 0;
	}

	public function updateSubdomainIp($subdomain,$domain,$ip) {
		$rowId = $this->getSubdomainRowId($subdomain,$domain);

		echo "rowId: ".$rowId."\n";

		$xml = $this->cmd("dns-row-update",array("domain"=>$domain,"row_id"=>$rowId,"ttl"=>self::TTL,"rdata"=>$ip));
		print_r($xml);
	}
}

if ( isset($argc) && $argc == 2 ) {
	$ip = $argv[1];
	echo "ip: ".$ip."\n";
	$dns = new DNS();
	$dns->updateSubdomainIp("pi","vician.cz",$ip);
} else {
	echo "ERROR: Wrong parameters!\n";
	echo "Usage: ./dns.php ip_addr\n";
}
//$id = $dns->getSubdomainRowId("pi","vician.cz");
//echo "pi.vician.cz: ".$id."\n";
//$dns->getDnsRowList("vician.cz");
//$xml = $dns->cmd("ping");
//print_r($xml);
?>
