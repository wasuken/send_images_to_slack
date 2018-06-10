# coding: utf-8
require 'slack'
require 'open-uri'
require 'faraday'
require 'fileutils'
require 'parseconfig'

MYCONF = ParseConfig.new('config')
IMAGE_PATH=MYCONF['image_path']
READED_IMAGE_PATH=MYCONF['readed_image_path']

SLACK_TOKEN = MYCONF['slack_api_token']
CLIENT = Slack::Client.new token: SLACK_TOKEN

Slack.configure do |config|
  config.token = SLACK_TOKEN
end

image_files = Dir.glob("#{IMAGE_PATH}/*.{png,jpeg,jpg}")
if image_files.count <= 0
  puts "image file nothing"
end

# search images
Dir.glob("#{IMAGE_PATH}/*.{png,jpeg,jpg}") do |f|
  CLIENT.files_upload(
    channels: "botroom",
    as_user: true,
    file: Faraday::UploadIO.new(f,f),
    filename: f.split('\\').last,
    initial_comment: f.split('\\').last
  )
  File.rename(f,"#{READED_IMAGE_PATH}/#{f.split('/').last}")
end


# send to image
#Slack.chat_postMessage(channel: "botroom",text: "sample")
