sb = __FILE__
while File.symlink?(sb)
  sb = File.expand_path(File.readlink(sb), File.dirname(sb))
end

$:.unshift(File.expand_path(File.join(File.dirname(sb), '')))

module Services
  autoload :SSH, 'services/ssh'
  autoload :Apache2, 'services/apache2'
end
