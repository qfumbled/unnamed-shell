[GtkTemplate(ui = "/control-panel.ui")]
class ControlPanel : Astal.Window {
  private AstalNetwork.Wifi wifi = AstalNetwork.get_default().wifi;
  private AstalBluetooth.Adapter bluetooth_adapter = AstalBluetooth.get_default().adapter;
  private AstalWp.Audio audio = AstalWp.get_default().audio;
  private AstalBrightness.Brightness brightness = AstalBrightness.get_default();
  private AstalMpris.Mpris mpris = AstalMpris.get_default();

  [GtkChild] unowned Gtk.ToggleButton wifi_toggle_button;
  [GtkChild] unowned Adw.ButtonContent wifi_toggle_button_content;

  [GtkChild] unowned Gtk.ToggleButton bluetooth_toggle_button;
  [GtkChild] unowned Adw.ButtonContent bluetooth_toggle_button_content;

  [GtkChild] unowned Gtk.Image volume_control_icon;
  [GtkChild] unowned Gtk.Adjustment volume_control_slider_adjustment;

  [GtkChild] unowned Gtk.Image brightness_control_icon;
  [GtkChild] unowned Gtk.Adjustment brightness_control_slider_adjustment;

  [GtkChild] unowned Gtk.Box music_players_carousel_container;
  [GtkChild] unowned Adw.Carousel music_players_carousel;

  public ControlPanel() {
    anchor = TOP | RIGHT;
    layer = TOP;

    wifi_toggle_button_content.set_label("Wi-Fi");
    wifi.bind_property("icon-name", wifi_toggle_button_content, "icon-name", BindingFlags.SYNC_CREATE);
    wifi.bind_property("enabled", wifi_toggle_button, "active", BindingFlags.SYNC_CREATE | BindingFlags.BIDIRECTIONAL);

    bluetooth_toggle_button_content.set_label("Bluetooth");
    bluetooth_adapter.bind_property("powered", bluetooth_toggle_button, "active", BindingFlags.SYNC_CREATE | BindingFlags.BIDIRECTIONAL);
    sync_bluetooth_toggle_button_icon();
    bluetooth_adapter.notify["powered"].connect(() => sync_bluetooth_toggle_button_icon());

    audio.default_speaker.bind_property("volume-icon", volume_control_icon, "icon-name", BindingFlags.SYNC_CREATE);
    audio.default_speaker.bind_property("volume", volume_control_slider_adjustment, "value", BindingFlags.SYNC_CREATE | BindingFlags.BIDIRECTIONAL);

    brightness_control_icon.set_from_icon_name("display-brightness-symbolic");
    brightness.bind_property("brightness", brightness_control_slider_adjustment, "value", BindingFlags.SYNC_CREATE | BindingFlags.BIDIRECTIONAL);

    sync_music_players_carousel_container_visible();
    mpris.players.foreach((player) => music_players_carousel_add_player(player));
    mpris.player_added.connect((_, player) => music_players_carousel_add_player(player));
    mpris.player_closed.connect((_, player) => music_players_carousel_remove_player(player));
  }

  private void sync_bluetooth_toggle_button_icon() {
    bluetooth_toggle_button_content.set_icon_name(bluetooth_adapter.powered ? "bluetooth-active-symbolic" : "bluetooth-disabled-symbolic");
  }

  private void sync_music_players_carousel_container_visible() {
    if (mpris.players.length() > 0) {
      music_players_carousel_container.set_visible(true);
    } else {
      music_players_carousel_container.set_visible(false);
    }
  }

  private void music_players_carousel_add_player(AstalMpris.Player player) {
    var player_widget = new MprisPlayer(player);
    player_widget.set_data("player-bus-name", player.bus_name);
    music_players_carousel.append(player_widget);
  }

  private void music_players_carousel_remove_player(AstalMpris.Player player) {
    var child = music_players_carousel.get_first_child();
    while (child != null) {
      string bus_name = child.get_data("player-bus-name");
      if (bus_name == player.bus_name) {
        music_players_carousel.remove(child);
        break;
      } else {
        child = music_players_carousel.get_next_sibling();
      }
    }
  }
}
