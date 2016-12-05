basics = ["wget", "build-essential", "libgd-dev", "sendmail", "unzip"] # Debian flavor basics 

package "#{basics}" do
	action :install
	
end

