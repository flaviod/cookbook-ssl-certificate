name             'ssl-certificate'
maintainer       'wenchma'
maintainer_email 'wenchma@gmail.com'
license          'Apache 2.0'
description      'Setup the PKI root CA and SSL certificates.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

recipe           'ssl-certificate', 'Setup the root CA and SSL certificates'

%w{ ubuntu suse redhat centos }.each do |os|
  supports os
end
