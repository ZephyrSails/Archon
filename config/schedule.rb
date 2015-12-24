# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# whenever --update-crontab
# whenever --update-crontab --set environment='development'
# whenever -c
# crontab -l

set :output, "cron_log.log"
every 2.hours do
  # runner "puts #{Time.now}"
  # command "proxychains /bin/bash -l -c 'cd /home/zephyr/code/Archon && bin/rails runner -e development '\''Captain.one_order_loot'\'' >> /home/zephyr/code/Archon/cron_log.log 2>&1'"
  runner "Captain.one_order_loot"
  # runner "ApplicationHelper.new_inspections"
end

# set :output, "auctioneer_cron_log.log"
# every '30 * * * *' do
#   runner "Merchant.auction"
# end
