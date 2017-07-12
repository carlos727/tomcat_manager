module TomcatService
  module_function

  def get_folder
    if File.directory?('C:\Program Files (x86)\Apache Software Foundation\Tomcat 7.0')
      return 'C:\Program Files (x86)\Apache Software Foundation\Tomcat 7.0'
    else
      return 'C:\Program Files\Apache Software Foundation\Tomcat 7.0'
    end
  end

end

module TomcatManager
  module_function

  def is_reachable?(url, username, password)
    require 'mechanize'
    
    sw = true
    agent = Mechanize.new
    agent.user_agent_alias = 'Windows Chrome'
    agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    tries = 3
    cont = 0

    begin
    	agent.read_timeout = 5 #set the agent time out
      unless username.nil?
        agent.add_auth(url, username, password)
      end
    	page = agent.get(url)
  	rescue
      cont += 1
      unless (tries -= 1).zero?
        Chef::Log.warn("Verifying if url #{url} is reachable (#{cont}/3) failed, try again in 1 minutes...")
        agent.shutdown
        agent = Mechanize.new { |agent| agent.user_agent_alias = 'Windows Chrome'}
        agent.request_headers
        sleep(60)
        retry
      else
        Chef::Log.error("The url #{url} isn't available.")
        sw = false
      end
    else
      sw = true
    ensure
      agent.history.pop()   #delete this request in the history
    end

    return sw
  end

end

Chef::Recipe.send(:include, TomcatService)
Chef::Recipe.send(:include, TomcatManager)
