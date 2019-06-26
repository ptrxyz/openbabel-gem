require 'fileutils'
require 'rbconfig'
require 'mkmf'

main_dir = File.expand_path(File.join(File.dirname(__FILE__),"..",".."))

# install OpenBabel

openbabel_dir = File.join main_dir, "openbabel"
src_dir = openbabel_dir 
build_dir = File.join src_dir, "build"
install_dir = openbabel_dir 
install_lib_dir = File.join install_dir, "lib"
lib_dir = File.join openbabel_dir, "lib", "openbabel"
ruby_src_dir = File.join src_dir, "scripts", "ruby"

begin
  nr_processors = `getconf _NPROCESSORS_ONLN`.to_i # should be POSIX compatible
rescue
  nr_processors = 1
end

FileUtils.mkdir_p openbabel_dir
Dir.chdir main_dir do
  FileUtils.rm_rf src_dir
  puts "Downloading OpenBabel sources"
  system "git clone https://github.com/ComPlat/openbabel.git --branch 'hot-fix-svg'"
end

FileUtils.mkdir_p build_dir
FileUtils.mkdir_p install_dir
Dir.chdir build_dir do
  puts "Configuring OpenBabel"
  cmake = "cmake #{src_dir} -DCMAKE_INSTALL_PREFIX=#{install_dir} -DBUILD_GUI=OFF -DENABLE_TESTS=OFF -DRUN_SWIG=ON -DRUBY_BINDINGS=ON"
  # set rpath for local installations
  # http://www.cmake.org/Wiki/CMake_RPATH_handling
  # http://vtk.1045678.n5.nabble.com/How-to-force-cmake-not-to-remove-install-rpath-td5721193.html
  cmake += " -DCMAKE_INSTALL_RPATH:STRING=\"#{install_lib_dir}\"" 
  system cmake
end

# local installation in gem directory
Dir.chdir build_dir do
  puts "Compiling OpenBabel sources."
  system "make -j#{nr_processors}"
  system "make install"
  ENV["PKG_CONFIG_PATH"] = File.dirname(File.expand_path(Dir["#{install_dir}/**/openbabel*pc"].first))
end







# compile ruby bindings
puts "Compiling and installing OpenBabel Ruby bindings."
Dir.chdir ruby_src_dir do
  # fix rpath
  system "sed -i 's|with_ldflags.*$|with_ldflags(\"#\$LDFLAGS -dynamic -Wl,-rpath,#{install_lib_dir}\") do|' #{File.join(ruby_src_dir,'extconf.rb')}" unless have_library('openbabel')
  # get include and lib from pkg-config
  ob_include=`pkg-config openbabel-2.0 --cflags-only-I`.sub(/\s+/,'').sub(/-I/,'')
  ob_lib=`pkg-config openbabel-2.0 --libs-only-L`.sub(/\s+/,'').sub(/-L/,'')
  system "#{RUBY} extconf.rb --with-openbabel-include=#{ob_include} --with-openbabel-lib=#{ob_lib}"
  system "make -j#{nr_processors}"
end
FileUtils.cp(ruby_src_dir+"/openbabel.#{RbConfig::CONFIG["DLEXT"]}", "./")
File.open('Makefile', 'w') do |makefile|
  makefile.write <<"EOF"
.PHONY: openbabel.#{RbConfig::CONFIG["DLEXT"]}
openbabel.#{RbConfig::CONFIG["DLEXT"]}:
chmod 755 openbabel.#{RbConfig::CONFIG["DLEXT"]}

.PHONY: install
install:
mkdir -p #{lib_dir}
mv openbabel.#{RbConfig::CONFIG["DLEXT"]} #{lib_dir}
EOF
FileUtils.remove_entry_secure src_dir, build_dir
end






# create a fake Makefile
File.open(File.join(File.dirname(__FILE__),"Makefile"),"w+") do |makefile|
  makefile.puts "all:\n\ttrue\n\ninstall:\n\ttrue\n"
end

$makefile_created = true
