<<-APPCUES_SCRIPT
  <script src='#{Config.library_url || "//d2dubfq97s02eu.cloudfront.net/appcues.min.js?i=#{appcues_id}"}' data-appcues-id='#{appcues_id}' data-user-id='#{user_id}' data-user-email='#{email}'></script>
  <script>
    Appcues.identify(#{user_json});
    Appcues.init();
  </script>
APPCUES_SCRIPT
