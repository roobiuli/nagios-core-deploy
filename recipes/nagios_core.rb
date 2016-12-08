nagusrpass = "node['nagios-core']['nagusrpass']"


user "nagios" do
	uid 1001
	home "/home/nagios"
	shell '/bin/bash'
	password "#{nagusrpass}"
end


group "nagcmd" do 
	members "nagios"
	append true
end


directory "/usr/local/src/nagios-core-kit" do
	action :create
end


bash "download_nagios_kit" do
	cwd "/usr/local/src/nagios-core-kit"
	code "wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.2.0.tar.gz && tar xvfz nagios*.tar.gz"
	end


#execute "compile_nagios_core" do
#	 command "/usr/local/src/nagios-core-kit/nagios-4.2.0/configure --with-nagios-group=nagios --with-command-group=nagcmd"
#	 command "cd /usr/local/src/nagios-core-kit/nagios-4.2.0/ && make all"
#	 command "cd /usr/local/src/nagios-core-kit/nagios-4.2.0/ && make install"
#	 command "cd /usr/local/src/nagios-core-kit/nagios-4.2.0/ && make install-commandmode"
#	 command "cd /usr/local/src/nagios-core-kit/nagios-4.2.0/ && make install-init"
#	 command "cd /usr/local/src/nagios-core-kit/nagios-4.2.0/ && make install-config"
#	 command "cd /usr/local/src/nagios-core-kit/nagios-4.2.0/ && /usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-available/nagios.conf"
#	 command "cd /usr/local/src/nagios-core-kit/nagios-4.2.0/ && cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/"

#	command "cd /usr/local/src/nagios-core-kit/nagios-4.2.0/ && chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers"

#	end

bash "compile_nagios_core" do
	cwd "/usr/local/src/nagios-core-kit/nagios-4.2.0/"
	code <<-EOH
	test -d /usr/local/nagios
	if [ $? -ne 0 ]
		then
	./configure --with-nagios-group=nagios --with-command-group=nagcmd 
	make all 
	make install
	make install-commandmode
	make install-init
	make install-config
	if [ $? -eq 0 ]
		then 
		 /usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-available/nagios.conf
		cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/
		chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers
		fi
	else
		exit 0
	fi	
	EOH
	not_if File.exist?('\/usr\/local\/nagios\/')
end




#### NAGIOS PLUGINS INSTALL IN THIS SECTION 
include_recipe "nagios-core::nagios-plugins"



###


## Nagios Quick Configure in this section


directory "/usr/local/nagios/etc/servers" do
	action :create
	owner "nagios"
	group "nagios"
	mode 0755
end


template "/usr/local/nagios/etc/nagios.cfg" do
	source "nagios.cfg.erb"
	owner "nagios"
	group "nagios"
	mode 0664
end


template "/usr/local/nagios/etc/objects/contacts.cfg" do
	source "contacts.cfg.erb"
	owner "nagios"
	group "nagios"
	mode 0644
end


template "/etc/init.d/nagios" do
	source "initnagios.erb"
	owner "root"
	group "root"
	mode 0755
end


#



# Apache configure for nagios in this section 
template "/usr/local/nagios/etc/htpasswd.users" do
	source "htpasswd.users.erb"
	owner "nagios"
	group "nagios"
	mode 0644
end

execute "enable_cgi_re_write" do
	command "a2enmod rewrite && a2enmod cgi"
	not_if 'test -f /etc/apache2/mods-enabled/rewrite.load'
end


if File.exist?("/etc/apache2/sites-available/nagios.conf")


	execute "Nagios_apache_site_enable" do
	command "ln -s /etc/apache2/sites-available/nagios.conf /etc/apache2/sites-enabled/"
	notifies :restart, "service[apache2]", :immediately
	not_if 'test -f /etc/apache2/sites-available/nagios.conf'

	end


end


service "nagios" do
	action :start
end

#