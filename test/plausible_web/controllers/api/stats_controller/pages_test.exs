defmodule PlausibleWeb.Api.StatsController.PagesTest do
  use PlausibleWeb.ConnCase
  import Plausible.TestUtils

  describe "GET /api/stats/:domain/pages" do
    setup [:create_user, :log_in, :create_site]

    test "returns top pages sources by pageviews", %{conn: conn, site: site} do
      conn = get(conn, "/api/stats/#{site.domain}/pages?period=day&date=2019-01-01")

      assert json_response(conn, 200) == [
               %{"count" => 2, "name" => "/"},
               %{"count" => 2, "name" => "/register"},
               %{"count" => 1, "name" => "/contact"},
               %{"count" => 1, "name" => "/irrelevant"}
             ]
    end

    test "calculates bounce rate and unique visitors for pages", %{conn: conn, site: site} do
      conn =
        get(
          conn,
          "/api/stats/#{site.domain}/pages?period=day&date=2019-01-01&include=bounce_rate,unique_visitors"
        )

      assert json_response(conn, 200) == [
               %{"bounce_rate" => 33.0, "count" => 2, "unique_visitors" => 2, "name" => "/"},
               %{
                 "bounce_rate" => nil,
                 "count" => 2,
                 "unique_visitors" => 2,
                 "name" => "/register"
               },
               %{
                 "bounce_rate" => nil,
                 "count" => 1,
                 "unique_visitors" => 1,
                 "name" => "/contact"
               },
               %{
                 "bounce_rate" => nil,
                 "count" => 1,
                 "unique_visitors" => 1,
                 "name" => "/irrelevant"
               }
             ]
    end

    test "returns top pages in realtime report", %{conn: conn, site: site} do
      conn = get(conn, "/api/stats/#{site.domain}/pages?period=realtime")

      assert json_response(conn, 200) == [
               %{"count" => 3, "name" => "/"}
             ]
    end
  end
end
