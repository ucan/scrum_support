shared_examples "an_api_controller" do |url, accepted_verbs|
    used_verbs = [:get, :post, :put, :delete]
    verbs_to_check = used_verbs - accepted_verbs

    verbs_to_check.each do |verb|
      it "#{url} does not respond to #{verb.to_s}" do

        case verb
        when :get
          get(url).should_not be_routable 
        when :post
          post(url).should_not be_routable
        when :put
          put(url).should_not be_routable
        when :delete
          delete(url).should_not be_routable
        end
      end
  end
end

