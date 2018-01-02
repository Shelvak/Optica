# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
env :PATH, '"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"'
# Example:
#
# set :output, "/path/to/my/cron_log.log"

# Send Happy Birthday
# every 1.day do
#  runner "Cliente.happyverde"
# end

# every '1 3 24,31 12 *' do
#   runner "MyMailer.fiestas"
# end

every '1 5 2 * *' do
  runner "MyMailer.all_bills.deliver"
end

# Learn more: http://github.com/javan/whenever
