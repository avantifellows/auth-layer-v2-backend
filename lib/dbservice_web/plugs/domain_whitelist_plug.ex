defmodule DbserviceWeb.DomainWhitelistPlug do
  @moduledoc """
  Only allow requests from the list of domains specified. Assumes the request domain is present in the `host`
  attribute on the passed in plug.
  If the request doamin is not whitelisted, the specified response code and body
  will be added to the Plug.Conn and it will be halted.
  If the request domain is on the whitelist, the plug chain will continue
  """
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _options) do
    if allowed_domains?(conn) do
      conn
    else
      send_resp(conn, 403, "Not Authorized")
    end
  end

  defp allowed_domains?(conn) do
    whitelisted_domains = System.get_env("WHITELISTED_DOMAINS")

    allowed_domains =
      if is_nil(whitelisted_domains),
        do: ["localhost", "0e05-103-55-63-180.in.ngrok.io"],
        else: String.split(whitelisted_domains, ",")

    Enum.member?(allowed_domains, conn.host)
  end
end
