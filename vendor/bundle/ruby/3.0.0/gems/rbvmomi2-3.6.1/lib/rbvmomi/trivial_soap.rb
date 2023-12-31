# frozen_string_literal: true
# Copyright (c) 2011-2017 VMware, Inc.  All Rights Reserved.
# SPDX-License-Identifier: MIT

require 'rubygems'
require 'builder'
require 'nokogiri'
require 'net/http'
require 'pp'

class RbVmomi::TrivialSoap
  attr_accessor :debug, :cookie, :operation_id
  attr_reader :http

  def initialize opts
    raise unless opts.is_a? Hash

    @opts = opts
    return unless @opts[:host] # for testcases

    @debug = @opts[:debug]
    @cookie = @opts[:cookie]
    @sso = @opts[:sso]
    @operation_id = @opts[:operation_id]
    @lock = Mutex.new
    @http = nil
    restart_http
  end

  def host
    @opts[:host]
  end

  def close
    @http.finish rescue IOError
  end

  def restart_http
    begin
      @http.finish if @http
    rescue Exception => ex
      puts "WARNING: Ignoring exception: #{ex.message}"
      puts ex.backtrace.join("\n")
    end
    @http = Net::HTTP.new(@opts[:host], @opts[:port], @opts[:proxyHost], @opts[:proxyPort])
    if @opts[:ssl]
      require 'net/https'
      @http.use_ssl = true
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE if @opts[:insecure]
      @http.ca_file = @opts[:ca_file] if @opts[:ca_file]
      @http.cert = OpenSSL::X509::Certificate.new(@opts[:cert]) if @opts[:cert]
      @http.key = OpenSSL::PKey::RSA.new(@opts[:key]) if @opts[:key]
    end
    @http.set_debug_output(STDERR) if $DEBUG
    @http.read_timeout = @opts[:read_timeout] || 1000000
    @http.open_timeout = @opts[:open_timeout] || 60
    def @http.on_connect
      @socket.io.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1)
    end
    @http.start
  end

  def soap_envelope
    xsd = 'http://www.w3.org/2001/XMLSchema'
    env = 'http://schemas.xmlsoap.org/soap/envelope/'
    xsi = 'http://www.w3.org/2001/XMLSchema-instance'
    xml = Builder::XmlMarkup.new indent: 0
    xml.tag!('env:Envelope', 'xmlns:xsd' => xsd, 'xmlns:env' => env, 'xmlns:xsi' => xsi) do
      if @vcSessionCookie || @operation_id
        xml.tag!('env:Header') do
          xml.tag!('vcSessionCookie', @vcSessionCookie) if @vcSessionCookie
          xml.tag!('operationID', @operation_id) if @operation_id
        end
      end

      xml.tag!('env:Body') do
        yield xml if block_given?
      end
    end
    xml
  end

  def request action, body
    headers = { 'content-type' => 'text/xml; charset=utf-8', 'SOAPAction' => action }
    headers['cookie'] = @cookie if @cookie

    RbVmomi.logger.debug("Request:\n#{body}") if @debug

    if @cookie.nil? && @sso
      @sso.request_token unless @sso.assertion_id
      body = @sso.sign_request(body)
    end

    start_time = Time.now
    response = @lock.synchronize do
      begin
        @http.request_post(@opts[:path], body, headers)
      rescue Exception
        restart_http
        raise
      end
    end
    end_time = Time.now

    raise 'Got HTTP 503: Service unavailable' if response.is_a? Net::HTTPServiceUnavailable

    self.cookie = response['set-cookie'] if response.key? 'set-cookie'

    nk = Nokogiri(response.body)

    RbVmomi.logger.debug("Response (in #{'%.3f' % (end_time - start_time)} s)\n#{nk}") if @debug

    [nk.xpath('//soapenv:Body/*').select(&:element?).first, response.body.size]
  end
end
