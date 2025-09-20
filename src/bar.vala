[GtkTemplate(ui = "/bar.ui")]
class Bar : Astal.Window {
  private AstalBattery.Device battery = AstalBattery.get_default();
  private AstalBluetooth.Bluetooth bluetooth = AstalBluetooth.get_default();
  private AstalNetwork.Wifi wifi = AstalNetwork.get_default().wifi;

  [GtkChild] unowned Gtk.Label clock_date;
  [GtkChild] unowned Gtk.Label clock_time;
  [GtkChild] unowned Gtk.Image battery_icon;
  [GtkChild] unowned Gtk.Image bluetooth_icon;
  [GtkChild] unowned Gtk.Image wifi_icon;

  public Bar() {
    anchor = TOP | LEFT | RIGHT;
    exclusivity = EXCLUSIVE;

    sync_clock_date_and_time();
    Timeout.add(1000, () => sync_clock_date_and_time());

    battery.bind_property("battery-icon-name", battery_icon, "icon-name", BindingFlags.SYNC_CREATE);
    sync_battery_icon_tooltip();
    battery.notify["percentage"].connect(() => sync_battery_icon_tooltip());

    sync_bluetooth_icon();
    bluetooth.notify["is-powered"].connect(() => sync_bluetooth_icon());

    wifi.bind_property("icon-name", wifi_icon, "icon-name", BindingFlags.SYNC_CREATE);

    present();
  }

  private bool sync_clock_date_and_time() {
    var now = new DateTime.now_local();
    clock_date.set_label(now.format("%a %d"));
    clock_time.set_label(now.format("%I:%M"));
    return true;
  }

  private void sync_battery_icon_tooltip() {
    var time_remaining = battery.charging ? battery.time_to_full : battery.time_to_empty;
    var hours_remaining = (int)(time_remaining / 3600);
    var minutes_remaining = (int)((time_remaining % 3600) / 60);

    battery_icon.set_tooltip_text("%d%%, %02d:%02d %s".printf(
      (int)(battery.percentage * 100),
      hours_remaining,
      minutes_remaining,
      battery.charging ? "until full" : "remaining"
    ));
  }

  private void sync_bluetooth_icon() {
    bluetooth_icon.set_from_icon_name(bluetooth.is_powered ? "bluetooth-active-symbolic" : "bluetooth-disabled-symbolic");
  }
}
