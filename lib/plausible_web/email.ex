defmodule PlausibleWeb.Email do
  use Bamboo.Phoenix, view: PlausibleWeb.EmailView
  import Bamboo.PostmarkHelper

  def mailer_email_from do
    Application.get_env(:plausible, :mailer_email)
  end

  def admin_email do
    Application.get_env(:plausible, :admin_email)
  end

  def activation_email(user, link) do
    base_email()
    |> to(user.email)
    |> from(mailer_email_from())
    |> tag("activation-email")
    |> subject("Activate your Plausible free trial")
    |> render("activation_email.html", name: user.name, link: link)
  end

  def welcome_email(user) do
    base_email()
    |> to(user)
    |> from(mailer_email_from())
    |> tag("welcome-email")
    |> subject("Welcome to Plausible")
    |> render("welcome_email.html", user: user)
  end

  def create_site_email(user) do
    base_email()
    |> to(user)
    |> from(mailer_email_from())
    |> tag("create-site-email")
    |> subject("Your Plausible setup: Add your website details")
    |> render("create_site_email.html", user: user)
  end

  def site_setup_help(user, site) do
    base_email()
    |> to(user)
    |> from(mailer_email_from())
    |> tag("help-email")
    |> subject("Your Plausible setup: Waiting for the first page views")
    |> render("site_setup_help_email.html", user: user, site: site)
  end

  def site_setup_success(user, site) do
    base_email()
    |> to(user)
    |> from(mailer_email_from())
    |> tag("setup-success-email")
    |> subject("Plausible is now tracking your website stats")
    |> render("site_setup_success_email.html", user: user, site: site)
  end

  def check_stats_email(user) do
    base_email()
    |> to(user)
    |> from(mailer_email_from())
    |> tag("check-stats-email")
    |> subject("Check your Plausible website stats")
    |> render("check_stats_email.html", user: user)
  end

  def password_reset_email(email, reset_link) do
    base_email()
    |> to(email)
    |> from(mailer_email_from())
    |> tag("password-reset-email")
    |> subject("Plausible password reset")
    |> render("password_reset_email.html", reset_link: reset_link)
  end

  def trial_one_week_reminder(user) do
    base_email()
    |> to(user)
    |> from(mailer_email_from())
    |> tag("trial-one-week-reminder")
    |> subject("Your Plausible trial expires next week")
    |> render("trial_one_week_reminder.html", user: user)
  end

  def trial_upgrade_email(user, day, pageviews) do
    base_email()
    |> to(user)
    |> from(mailer_email_from())
    |> tag("trial-upgrade-email")
    |> subject("Your Plausible trial ends #{day}")
    |> render("trial_upgrade_email.html", user: user, day: day, pageviews: pageviews)
  end

  def trial_over_email(user) do
    base_email()
    |> to(user)
    |> from(mailer_email_from())
    |> tag("trial-over-email")
    |> subject("Your Plausible trial has ended")
    |> render("trial_over_email.html", user: user)
  end

  def weekly_report(email, site, assigns) do
    base_email()
    |> to(email)
    |> from(mailer_email_from())
    |> tag("weekly-report")
    |> subject("#{assigns[:name]} report for #{site.domain}")
    |> render("weekly_report.html", Keyword.put(assigns, :site, site))
  end

  defp base_email() do
    new_email()
    |> put_param("TrackOpens", false)
  end
end
