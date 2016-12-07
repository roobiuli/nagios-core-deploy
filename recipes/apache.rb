
case node['platform_family']

when "debian"

packages =[ "apache2", "php-gd", "php" ] #Debian Flavor Packages

when "fedora"
packages =[ "httpd", "apache-mode-php7.0" ] 


end


packages.each do |pr|
 package "#{pr}" do
	 action :install


 end
end