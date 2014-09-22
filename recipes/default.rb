# encoding: UTF-8
# =================================================================
# Licensed Materials - Property of IBM
#
# (c) Copyright IBM Corp. 2014 All Rights Reserved
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
# =================================================================
#
# Cookbook Name:: ssl-certificate
# Recipe:: default
#

require 'openssl'

# Setup the CA and certificate
# Generate CA's public/private key
root_key = OpenSSL::PKey::RSA.new 2048
root_ca = OpenSSL::X509::Certificate.new
# cf. RFC 5280 - to make it a "v3" certificate
root_ca.version = 2
root_ca.serial = 1
root_ca.subject = OpenSSL::X509::Name.parse '/DC=org/DC=ruby-lang/CN=CA'
# root CA's are "self-signed"
root_ca.issuer = root_ca.subject
root_ca.public_key = root_key.public_key
root_ca.not_before = Time.now
# 10 years validity
root_ca.not_after = root_ca.not_before + 10 * 365 * 24 * 60 * 60
ef = OpenSSL::X509::ExtensionFactory.new
ef.subject_certificate = root_ca
ef.issuer_certificate = root_ca
root_ca.add_extension(ef.create_extension('basicConstraints', 'CA:TRUE', true))
root_ca.add_extension(ef.create_extension('keyUsage', 'keyCertSign, cRLSign', true))
root_ca.add_extension(ef.create_extension('subjectKeyIdentifier', 'hash', false))
root_ca.add_extension(ef.create_extension('authorityKeyIdentifier', 'keyid:always', false))
root_ca.sign(root_key, OpenSSL::Digest::SHA256.new)

directory node['ssl']['ca']['base_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory node['ssl']['cert']['dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

file node['ssl']['ca']['key_file'] do
  owner 'root'
  group 'root'
  mode '0644'
  content root_key.to_pem
  action :create
end

file node['ssl']['ca']['cert_file'] do
  owner 'root'
  group 'root'
  mode '0644'
  content root_ca.to_pem
  action :create
end

# Issue certificate by root CA certificate
key = OpenSSL::PKey::RSA.new 2048
cert = OpenSSL::X509::Certificate.new
cert.version = 2
cert.serial = 2
cert.subject = OpenSSL::X509::Name.parse '/DC=org/DC=ruby-lang/CN=certificate'
# root CA is the issuer
cert.issuer = root_ca.subject
cert.public_key = key.public_key
cert.not_before = Time.now
cert.not_after = cert.not_before + 10 * 365 * 24 * 60 * 60
ef = OpenSSL::X509::ExtensionFactory.new
ef.subject_certificate = cert
ef.issuer_certificate = root_ca
cert.add_extension(ef.create_extension('keyUsage', 'digitalSignature', true))
cert.add_extension(ef.create_extension('subjectKeyIdentifier', 'hash', false))
cert.sign(root_key, OpenSSL::Digest::SHA256.new)

file node['ssl']['cert']['key_file'] do
  owner 'root'
  group 'root'
  mode '0644'
  content key.to_pem
  action :create
end

file node['ssl']['cert']['file'] do
  owner 'root'
  group 'root'
  mode '0644'
  content cert.to_pem
  action :create
end
