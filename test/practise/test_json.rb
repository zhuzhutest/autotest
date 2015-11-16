#!/usr/bin/ruby
require 'rubygems'
require 'json'
require 'pp'

json = File.read('input.json')
puts json
obj = JSON.parse(json)

pp obj