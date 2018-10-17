Cronex.Test.DateTime.start_link()
Application.put_env(:cronex, :date_time_provider, Cronex.Test.DateTime)

ExUnit.start()
