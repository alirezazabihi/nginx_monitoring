# monitoring
Zabbix 4 Nginx monitoring by Alireza Zabihi based on Alex Gluck solution.


Connection Statistics:
- Active
- Reading
- Waiting
- Writing
- Requests pro connection
- Request Statistics:
- Accepted
- Handled
- Total

Linux and Nginx performance monitoring:
- File descriptors (Maximum and Current)
- CPU Cores
- Worker_Connections
- Worker_Processes
- Maximum supported connection depended on configuration
- Nginx service status

Graph and screen:
- 'Requests Statistics' graph
- 'Connection Status' graph
- File descriptors

Triggers:
- Nginx service status
- Worker processes bad configuration

***********************************************
***********************************************

Installation:
Part 1 (Nginx side):
0 - Check for with-http_stub_status_module enabled or not: nginx -V 2>&1 | grep -o with-http_stub_status_module with-http_stub_status_module
if there is not any output you need to configure nginx with --with-http_stub_status_module:
./cofigure --with-http_stub_status_module
make && make install
1 - Edit Nginx configuration and add nginx_status location to your website server context: vi /etc/nginx/nginx.conf
server { listen 80; server_name 192.168.1.10;
# add nginx_status location for nginx monitoring 

location /nginx_status {
 	stub_status on;     
    access_log   off;     
    allow 127.0.0.1;de
    deny all; }
}
:wq # ---> save and quit
2 - Restart nginx service 
systemctl restart nginx    or #    nginx -s reload
________________________________________
Part 2 (Linux side):
1 - download script file "nginx.sh" and put it in nginx server in /etc/zabbix/  
chmod 775 nginx.sh 
cp nginx.sh /etc/zabbix/
2 - Installing bc (Bash Calculator) if doesnt exist 
yum install bc -y
________________________________________
Part 3 (Zabbix agent side):
1 - Edit zabbix_agent.conf file on Nginx server and add UserParameter:
vi /etc/zabbix/zabbix-agent.conf 
UserParameter=nginx[*],/root/nginx.sh $1
:wq # ---> save and quit
2 - Restart zabbix-agent service: 
systemctl restart zabbix-agent
________________________________________
Part 4 (Zabbix frontend side):
1 - Download nginx_template.xml template and import it to your zabbix server from ---> Configuration -> Templates -> Import 
2 - Link imported template to your Nginx host 
Finish
