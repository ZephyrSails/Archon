module GeneralHelper
  def GeneralHelper.get_agent
    $AGENT = Mechanize.new
    $AGENT.log = Logger.new "mech.log"
    page = $AGENT.get "http://en.ogame.gameforge.com/"
    empire = Empire.find_by(api_id: "113232")

    login_form = page.form_with :name => "loginForm"
    login_form.field_with(:name => "login").value = empire.name
    login_form.field_with(:name => "pass").value = empire.pass
    login_form.field_with(:name => "uni").value = "#{empire.galaxy.code}.ogame.gameforge.com"
    login_result = $AGENT.submit login_form
    puts "login success"
  end
end
