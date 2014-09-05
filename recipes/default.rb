package "build-essential"
package "unzip"
package "libpng12-dev"

# retrieve source code
remote_file "#{Chef::Config[:file_cache_path]}/blatSrc35.zip" do
  source "http://users.soe.ucsc.edu/~kent/src/blatSrc35.zip"
  action :create_if_missing
end
# create install directory if missing
directory node[:blat][:installdirectory] do
  recursive true
  owner "root"
  group "root"
  mode "0755"
  action :create
  not_if { File.exists?("#{node[:blat][:installdirectory]}") }
end

#
execute "blat source compile and install" do
  command <<-CODE
set -e
(cd #{Chef::Config[:file_cache_path]}/ && unzip blatSrc35.zip)
(chown root:root #{Chef::Config[:file_cache_path]}/blatSrc)
(cd #{Chef::Config[:file_cache_path]}/blatSrc && MACHTYPE=x86_64 BINDIR=#{node[:blat][:installdirectory]} make)
CODE
  action :run
  not_if { File.exists?("#{node[:blat][:installdirectory]}/blat") }
end

