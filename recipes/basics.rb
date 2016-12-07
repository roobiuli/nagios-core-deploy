basics = [ 'wget', 'build-essential', 'sendmail', 'unzip', 'libgd-dev' ] # Debian flavor basics 

execute "update_apt_cache" do
	command "apt-get update"
end



basics.each do |p| 
 package "#{p}" do
    	action :install
	
 end
end
