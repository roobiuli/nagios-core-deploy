
case node['platform_family']

when "debian"

packages = ["apache2", "apache-mode-php7.0"] #Debian Flavor Packages

when "fedora"
packages = ["httpd", "apache-mode-php7.0"] 


end



package "#{packages}" do
	action :install


end
