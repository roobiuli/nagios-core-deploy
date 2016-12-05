nagusrpass = "node['nagios-core']['nagusrpass']" 

user "nagios" do
	uid 1001
	shell "/bin/bash"
	home "/home/nagios"
	password "#{nagusrpass}"
end


#execute "get_nagios_plugins" do
#	command "cd /usr/local/src/ && wget https://nagios-plugins.org/download/nagios-plugins-2.1.2.tar.gz"
#	command "cd /usr/local/src/ && tar xvfz nagios-plugins*.tar.gz"
#	command "/usr/local/src/nagios-plugin-2.1.2/configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl"
#	command "cd /usr/local/src/nagios-plugin-2.1.2/ && make"
#	command "cd /usr/local/src/nagios-plugin-2.1.2/ && make install"

#	end


bash "get_nagios_plugins" do
	cwd "/usr/local/src/"
	code <<-EOH
	if [ -f *.tar.gz ]
		then
		exit 0
	else
	 wget https://nagios-plugins.org/download/nagios-plugins-2.1.2.tar.gz && tar xvfz nagios-plugins*.tar.gz 
	 if [ $? -eq 0 ]
	 	then
	 	cd nagios-plugins-2.1.2/ && ./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl && make && make install
	 	fi
	 fi
	EOH

	end